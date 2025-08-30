import 'package:flutter_test/flutter_test.dart';
import 'package:rehearsal_app/core/db/app_database.dart';
import 'package:rehearsal_app/domain/repositories/availability_repository.dart';
import 'package:rehearsal_app/domain/repositories/rehearsals_repository.dart';
import 'package:rehearsal_app/domain/usecases/check_conflicts.dart';

void main() {
  test('returns empty list', () async {
    final usecase = CheckConflicts(
      rehearsalsRepository: _FakeRehearsalsRepository(),
      availabilityRepository: _FakeAvailabilityRepository(),
    );
    final rehearsal = Rehearsal(
      id: 'r1',
      createdAtUtc: 0,
      updatedAtUtc: 0,
      lastWriter: 'system',
      startsAtUtc: 0,
      endsAtUtc: 1,
    );
    final attendee = User(
      id: 'u1',
      createdAtUtc: 0,
      updatedAtUtc: 0,
      lastWriter: 'system',
      tz: 'UTC',
    );
    final result = await usecase(rehearsal: rehearsal, attendees: [attendee]);
    expect(result, isEmpty);
  });
}

class _FakeRehearsalsRepository implements RehearsalsRepository {}

class _FakeAvailabilityRepository implements AvailabilityRepository {}
