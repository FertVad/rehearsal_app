import 'package:flutter/material.dart';
import 'day_cell.dart';

/// Displays a 1x7 grid representing a week view.
class WeekView extends StatelessWidget {
  const WeekView({super.key, required this.anchor, required this.onDaySelected});

  final DateTime anchor;
  final ValueChanged<DateTime> onDaySelected;

  @override
  Widget build(BuildContext context) {
    final start = anchor.subtract(Duration(days: anchor.weekday % 7));
    final days = List.generate(7, (i) => start.add(Duration(days: i)));

    return GridView.builder(
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
      ),
      itemCount: days.length,
      itemBuilder: (context, index) {
        final day = days[index];
        return DayCell(
          date: day,
          onTap: () => onDaySelected(day),
        );
      },
    );
  }
}
