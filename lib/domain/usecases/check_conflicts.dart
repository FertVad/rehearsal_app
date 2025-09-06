import 'dart:convert';

import 'package:rehearsal_app/core/constants/time_constants.dart';
import 'package:rehearsal_app/domain/models/user.dart';
import 'package:rehearsal_app/domain/models/rehearsal.dart';

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
  Future<List<Conflict>> call({
    required Rehearsal rehearsal,
    required List<User> attendees,
  }) async {
    var start = rehearsal.startsAtUtc;
    var end = rehearsal.endsAtUtc;
    if (end < start) {
      final tmp = start;
      start = end;
      end = tmp;
    }

    final dateUtc00 = _dateUtc00(start);
    final conflicts = <Conflict>[];

    for (final user in attendees) {
      final availability = await availabilityRepository.getForUserOnDateUtc(
        userId: user.id,
        dateUtc00: dateUtc00,
      );
      if (availability != null) {
        if (availability.status == 'busy') {
          conflicts.add(Conflict(userId: user.id, type: ConflictType.busy));
        } else if (availability.status == 'partial') {
          final List<Interval> intervals = _parseIntervals(
            availability.intervalsJson,
          );
          final hasOverlap = intervals.any(
            (i) => _overlaps(start, end, i.start, i.end),
          );
          if (!hasOverlap) {
            conflicts.add(
              Conflict(userId: user.id, type: ConflictType.partial),
            );
          }
        }
      }

      final otherRehearsals = await rehearsalsRepository.listForUserOnDateUtc(
        userId: user.id,
        dateUtc00: dateUtc00,
      );
      for (final other in otherRehearsals) {
        if (other.id == rehearsal.id) continue;
        if (_overlaps(start, end, other.startsAtUtc, other.endsAtUtc)) {
          conflicts.add(
            Conflict(
              userId: user.id,
              type: ConflictType.overlap,
              details: other.id,
            ),
          );
          break;
        }
      }
    }

    return conflicts;
  }
}

/// Types of conflicts detected for an attendee.
enum ConflictType { busy, partial, overlap }

typedef Interval = ({int start, int end});

/// Describes a scheduling conflict for a user.
class Conflict {
  const Conflict({required this.userId, required this.type, this.details});

  final String userId;
  final ConflictType type;
  final String? details;
}

const _msPerDay = TimeConstants.millisecondsPerDay;

int _dateUtc00(int msUtc) => msUtc - msUtc % _msPerDay;

bool _overlaps(int aStart, int aEnd, int bStart, int bEnd) =>
    aStart < bEnd && bStart < aEnd;

List<Interval> _parseIntervals(String? json) {
  if (json == null || json.isEmpty) {
    return const <Interval>[];
  }
  try {
    final list = jsonDecode(json) as List<dynamic>;
    return list.map<Interval>((e) {
      final m = e as Map<String, dynamic>;
      return (start: m['startUtc'] as int, end: m['endUtc'] as int);
    }).toList();
  } catch (_) {
    return const <Interval>[];
  }
}
