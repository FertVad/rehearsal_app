import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rehearsal_app/core/design_system/app_spacing.dart';
import 'package:rehearsal_app/core/design_system/app_typography.dart';
import 'package:rehearsal_app/core/design_system/calendar_components.dart'
    as calendar;
import 'package:rehearsal_app/core/widgets/loading_state.dart';
import 'package:rehearsal_app/core/widgets/empty_state.dart';
import 'package:rehearsal_app/core/utils/localization_helper.dart';
import 'package:rehearsal_app/l10n/app.dart';
import '../controller/availability_provider.dart';
import '../controller/availability_state.dart';
import 'widgets/calendar_grid.dart';
import 'day_bottom_sheet.dart';

class AvailabilityPage extends ConsumerStatefulWidget {
  const AvailabilityPage({super.key});

  @override
  ConsumerState<AvailabilityPage> createState() => _AvailabilityPageState();
}

class _AvailabilityPageState extends ConsumerState<AvailabilityPage> {
  late DateTime _currentMonth;

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime.now();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(availabilityControllerProvider.notifier)
          .loadMonth(_currentMonth);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(availabilityControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.availabilityTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.today),
            onPressed: () {
              final today = DateTime.now();
              _changeMonth(today);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Month navigation
          Padding(
            padding: AppSpacing.paddingLG,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () => _changeMonth(
                    DateTime(_currentMonth.year, _currentMonth.month - 1),
                  ),
                ),
                Text(
                  _getMonthYearString(_currentMonth),
                  style: AppTypography.headingMedium,
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () => _changeMonth(
                    DateTime(_currentMonth.year, _currentMonth.month + 1),
                  ),
                ),
              ],
            ),
          ),

          // Weekday headers
          Padding(
            padding: AppSpacing.paddingLG,
            child: Row(
              children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                  .map(
                    (day) => Expanded(
                      child: Center(
                        child: Text(day, style: AppTypography.calendarWeekday),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),

          // Calendar grid
          Expanded(
            child: Padding(
              padding: AppSpacing.paddingLG,
              child: _buildCalendarContent(state),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarContent(AvailabilityState state) {
    if (state.isLoading) {
      return const LoadingState();
    }

    if (state.error != null) {
      return EmptyState(
        icon: Icons.error_outline,
        title: 'Error loading availability',
        description: state.error!,
        actionLabel: 'Retry',
        onAction: () => ref
            .read(availabilityControllerProvider.notifier)
            .loadMonth(_currentMonth),
      );
    }

    // Convert AvailabilityView to AvailabilityStatus for CalendarGrid
    final byDateStatus = <int, calendar.AvailabilityStatus>{};
    for (final entry in state.byDate.entries) {
      // Convert between the two AvailabilityStatus enums
      calendar.AvailabilityStatus calendarStatus;
      switch (entry.value.status) {
        case AvailabilityStatus.free:
          calendarStatus = calendar.AvailabilityStatus.free;
          break;
        case AvailabilityStatus.busy:
          calendarStatus = calendar.AvailabilityStatus.busy;
          break;
        case AvailabilityStatus.partial:
          calendarStatus = calendar.AvailabilityStatus.partial;
          break;
      }
      byDateStatus[entry.key] = calendarStatus;
    }

    return CalendarGrid(
      month: _currentMonth,
      byDate: byDateStatus,
      onDayTap: _openDaySheet,
    );
  }

  void _changeMonth(DateTime newMonth) {
    setState(() {
      _currentMonth = newMonth;
    });
    ref.read(availabilityControllerProvider.notifier).loadMonth(newMonth);
  }

  void _openDaySheet(DateTime day) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusXL),
        ),
      ),
      builder: (ctx) => DayBottomSheet(dayLocal: day),
    );
  }

  String _getMonthYearString(DateTime date) {
    final months = LocalizationHelper.getMonthNames(context);
    return '${months[date.month - 1]} ${date.year}';
  }
}
