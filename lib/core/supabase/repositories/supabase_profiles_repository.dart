import 'package:rehearsal_app/domain/repositories/users_repository.dart';
import 'package:rehearsal_app/core/supabase/supabase_config.dart';
import 'package:rehearsal_app/core/db/app_database.dart';

class SupabaseProfilesRepository implements UsersRepository {
  static const String _tableName = 'profiles';

  @override
  Future<User> create({
    required String id,
    String? name,
    String? avatarUrl,
    String tz = 'UTC',
    String lastWriter = 'device:local',
  }) async {
    try {
      final data = {
        'user_id': id, // profiles.user_id links to auth.users.id
        'display_name': name,
        'avatar_url': avatarUrl,
        'timezone': tz,
        'metadata': <String, dynamic>{},
      };

      final response = await SupabaseConfig.client
          .from(_tableName)
          .insert(data)
          .select()
          .single();

      // Convert back to Drift format for compatibility
      final createdAt = DateTime.parse(response['created_at']);
      final updatedAt = DateTime.parse(response['updated_at']);
      final deletedAt = response['deleted_at'] != null ? DateTime.parse(response['deleted_at']) : null;

      return User(
        id: response['id'],
        createdAtUtc: createdAt.millisecondsSinceEpoch,
        updatedAtUtc: updatedAt.millisecondsSinceEpoch,
        deletedAtUtc: deletedAt?.millisecondsSinceEpoch,
        lastWriter: lastWriter,
        name: response['display_name'],
        avatarUrl: response['avatar_url'],
        tz: response['timezone'],
        metadata: response['metadata']?.toString(),
      );
    } catch (e) {
      throw Exception('Failed to create profile: $e');
    }
  }

  @override
  Future<User?> getById(String id) async {
    try {
      final response = await SupabaseConfig.client
          .from(_tableName)
          .select()
          .eq('user_id', id)
          .maybeSingle();

      if (response == null) {
        return null;
      }

      final createdAt = DateTime.parse(response['created_at']);
      final updatedAt = DateTime.parse(response['updated_at']);
      final deletedAt = response['deleted_at'] != null ? DateTime.parse(response['deleted_at']) : null;

      return User(
        id: response['user_id'] ?? response['id'], // Use user_id if available, fallback to id
        createdAtUtc: createdAt.millisecondsSinceEpoch,
        updatedAtUtc: updatedAt.millisecondsSinceEpoch,
        deletedAtUtc: deletedAt?.millisecondsSinceEpoch,
        lastWriter: 'supabase:user',
        name: response['display_name'],
        avatarUrl: response['avatar_url'],
        tz: response['timezone'] ?? 'UTC',
        metadata: response['metadata']?.toString(),
      );
    } catch (e) {
      throw Exception('Failed to get profile by ID: $e');
    }
  }

  @override
  Future<List<User>> list() async {
    try {
      final response = await SupabaseConfig.client
          .from(_tableName)
          .select()
          .order('created_at', ascending: false);

      return response.map<User>((json) {
        final createdAt = DateTime.parse(json['created_at']);
        final updatedAt = DateTime.parse(json['updated_at']);
        final deletedAt = json['deleted_at'] != null ? DateTime.parse(json['deleted_at']) : null;

        return User(
          id: json['user_id'] ?? json['id'], // Use user_id if available, fallback to id
          createdAtUtc: createdAt.millisecondsSinceEpoch,
          updatedAtUtc: updatedAt.millisecondsSinceEpoch,
          deletedAtUtc: deletedAt?.millisecondsSinceEpoch,
          lastWriter: 'supabase:user',
          name: json['display_name'],
          avatarUrl: json['avatar_url'],
          tz: json['timezone'] ?? 'UTC',
          metadata: json['metadata']?.toString(),
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to list profiles: $e');
    }
  }

  @override
  Future<void> update({
    required String id,
    String? name,
    String? avatarUrl,
    String? tz,
    String lastWriter = 'device:local',
  }) async {
    try {
      final updateData = <String, dynamic>{};

      if (name != null) updateData['display_name'] = name;
      if (avatarUrl != null) updateData['avatar_url'] = avatarUrl;
      if (tz != null) updateData['timezone'] = tz;

      await SupabaseConfig.client
          .from(_tableName)
          .update(updateData)
          .eq('user_id', id);
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  @override
  Future<void> softDelete(String id, {String lastWriter = 'device:local'}) async {
    try {
      await SupabaseConfig.client
          .from(_tableName)
          .update({
            'deleted_at': DateTime.now().toUtc().toIso8601String(),
          })
          .eq('user_id', id);
    } catch (e) {
      throw Exception('Failed to delete profile: $e');
    }
  }

  /// Update user metadata specifically (for settings)
  Future<void> updateMetadata({
    required String id,
    required Map<String, dynamic> metadata,
    String lastWriter = 'device:local',
  }) async {
    try {
      await SupabaseConfig.client
          .from(_tableName)
          .update({'metadata': metadata})
          .eq('user_id', id);
    } catch (e) {
      throw Exception('Failed to update metadata: $e');
    }
  }
}