/// Rehearsal domain model for Supabase-based app
class Rehearsal {
  const Rehearsal({
    required this.id,
    required this.createdAtUtc,
    required this.updatedAtUtc,
    this.deletedAtUtc,
    required this.lastWriter,
    required this.projectId,
    required this.startsAtUtc,
    required this.endsAtUtc,
    this.place,
    this.note,
  });

  final String id;
  final int createdAtUtc;
  final int updatedAtUtc;
  final int? deletedAtUtc;
  final String lastWriter;
  final String projectId;
  final int startsAtUtc;
  final int endsAtUtc;
  final String? place;
  final String? note;

  Rehearsal copyWith({
    String? id,
    int? createdAtUtc,
    int? updatedAtUtc,
    int? deletedAtUtc,
    String? lastWriter,
    String? projectId,
    int? startsAtUtc,
    int? endsAtUtc,
    String? place,
    String? note,
  }) {
    return Rehearsal(
      id: id ?? this.id,
      createdAtUtc: createdAtUtc ?? this.createdAtUtc,
      updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
      deletedAtUtc: deletedAtUtc ?? this.deletedAtUtc,
      lastWriter: lastWriter ?? this.lastWriter,
      projectId: projectId ?? this.projectId,
      startsAtUtc: startsAtUtc ?? this.startsAtUtc,
      endsAtUtc: endsAtUtc ?? this.endsAtUtc,
      place: place ?? this.place,
      note: note ?? this.note,
    );
  }

  @override
  String toString() {
    return 'Rehearsal(id: $id, place: $place, startsAtUtc: $startsAtUtc)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Rehearsal &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}