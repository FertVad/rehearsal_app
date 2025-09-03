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
    this.size = 36, // диаметр «капли»
  });

  final DateTime day;
  final bool isSelected;
  final bool hasEvent;
  final VoidCallback? onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    final b = Theme.of(context).brightness;
    final Color textSecondary = b == Brightness.dark
        ? Colors.white.withValues(alpha: 0.70)
        : AppColors.textSecondary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Weekday кратко (Mon/Tue/…)
        Text(
          _weekdayShort(day),
          style: AppTypography.calendarWeekday.copyWith(color: textSecondary),
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
              child: GlassButton(
                size: GlassSize.small,
                selected: isSelected,
                onTap: () {
                  // тактильная отдача с троттлингом
                  AppHaptics.selection();
                  onTap?.call();
                },
                // центрируем цифру
                child: SizedBox(
                  width: size,
                  height: size,
                  child: Center(
                    child: Text(
                      '${day.day}',
                      style: AppTypography.calendarDay.copyWith(
                        // более контрастный текст для выбранного
                        color: isSelected
                            ? (b == Brightness.dark
                                  ? Colors.white.withValues(alpha: 0.95)
                                  : AppColors.textPrimary)
                            : textSecondary,
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
  const _DropletSurface({required this.child, required this.selected});

  final Widget child;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final b = Theme.of(context).brightness;
    final Color borderBase = b == Brightness.dark
        ? Colors.white.withValues(alpha: 0.18)
        : Colors.white.withValues(alpha: 0.28);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: selected
              ? AppColors.accentHotPink.withValues(alpha: 0.30)
              : borderBase,
          width: selected ? 1.0 : 0.8,
        ),
      ),
      child: child,
    );
  }
}
