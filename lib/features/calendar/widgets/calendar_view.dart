import 'package:flutter/material.dart';
import 'package:rehearsal_app/core/design_system/glass_system.dart';
import 'package:rehearsal_app/core/design_system/app_spacing.dart';
import 'package:rehearsal_app/core/design_system/app_typography.dart';
import 'package:rehearsal_app/core/design_system/calendar_components.dart';
import 'package:rehearsal_app/features/calendar/widgets/improved_day_cell.dart';
import 'package:rehearsal_app/core/utils/localization_helper.dart';

class CalendarView extends StatelessWidget {
  const CalendarView({
    super.key,
    required this.currentDate,
    this.selectedDate,
    this.onDateSelected,
    this.eventDates = const [],
    this.availabilityMap = const {},
  });

  final DateTime currentDate;
  final DateTime? selectedDate;
  final Function(DateTime)? onDateSelected;
  final List<DateTime> eventDates;
  final Map<DateTime, AvailabilityStatus> availabilityMap;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Padding(
        padding: AppSpacing.paddingLG,
        child: Column(
          children: [
            // Month/Year header
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.lg),
              child: Text(
                _getMonthYearString(currentDate, context),
                style: AppTypography.headingMedium,
              ),
            ),
            // Weekday headers
            Row(
              children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                  .map(
                    (day) => Expanded(
                      child: Center(
                        child: Text(day, style: AppTypography.calendarWeekday),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: AppSpacing.md),
            // Calendar grid
            ..._buildCalendarWeeks(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCalendarWeeks() {
    final firstDayOfMonth = DateTime(currentDate.year, currentDate.month, 1);
    final lastDayOfMonth = DateTime(currentDate.year, currentDate.month + 1, 0);
    final firstDayOfWeek = firstDayOfMonth.weekday - 1;
    final startDate = firstDayOfMonth.subtract(Duration(days: firstDayOfWeek));
    final endDate = lastDayOfMonth.add(
      Duration(days: 7 - lastDayOfMonth.weekday),
    );

    final weeks = <Widget>[];
    DateTime current = startDate;

    while (current.isBefore(endDate)) {
      final week = <Widget>[];

      for (int i = 0; i < 7; i++) {
        final date = current.add(Duration(days: i));
        final isCurrentMonth = date.month == currentDate.month;
        final isToday = _isSameDay(date, DateTime.now());
        final isSelected =
            selectedDate != null && _isSameDay(date, selectedDate!);
        final hasEvents = eventDates.any(
          (eventDate) => _isSameDay(eventDate, date),
        );
        final availabilityStatus = availabilityMap[_normalizeDate(date)];

        week.add(
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: ImprovedDayCell(
                date: date,
                isCurrentMonth: isCurrentMonth,
                isToday: isToday,
                isSelected: isSelected,
                hasEvents: hasEvents,
                availabilityStatus: availabilityStatus,
                onTap: () => onDateSelected?.call(date),
              ),
            ),
          ),
        );
      }

      weeks.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(children: week),
        ),
      );

      current = current.add(const Duration(days: 7));
    }

    return weeks;
  }

  String _getMonthYearString(DateTime date, BuildContext context) {
    final months = LocalizationHelper.getMonthNames(context);
    return '${months[date.month - 1]} ${date.year}';
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
}
