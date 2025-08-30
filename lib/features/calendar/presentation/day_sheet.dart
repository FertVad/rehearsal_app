import 'package:flutter/material.dart';

/// Bottom sheet displaying basic information about a day.
class DaySheet extends StatelessWidget {
  const DaySheet({super.key, required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final formatted = '${date.toLocal()}';
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(formatted, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          const Text('Доступность: none'),
          const SizedBox(height: 8),
          const Text('Репетиции: 0'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Изменить доступность'),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Новая репетиция'),
          ),
        ],
      ),
    );
  }
}
