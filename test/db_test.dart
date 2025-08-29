import 'package:flutter_test/flutter_test.dart';
import 'package:rehearsal_app/core/db/app_database.dart';

void main() {
  late AppDatabase db;
  late UserDao userDao;

  setUp(() {
    db = AppDatabase();
    userDao = db.userDao;
  });

  tearDown(() async {
    await db.close();
  });

  test('insert and query user', () async {
    final id = await userDao.insertUser(
      UsersCompanion.insert(name: 'Alice'),
    );
    final users = await userDao.getAllUsers();
    expect(users.length, 1);
    expect(users.first.id, id);
    expect(users.first.name, 'Alice');
  });
}
