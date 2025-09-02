import 'package:flutter/material.dart';
import 'package:rehearsal_app/core/design_system/calendar_components.dart';

/// Grid-based calendar widget that shows availability indicators for days.
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
        // Use local midnight converted to UTC to match test keys and app-wide date keying.
        final keyBase = day.toUtc().millisecondsSinceEpoch;
        final status = byDate[keyBase];
        final isCurrentMonth = day.month == month.month;

        return GestureDetector(
          key: Key('day-$keyBase'),
          onTap: () => onDayTap?.call(day),
          child: Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${day.day}',
                  style: TextStyle(
                    color: isCurrentMonth ? Colors.black : Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                if (status != null)
                  StatusIndicator(key: Key('dot-$keyBase'), status: status!)
                else
                  const SizedBox(height: 8, width: 8),
              ],
            ),
          ),
        );
      },
    );
  }
}
