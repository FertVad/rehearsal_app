import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:rehearsal_app/core/constants/time_constants.dart';
import 'package:rehearsal_app/domain/models/user.dart';
import 'package:rehearsal_app/domain/models/rehearsal.dart';
import 'package:rehearsal_app/domain/models/availability.dart';
import 'package:rehearsal_app/domain/repositories/availability_repository.dart';
import 'package:rehearsal_app/domain/repositories/rehearsals_repository.dart';
import 'package:rehearsal_app/domain/usecases/check_conflicts.dart';

void main() {
  late User u1;
  late Rehearsal base;

  setUp(() {
    u1 = User(
      id: 'u1',
      createdAtUtc: 0,
      updatedAtUtc: 0,
      lastWriter: 't',
      tz: 'Asia/Jerusalem',
    );
    base = Rehearsal(
      id: 'r1',
      createdAtUtc: 0,
      updatedAtUtc: 0,
      lastWriter: 't',
      projectId: 'project1',
      startsAtUtc: 1711929600000,
      endsAtUtc: 1711933200000,
    );
  });

  int dateUtc00(int msUtc) => msUtc - msUtc % TimeConstants.millisecondsPerDay;

  test('busy -> ConflictType.busy', () async {
    final date = dateUtc00(base.startsAtUtc);
    final usecase = CheckConflicts(
      rehearsalsRepository: _FakeRehearsalsRepository(),
      availabilityRepository: _FakeAvailabilityRepository(
        availByUserAndDate: {
          ('u1', date): Availability(
            id: 'a1',
            createdAtUtc: 0,
            updatedAtUtc: 0,
            deletedAtUtc: null,
            lastWriter: 't',
            userId: 'u1',
            dateUtc: date,
            status: 'busy',
            intervalsJson: null,
            note: null,
          ),
        },
      ),
    );
    final res = await usecase(rehearsal: base, attendees: [u1]);
    expect(
      res.where((c) => c.userId == 'u1' && c.type == ConflictType.busy).length,
      1,
    );
  });

  test('partial (no overlap) -> ConflictType.partial', () async {
    final date = dateUtc00(base.startsAtUtc);
    final avail = Availability(
      id: 'a1',
      createdAtUtc: 0,
      updatedAtUtc: 0,
      deletedAtUtc: null,
      lastWriter: 't',
      userId: 'u1',
      dateUtc: date,
      status: 'partial',
      intervalsJson: jsonEncode([
        {
          'startUtc': base.startsAtUtc - 7200000,
          'endUtc': base.startsAtUtc - 3600000,
        },
      ]),
      note: null,
    );
    final usecase = CheckConflicts(
      rehearsalsRepository: _FakeRehearsalsRepository(),
      availabilityRepository: _FakeAvailabilityRepository(
        availByUserAndDate: {('u1', date): avail},
      ),
    );
    final res = await usecase(rehearsal: base, attendees: [u1]);
    expect(
      res
          .where((c) => c.userId == 'u1' && c.type == ConflictType.partial)
          .length,
      1,
    );
  });

  test('overlap -> ConflictType.overlap', () async {
    final date = dateUtc00(base.startsAtUtc);
    final other = Rehearsal(
      id: 'r2',
      createdAtUtc: 0,
      updatedAtUtc: 0,
      lastWriter: 't',
      projectId: 'project1',
      startsAtUtc: base.startsAtUtc + 600000,
      endsAtUtc: base.endsAtUtc + 600000,
    );
    final usecase = CheckConflicts(
      rehearsalsRepository: _FakeRehearsalsRepository(
        rehearsalsByUserAndDate: {
          ('u1', date): [other],
        },
      ),
      availabilityRepository: _FakeAvailabilityRepository(),
    );
    final res = await usecase(rehearsal: base, attendees: [u1]);
    expect(
      res
          .where((c) => c.userId == 'u1' && c.type == ConflictType.overlap)
          .length,
      1,
    );
  });

  test('DST overlap -> ConflictType.overlap', () async {
    final dstBase = Rehearsal(
      id: 'r1',
      createdAtUtc: 0,
      updatedAtUtc: 0,
      lastWriter: 't',
      projectId: 'project1',
      startsAtUtc: 1711666800000, // 2024-03-28 23:00 UTC
      endsAtUtc: 1711674000000, // 2024-03-29 01:00 UTC
    );
    final other = Rehearsal(
      id: 'r2',
      createdAtUtc: 0,
      updatedAtUtc: 0,
      lastWriter: 't',
      projectId: 'project1',
      startsAtUtc: 1711668600000, // 2024-03-28 23:30 UTC
      endsAtUtc: 1711672200000, // 2024-03-29 00:30 UTC
    );
    final date = dateUtc00(dstBase.startsAtUtc);
    final usecase = CheckConflicts(
      rehearsalsRepository: _FakeRehearsalsRepository(
        rehearsalsByUserAndDate: {
          ('u1', date): [other],
        },
      ),
      availabilityRepository: _FakeAvailabilityRepository(),
    );
    final res = await usecase(rehearsal: dstBase, attendees: [u1]);
    expect(
      res
          .where((c) => c.userId == 'u1' && c.type == ConflictType.overlap)
          .length,
      1,
    );
  });
}

class _FakeAvailabilityRepository implements AvailabilityRepository {
  final Map<(String, int), Availability?> availByUserAndDate;
  _FakeAvailabilityRepository({
    Map<(String, int), Availability?>? availByUserAndDate,
  }) : availByUserAndDate = availByUserAndDate ?? {};

  @override
  Future<Availability?> getForUserOnDateUtc({
    required String userId,
    required int dateUtc00,
  }) async {
    return availByUserAndDate[(userId, dateUtc00)];
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeRehearsalsRepository implements RehearsalsRepository {
  final Map<(String, int), List<Rehearsal>> rehearsalsByUserAndDate;
  _FakeRehearsalsRepository({
    Map<(String, int), List<Rehearsal>>? rehearsalsByUserAndDate,
  }) : rehearsalsByUserAndDate = rehearsalsByUserAndDate ?? {};

  @override
  Future<List<Rehearsal>> listForUserOnDateUtc({
    required String userId,
    required int dateUtc00,
  }) async {
    return rehearsalsByUserAndDate[(userId, dateUtc00)] ?? const <Rehearsal>[];
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
