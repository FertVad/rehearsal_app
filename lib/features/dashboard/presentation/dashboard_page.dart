import 'package:flutter/material.dart';

import 'package:rehearsal_app/core/design_system/glass_system.dart';
import 'package:rehearsal_app/features/dashboard/widgets/day_scroller.dart';
import 'package:rehearsal_app/features/dashboard/widgets/dash_background.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late final DateTime _start;      // точка отсчёта (сегодня без времени)
  late DateTime _selected;         // выбранный день

  @override
  void initState() {
    super.initState();
    _start = DateUtils.dateOnly(DateTime.now());
    _selected = _start;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const DashBackground(),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Стеклянная панель с DayScroller — БЕЗ дополнительных обёрток стекла внутри
                  GlassCard(
                    child: DayScroller(
                      start: _start,
                      selected: _selected,
                      onDateSelected: (day) {
                        if (day == _selected) return;
                        setState(() => _selected = DateUtils.dateOnly(day));
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Пример использования выбранной даты в контенте ниже
                  Text(
                    'Selected: ${_selected.toIso8601String().substring(0, 10)}',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),

                  // todo: остальной контент дашборда
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
