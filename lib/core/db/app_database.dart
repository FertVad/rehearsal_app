// ignore_for_file: use_super_parameters
import 'package:drift/drift.dart';

import 'connection.dart';

part 'app_database.g.dart';

// ───────────────────────── Tables: Common columns in each table ─────────────────────────
class Users extends Table {
  // common
  TextColumn get id => text()();
  IntColumn get createdAtUtc => integer()();
  IntColumn get updatedAtUtc => integer()();
  IntColumn get deletedAtUtc => integer().nullable()();
  TextColumn get lastWriter => text()();

  // specific
  TextColumn get name => text().nullable()();
  TextColumn get avatarUrl => text().nullable()();
  TextColumn get tz => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class Troupes extends Table {
  TextColumn get id => text()();
  IntColumn get createdAtUtc => integer()();
  IntColumn get updatedAtUtc => integer()();
  IntColumn get deletedAtUtc => integer().nullable()();
  TextColumn get lastWriter => text()();

  TextColumn get name => text()();
  TextColumn get inviteCode => text().unique()();

  @override
  Set<Column> get primaryKey => {id};
}

class TroupeMembers extends Table {
  TextColumn get id => text()();
  IntColumn get createdAtUtc => integer()();
  IntColumn get updatedAtUtc => integer()();
  IntColumn get deletedAtUtc => integer().nullable()();
  TextColumn get lastWriter => text()();

  TextColumn get troupeId => text()();
  TextColumn get userId => text()();
  TextColumn get role => text()(); // admin|actor|observer

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<String> get customConstraints => [
    'UNIQUE(troupe_id, user_id)',
    'FOREIGN KEY(troupe_id) REFERENCES troupes(id)',
    'FOREIGN KEY(user_id) REFERENCES users(id)',
  ];
}

class Rehearsals extends Table {
  TextColumn get id => text()();
  IntColumn get createdAtUtc => integer()();
  IntColumn get updatedAtUtc => integer()();
  IntColumn get deletedAtUtc => integer().nullable()();
  TextColumn get lastWriter => text()();

  TextColumn get troupeId => text().nullable()(); // MVP допускает single-user
  IntColumn get startsAtUtc => integer()();
  IntColumn get endsAtUtc => integer()();
  TextColumn get place => text().nullable()();
  TextColumn get note => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class RehearsalAttendees extends Table {
  TextColumn get id => text()();
  IntColumn get createdAtUtc => integer()();
  IntColumn get updatedAtUtc => integer()();
  IntColumn get deletedAtUtc => integer().nullable()();
  TextColumn get lastWriter => text()();

  TextColumn get rehearsalId => text()();
  TextColumn get userId => text()();
  TextColumn get role => text()(); // required|optional
  TextColumn get rsvp => text().nullable()(); // yes|no|pending

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<String> get customConstraints => [
    'UNIQUE(rehearsal_id, user_id)',
    'FOREIGN KEY(rehearsal_id) REFERENCES rehearsals(id)',
    'FOREIGN KEY(user_id) REFERENCES users(id)',
  ];
}

class Availabilities extends Table {
  TextColumn get id => text()();
  IntColumn get createdAtUtc => integer()();
  IntColumn get updatedAtUtc => integer()();
  IntColumn get deletedAtUtc => integer().nullable()();
  TextColumn get lastWriter => text()();

  TextColumn get userId => text()();
  IntColumn get dateUtc => integer()(); // 00:00 UTC дня
  TextColumn get status => text()(); // free|busy|partial
  TextColumn get intervalsJson => text().nullable()();
  TextColumn get note => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<String> get customConstraints => [
    'UNIQUE(user_id, date_utc)',
    'FOREIGN KEY(user_id) REFERENCES users(id)',
  ];
}

class Settings extends Table {
  TextColumn get key => text()(); // singleton key, e.g. 'app'
  TextColumn get valueJson => text()();

  @override
  Set<Column> get primaryKey => {key};
}

@DriftDatabase(
  tables: [
    Users,
    Troupes,
    TroupeMembers,
    Rehearsals,
    RehearsalAttendees,
    Availabilities,
    Settings,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openConnection());
  AppDatabase.forTesting({required QueryExecutor connection})
    : super(connection);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();

      // Индексы v1 — чтобы не переделывать позже
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_rehearsals_troupe_starts ON rehearsals(troupe_id, starts_at_utc)',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_rehearsal_attendees_rehearsal ON rehearsal_attendees(rehearsal_id)',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_availabilities_user_date ON availabilities(user_id, date_utc)',
      );
      await customStatement(
        'CREATE UNIQUE INDEX IF NOT EXISTS idx_troupe_members_unique ON troupe_members(troupe_id, user_id)',
      );
    },
    onUpgrade: (m, from, to) async {
      // v1 -> будущие версии: add-only миграции
    },
  );

  // ───────────────────────── Simple example DAO methods ─────────────────────────
  Future<void> insertUser(UsersCompanion entry) =>
      into(users).insertOnConflictUpdate(entry);

  Future<List<User>> getAllUsers() => select(users).get();
}
