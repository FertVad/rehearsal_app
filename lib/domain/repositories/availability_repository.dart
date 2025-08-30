import 'package:rehearsal_app/core/db/app_database.dart';

abstract class AvailabilityRepository {
  /// Возвращает Availability пользователя на дату (00:00 UTC этого дня), либо null
  Future<Availability?> getForUserOnDateUtc({
    required String userId,
    required int dateUtc00,
  });
}
