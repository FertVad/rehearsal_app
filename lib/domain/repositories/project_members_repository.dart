import '../models/project_member.dart';

abstract class ProjectMembersRepository {
  /// Add a member to project by invite code
  Future<ProjectMember> joinProjectByInviteCode({
    required String inviteCode,
    required String userId,
  });

  /// Add a member to project directly (by project creator/admin)
  Future<ProjectMember> addMemberToProject({
    required String projectId,
    required String userId,
    required String role,
    String? invitedBy,
  });

  /// Get all members of a project
  Future<List<ProjectMember>> getProjectMembers(String projectId);

  /// Remove member from project
  Future<void> removeMemberFromProject({
    required String projectId,
    required String userId,
  });

  /// Update member role
  Future<ProjectMember> updateMemberRole({
    required String projectId,
    required String userId,
    required String newRole,
  });

  /// Get projects where user is a member
  Future<List<ProjectMember>> getUserMemberships(String userId);

  /// Leave project
  Future<void> leaveProject({
    required String projectId,
    required String userId,
  });

  /// Check if user is member of project
  Future<bool> isUserMemberOfProject({
    required String projectId,
    required String userId,
  });

  /// Get project by invite code
  Future<String?> getProjectIdByInviteCode(String inviteCode);
}
