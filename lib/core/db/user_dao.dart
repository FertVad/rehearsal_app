part of 'app_database.dart';

@DriftAccessor(tables: [Users])
class UserDao extends DatabaseAccessor<AppDatabase> with _$UserDaoMixin {
  UserDao(AppDatabase db) : super(db);

  Future<int> insertUser(UsersCompanion entity) => into(users).insert(entity);

  Future<List<User>> getAllUsers() => select(users).get();
}
