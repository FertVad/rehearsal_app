class Project {
  const Project({
    required this.id,
    required this.name,
    this.description,
    this.startDate,
    this.endDate,
    this.venue,
    this.directorId,
    required this.createdAtUtc,
    required this.updatedAtUtc,
    this.deletedAtUtc,
    this.ownerId,
    this.memberCount = 1,
  });

  final String id;
  final String name;
  final String? description;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? venue;
  final String? directorId;
  final int createdAtUtc;
  final int updatedAtUtc;
  final int? deletedAtUtc;
  final String? ownerId;
  final int memberCount;

  String get title => name;

  DateTime get createdAt => DateTime.fromMillisecondsSinceEpoch(createdAtUtc);
  DateTime get updatedAt => DateTime.fromMillisecondsSinceEpoch(updatedAtUtc);
  DateTime? get deletedAt => deletedAtUtc != null 
      ? DateTime.fromMillisecondsSinceEpoch(deletedAtUtc!) 
      : null;

  DateTime get lastActivity => updatedAt;

  Project copyWith({
    String? id,
    String? name,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    String? venue,
    String? directorId,
    int? createdAtUtc,
    int? updatedAtUtc,
    int? deletedAtUtc,
    String? ownerId,
    int? memberCount,
  }) {
    return Project(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      venue: venue ?? this.venue,
      directorId: directorId ?? this.directorId,
      createdAtUtc: createdAtUtc ?? this.createdAtUtc,
      updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
      deletedAtUtc: deletedAtUtc ?? this.deletedAtUtc,
      ownerId: ownerId ?? this.ownerId,
      memberCount: memberCount ?? this.memberCount,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Project && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Project(id: $id, name: $name, memberCount: $memberCount)';
  }
}