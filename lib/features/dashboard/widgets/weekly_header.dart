import 'package:flutter/material.dart';
import 'package:rehearsal_app/core/ui/liquid_glass_panel.dart';

class WeeklyHeader extends StatelessWidget {
  final DateTime currentWeekStart;

  const WeeklyHeader({super.key, required this.currentWeekStart});

  static const List<String> weekDayLabels = [
    'Пн',
    'Вт',
    'Ср',
    'Чт',
    'Пт',
    'Сб',
    'Вс',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: LiquidGlassPanel(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(7, (index) {
            final day = DateTime(
              currentWeekStart.year,
              currentWeekStart.month,
              currentWeekStart.day + index,
            );
            final weekDayLabel = weekDayLabels[(day.weekday - 1) % 7];
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  weekDayLabel,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  '${day.day}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
