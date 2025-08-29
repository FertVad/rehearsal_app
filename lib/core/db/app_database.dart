import 'package:drift/drift.dart';

import 'connection.dart';

part 'app_database.g.dart';

class Users extends Table {
  TextColumn get id => text()();

  IntColumn get createdAtUtc => integer()();
  IntColumn get updatedAtUtc => integer()();
  IntColumn get deletedAtUtc => integer().nullable()();

  TextColumn get lastWriter => text()();

  TextColumn get name => text().nullable()();
  TextColumn get avatarUrl => text().nullable()();
  TextColumn get tz => text()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Users])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openConnection());
  AppDatabase.forTesting(DatabaseConnection connection) : super(connection);

  @override
  int get schemaVersion => 1;

  Future<void> insertUser(UsersCompanion entry) =>
      into(users).insertOnConflictUpdate(entry);

  Future<List<User>> getAllUsers() => select(users).get();
}
