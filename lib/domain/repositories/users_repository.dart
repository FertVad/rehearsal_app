import 'package:rehearsal_app/core/db/app_database.dart';

abstract class UsersRepository {
  Future<User> create({
    required String id,
    String? name,
    String? avatarUrl,
    required String tz,
    String lastWriter = 'device:local',
  });

  Future<User?> getById(String id);
  Future<List<User>> list();

  Future<void> update({
    required String id,
    String? name,
    String? avatarUrl,
    String? tz,
    String lastWriter = 'device:local',
  });

  Future<void> softDelete(String id, {String lastWriter = 'device:local'});
}
