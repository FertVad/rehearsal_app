import 'package:flutter/material.dart';
import 'package:rehearsal_app/core/design_system/app_spacing.dart';
import 'package:rehearsal_app/l10n/app.dart';
import 'day_bottom_sheet.dart';

class AvailabilityPage extends StatelessWidget {
  const AvailabilityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.availabilityTitle)),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(AppSpacing.radiusXL),
                ),
              ),
              builder: (ctx) => DayBottomSheet(dayLocal: DateTime.now()),
            );
          },
          child: Text(context.l10n.availabilityOpenDay),
        ),
      ),
    );
  }
}
