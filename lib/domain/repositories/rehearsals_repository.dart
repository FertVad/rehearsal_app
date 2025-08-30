import 'package:rehearsal_app/core/db/app_database.dart';

abstract class RehearsalsRepository {
  /// Возвращает репетиции пользователя за день [dateUtc00, dateUtc00+86400000)
  Future<List<Rehearsal>> listForUserOnDateUtc({
    required String userId,
    required int dateUtc00,
  });
}
