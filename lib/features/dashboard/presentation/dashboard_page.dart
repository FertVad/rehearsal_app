import 'package:flutter/material.dart';
import 'package:rehearsal_app/core/ui/liquid_glass_panel.dart';
import 'package:rehearsal_app/features/dashboard/widgets/day_scroller.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late DateTime _selected;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selected = DateTime(now.year, now.month, now.day);
  }

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
          // Glass panel with the weekly header inside
          Center(
            child: SizedBox(
              width: 388,
              height: 120,
              child: LiquidGlassPanel(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: DayScroller(),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Выбрано: '
            '${DateTimeRange(start: _selected, end: _selected).start.toString().split(' ').first}',
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
