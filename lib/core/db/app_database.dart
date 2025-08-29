import 'dart:io' show File, Platform;
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:drift/web.dart' as web;

part 'app_database.g.dart';

class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

@DriftDatabase(tables: [Users])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<int> insertUser(UsersCompanion entry) => into(users).insert(entry);
  Future<List<User>> getAllUsers() => select(users).get();
}

QueryExecutor _openConnection() {
  if (kIsWeb) {
    // Временное решение: старый, но рабочий WebDatabase
    return web.WebDatabase('rehearsal');
  } else {
    return LazyDatabase(() async {
      final dir = (Platform.isIOS || Platform.isMacOS)
          ? await getLibraryDirectory()
          : await getApplicationSupportDirectory();
      final file = File(p.join(dir.path, 'app.sqlite'));
      return NativeDatabase(file);
    });
  }
}
