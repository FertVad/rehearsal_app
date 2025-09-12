import 'package:rehearsal_app/core/utils/logger.dart';
import 'package:rehearsal_app/data/repositories/base_repository.dart';
import 'package:rehearsal_app/data/datasources/supabase_datasource.dart';
import 'package:rehearsal_app/domain/repositories/project_members_repository.dart';
import 'package:rehearsal_app/domain/models/project_member.dart';

class ProjectMembersRepositoryImpl extends BaseRepository
    implements ProjectMembersRepository {
  static const String _membersTableName = 'project_members';
  static const String _projectsTableName = 'projects';
  static const String _usersTableName = 'users';

  final SupabaseDataSource _dataSource;

  ProjectMembersRepositoryImpl({SupabaseDataSource? dataSource})
    : _dataSource = dataSource ?? SupabaseDataSource();

  @override
  Future<ProjectMember> joinProjectByInviteCode({
    required String inviteCode,
    required String userId,
  }) async {
    return await safeExecute(
      () async {
        Logger.repository(
          'JOIN_BY_INVITE',
          _membersTableName,
          recordId: userId,
          data: {'inviteCode': inviteCode},
        );

        // First, get project by invite code
        final projectResponse = await _dataSource.select(
          table: _projectsTableName,
          filters: {'invite_code': inviteCode},
          excludeDeleted: true, // projects table has deleted_at
        );

        if (projectResponse.isEmpty) {
          throw Exception('Invalid invite code');
        }

        final projectId = projectResponse.first['id'] as String;

        // Check if user is already a member
        final existingMember = await _dataSource.select(
          table: _membersTableName,
          filters: {'project_id': projectId, 'user_id': userId},
          excludeDeleted:
              false, // project_members table doesn't have deleted_at
        );

        if (existingMember.isNotEmpty) {
          throw Exception('User is already a member of this project');
        }

        // Add user as member
        final memberData = {
          'project_id': projectId,
          'user_id': userId,
          'role': 'member',
          'invited_by':
              projectResponse.first['creator_id'], // Assume creator invited
        };

        final response = await _dataSource.insert(
          table: _membersTableName,
          data: memberData,
        );

        return _mapToProjectMember(response);
      },
      operationName: 'JOIN_BY_INVITE',
      tableName: _membersTableName,
      recordId: userId,
    );
  }

  @override
  Future<ProjectMember> addMemberToProject({
    required String projectId,
    required String userId,
    required String role,
    String? invitedBy,
  }) async {
    return await safeExecute(
      () async {
        // Check if user is already a member
        final existingMember = await _dataSource.select(
          table: _membersTableName,
          filters: {'project_id': projectId, 'user_id': userId},
          excludeDeleted:
              false, // project_members table doesn't have deleted_at
        );

        if (existingMember.isNotEmpty) {
          // User is already a member, return existing membership
          return _mapToProjectMember(existingMember.first);
        }

        final memberData = {
          'project_id': projectId,
          'user_id': userId,
          'role': role,
          if (invitedBy != null) 'invited_by': invitedBy,
        };

        Logger.repository(
          'ADD_MEMBER',
          _membersTableName,
          recordId: userId,
          data: memberData,
        );

        final response = await _dataSource.insert(
          table: _membersTableName,
          data: memberData,
        );

        return _mapToProjectMember(response);
      },
      operationName: 'ADD_MEMBER',
      tableName: _membersTableName,
      recordId: userId,
    );
  }

  @override
  Future<List<ProjectMember>> getProjectMembers(String projectId) async {
    return await safeExecute(
      () async {
        Logger.repository(
          'GET_PROJECT_MEMBERS',
          _membersTableName,
          recordId: projectId,
        );

        // Get members first
        final membersResponse = await _dataSource.select(
          table: _membersTableName,
          filters: {'project_id': projectId},
          excludeDeleted:
              false, // project_members table doesn't have deleted_at
        );

        final members = <ProjectMember>[];

        for (final memberJson in membersResponse) {
          final userId = memberJson['user_id'] as String;

          // Get user details
          final userResponse = await _dataSource.selectById(
            table: _usersTableName,
            id: userId,
            excludeDeleted: true, // users table has deleted_at
          );

          if (userResponse != null) {
            // Combine member and user data
            final combinedJson = {...memberJson, ...userResponse};
            members.add(_mapToProjectMemberWithUser(combinedJson));
          } else {
            // Add member without user details
            members.add(_mapToProjectMember(memberJson));
          }
        }

        return members;
      },
      operationName: 'GET_PROJECT_MEMBERS',
      tableName: _membersTableName,
      recordId: projectId,
    );
  }

  @override
  Future<void> removeMemberFromProject({
    required String projectId,
    required String userId,
  }) async {
    await safeExecute(
      () async {
        Logger.repository(
          'REMOVE_MEMBER',
          _membersTableName,
          recordId: userId,
          data: {'projectId': projectId},
        );

        // Find the member record
        final memberResponse = await _dataSource.select(
          table: _membersTableName,
          filters: {'project_id': projectId, 'user_id': userId},
          excludeDeleted:
              false, // project_members table doesn't have deleted_at
        );

        if (memberResponse.isEmpty) {
          throw Exception('Member not found in project');
        }

        final memberId = memberResponse.first['id'] as String;

        // Delete the member record
        await _dataSource.softDelete(table: _membersTableName, id: memberId);
      },
      operationName: 'REMOVE_MEMBER',
      tableName: _membersTableName,
      recordId: userId,
    );
  }

  @override
  Future<ProjectMember> updateMemberRole({
    required String projectId,
    required String userId,
    required String newRole,
  }) async {
    return await safeExecute(
      () async {
        Logger.repository(
          'UPDATE_MEMBER_ROLE',
          _membersTableName,
          recordId: userId,
          data: {'role': newRole},
        );

        // Find the member record
        final memberResponse = await _dataSource.select(
          table: _membersTableName,
          filters: {'project_id': projectId, 'user_id': userId},
          excludeDeleted:
              false, // project_members table doesn't have deleted_at
        );

        if (memberResponse.isEmpty) {
          throw Exception('Member not found in project');
        }

        final memberId = memberResponse.first['id'] as String;

        // Update the role
        await _dataSource.update(
          table: _membersTableName,
          id: memberId,
          data: {'role': newRole},
        );

        // Return updated member
        final updatedResponse = await _dataSource.selectById(
          table: _membersTableName,
          id: memberId,
          excludeDeleted:
              false, // project_members table doesn't have deleted_at
        );

        return _mapToProjectMember(updatedResponse!);
      },
      operationName: 'UPDATE_MEMBER_ROLE',
      tableName: _membersTableName,
      recordId: userId,
    );
  }

  @override
  Future<List<ProjectMember>> getUserMemberships(String userId) async {
    return await safeExecute(
      () async {
        Logger.repository(
          'GET_USER_MEMBERSHIPS',
          _membersTableName,
          recordId: userId,
        );

        final response = await _dataSource.select(
          table: _membersTableName,
          filters: {'user_id': userId},
          excludeDeleted:
              false, // project_members table doesn't have deleted_at
        );

        return response
            .map<ProjectMember>((json) => _mapToProjectMember(json))
            .toList();
      },
      operationName: 'GET_USER_MEMBERSHIPS',
      tableName: _membersTableName,
      recordId: userId,
    );
  }

  @override
  Future<void> leaveProject({
    required String projectId,
    required String userId,
  }) async {
    await removeMemberFromProject(projectId: projectId, userId: userId);
  }

  @override
  Future<bool> isUserMemberOfProject({
    required String projectId,
    required String userId,
  }) async {
    return await safeExecute(
      () async {
        final response = await _dataSource.select(
          table: _membersTableName,
          filters: {'project_id': projectId, 'user_id': userId},
          excludeDeleted:
              false, // project_members table doesn't have deleted_at
        );

        return response.isNotEmpty;
      },
      operationName: 'IS_USER_MEMBER',
      tableName: _membersTableName,
      recordId: userId,
    );
  }

  @override
  Future<String?> getProjectIdByInviteCode(String inviteCode) async {
    return await safeExecute(
      () async {
        final response = await _dataSource.select(
          table: _projectsTableName,
          filters: {'invite_code': inviteCode},
          excludeDeleted: true, // projects table has deleted_at
        );

        if (response.isEmpty) return null;
        return response.first['id'] as String;
      },
      operationName: 'GET_PROJECT_BY_INVITE',
      tableName: _projectsTableName,
      recordId: inviteCode,
    );
  }

  /// Map database response to ProjectMember domain model
  ProjectMember _mapToProjectMember(Map<String, dynamic> json) {
    final timestamps = extractTimestamps(json);

    return ProjectMember(
      id: json['id'],
      projectId: json['project_id'],
      userId: json['user_id'],
      role: json['role'],
      invitedBy: json['invited_by'],
      joinedAt: json['joined_at'] != null
          ? DateTime.parse(json['joined_at']).toUtc()
          : null,
      createdAtUtc: DateTime.fromMillisecondsSinceEpoch(
        timestamps['createdAtUtc']!,
      ),
      updatedAtUtc: DateTime.fromMillisecondsSinceEpoch(
        timestamps['updatedAtUtc']!,
      ),
    );
  }

  /// Map database response with user details to ProjectMember domain model
  ProjectMember _mapToProjectMemberWithUser(Map<String, dynamic> json) {
    final timestamps = extractTimestamps(json);

    return ProjectMember(
      id: json['id'],
      projectId: json['project_id'],
      userId: json['user_id'],
      role: json['role'],
      invitedBy: json['invited_by'],
      joinedAt: json['joined_at'] != null
          ? DateTime.parse(json['joined_at']).toUtc()
          : null,
      createdAtUtc: DateTime.fromMillisecondsSinceEpoch(
        timestamps['createdAtUtc']!,
      ),
      updatedAtUtc: DateTime.fromMillisecondsSinceEpoch(
        timestamps['updatedAtUtc']!,
      ),
      userFullName: json['full_name']?.toString(),
      userEmail: json['email']?.toString(),
      userAvatarUrl: json['avatar_url']?.toString(),
    );
  }
}
