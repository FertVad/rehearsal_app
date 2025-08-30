import 'package:flutter/material.dart';
import 'day_bottom_sheet.dart';

class AvailabilityPage extends StatelessWidget {
  const AvailabilityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Availability')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              builder: (ctx) => DayBottomSheet(dayLocal: DateTime.now()),
            );
          },
          child: const Text('Open Day'),
        ),
      ),
    );
  }
}
