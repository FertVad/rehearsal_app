import 'package:rehearsal_app/core/db/app_database.dart';

import '../repositories/availability_repository.dart';
import '../repositories/rehearsals_repository.dart';

/// Checks conflicts between a rehearsal and attendee schedules.
///
/// Uses UTC intervals [startUtc, endUtc). Algorithm is described in ADR-0008.
class CheckConflicts {
  CheckConflicts({
    required this.rehearsalsRepository,
    required this.availabilityRepository,
  });

  final RehearsalsRepository rehearsalsRepository;
  final AvailabilityRepository availabilityRepository;

  /// Returns a list of detected conflicts.
  ///
  /// The current placeholder implementation returns an empty list.
  Future<List<Conflict>> call({
    required Rehearsal rehearsal,
    required List<User> attendees,
  }) async {
    return [];
  }
}

/// Types of conflicts detected for an attendee.
enum ConflictType { busy, partial, overlap }

/// Describes a scheduling conflict for a user.
class Conflict {
  const Conflict({
    required this.userId,
    required this.type,
    this.details,
  });

  final String userId;
  final ConflictType type;
  final String? details;
}
