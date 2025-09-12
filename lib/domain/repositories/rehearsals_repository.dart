import 'package:rehearsal_app/domain/models/rehearsal.dart';

abstract class RehearsalsRepository {
  Future<Rehearsal> create({
    required String id,
    String? projectId,
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

  /// Add participants to a rehearsal
  Future<void> addParticipants({
    required String rehearsalId,
    required List<String> userIds,
    String rsvpStatus = 'pending',
  });

  /// Create rehearsal with participants and update their availability
  Future<Rehearsal> createWithParticipants({
    required String id,
    String? projectId,
    required int startsAtUtc,
    required int endsAtUtc,
    String? place,
    String? note,
    required List<String> participantIds,
    String lastWriter = 'device:local',
  });
}
