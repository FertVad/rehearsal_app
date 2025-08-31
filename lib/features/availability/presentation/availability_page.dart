import 'package:flutter/material.dart';
import 'package:rehearsal_app/core/l10n/l10n.dart';
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
              builder: (ctx) => DayBottomSheet(dayLocal: DateTime.now()),
            );
          },
          child: Text(context.l10n.availabilityOpenDay),
        ),
      ),
    );
  }
}
