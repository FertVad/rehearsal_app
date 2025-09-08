import 'package:flutter/foundation.dart';
import 'package:rehearsal_app/data/repositories/base_repository.dart';
import 'package:rehearsal_app/data/datasources/supabase_datasource.dart';
import 'package:rehearsal_app/domain/repositories/rehearsals_repository.dart';
import 'package:rehearsal_app/domain/models/rehearsal.dart';

class RehearsalsRepositoryImpl extends BaseRepository implements RehearsalsRepository {
  static const String _tableName = 'rehearsals';
  
  final SupabaseDataSource _dataSource;

  RehearsalsRepositoryImpl({SupabaseDataSource? dataSource}) 
      : _dataSource = dataSource ?? SupabaseDataSource();

  @override
  Future<Rehearsal> create({
    required String id,
    String? projectId,
    required int startsAtUtc,
    required int endsAtUtc,
    String? place,
    String? note,
    String lastWriter = 'device:local',
  }) async {
    return await safeExecute(
      () async {
        // Convert timestamps to ISO strings for Supabase
        final startsAtDateTime = DateTime.fromMillisecondsSinceEpoch(startsAtUtc, isUtc: true);
        final endsAtDateTime = DateTime.fromMillisecondsSinceEpoch(endsAtUtc, isUtc: true);

        final insertData = buildDataMap({
          'id': id,
          if (projectId != null) 'project_id': projectId,
          'start_datetime': startsAtDateTime.toIso8601String(),
          'end_datetime': endsAtDateTime.toIso8601String(),
          if (place != null) 'location': place,
          if (note != null) 'scene_details': note,
          'status': 'scheduled',
          'created_by': _dataSource.currentUserId, // Current authenticated user
        });

        if (kDebugMode) {
          print('🔍 RehearsalsRepositoryImpl.create:');
          print('🔍 Insert data: $insertData');
          print('🔍 Current auth user: ${_dataSource.currentUserId}');
        }

        final response = await _dataSource.insert(
          table: _tableName,
          data: insertData,
        );

        return _mapToRehearsal(response, lastWriter: lastWriter);
      },
      operationName: 'CREATE',
      tableName: _tableName,
      recordId: id,
    );
  }

  @override
  Future<Rehearsal?> getById(String id) async {
    return await safeExecute(
      () async {
        if (kDebugMode) {
          print('🔍 RehearsalsRepositoryImpl.getById: Looking for rehearsal with id: $id');
        }

        final response = await _dataSource.selectById(
          table: _tableName,
          id: id,
          excludeDeleted: true,
        );

        if (response == null) {
          if (kDebugMode) {
            print('🔍 RehearsalsRepositoryImpl.getById: No rehearsal found for id: $id');
          }
          return null;
        }

        return _mapToRehearsal(response, lastWriter: 'supabase:rehearsal');
      },
      operationName: 'GET_BY_ID',
      tableName: _tableName,
      recordId: id,
    );
  }

  @override
  Future<List<Rehearsal>> listForUserOnDateUtc({
    required String userId,
    required int dateUtc00,
  }) async {
    return await safeExecute(
      () async {
        // Convert date to start and end of day
        final startOfDay = DateTime.fromMillisecondsSinceEpoch(dateUtc00, isUtc: true);
        final endOfDay = startOfDay.add(const Duration(days: 1));

        if (kDebugMode) {
          print('🔍 RehearsalsRepositoryImpl.listForUserOnDateUtc: $userId on ${startOfDay.toIso8601String()}');
        }

        // Query rehearsals that start within the day
        final response = await _dataSource.select(
          table: _tableName,
          orderBy: 'start_datetime',
          ascending: true,
          excludeDeleted: true,
        );

        // Filter manually for the specific date range where user is a participant
        final filtered = response.where((json) {
          final startDateTime = DateTime.parse(json['start_datetime']).toUtc();
          return startDateTime.isAfter(startOfDay.subtract(const Duration(seconds: 1))) &&
                 startDateTime.isBefore(endOfDay);
        }).toList();

        return filtered.map<Rehearsal>((json) => _mapToRehearsal(json, lastWriter: 'supabase:rehearsal')).toList();
      },
      operationName: 'LIST_FOR_USER_ON_DATE',
      tableName: _tableName,
      recordId: userId,
    );
  }

