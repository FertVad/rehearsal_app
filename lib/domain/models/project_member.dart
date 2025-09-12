class ProjectMember {
  final String id;
  final String projectId;
  final String userId;
  final String role; // 'creator', 'admin', 'member'
  final String? invitedBy;
  final DateTime? joinedAt;
  final DateTime createdAtUtc;
  final DateTime updatedAtUtc;

  // User details (if populated)
  final String? userFullName;
  final String? userEmail;
  final String? userAvatarUrl;

  const ProjectMember({
    required this.id,
    required this.projectId,
    required this.userId,
    required this.role,
    this.invitedBy,
    this.joinedAt,
    required this.createdAtUtc,
    required this.updatedAtUtc,
    this.userFullName,
    this.userEmail,
    this.userAvatarUrl,
  });

  ProjectMember copyWith({
    String? id,
    String? projectId,
    String? userId,
    String? role,
    String? invitedBy,
    DateTime? joinedAt,
    DateTime? createdAtUtc,
    DateTime? updatedAtUtc,
    String? userFullName,
    String? userEmail,
    String? userAvatarUrl,
  }) {
    return ProjectMember(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      userId: userId ?? this.userId,
      role: role ?? this.role,
      invitedBy: invitedBy ?? this.invitedBy,
      joinedAt: joinedAt ?? this.joinedAt,
      createdAtUtc: createdAtUtc ?? this.createdAtUtc,
      updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
      userFullName: userFullName ?? this.userFullName,
      userEmail: userEmail ?? this.userEmail,
      userAvatarUrl: userAvatarUrl ?? this.userAvatarUrl,
    );
  }

  bool get isCreator => role == 'creator';
  bool get isAdmin => role == 'admin';
  bool get isMember => role == 'member';
  bool get canManageProject => isCreator || isAdmin;
}
