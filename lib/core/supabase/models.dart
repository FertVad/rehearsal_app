// Supabase models - equivalent to Drift models but for JSON serialization

class SupabaseProfile {
  final String id;
  final String? userId; // Links to auth.users.id
  final String? displayName;
  final String? avatarUrl;
  final String timezone;
  final String? bio;
  final String? phone;
  final Map<String, dynamic> metadata;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  const SupabaseProfile({
    required this.id,
    this.userId,
    this.displayName,
    this.avatarUrl,
    required this.timezone,
    this.bio,
    this.phone,
    required this.metadata,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory SupabaseProfile.fromJson(Map<String, dynamic> json) {
    return SupabaseProfile(
      id: json['id'],
      userId: json['user_id'],
      displayName: json['display_name'],
      avatarUrl: json['avatar_url'],
      timezone: json['timezone'] ?? 'UTC',
      bio: json['bio'],
      phone: json['phone'],
      metadata: json['metadata'] ?? {},
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'display_name': displayName,
      'avatar_url': avatarUrl,
      'timezone': timezone,
      'bio': bio,
      'phone': phone,
      'metadata': metadata,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }

  Map<String, dynamic> toInsertJson() {
    final json = toJson();
    json.remove('id'); // Let Supabase generate ID
    json.remove('created_at'); // Use default
    json.remove('updated_at'); // Use default
    return json;
  }
}

class SupabaseRehearsal {
  final String id;
  final String projectId;
  final String title;
  final String? description;
  final String? location;
  final DateTime startTime;
  final DateTime endTime;
  final bool isMandatory;
  final String? createdBy;
  final Map<String, dynamic> metadata;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  const SupabaseRehearsal({
    required this.id,
    required this.projectId,
    required this.title,
    this.description,
    this.location,
    required this.startTime,
    required this.endTime,
    required this.isMandatory,
    this.createdBy,
    required this.metadata,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory SupabaseRehearsal.fromJson(Map<String, dynamic> json) {
    return SupabaseRehearsal(
      id: json['id'],
      projectId: json['project_id'],
      title: json['title'],
      description: json['description'],
      location: json['location'],
      startTime: DateTime.parse(json['start_time']),
      endTime: DateTime.parse(json['end_time']),
      isMandatory: json['is_mandatory'] ?? false,
      createdBy: json['created_by'],
      metadata: json['metadata'] ?? {},
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'project_id': projectId,
      'title': title,
      'description': description,
      'location': location,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'is_mandatory': isMandatory,
      'created_by': createdBy,
      'metadata': metadata,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }

  Map<String, dynamic> toInsertJson() {
    final json = toJson();
    json.remove('id'); // Let Supabase generate ID
    json.remove('created_at'); // Use default
    json.remove('updated_at'); // Use default
    return json;
  }
}

class SupabaseUserAvailability {
  final String id;
  final String profileId;
  final DateTime date;
  final String status; // 'available', 'busy', 'partial'
  final List<Map<String, String>> timeIntervals; // Array of {start: "HH:MM", end: "HH:MM"}
  final String? notes;
  final Map<String, dynamic> metadata;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  const SupabaseUserAvailability({
    required this.id,
    required this.profileId,
    required this.date,
    required this.status,
    required this.timeIntervals,
    this.notes,
    required this.metadata,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory SupabaseUserAvailability.fromJson(Map<String, dynamic> json) {
    return SupabaseUserAvailability(
      id: json['id'],
      profileId: json['profile_id'],
      date: DateTime.parse(json['date']),
      status: json['status'],
      timeIntervals: List<Map<String, String>>.from(json['time_intervals'] ?? []),
      notes: json['notes'],
      metadata: json['metadata'] ?? {},
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'profile_id': profileId,
      'date': date.toIso8601String().split('T')[0], // Date only
      'status': status,
      'time_intervals': timeIntervals,
      'notes': notes,
      'metadata': metadata,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }

  Map<String, dynamic> toInsertJson() {
    final json = toJson();
    json.remove('id'); // Let Supabase generate ID
    json.remove('created_at'); // Use default
    json.remove('updated_at'); // Use default
    return json;
  }
}

class SupabaseProject {
  final String id;
  final String name;
  final String? description;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? venue;
  final String? directorId;
  final String inviteCode;
  final bool isActive;
  final Map<String, dynamic> metadata;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  const SupabaseProject({
    required this.id,
    required this.name,
    this.description,
    this.startDate,
    this.endDate,
    this.venue,
    this.directorId,
    required this.inviteCode,
    required this.isActive,
    required this.metadata,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory SupabaseProject.fromJson(Map<String, dynamic> json) {
    return SupabaseProject(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      startDate: json['start_date'] != null ? DateTime.parse(json['start_date']) : null,
      endDate: json['end_date'] != null ? DateTime.parse(json['end_date']) : null,
      venue: json['venue'],
      directorId: json['director_id'],
      inviteCode: json['invite_code'],
      isActive: json['is_active'] ?? true,
      metadata: json['metadata'] ?? {},
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'start_date': startDate?.toIso8601String().split('T')[0],
      'end_date': endDate?.toIso8601String().split('T')[0],
      'venue': venue,
      'director_id': directorId,
      'invite_code': inviteCode,
      'is_active': isActive,
      'metadata': metadata,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }

  Map<String, dynamic> toInsertJson() {
    final json = toJson();
    json.remove('id'); // Let Supabase generate ID
    json.remove('created_at'); // Use default
    json.remove('updated_at'); // Use default
    json.remove('invite_code'); // Use default generated code
    return json;
  }
}