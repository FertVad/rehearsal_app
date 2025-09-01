import 'package:flutter/material.dart';
import 'package:rehearsal_app/core/design_system/haptics.dart';
import 'package:rehearsal_app/features/dashboard/widgets/day_scroller.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  DateTime _selected = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          Center(
            child: DayScroller(
              initialDate: _selected,
              onDateChanged: (d) => setState(() => _selected = d),
              onHaptic: () => AppHaptics.selection(),
              eventPredicate: (_) => false,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Выбрано: ${_selected.toString().split(' ').first}',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Center(
              child: Text(
                'Секции дашборда появятся здесь',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
