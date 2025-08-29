import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rehearsal_app/core/db/app_database.dart';
import 'package:rehearsal_app/core/db/connection_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('users insert & query', () async {
    final db = AppDatabase.forTesting(testConnection());

    final now = DateTime.now().millisecondsSinceEpoch;
    await db.insertUser(UsersCompanion.insert(
      id: 'user-1',
      createdAtUtc: now,
      updatedAtUtc: now,
      lastWriter: 'tester',
      tz: 'UTC',
      name: const Value('Vadim'),
    ));

    final all = await db.getAllUsers();
    expect(all.length, 1);
    expect(all.first.id, 'user-1');
    expect(all.first.createdAtUtc, now);

    await db.close();
  });
}
