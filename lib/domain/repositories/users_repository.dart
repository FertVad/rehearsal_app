import 'package:rehearsal_app/domain/models/user.dart';

abstract class UsersRepository {
  Future<User> create({
    required String id,
    String? name,
    String? avatarUrl,
    String tz = 'UTC',
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
