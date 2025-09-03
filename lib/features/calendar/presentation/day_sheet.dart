import 'package:flutter/material.dart';
import 'package:rehearsal_app/core/design_system/app_spacing.dart';
import 'package:rehearsal_app/core/design_system/app_typography.dart';
import 'package:rehearsal_app/l10n/app.dart';

/// Bottom sheet displaying basic information about a day.
class DaySheet extends StatelessWidget {
  const DaySheet({super.key, required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final formatted = '${date.toLocal()}';
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(formatted, style: AppTypography.titleSm),
          const SizedBox(height: AppSpacing.md),
          Text(
            context.l10n.daySheetAvailabilityNone,
            style: AppTypography.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            context.l10n.daySheetRehearsals0,
            style: AppTypography.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.lg),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(context.l10n.daySheetChangeAvailability),
          ),
          const SizedBox(height: AppSpacing.sm),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(context.l10n.daySheetNewRehearsal),
          ),
        ],
      ),
    );
  }
}
