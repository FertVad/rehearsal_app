import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rehearsal_app/core/design_system/app_colors.dart';
import 'package:rehearsal_app/core/design_system/app_spacing.dart';
import 'package:rehearsal_app/core/design_system/app_typography.dart';
import 'package:rehearsal_app/core/widgets/loading_state.dart';
import 'package:rehearsal_app/core/widgets/empty_state.dart';
import 'package:rehearsal_app/features/calendar/providers/calendar_providers.dart';
import 'package:rehearsal_app/features/calendar/widgets/calendar_view.dart';
import 'package:rehearsal_app/features/dashboard/widgets/dash_background.dart';
import 'package:rehearsal_app/features/rehearsals/presentation/rehearsal_create_page.dart';
import 'package:rehearsal_app/features/rehearsals/presentation/rehearsal_details_page.dart';
import 'package:rehearsal_app/core/providers/repository_providers.dart';
import 'package:rehearsal_app/l10n/app.dart';

final selectedCalendarDateProvider = StateProvider<DateTime?>((ref) => null);
final currentCalendarMonthProvider =
    StateProvider<DateTime>((ref) => DateTime.now());

class CalendarPage extends ConsumerWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentMonth = ref.watch(currentCalendarMonthProvider);
    final selectedDate = ref.watch(selectedCalendarDateProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.navCalendar),
        actions: [
          IconButton(
            icon: const Icon(Icons.today),
            onPressed: () {
              final today = DateTime.now();
              ref.read(currentCalendarMonthProvider.notifier).state = today;
              ref.read(selectedCalendarDateProvider.notifier).state = today;
            },
          ),
        ],
      ),
      body: DashBackground(
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(const Duration(seconds: 1));
            },
            child: CustomScrollView(
              slivers: [
              // Month navigation
              SliverToBoxAdapter(
                child: Padding(
                  padding: AppSpacing.paddingLG,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left),
                        onPressed: () {
                          final previousMonth = DateTime(
                            currentMonth.year,
                            currentMonth.month - 1,
                          );
                          ref.read(currentCalendarMonthProvider.notifier).state =
                              previousMonth;
                        },
                      ),
                      Text(
                        _getMonthYearString(currentMonth),
                        style: AppTypography.headingMedium,
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_right),
                        onPressed: () {
                          final nextMonth = DateTime(
                            currentMonth.year,
                            currentMonth.month + 1,
                          );
                          ref.read(currentCalendarMonthProvider.notifier).state =
                              nextMonth;
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // Calendar
              SliverToBoxAdapter(
                child: Padding(
                  padding: AppSpacing.paddingLG,
                  child: _buildCalendar(currentMonth, selectedDate, ref),
                ),
              ),

              // Selected date details
              if (selectedDate != null)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: AppSpacing.paddingLG,
                    child: _DateDetails(date: selectedDate),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getMonthYearString(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  Widget _buildCalendar(DateTime currentMonth, DateTime? selectedDate, WidgetRef ref) {
    final eventDatesAsync = ref.watch(eventDatesProvider(currentMonth));
    final availabilityMapAsync = ref.watch(availabilityMapProvider(currentMonth));

    return eventDatesAsync.when(
      loading: () => const SizedBox(
        height: 300,
        child: LoadingState(),
      ),
      error: (error, stackTrace) => SizedBox(
        height: 300,
        child: EmptyState(
          icon: Icons.error_outline,
          title: 'Error loading calendar',
          description: 'Failed to load calendar data: $error',
          actionLabel: 'Retry',
          onAction: () {
            ref.invalidate(eventDatesProvider(currentMonth));
            ref.invalidate(availabilityMapProvider(currentMonth));
          },
        ),
      ),
      data: (eventDates) => availabilityMapAsync.when(
        loading: () => const SizedBox(
          height: 300,
          child: LoadingState(),
        ),
        error: (error, stackTrace) => CalendarView(
          currentDate: currentMonth,
          selectedDate: selectedDate,
          onDateSelected: (date) {
            ref.read(selectedCalendarDateProvider.notifier).state = date;
          },
          eventDates: eventDates,
          availabilityMap: const {}, // Show events without availability on error
        ),
        data: (availabilityMap) => CalendarView(
          currentDate: currentMonth,
          selectedDate: selectedDate,
          onDateSelected: (date) {
            ref.read(selectedCalendarDateProvider.notifier).state = date;
          },
          eventDates: eventDates,
          availabilityMap: availabilityMap,
        ),
      ),
    );
  }
}

class _DateDetails extends ConsumerWidget {
  const _DateDetails({required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Selected: ${_formatDate(date)}',
              style: AppTypography.headingMedium,
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _createRehearsal(context, date),
              tooltip: 'Add rehearsal',
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        
        // Rehearsals for this date
        FutureBuilder(
          future: _loadRehearsals(ref, date),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                height: 100,
                padding: AppSpacing.paddingLG,
                decoration: BoxDecoration(
                  color: AppColors.glassLightBase,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLG),
                  border: Border.all(color: AppColors.glassLightStroke),
                ),
                child: const Center(child: CircularProgressIndicator()),
              );
            }

            if (snapshot.hasError) {
              return Container(
                padding: AppSpacing.paddingLG,
                decoration: BoxDecoration(
                  color: AppColors.statusBusy.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLG),
                ),
                child: Text('Error loading rehearsals: ${snapshot.error}'),
              );
            }

            final rehearsals = snapshot.data ?? [];
            
            if (rehearsals.isEmpty) {
              return Container(
                width: double.infinity,
                padding: AppSpacing.paddingLG,
                decoration: BoxDecoration(
                  color: AppColors.glassLightBase,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLG),
                  border: Border.all(color: AppColors.glassLightStroke),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.event_busy,
                      size: 48,
                      color: AppColors.textTertiary,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'No rehearsals scheduled',
                      style: AppTypography.bodyLarge.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    ElevatedButton.icon(
                      onPressed: () => _createRehearsal(context, date),
                      icon: const Icon(Icons.add),
                      label: const Text('Add Rehearsal'),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: rehearsals.map((rehearsal) {
                final startTime = DateTime.fromMillisecondsSinceEpoch(rehearsal.startsAtUtc, isUtc: true).toLocal();
                final endTime = DateTime.fromMillisecondsSinceEpoch(rehearsal.endsAtUtc, isUtc: true).toLocal();
                
                return Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.glassLightBase,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                    border: Border.all(color: AppColors.glassLightStroke),
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.event,
                      color: AppColors.primaryPurple,
                    ),
                    title: Text(
                      rehearsal.place ?? 'Rehearsal',
                      style: AppTypography.bodyLarge,
                    ),
                    subtitle: Text(
                      '${TimeOfDay.fromDateTime(startTime).format(context)} - ${TimeOfDay.fromDateTime(endTime).format(context)}',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _openRehearsalDetails(context, rehearsal.id),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  Future<List<dynamic>> _loadRehearsals(WidgetRef ref, DateTime date) async {
    try {
      final rehearsalsRepo = ref.read(rehearsalsRepositoryProvider);
      final userId = ref.read(currentUserIdProvider);
      final dateUtc = DateTime(date.year, date.month, date.day).toUtc().millisecondsSinceEpoch;
      
      return await rehearsalsRepo.listForUserOnDateUtc(
        userId: userId,
        dateUtc00: dateUtc,
      );
    } catch (e) {
      return [];
    }
  }

  Future<void> _createRehearsal(BuildContext context, DateTime date) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => RehearsalCreatePage(selectedDate: date),
      ),
    );
    
    if (result == true) {
      // Refresh the calendar data
      // Note: The FutureBuilder will automatically rebuild
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