  @override
  Future<List<Rehearsal>> listForUserInRange({
    required String userId,
    required int fromUtc,
    required int toUtc,
  }) async {
    return await safeExecute(
      () async {
        final fromDateTime = DateTime.fromMillisecondsSinceEpoch(fromUtc, isUtc: true);
        final toDateTime = DateTime.fromMillisecondsSinceEpoch(toUtc, isUtc: true);

        if (kDebugMode) {
          print('🔍 RehearsalsRepositoryImpl.listForUserInRange: $userId from ${fromDateTime.toIso8601String()} to ${toDateTime.toIso8601String()}');
        }

        final response = await _dataSource.select(
          table: _tableName,
          orderBy: 'start_datetime',
          ascending: true,
          excludeDeleted: true,
        );

        // Filter manually for the specific date range
        final filtered = response.where((json) {
          final startDateTime = DateTime.parse(json['start_datetime']).toUtc();
          return startDateTime.isAfter(fromDateTime.subtract(const Duration(seconds: 1))) &&
                 startDateTime.isBefore(toDateTime);
        }).toList();

        return filtered.map<Rehearsal>((json) => _mapToRehearsal(json, lastWriter: 'supabase:rehearsal')).toList();
      },
      operationName: 'LIST_FOR_USER_IN_RANGE',
      tableName: _tableName,
      recordId: userId,
    );
  }

  @override
  Future<void> update({
    required String id,
    int? startsAtUtc,
    int? endsAtUtc,
    String? place,
    String? note,
    String lastWriter = 'device:local',
  }) async {
    await safeExecute(
      () async {
        final updateData = buildDataMap({
          if (startsAtUtc != null) 'start_datetime': DateTime.fromMillisecondsSinceEpoch(startsAtUtc, isUtc: true).toIso8601String(),
          if (endsAtUtc != null) 'end_datetime': DateTime.fromMillisecondsSinceEpoch(endsAtUtc, isUtc: true).toIso8601String(),
          if (place != null) 'location': place,
          if (note != null) 'scene_details': note,
          'status': 'updated', // Mark as updated
        });

        if (kDebugMode) {
          print('🔍 RehearsalsRepositoryImpl.update:');
          print('🔍 Rehearsal ID: $id');
          print('🔍 Update data: $updateData');
        }

        if (updateData.isNotEmpty) {
          await _dataSource.update(
            table: _tableName,
            id: id,
            data: updateData,
          );
        }
      },
      operationName: 'UPDATE',
      tableName: _tableName,
      recordId: id,
    );
  }

  @override
  Future<void> softDelete(String id, {String lastWriter = 'device:local'}) async {
    await safeExecute(
      () async {
        await _dataSource.softDelete(
          table: _tableName,
          id: id,
        );
      },
      operationName: 'SOFT_DELETE',
      tableName: _tableName,
      recordId: id,
    );
  }

  /// Map Supabase response to Rehearsal domain model
  Rehearsal _mapToRehearsal(Map<String, dynamic> json, {required String lastWriter}) {
    // Use base repository method for timestamp extraction
    final timestamps = extractTimestamps(json);

    // Parse TIMESTAMPTZ from Supabase
    final startsAt = DateTime.parse(json['start_datetime']).toUtc();
    final endsAt = DateTime.parse(json['end_datetime']).toUtc();

    return Rehearsal(
      id: json['id'],
      createdAtUtc: timestamps['createdAtUtc']!,
      updatedAtUtc: timestamps['updatedAtUtc']!,
      deletedAtUtc: timestamps['deletedAtUtc'],
      lastWriter: lastWriter,
      projectId: json['project_id'] ?? '', // Handle null project_id
      startsAtUtc: startsAt.millisecondsSinceEpoch,
      endsAtUtc: endsAt.millisecondsSinceEpoch,
      place: json['location']?.toString(),
      note: json['scene_details']?.toString(),
    );
  }
}