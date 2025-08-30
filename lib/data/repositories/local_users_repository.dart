import 'package:drift/drift.dart';
import 'package:rehearsal_app/core/db/app_database.dart';
import 'package:rehearsal_app/domain/repositories/users_repository.dart';

class LocalUsersRepository implements UsersRepository {
  LocalUsersRepository(this.db);
  final AppDatabase db;

  @override
  Future<User> create({
    required String id,
    String? name,
    String? avatarUrl,
    required String tz,
    String lastWriter = 'device:local',
  }) async {
    final now = DateTime.now().toUtc().millisecondsSinceEpoch;
    await db.into(db.users).insert(
          UsersCompanion.insert(
            id: id,
            name: Value(name),
            avatarUrl: Value(avatarUrl),
            tz: tz,
            createdAtUtc: now,
            updatedAtUtc: now,
            lastWriter: lastWriter,
          ),
        );
    return (await getById(id))!;
  }

  @override
  Future<User?> getById(String id) {
    return (db.select(db.users)
          ..where((t) => t.id.equals(id))
          ..where((t) => t.deletedAtUtc.isNull()))
        .getSingleOrNull();
  }

  @override
  Future<List<User>> list() {
    return (db.select(db.users)
          ..where((t) => t.deletedAtUtc.isNull())
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .get();
  }

  @override
  Future<void> update({
    required String id,
    String? name,
    String? avatarUrl,
    String? tz,
    String lastWriter = 'device:local',
  }) async {
    final now = DateTime.now().toUtc().millisecondsSinceEpoch;
    await (db.update(db.users)..where((t) => t.id.equals(id))).write(
      UsersCompanion(
        name: name != null ? Value(name) : const Value.absent(),
        avatarUrl: avatarUrl != null ? Value(avatarUrl) : const Value.absent(),
        tz: tz != null ? Value(tz) : const Value.absent(),
        updatedAtUtc: Value(now),
        lastWriter: Value(lastWriter),
      ),
    );
  }

  @override
  Future<void> softDelete(String id, {String lastWriter = 'device:local'}) async {
    final now = DateTime.now().toUtc().millisecondsSinceEpoch;
    await (db.update(db.users)..where((t) => t.id.equals(id))).write(
      UsersCompanion(
        deletedAtUtc: Value(now),
        updatedAtUtc: Value(now),
        lastWriter: Value(lastWriter),
      ),
    );
  }
}
