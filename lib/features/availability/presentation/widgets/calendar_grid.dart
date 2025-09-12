import 'package:flutter/material.dart';
import 'package:rehearsal_app/core/design_system/app_colors.dart';
import 'package:rehearsal_app/core/design_system/app_spacing.dart';
import 'package:rehearsal_app/core/design_system/app_typography.dart';
import 'package:rehearsal_app/core/design_system/calendar_components.dart';
import 'package:rehearsal_app/core/utils/time.dart';

/// Grid-based calendar widget that shows availability indicators for days.
///
/// Each day cell and its indicator expose stable [ValueKey]s for tests:
/// `day-<dateUtc>` for the cell and `dot-<dateUtc>` for the status dot where
/// `dateUtc` is `dateUtc00` of the day.
class CalendarGrid extends StatelessWidget {
  const CalendarGrid({
    super.key,
    required this.month,
    required this.byDate,
    this.onDayTap,
  });

  /// Local month to display.
  final DateTime month;

  /// Map from `dateUtc00` to the day's availability status.
  final Map<int, AvailabilityStatus> byDate;

  /// Called when a day is tapped.
  final void Function(DateTime day)? onDayTap;

  @override
  Widget build(BuildContext context) {
    final firstDay = DateTime(month.year, month.month, 1);
    final leadingEmpty = firstDay.weekday - 1; // Monday first
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final totalShown = leadingEmpty + daysInMonth;
    final rows = (totalShown / 7).ceil();
    final itemCount = rows * 7;
    final startDay = firstDay.subtract(Duration(days: leadingEmpty));

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        final day = startDay.add(Duration(days: index));
        final keyBase = dateUtc00(day);
        final status = byDate[keyBase];
        final isCurrentMonth = day.month == month.month;
        final isToday = _isToday(day);

        return GestureDetector(
          key: Key('day-$keyBase'),
          onTap: () => onDayTap?.call(day),
          child: Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: isToday
                  ? AppColors.primaryPurple.withValues(alpha: 0.2)
                  : isCurrentMonth
                  ? AppColors.glassLightBase.withValues(alpha: 0.6)
                  : AppColors.glassLightBase.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
              border: Border.all(
                color: isToday
                    ? AppColors.primaryPurple.withValues(alpha: 0.8)
                    : AppColors.glassLightStroke.withValues(alpha: 0.4),
                width: isToday ? 2 : 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${day.day}',
                  style: AppTypography.calendarDay.copyWith(
                    color: isCurrentMonth
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                if (status != null)
                  StatusIndicator(key: Key('dot-$keyBase'), status: status)
                else
                  const SizedBox(height: 6, width: 6),
              ],
            ),
          ),
        );
      },
    );
  }

  bool _isToday(DateTime day) {
    final today = DateTime.now();
    return day.year == today.year &&
        day.month == today.month &&
        day.day == today.day;
  }
}
