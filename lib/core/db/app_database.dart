import 'package:drift/drift.dart';

import 'connection.dart';

part 'app_database.g.dart';

class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

@DriftDatabase(tables: [Users])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openConnection());

  @override
  int get schemaVersion => 1;

  Future<int> insertUser(UsersCompanion entry) => into(users).insert(entry);
  Future<List<User>> getAllUsers() => select(users).get();
}
