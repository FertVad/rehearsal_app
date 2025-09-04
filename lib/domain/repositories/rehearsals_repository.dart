import 'package:rehearsal_app/core/db/app_database.dart';

abstract class RehearsalsRepository {
  Future<Rehearsal> create({
    required String id,
    String? troupeId,
    required int startsAtUtc,
    required int endsAtUtc,
    String? place,
    String? note,
    String lastWriter = 'device:local',
  });

  Future<Rehearsal?> getById(String id);

  Future<List<Rehearsal>> listForUserOnDateUtc({
    required String userId,
    required int dateUtc00,
  });

  Future<List<Rehearsal>> listForUserInRange({
    required String userId,
    required int fromUtc,
    required int toUtc,
  });

  Future<void> update({
    required String id,
    int? startsAtUtc,
    int? endsAtUtc,
    String? place,
    String? note,
    String lastWriter = 'device:local',
  });

  Future<void> softDelete(String id, {String lastWriter = 'device:local'});
}
