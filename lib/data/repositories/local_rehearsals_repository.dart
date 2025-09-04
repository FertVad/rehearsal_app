import 'package:drift/drift.dart';
import 'package:rehearsal_app/core/constants/time_constants.dart';
import 'package:rehearsal_app/core/db/app_database.dart';
import 'package:rehearsal_app/domain/repositories/rehearsals_repository.dart';

class LocalRehearsalsRepository implements RehearsalsRepository {
  LocalRehearsalsRepository(this.db);
  final AppDatabase db;

  @override
  Future<Rehearsal> create({
    required String id,
    String? troupeId,
    required int startsAtUtc,
    required int endsAtUtc,
    String? place,
    String? note,
    String lastWriter = 'device:local',
  }) async {
    final now = DateTime.now().toUtc().millisecondsSinceEpoch;
    await db.into(db.rehearsals).insert(
          RehearsalsCompanion.insert(
            id: id,
            troupeId: Value(troupeId),
            startsAtUtc: startsAtUtc,
            endsAtUtc: endsAtUtc,
            place: Value(place),
            note: Value(note),
            createdAtUtc: now,
            updatedAtUtc: now,
            lastWriter: lastWriter,
          ),
        );
    return (await getById(id))!;
  }

  @override
  Future<Rehearsal?> getById(String id) {
    return (db.select(db.rehearsals)
          ..where((t) => t.id.equals(id))
          ..where((t) => t.deletedAtUtc.isNull()))
        .getSingleOrNull();
  }

  @override
  Future<List<Rehearsal>> listForUserOnDateUtc({
    required String userId,
    required int dateUtc00,
  }) async {
    final msPerDay = TimeConstants.millisecondsPerDay;
    final dayEnd = dateUtc00 + msPerDay;

    final joins = await (db.select(db.rehearsalAttendees).join([
      innerJoin(
        db.rehearsals,
        db.rehearsals.id.equalsExp(db.rehearsalAttendees.rehearsalId),
      ),
    ])
          ..where(db.rehearsalAttendees.userId.equals(userId))
          ..where(db.rehearsalAttendees.deletedAtUtc.isNull())
          ..where(db.rehearsals.deletedAtUtc.isNull())
          ..where(db.rehearsals.startsAtUtc.isBiggerOrEqualValue(dateUtc00))
          ..where(db.rehearsals.startsAtUtc.isSmallerThanValue(dayEnd))
          ..orderBy([OrderingTerm.asc(db.rehearsals.startsAtUtc)]))
        .get();

    return joins.map((row) => row.readTable(db.rehearsals)).toList();
  }

  @override
  Future<List<Rehearsal>> listForUserInRange({
    required String userId,
    required int fromUtc,
    required int toUtc,
  }) async {
    final joins = await (db.select(db.rehearsalAttendees).join([
      innerJoin(
        db.rehearsals,
        db.rehearsals.id.equalsExp(db.rehearsalAttendees.rehearsalId),
      ),
    ])
          ..where(db.rehearsalAttendees.userId.equals(userId))
          ..where(db.rehearsalAttendees.deletedAtUtc.isNull())
          ..where(db.rehearsals.deletedAtUtc.isNull())
          ..where(db.rehearsals.startsAtUtc.isBiggerOrEqualValue(fromUtc))
          ..where(db.rehearsals.startsAtUtc.isSmallerThanValue(toUtc))
          ..orderBy([OrderingTerm.asc(db.rehearsals.startsAtUtc)]))
        .get();

    return joins.map((row) => row.readTable(db.rehearsals)).toList();
  }

  @override
  Future<void> update({
    required String id,
    int? startsAtUtc,
    int? endsAtUtc,
    String? place,
    String? note,
    String lastWriter = 'device:local',
  }) async {
    final now = DateTime.now().toUtc().millisecondsSinceEpoch;
    await (db.update(db.rehearsals)..where((t) => t.id.equals(id))).write(
      RehearsalsCompanion(
        startsAtUtc:
            startsAtUtc != null ? Value(startsAtUtc) : const Value.absent(),
        endsAtUtc: endsAtUtc != null ? Value(endsAtUtc) : const Value.absent(),
        place: place != null ? Value(place) : const Value.absent(),
        note: note != null ? Value(note) : const Value.absent(),
        updatedAtUtc: Value(now),
        lastWriter: Value(lastWriter),
      ),
    );
  }

  @override
  Future<void> softDelete(String id, {String lastWriter = 'device:local'}) async {
    final now = DateTime.now().toUtc().millisecondsSinceEpoch;
    await (db.update(db.rehearsals)..where((t) => t.id.equals(id))).write(
      RehearsalsCompanion(
        deletedAtUtc: Value(now),
        updatedAtUtc: Value(now),
        lastWriter: Value(lastWriter),
      ),
    );
  }
}
