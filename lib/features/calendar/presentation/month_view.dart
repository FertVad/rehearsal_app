import 'package:flutter/material.dart';
import 'day_cell.dart';

/// Displays a 6x7 grid representing a month view.
class MonthView extends StatelessWidget {
  const MonthView({super.key, required this.anchor, required this.onDaySelected});

  final DateTime anchor;
  final ValueChanged<DateTime> onDaySelected;

  @override
  Widget build(BuildContext context) {
    final firstOfMonth = DateTime(anchor.year, anchor.month, 1);
    final startCell = firstOfMonth.subtract(
      Duration(days: firstOfMonth.weekday % 7),
    );
    final days = List.generate(42, (i) => startCell.add(Duration(days: i)));

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
