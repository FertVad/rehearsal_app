import 'package:flutter/material.dart';

import 'package:rehearsal_app/core/design_system/glass_system.dart';
import 'package:rehearsal_app/core/design_system/app_typography.dart';
import 'package:rehearsal_app/core/design_system/app_colors.dart';
import 'package:rehearsal_app/core/design_system/app_spacing.dart';

/// Небольшой стеклянный хедер недели.
/// Рисует названия дней и числа в одной строке.
/// [start] — первый день недели (обычно понедельник, без времён).
class WeeklyHeader extends StatelessWidget {
  const WeeklyHeader({super.key, required this.start});

  /// Первый день недели (например, понедельник).
  final DateTime start;

  static const _weekdayShortRu = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];

  @override
  Widget build(BuildContext context) {
    final labelColor = AppColors.textSecondary;
    final valueColor = AppColors.textPrimary;

    final days = List<DateTime>.generate(
      7,
      (i) =>
          DateTime(start.year, start.month, start.day).add(Duration(days: i)),
    );

    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (var i = 0; i < 7; i++)
              _DayCell(
                label: _weekdayShortRu[i],
                value: days[i].day.toString(),
                labelColor: labelColor,
                valueColor: valueColor,
              ),
          ],
        ),
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.label,
    required this.value,
    required this.labelColor,
    required this.valueColor,
  });

  final String label;
  final String value;
  final Color labelColor;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppTypography.calendarWeekday.copyWith(color: labelColor),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: AppTypography.calendarDay.copyWith(color: valueColor),
          ),
        ],
      ),
    );
  }
}
