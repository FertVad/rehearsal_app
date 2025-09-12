import 'dart:convert' as dart;
import 'package:rehearsal_app/core/utils/logger.dart';
import 'package:rehearsal_app/data/repositories/base_repository.dart';
import 'package:rehearsal_app/data/datasources/supabase_datasource.dart';
import 'package:rehearsal_app/domain/repositories/users_repository.dart';
import 'package:rehearsal_app/domain/models/user.dart';

class UsersRepositoryImpl extends BaseRepository implements UsersRepository {
  static const String _tableName = 'users';

  final SupabaseDataSource _dataSource;

  UsersRepositoryImpl({SupabaseDataSource? dataSource})
    : _dataSource = dataSource ?? SupabaseDataSource();

  @override
  Future<User?> getById(String id) async {
    return await safeExecute(
      () async {
        Logger.repository('GET_BY_ID', _tableName, recordId: id);

        final response = await _dataSource.selectById(
          table: _tableName,
          id: id,
          excludeDeleted: true,
        );

        if (response == null) {
          Logger.debug('No user found for id: $id');
          return null;
        }

        return _mapToUser(response, lastWriter: 'supabase:user');
      },
      operationName: 'GET_BY_ID',
      tableName: _tableName,
      recordId: id,
    );
  }

  @override
  Future<List<User>> list() async {
    return await safeExecute(
      () async {
        final response = await _dataSource.select(
          table: _tableName,
          orderBy: 'created_at',
          ascending: false,
          excludeDeleted: true,
        );

        return response
            .map<User>((json) => _mapToUser(json, lastWriter: 'supabase:user'))
            .toList();
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
    await safeExecute(
      () async {
        // Build update data map with only non-null values
        final updateData = buildDataMap({
          if (name != null) 'full_name': name,
          if (avatarUrl != null) 'avatar_url': avatarUrl,
          if (tz != null) 'timezone': tz,
        });

        Logger.repository('UPDATE', _tableName, recordId: id, data: updateData);
        Logger.debug('Current auth user: ${_dataSource.currentUserId}');

        if (updateData.isNotEmpty) {
          await _dataSource.update(table: _tableName, id: id, data: updateData);
        }
      },
      operationName: 'UPDATE',
      tableName: _tableName,
      recordId: id,
    );
  }

  @override
  Future<void> softDelete(
    String id, {
    String lastWriter = 'device:local',
  }) async {
    await safeExecute(
      () async {
        await _dataSource.softDelete(table: _tableName, id: id);
      },
      operationName: 'SOFT_DELETE',
      tableName: _tableName,
      recordId: id,
    );
  }

  /// Map Supabase response to User domain model
  User _mapToUser(Map<String, dynamic> json, {required String lastWriter}) {
    // Use base repository method for timestamp extraction
    final timestamps = extractTimestamps(json);

    return User(
      id: json['id'],
      createdAtUtc: timestamps['createdAtUtc']!,
      updatedAtUtc: timestamps['updatedAtUtc']!,
      deletedAtUtc: timestamps['deletedAtUtc'],
      lastWriter: lastWriter,
      name: json['full_name']?.toString(),
      email: json['email']?.toString(),
      phone: json['phone']?.toString(),
      avatarUrl: json['avatar_url']?.toString(),
      tz: json['timezone']?.toString() ?? 'UTC',
      metadata: _formatNotificationSettings(json['notification_settings']),
    );
  }

  /// Format notification settings JSONB field for metadata
  String? _formatNotificationSettings(dynamic notificationSettings) {
    if (notificationSettings == null) return null;

    if (notificationSettings is Map) {
      // Convert map to JSON string for metadata field
      return dart.jsonEncode(notificationSettings);
    }

    return notificationSettings.toString();
  }

  /// Update user notification settings specifically
  Future<void> updateNotificationSettings({
    required String id,
    required Map<String, dynamic> settings,
    String lastWriter = 'device:local',
  }) async {
    await safeExecute(
      () async {
        await _dataSource.update(
          table: _tableName,
          id: id,
          data: {'notification_settings': settings},
        );
      },
      operationName: 'UPDATE_NOTIFICATION_SETTINGS',
      tableName: _tableName,
      recordId: id,
    );
  }
}
