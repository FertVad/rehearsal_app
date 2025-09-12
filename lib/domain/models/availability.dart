/// Availability domain model for Supabase-based app
class Availability {
  const Availability({
    required this.id,
    required this.createdAtUtc,
    required this.updatedAtUtc,
    this.deletedAtUtc,
    required this.lastWriter,
    required this.userId,
    required this.dateUtc,
    required this.status,
    this.intervalsJson,
    this.note,
  });

  final String id;
  final int createdAtUtc;
  final int updatedAtUtc;
  final int? deletedAtUtc;
  final String lastWriter;
  final String userId;
  final int dateUtc;
  final String status;
  final String? intervalsJson;
  final String? note;

  Availability copyWith({
    String? id,
    int? createdAtUtc,
    int? updatedAtUtc,
    int? deletedAtUtc,
    String? lastWriter,
    String? userId,
    int? dateUtc,
    String? status,
    String? intervalsJson,
    String? note,
  }) {
    return Availability(
      id: id ?? this.id,
      createdAtUtc: createdAtUtc ?? this.createdAtUtc,
      updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
      deletedAtUtc: deletedAtUtc ?? this.deletedAtUtc,
      lastWriter: lastWriter ?? this.lastWriter,
      userId: userId ?? this.userId,
      dateUtc: dateUtc ?? this.dateUtc,
      status: status ?? this.status,
      intervalsJson: intervalsJson ?? this.intervalsJson,
      note: note ?? this.note,
    );
  }

  @override
  String toString() {
    return 'Availability(id: $id, userId: $userId, dateUtc: $dateUtc, status: $status)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Availability &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
