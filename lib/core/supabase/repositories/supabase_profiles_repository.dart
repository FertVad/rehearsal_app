import 'package:flutter/foundation.dart';
import 'package:rehearsal_app/domain/repositories/users_repository.dart';
import 'package:rehearsal_app/core/supabase/supabase_config.dart';
import 'package:rehearsal_app/core/supabase/base_repository.dart';
import 'package:rehearsal_app/domain/models/user.dart';

class SupabaseProfilesRepository extends BaseSupabaseRepository implements UsersRepository {
  static const String _tableName = 'profiles';

  @override
  Future<User> create({
    required String id,
    String? name,
    String? avatarUrl,
    String tz = 'UTC',
    String lastWriter = 'device:local',
  }) async {
    return safeExecute(
      () async {
        // Use fix_db schema fields for profiles table
        final data = buildDataMap({
          'id': id, // profiles.id (UUID primary key)
          'user_id': id, // profiles.user_id → auth.users.id
          'display_name': name,
          'avatar_url': avatarUrl,
          'timezone': tz != 'UTC' ? tz : null,
        });

        final response = await SupabaseConfig.client
            .from(_tableName)
            .insert(data)
            .select()
            .single();

        // Use base repository method for timestamp extraction
        final timestamps = extractTimestamps(response);

        return User(
          id: response['id'],
          createdAtUtc: timestamps['createdAtUtc']!,
          updatedAtUtc: timestamps['updatedAtUtc']!,
          deletedAtUtc: timestamps['deletedAtUtc'],
          lastWriter: lastWriter,
          name: response['display_name']?.toString() ?? response['username']?.toString() ?? 'Unknown User',
          avatarUrl: response['avatar_url'],
          tz: response['timezone']?.toString() ?? 'UTC',
          metadata: response['bio']?.toString() ?? '',
        );
      },
      operationName: 'CREATE',
      tableName: _tableName,
      recordId: id,
    );
  }

  @override
  Future<User?> getById(String id) async {
    return safeExecute(
      () async {
        if (kDebugMode) print('SupabaseProfilesRepository.getById: Looking for user with id: $id');
        
        final response = await SupabaseConfig.client
            .from(_tableName)
            .select()
            .eq('id', id)
            .isFilter('deleted_at', null)
            .maybeSingle();

        if (kDebugMode) print('SupabaseProfilesRepository.getById: Response: $response');

        if (response == null) {
          if (kDebugMode) print('SupabaseProfilesRepository.getById: No profile found for id: $id');
          return null;
        }

        // Use base repository method for timestamp extraction
        final timestamps = extractTimestamps(response);

        return User(
          id: response['id'],
          createdAtUtc: timestamps['createdAtUtc']!,
          updatedAtUtc: timestamps['updatedAtUtc']!,
          deletedAtUtc: timestamps['deletedAtUtc'],
          lastWriter: 'supabase:user',
          name: response['display_name']?.toString() ?? 'Unknown User',
          avatarUrl: response['avatar_url'],
          tz: response['timezone']?.toString() ?? 'UTC',
          metadata: response['bio']?.toString() ?? '',
        );
      },
      operationName: 'GET_BY_ID',
      tableName: _tableName,
      recordId: id,
    );
  }

  @override
  Future<List<User>> list() async {
    return safeExecute(
      () async {
        final response = await SupabaseConfig.client
            .from(_tableName)
            .select()
            .order('created_at', ascending: false);

        return response.map<User>((json) {
          // Use base repository method for timestamp extraction
          final timestamps = extractTimestamps(json);

          return User(
            id: json['id'],
            createdAtUtc: timestamps['createdAtUtc']!,
            updatedAtUtc: timestamps['updatedAtUtc']!,
            deletedAtUtc: timestamps['deletedAtUtc'],
            lastWriter: 'supabase:user',
            name: json['display_name']?.toString() ?? 'Unknown User',
            avatarUrl: json['avatar_url'],
            tz: json['timezone']?.toString() ?? 'UTC',
            metadata: json['bio']?.toString() ?? '',
          );
        }).toList();
      },
      operationName: 'LIST',
      tableName: _tableName,
    );
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
          .eq('id', id);
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  @override
  Future<void> softDelete(String id, {String lastWriter = 'device:local'}) async {
    // Use base repository method for consistent soft delete
    await performSoftDelete(_tableName, id);
  }

  /// Update user bio specifically 
  Future<void> updateBio({
    required String id,
    required String bio,
    String lastWriter = 'device:local',
  }) async {
    try {
      await SupabaseConfig.client
          .from(_tableName)
          .update({'bio': bio})
          .eq('id', id);
    } catch (e) {
      throw Exception('Failed to update bio: $e');
    }
  }
}