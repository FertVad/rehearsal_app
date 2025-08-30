import 'package:flutter/material.dart';

/// A simple widget showing a day number.
class DayCell extends StatelessWidget {
  const DayCell({super.key, required this.date, this.onTap});

  final DateTime date;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
        ),
        alignment: Alignment.center,
        child: Text('${date.day}'),
      ),
    );
  }
}
