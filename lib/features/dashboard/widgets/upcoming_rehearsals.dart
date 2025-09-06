import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rehearsal_app/core/design_system/glass_system.dart';
import 'package:rehearsal_app/core/design_system/app_colors.dart';
import 'package:rehearsal_app/core/design_system/app_spacing.dart';
import 'package:rehearsal_app/core/design_system/app_typography.dart';
import 'package:rehearsal_app/core/widgets/empty_state.dart';
import 'package:rehearsal_app/core/widgets/loading_state.dart';
import 'package:rehearsal_app/core/providers/index.dart';
import 'package:rehearsal_app/features/rehearsals/presentation/rehearsal_create_page.dart';
import 'package:rehearsal_app/features/rehearsals/presentation/rehearsal_details_page.dart';
import 'package:rehearsal_app/core/utils/localization_helper.dart';
import 'package:rehearsal_app/l10n/app.dart';

class UpcomingRehearsals extends ConsumerWidget {
  const UpcomingRehearsals({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch locale changes to trigger rebuild
    ref.watch(localeProvider);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(context.l10n.upcomingRehearsals, style: AppTypography.headingMedium),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => _createRehearsal(context),
                tooltip: context.l10n.addRehearsal,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          GlassCard(
            child: SizedBox(
              height: 250,
              child: FutureBuilder(
                key: ValueKey('upcoming_rehearsals_${ref.watch(localeProvider)}'),
                future: _loadUpcomingRehearsals(ref),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const LoadingState();
                  }

                  if (snapshot.hasError) {
                    return EmptyState(
                      icon: Icons.error_outline,
                      title: context.l10n.error,
                      description: context.l10n.failedToLoad,
                      actionLabel: context.l10n.retry,
                      onAction: () {
                        // Trigger rebuild
                      },
                    );
                  }

                  final rehearsals = snapshot.data ?? [];
                  
                  if (rehearsals.isEmpty) {
                    return EmptyState(
                      icon: Icons.event_busy,
                      title: context.l10n.noRehearsalsScheduled,
                      description: context.l10n.scheduleFirst,
                      actionLabel: context.l10n.createRehearsal,
                      onAction: () => _createRehearsal(context),
                    );
                  }

                  return ListView.builder(
                    padding: AppSpacing.paddingMD,
                    itemCount: rehearsals.length,
                    itemBuilder: (context, index) {
                      final rehearsal = rehearsals[index];
                      final startTime = DateTime.fromMillisecondsSinceEpoch(
                        rehearsal.startsAtUtc,
                        isUtc: true,
                      ).toLocal();

                      return Card(
                        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                        color: AppColors.glassLightBase,
                        child: ListTile(
                          leading: Icon(
                            Icons.event,
                            color: AppColors.primaryPurple,
                          ),
                          title: Text(
                            rehearsal.place ?? context.l10n.rehearsal,
                            style: AppTypography.bodyLarge,
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${_formatDate(context, startTime)} at ${TimeOfDay.fromDateTime(startTime).format(context)}',
                                style: AppTypography.bodyMedium.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              if (rehearsal.note != null && rehearsal.note!.isNotEmpty)
                                Text(
                                  rehearsal.note!,
                                  style: AppTypography.bodySmall.copyWith(
                                    color: AppColors.textTertiary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                            ],
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => _openRehearsalDetails(context, rehearsal.id),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<List<dynamic>> _loadUpcomingRehearsals(WidgetRef ref) async {
    try {
      final rehearsalsRepo = ref.read(rehearsalsRepositoryProvider);
      final userId = ref.read(currentUserIdProvider) ?? 'anonymous';
      
      final now = DateTime.now().toUtc();
      final nextWeek = now.add(const Duration(days: 7));
      
      final rehearsals = await rehearsalsRepo.listForUserInRange(
        userId: userId,
        fromUtc: now.millisecondsSinceEpoch,
        toUtc: nextWeek.millisecondsSinceEpoch,
      );
      
      // Sort by start time
      rehearsals.sort((a, b) => a.startsAtUtc.compareTo(b.startsAtUtc));
      
      // Limit to 5 most recent
      return rehearsals.take(5).toList();
    } catch (e) {
      throw Exception('Failed to load rehearsals: $e');
    }
  }

  String _formatDate(BuildContext context, DateTime date) {
    return LocalizationHelper.formatRelativeDate(context, date);
  }

  Future<void> _createRehearsal(BuildContext context) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => const RehearsalCreatePage(),
      ),
    );
    
    if (result == true) {
      // Data will be refreshed automatically by FutureBuilder
    }
  }

  void _openRehearsalDetails(BuildContext context, String rehearsalId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RehearsalDetailsPage(rehearsalId: rehearsalId),
      ),
    );
  }
}
