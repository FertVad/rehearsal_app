import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rehearsal_app/core/design_system/calendar_components.dart';
import 'package:rehearsal_app/core/providers/index.dart';
import 'package:rehearsal_app/core/utils/time.dart';

/// Calendar data providers that fetch real rehearsal data

/// Provider for rehearsal event dates in a given month
final eventDatesProvider = FutureProvider.family<List<DateTime>, DateTime>((
  ref,
  month,
) async {
  final rehearsalsRepo = ref.read(rehearsalsRepositoryProvider);
  final userId = ref.read(currentUserIdProvider);

  // Return empty list if user is not authenticated
  if (userId == null) {
    return [];
  }

  // Get first and last day of the month in UTC
  final firstDay = DateTime(month.year, month.month, 1);
  final lastDay = DateTime(month.year, month.month + 1, 0);
  final fromUtc = dateUtc00(firstDay);
  final toUtc = dateUtc00(lastDay);

  try {
    final rehearsals = await rehearsalsRepo.listForUserInRange(
      userId: userId,
      fromUtc: fromUtc,
      toUtc: toUtc,
    );

    // Extract unique start dates from rehearsals
    final eventDates = <DateTime>{};
    for (final rehearsal in rehearsals) {
      final startDate = DateTime.fromMillisecondsSinceEpoch(
        rehearsal.startsAtUtc,
        isUtc: true,
      );
      final localDate = DateTime(
        startDate.year,
        startDate.month,
        startDate.day,
      );
      eventDates.add(localDate);
    }

    return eventDates.toList()..sort();
  } catch (e) {
    // Return empty list on error (calendar will show no events)
    return [];
  }
});

/// Provider for availability map in a given month
final availabilityMapProvider =
    FutureProvider.family<Map<DateTime, AvailabilityStatus>, DateTime>((
      ref,
      month,
    ) async {
      final availabilityRepo = ref.read(availabilityRepositoryProvider);
      final userId = ref.read(currentUserIdProvider);

      // Return empty map if user is not authenticated
      if (userId == null) {
        return {};
      }

      // Get first and last day of the month in UTC
      final firstDay = DateTime(month.year, month.month, 1);
      final lastDay = DateTime(month.year, month.month + 1, 0);
      final fromUtc = dateUtc00(firstDay);
      final toUtc = dateUtc00(lastDay);

      try {
        final availabilityItems = await availabilityRepo.listForUserRange(
          userId: userId,
          fromDateUtc00: fromUtc,
          toDateUtc00: toUtc,
        );

        final map = <DateTime, AvailabilityStatus>{};
        for (final item in availabilityItems) {
          final date = DateTime.fromMillisecondsSinceEpoch(
            item.dateUtc,
            isUtc: true,
          );
          final localDate = DateTime(date.year, date.month, date.day);

          // Use the status from availability state
          AvailabilityStatus status;
          switch (item.status) {
            case 'free':
              status = AvailabilityStatus.free;
              break;
            case 'busy':
              status = AvailabilityStatus.busy;
              break;
            case 'partial':
              status = AvailabilityStatus.partial;
              break;
            default:
              continue; // Skip unknown statuses
          }

          map[localDate] = status;
        }

        return map;
      } catch (e) {
        // Return empty map on error
        return {};
      }
    });
