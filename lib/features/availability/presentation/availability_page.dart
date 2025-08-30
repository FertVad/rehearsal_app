import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/availability_provider.dart';
import 'widgets/calendar_grid.dart' as grid;

class AvailabilityPage extends ConsumerWidget {
  const AvailabilityPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Trigger loading for the currently visible month and when it changes.
    ref.listen<DateTime>(
      availabilityControllerProvider.select((s) => s.visibleMonth),
      (_, month) {
        ref.read(availabilityControllerProvider.notifier).loadMonth(month);
      },
    );

    final pageState = ref.watch(availabilityControllerProvider);
    // Ensure initial month data is loaded at least once after first frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(availabilityControllerProvider.notifier)
          .loadMonth(pageState.visibleMonth);
    });

    final byDate = pageState.byDate.map(
      (key, view) =>
          MapEntry(key, grid.AvailabilityStatus.values[view.status.index]),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Availability')),
      body: Column(
        children: [
          const SizedBox(height: 8),
          ToggleButtons(
            isSelected: const [true, false],
            onPressed: (_) {},
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text('Month'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text('Week'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          grid.CalendarGrid(
            month: pageState.visibleMonth,
            byDate: byDate,
            onDayTap: (day) {
              showModalBottomSheet(
                context: context,
                builder: (_) => Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('Day: $day'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
