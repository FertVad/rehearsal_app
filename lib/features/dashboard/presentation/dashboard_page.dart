import 'package:flutter/material.dart';

import 'package:rehearsal_app/core/design_system/glass_system.dart' as ds;
import 'package:rehearsal_app/features/dashboard/widgets/day_scroller.dart';
import 'package:rehearsal_app/features/dashboard/widgets/dash_background.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DashBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Стеклянная панель с DayScroller — БЕЗ дополнительных обёрток стекла внутри
                ds.GlassCard(
                  child: SizedBox(height: 120, child: DayScroller()),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
