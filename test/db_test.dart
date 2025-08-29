import 'package:flutter_test/flutter_test.dart';
import 'package:drift/drift.dart';
import 'package:rehearsal_app/core/db/app_database.dart';

void main() {
  test('users insert & query', () async {
    final db = AppDatabase();
    final id = await db.insertUser(UsersCompanion.insert(name: 'Vadim'));
    expect(id, greaterThan(0));

    final all = await db.getAllUsers();
    expect(all.any((u) => u.name == 'Vadim'), isTrue);

    await db.close();
  });
}
