import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rehearsal_app/core/design_system/app_spacing.dart';
import 'package:rehearsal_app/core/design_system/app_typography.dart';
import 'package:rehearsal_app/core/design_system/calendar_components.dart';
import 'package:rehearsal_app/features/calendar/widgets/calendar_view.dart';
import 'package:rehearsal_app/features/dashboard/widgets/dash_background.dart';
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
              // TODO: Refresh data
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
                  child: CalendarView(
                    currentDate: currentMonth,
                    selectedDate: selectedDate,
                    onDateSelected: (date) {
                      ref.read(selectedCalendarDateProvider.notifier).state =
                          date;
                    },
                    eventDates:
                        _getMockEventDates(),
                    availabilityMap:
                        _getMockAvailabilityMap(),
                  ),
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

  List<DateTime> _getMockEventDates() {
    final today = DateTime.now();
    return [
      today,
      today.add(const Duration(days: 2)),
      today.add(const Duration(days: 5)),
      today.add(const Duration(days: 10)),
    ];
  }

  Map<DateTime, AvailabilityStatus> _getMockAvailabilityMap() {
    final today = DateTime.now();
    return {
      DateTime(today.year, today.month, today.day): AvailabilityStatus.free,
      DateTime(today.year, today.month, today.day + 1): AvailabilityStatus.busy,
      DateTime(today.year, today.month, today.day + 2):
          AvailabilityStatus.partial,
      DateTime(today.year, today.month, today.day + 3): AvailabilityStatus.free,
    };
  }
}

class _DateDetails extends StatelessWidget {
  const _DateDetails({required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Selected: ${_formatDate(date)}',
          style: AppTypography.headingMedium,
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          padding: AppSpacing.paddingLG,
          decoration: BoxDecoration(
            color: Colors.grey.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppSpacing.radiusLG),
          ),
          child: const Text('Details for this day will be shown here'),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
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
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}

