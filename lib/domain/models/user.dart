/// User domain model for Supabase-based app
class User {
  const User({
    required this.id,
    required this.createdAtUtc,
    required this.updatedAtUtc,
    this.deletedAtUtc,
    required this.lastWriter,
    this.name,
    this.email,
    this.phone,
    this.avatarUrl,
    required this.tz,
    this.metadata,
  });

  final String id;
  final int createdAtUtc;
  final int updatedAtUtc;
  final int? deletedAtUtc;
  final String lastWriter;
  final String? name;
  final String? email;
  final String? phone;
  final String? avatarUrl;
  final String tz;
  final String? metadata;

  User copyWith({
    String? id,
    int? createdAtUtc,
    int? updatedAtUtc,
    int? deletedAtUtc,
    String? lastWriter,
    String? name,
    String? email,
    String? phone,
    String? avatarUrl,
    String? tz,
    String? metadata,
  }) {
    return User(
      id: id ?? this.id,
      createdAtUtc: createdAtUtc ?? this.createdAtUtc,
      updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
      deletedAtUtc: deletedAtUtc ?? this.deletedAtUtc,
      lastWriter: lastWriter ?? this.lastWriter,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      tz: tz ?? this.tz,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, name: $name, tz: $tz)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}