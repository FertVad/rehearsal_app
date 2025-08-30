import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rehearsal_app/core/db/app_database.dart';
import 'package:rehearsal_app/core/db/connection_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('migration smoke: schema v1 opens and basic CRUD', () async {
    final db = AppDatabase.forTesting(connection: testConnection());

    // 1) Проверяем версию схемы
    expect(db.schemaVersion, 1);

    // 2) Проверяем, что все таблицы на месте (по данным Drift)
    final tableNames = db.allTables.map((t) => t.actualTableName).toSet();

    expect(
      tableNames.containsAll({
        'users',
        'troupes',
        'troupe_members',
        'rehearsals',
        'rehearsal_attendees',
        'availabilities',
        'settings',
      }),
      isTrue,
      reason:
          'Не все ожидаемые таблицы найдены. Есть: ${tableNames.join(', ')}',
    );

    // 3) Минимальный CRUD (Users)
    final now = DateTime.now().millisecondsSinceEpoch;
    await db
        .into(db.users)
        .insert(
          UsersCompanion.insert(
            id: 'm-user',
            createdAtUtc: now,
            updatedAtUtc: now,
            lastWriter: 'tester',
            tz: 'UTC',
            name: const Value('Smoke'),
          ),
        );
    final users = await db.select(db.users).get();
    expect(users.any((u) => u.id == 'm-user'), isTrue);

    await db.close();
  });
}
