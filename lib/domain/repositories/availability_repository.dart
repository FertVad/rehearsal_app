import 'package:rehearsal_app/domain/models/availability.dart';

abstract class AvailabilityRepository {
  Future<Availability?> getForUserOnDateUtc({
    required String userId,
    required int dateUtc00, // 00:00 UTC millis for the date
  });

  Future<void> upsertForUserOnDateUtc({
    required String userId,
    required int dateUtc00,
    required String status, // 'free' | 'busy' | 'partial'
    String? intervalsJson, // JSON массив интервалов
    String? note,
    String lastWriter = 'device:local',
  });

  Future<List<Availability>> listForUserRange({
    required String userId,
    required int fromDateUtc00,
    required int toDateUtc00, // exclusive
  });

  /// Block time slot for rehearsal - remove this time from user's available intervals
  Future<void> blockTimeSlot({
    required String userId,
    required int dateUtc00,
    required int startMinutes, // minutes from midnight (e.g. 600 for 10:00)
    required int endMinutes,   // minutes from midnight (e.g. 720 for 12:00)
    String lastWriter = 'system:rehearsal',
  });
}
