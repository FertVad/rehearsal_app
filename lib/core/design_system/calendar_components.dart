import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'app_spacing.dart';
import 'glass_system.dart';
import 'package:rehearsal_app/core/design_system/haptics.dart';

/// Статус доступности для сеток/точек.
enum AvailabilityStatus { free, busy, partial }

/// Точка события под каплей дня.
class EventDot extends StatelessWidget {
  const EventDot({
    super.key,
    this.visible = false,
    this.size = 4,
    this.color = AppColors.accentHotPink,
  });

  final bool visible;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: visible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}

/// Индикатор статуса доступности (для availability grid).
class StatusIndicator extends StatelessWidget {
  const StatusIndicator({super.key, required this.status, this.size = 8});

  final AvailabilityStatus status;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _colorFor(status),
      ),
    );
  }

  Color _colorFor(AvailabilityStatus s) {
    switch (s) {
      case AvailabilityStatus.free:
        return AppColors.statusFree;
      case AvailabilityStatus.busy:
        return AppColors.statusBusy;
      case AvailabilityStatus.partial:
        return AppColors.statusPartial;
    }
  }
}

/// Капля-день: Weekday (коротко) + стеклянная кнопка с числом + точка события.
/// Полностью на дизайн-системе: цвета/типографика/отступы/стекло.
class CalendarDayButton extends StatelessWidget {
  const CalendarDayButton({
    super.key,
    required this.day,
    required this.isSelected,
    this.hasEvent = false,
    this.onTap,
    this.onLongPress,
    this.size = 36, // диаметр «капли»
  });

  final DateTime day;
  final bool isSelected;
  final bool hasEvent;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final double size;

  @override
  Widget build(BuildContext context) {
    // Проверка на сегодняшний день
    final today = DateTime.now();
    final isToday =
        day.year == today.year &&
        day.month == today.month &&
        day.day == today.day;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Weekday кратко (Mon/Tue/…)
        Text(
          _weekdayShort(day),
          style: AppTypography.calendarWeekday.copyWith(
            color: Colors.white.withValues(alpha: 0.85),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),

        // Стеклянная «капля» с цифрой дня
        SizedBox(
          width: size,
          height: size,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(size / 2),
            child: _DropletSurface(
              selected: isSelected,
              isToday: isToday,
              child: GestureDetector(
                onTap: onTap != null
                    ? () {
                        AppHaptics.selection();
                        onTap!();
                      }
                    : null,
                onLongPress: onLongPress != null
                    ? () {
                        AppHaptics.light();
                        onLongPress!();
                      }
                    : null,
                child: AppGlass(
                  size: GlassSize.small,
                  style: GlassStyle.light,
                  // центрируем цифру
                  child: SizedBox(
                    width: size,
                    height: size,
                    child: Center(
                      child: Text(
                        '${day.day}',
                        style: AppTypography.calendarDay.copyWith(
                          // белый текст для всех дней
                          color: Colors.white.withValues(alpha: 0.95),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.xs),
        EventDot(visible: hasEvent, size: 4),
      ],
    );
  }

  String _weekdayShort(DateTime d) {
    // ISO: Monday=1 ... Sunday=7
    const en = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return en[d.weekday - 1];
  }
}

/// Тонкая подложка-обводка для «капли», чтобы даже без акцента
/// было ощущение стеклянного объёма.
class _DropletSurface extends StatelessWidget {
  const _DropletSurface({
    required this.child,
    required this.selected,
    this.isToday = false,
  });

  final Widget child;
  final bool selected;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    final Color borderBase = Colors.white.withValues(alpha: 0.18);

    // Определяем стиль в зависимости от состояния
    Color borderColor = borderBase;
    double borderWidth = 0.8;
    List<BoxShadow>? boxShadow;

    if (selected) {
      // Выбранный день: свечение (без бордера)
      borderColor = borderBase;
      borderWidth = 0.8;
      boxShadow = [
        BoxShadow(
          color: AppColors.accentHotPink.withValues(alpha: 0.4),
          blurRadius: 8,
          spreadRadius: 2,
        ),
      ];
    } else if (isToday) {
      // Сегодняшний день: яркий бордер и легкое свечение
      borderColor = AppColors.primaryPurple.withValues(alpha: 1.0);
      borderWidth = 2.0;
      boxShadow = [
        BoxShadow(
          color: AppColors.primaryPurple.withValues(alpha: 0.3),
          blurRadius: 6,
          spreadRadius: 1,
        ),
      ];
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: borderColor, width: borderWidth),
        boxShadow: boxShadow,
      ),
      child: child,
    );
  }
}
