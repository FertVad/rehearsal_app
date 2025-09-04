import 'package:flutter/material.dart';
import 'package:rehearsal_app/core/design_system/glass_system.dart';
import 'package:rehearsal_app/core/design_system/app_spacing.dart';
import 'package:rehearsal_app/core/design_system/app_typography.dart';
import 'package:rehearsal_app/core/widgets/empty_state.dart';

class UpcomingRehearsals extends StatelessWidget {
  const UpcomingRehearsals({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Подключить к реальным данным через Provider
    final hasRehearsals = false;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Upcoming Rehearsals',
            style: AppTypography.headingMedium,
          ),
          const SizedBox(height: AppSpacing.md),
          GlassCard(
            child: SizedBox(
              height: 200,
              child: hasRehearsals
                  ? _RehearsalsList()
                  : EmptyState(
                      icon: Icons.event_busy,
                      title: 'No rehearsals scheduled',
                      description: 'Schedule your first rehearsal',
                      actionLabel: 'Create rehearsal',
                      onAction: () {
                        // TODO: Navigate to create rehearsal
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RehearsalsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: Implement rehearsals list
    return const Center(
      child: Text('Rehearsals list'),
    );
  }
}

