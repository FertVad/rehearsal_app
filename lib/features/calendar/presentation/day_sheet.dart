import 'package:flutter/material.dart';
import 'package:rehearsal_app/core/l10n/l10n.dart';

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
          Text(context.l10n.daySheetAvailabilityNone),
          const SizedBox(height: 8),
          Text(context.l10n.daySheetRehearsals0),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(context.l10n.daySheetChangeAvailability),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(context.l10n.daySheetNewRehearsal),
          ),
        ],
      ),
    );
  }
}
