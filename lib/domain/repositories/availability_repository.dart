import 'package:rehearsal_app/core/db/app_database.dart';

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
}
