import 'package:drift/drift.dart';
import 'package:rehearsal_app/core/db/app_database.dart';
import 'package:rehearsal_app/domain/repositories/availability_repository.dart';

class LocalAvailabilityRepository implements AvailabilityRepository {
  LocalAvailabilityRepository(this.db);
  final AppDatabase db;

  @override
  Future<Availability?> getForUserOnDateUtc({
    required String userId,
    required int dateUtc00,
  }) {
    return (db.select(db.availabilities)
          ..where((t) => t.userId.equals(userId) & t.dateUtc.equals(dateUtc00))
          ..where((t) => t.deletedAtUtc.isNull()))
        .getSingleOrNull();
  }

  @override
  Future<List<Availability>> listForUserRange({
    required String userId,
    required int fromDateUtc00,
    required int toDateUtc00,
  }) {
    return (db.select(db.availabilities)
          ..where((t) =>
              t.userId.equals(userId) &
              t.dateUtc.isBiggerOrEqualValue(fromDateUtc00) &
              t.dateUtc.isSmallerThanValue(toDateUtc00))
          ..where((t) => t.deletedAtUtc.isNull())
          ..orderBy([(t) => OrderingTerm.asc(t.dateUtc)]))
        .get();
  }

  @override
  Future<void> upsertForUserOnDateUtc({
    required String userId,
    required int dateUtc00,
    required String status,
    String? intervalsJson,
    String? note,
    String lastWriter = 'device:local',
  }) async {
    final nowUtc = DateTime.now().toUtc().millisecondsSinceEpoch;
    final existing = await getForUserOnDateUtc(
      userId: userId,
      dateUtc00: dateUtc00,
    );

    if (existing == null) {
      await db.into(db.availabilities).insert(
            AvailabilitiesCompanion.insert(
              id: '${userId}_$dateUtc00',
              userId: userId,
              dateUtc: dateUtc00,
              status: status,
              intervalsJson: Value(intervalsJson),
              note: Value(note),
              createdAtUtc: nowUtc,
              updatedAtUtc: nowUtc,
              lastWriter: lastWriter,
            ),
          );
    } else {
      await (db.update(db.availabilities)
            ..where((t) => t.id.equals(existing.id)))
          .write(
        AvailabilitiesCompanion(
          status: Value(status),
          intervalsJson: Value(intervalsJson),
          note: Value(note),
          updatedAtUtc: Value(nowUtc),
          lastWriter: Value(lastWriter),
        ),
      );
    }
  }
}
