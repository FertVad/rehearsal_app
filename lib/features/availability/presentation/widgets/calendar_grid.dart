import 'package:flutter/material.dart';

import '../../../../core/utils/time.dart';

/// Indicates availability for a particular day.
enum AvailabilityStatus { free, busy, partial }

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
        final keyBase = dateUtc00(day);
        final status = byDate[keyBase];
        final isCurrentMonth = day.month == month.month;

        return GestureDetector(
          key: ValueKey('day-$keyBase'),
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
                _StatusDot(key: ValueKey('dot-$keyBase'), status: status),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _StatusDot extends StatelessWidget {
  const _StatusDot({super.key, this.status});

  final AvailabilityStatus? status;

  Color? _color() {
    switch (status) {
      case AvailabilityStatus.free:
        return Colors.green;
      case AvailabilityStatus.busy:
        return Colors.red;
      case AvailabilityStatus.partial:
        return Colors.yellow;
      case null:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _color();
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: color == null ? Border.all(color: Colors.grey) : null,
      ),
    );
  }
}
