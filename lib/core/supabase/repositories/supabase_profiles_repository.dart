import 'package:flutter/foundation.dart';
import 'package:rehearsal_app/domain/repositories/users_repository.dart';
import 'package:rehearsal_app/core/supabase/supabase_config.dart';
import 'package:rehearsal_app/domain/models/user.dart';

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
      // Use actual schema fields for profiles table
      final data = <String, dynamic>{
        'id': id, // profiles.id links to auth.users.id (UUID)
      };
      
      // Add available fields based on real schema
      if (name != null && name.isNotEmpty) {
        data['display_name'] = name;
      }
      if (avatarUrl != null && avatarUrl.isNotEmpty) {
        data['avatar_url'] = avatarUrl;
      }

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
        name: response['display_name']?.toString() ?? response['username']?.toString() ?? 'Unknown User',
        avatarUrl: response['avatar_url'],
        tz: 'UTC', // Default timezone since schema doesn't have timezone field
        metadata: response['bio']?.toString() ?? '',
      );
    } catch (e) {
      throw Exception('Failed to create profile: $e');
    }
  }

  @override
  Future<User?> getById(String id) async {
    try {
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

      final createdAt = DateTime.parse(response['created_at']);
      final updatedAt = DateTime.parse(response['updated_at']);
      final deletedAt = response['deleted_at'] != null ? DateTime.parse(response['deleted_at']) : null;

      return User(
        id: response['id'],
        createdAtUtc: createdAt.millisecondsSinceEpoch,
        updatedAtUtc: updatedAt.millisecondsSinceEpoch,
        deletedAtUtc: deletedAt?.millisecondsSinceEpoch,
        lastWriter: 'supabase:user',
        name: response['display_name']?.toString() ?? 'Unknown User',
        avatarUrl: response['avatar_url'],
        tz: 'UTC', // Default timezone since schema doesn't have timezone field
        metadata: response['bio']?.toString() ?? '',
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
          id: json['id'],
          createdAtUtc: createdAt.millisecondsSinceEpoch,
          updatedAtUtc: updatedAt.millisecondsSinceEpoch,
          deletedAtUtc: deletedAt?.millisecondsSinceEpoch,
          lastWriter: 'supabase:user',
          name: json['display_name']?.toString() ?? 'Unknown User',
          avatarUrl: json['avatar_url'],
          tz: 'UTC', // Default timezone since schema doesn't have timezone field
          metadata: json['bio']?.toString() ?? '',
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
    try {
      await SupabaseConfig.client
          .from(_tableName)
          .update({
            'deleted_at': DateTime.now().toUtc().toIso8601String(),
          })
          .eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete profile: $e');
    }
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