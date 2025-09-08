import 'package:flutter/foundation.dart';
import 'package:rehearsal_app/data/repositories/base_repository.dart';
import 'package:rehearsal_app/data/datasources/supabase_datasource.dart';
import 'package:rehearsal_app/domain/repositories/projects_repository.dart';
import 'package:rehearsal_app/domain/models/project.dart';

class ProjectsRepositoryImpl extends BaseRepository implements ProjectsRepository {
  static const String _tableName = 'projects';
  static const String _membersTableName = 'project_members';
  
  final SupabaseDataSource _dataSource;

  ProjectsRepositoryImpl({SupabaseDataSource? dataSource}) 
      : _dataSource = dataSource ?? SupabaseDataSource();

  @override
  Future<Project> create({
    required String id,
    required String name,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    String? venue,
    String? directorId,
    String? ownerId,
  }) async {
    return await safeExecute(
      () async {
        final insertData = buildDataMap({
          'id': id,
          'name': name,
          if (description != null) 'description': description,
          if (startDate != null) 'start_date': startDate.toIso8601String(),
          if (endDate != null) 'end_date': endDate.toIso8601String(),
          if (venue != null) 'location': venue,
          'creator_id': directorId ?? _dataSource.currentUserId, // Use current user if not specified
          'is_active': true,
        });

        if (kDebugMode) {
          print('🔍 ProjectsRepositoryImpl.create:');
          print('🔍 Insert data: $insertData');
          print('🔍 Current auth user: ${_dataSource.currentUserId}');
        }

        final response = await _dataSource.insert(
          table: _tableName,
          data: insertData,
        );

        return _mapToProject(response, lastWriter: 'device:local');
      },
      operationName: 'CREATE',
      tableName: _tableName,
      recordId: id,
    );
  }

  @override
  Future<Project> update({
    required String id,
    String? name,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    String? venue,
    String? directorId,
    int? memberCount,
  }) async {
    return await safeExecute(
      () async {
        final updateData = buildDataMap({
          if (name != null) 'name': name,
          if (description != null) 'description': description,
          if (startDate != null) 'start_date': startDate.toIso8601String(),
          if (endDate != null) 'end_date': endDate.toIso8601String(),
          if (venue != null) 'location': venue,
          if (directorId != null) 'creator_id': directorId,
        });

        if (kDebugMode) {
          print('🔍 ProjectsRepositoryImpl.update:');
          print('🔍 Project ID: $id');
          print('🔍 Update data: $updateData');
        }

        if (updateData.isNotEmpty) {
          await _dataSource.update(
            table: _tableName,
            id: id,
            data: updateData,
          );
        }

        // Fetch updated project
        final response = await _dataSource.selectById(
          table: _tableName,
          id: id,
          excludeDeleted: true,
        );

        if (response == null) {
          throw Exception('Project not found after update: $id');
        }

        return _mapToProject(response, lastWriter: 'device:local');
      },
      operationName: 'UPDATE',
      tableName: _tableName,
      recordId: id,
    );
  }

  @override
  Future<void> delete(String id) async {
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

  @override
  Future<Project?> getById(String id) async {
    return await safeExecute(
      () async {
        if (kDebugMode) {
          print('🔍 ProjectsRepositoryImpl.getById: Looking for project with id: $id');
        }

        final response = await _dataSource.selectById(
          table: _tableName,
          id: id,
          excludeDeleted: true,
        );

        if (response == null) {
          if (kDebugMode) {
            print('🔍 ProjectsRepositoryImpl.getById: No project found for id: $id');
          }
          return null;
        }

        return _mapToProject(response, lastWriter: 'supabase:project');
      },
      operationName: 'GET_BY_ID',
      tableName: _tableName,
      recordId: id,
    );
  }

  @override
  Future<List<Project>> listForUser(String userId) async {
    return await safeExecute(
      () async {
        if (kDebugMode) {
          print('🔍 ProjectsRepositoryImpl.listForUser: Loading projects for user $userId');
        }

        // First, get project IDs where user is a member
        final membershipResponse = await _dataSource.select(
          table: _membersTableName,
          filters: {'user_id': userId},
          excludeDeleted: false, // membership records don't have deleted_at
        );

        final projectIds = membershipResponse.map<String>((json) => json['project_id'] as String).toList();

        if (projectIds.isEmpty) {
          return [];
        }

        // Then get the projects themselves
        final response = await _dataSource.select(
          table: _tableName,
          orderBy: 'updated_at',
          ascending: false,
          excludeDeleted: true,
        );

        // Filter to only projects where user is a member
        final filtered = response.where((json) => projectIds.contains(json['id'])).toList();

        return filtered.map<Project>((json) => _mapToProject(json, lastWriter: 'supabase:project')).toList();
      },
      operationName: 'LIST_FOR_USER',
      tableName: _tableName,
      recordId: userId,
    );
  }

  @override
  Future<List<Project>> listAll() async {
    return await safeExecute(
      () async {
        final response = await _dataSource.select(
          table: _tableName,
          orderBy: 'updated_at',
          ascending: false,
          excludeDeleted: true,
        );

        return response.map<Project>((json) => _mapToProject(json, lastWriter: 'supabase:project')).toList();
      },
      operationName: 'LIST_ALL',
      tableName: _tableName,
    );
  }

  @override
  Future<List<Project>> searchByName(String query) async {
    return await safeExecute(
      () async {
        if (kDebugMode) {
          print('🔍 ProjectsRepositoryImpl.searchByName: Searching for "$query"');
        }

        final response = await _dataSource.select(
          table: _tableName,
          orderBy: 'updated_at',
          ascending: false,
          excludeDeleted: true,
        );

        // Filter by name (case-insensitive)
        final filtered = response.where((json) {
          final name = (json['name'] as String? ?? '').toLowerCase();
          return name.contains(query.toLowerCase());
        }).toList();

        return filtered.map<Project>((json) => _mapToProject(json, lastWriter: 'supabase:project')).toList();
      },
      operationName: 'SEARCH_BY_NAME',
      tableName: _tableName,
      recordId: query,
    );
  }

  /// Map Supabase response to Project domain model
  Project _mapToProject(Map<String, dynamic> json, {required String lastWriter}) {
    // Use base repository method for timestamp extraction
    final timestamps = extractTimestamps(json);

    // Parse dates (can be null)
    DateTime? startDate;
    DateTime? endDate;

    if (json['start_date'] != null) {
      startDate = DateTime.parse(json['start_date']);
    }

    if (json['end_date'] != null) {
      endDate = DateTime.parse(json['end_date']);
    }

    return Project(
      id: json['id'],
      name: json['name'],
      description: json['description']?.toString(),
      startDate: startDate,
      endDate: endDate,
      venue: json['location']?.toString(),
      directorId: json['creator_id'],
      createdAtUtc: timestamps['createdAtUtc']!,
      updatedAtUtc: timestamps['updatedAtUtc']!,
      deletedAtUtc: timestamps['deletedAtUtc'],
      ownerId: json['creator_id'],
      memberCount: json['member_count'] ?? 1,
    );
  }
}