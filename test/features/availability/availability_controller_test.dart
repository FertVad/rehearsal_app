import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rehearsal_app/core/db/app_database.dart';
import 'package:rehearsal_app/core/utils/time.dart';
import 'package:rehearsal_app/domain/repositories/availability_repository.dart';
import 'package:rehearsal_app/core/providers/index.dart';
import 'package:rehearsal_app/features/availability/controller/availability_state.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

class FakeAvailabilityRepository implements AvailabilityRepository {
  final map = <(String, int), Availability>{};

  @override
  Future<Availability?> getForUserOnDateUtc({
    required String userId,
    required int dateUtc00,
  }) async {
    return map[(userId, dateUtc00)];
  }

  @override
  Future<void> upsertForUserOnDateUtc({
    required String userId,
    required int dateUtc00,
    required String status,
    String? intervalsJson,
    String? note,
    String lastWriter = 'device:local',
  }) async {
    final now = DateTime.now().toUtc().millisecondsSinceEpoch;
    map[(userId, dateUtc00)] = Availability(
      id: '${userId}_$dateUtc00',
      createdAtUtc: now,
      updatedAtUtc: now,
      deletedAtUtc: null,
      lastWriter: lastWriter,
      userId: userId,
      dateUtc: dateUtc00,
      status: status,
      intervalsJson: intervalsJson,
      note: note,
    );
  }

  @override
  Future<List<Availability>> listForUserRange({
    required String userId,
    required int fromDateUtc00,
    required int toDateUtc00,
  }) async {
    final result = <Availability>[];
    for (final entry in map.entries) {
      final key = entry.key;
      if (key.$1 == userId && key.$2 >= fromDateUtc00 && key.$2 < toDateUtc00) {
        result.add(entry.value);
      }
    }
    result.sort((a, b) => a.dateUtc.compareTo(b.dateUtc));
    return result;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late tz.Location location;

  setUpAll(() {
    tzdata.initializeTimeZones();
    location = tz.getLocation('Asia/Jerusalem');
    tz.setLocalLocation(location);
  });

  group('AvailabilityController', () {
    late ProviderContainer container;
    late FakeAvailabilityRepository repo;

    setUp(() {
      repo = FakeAvailabilityRepository();
      container = ProviderContainer(
        overrides: [
          availabilityRepositoryProvider.overrideWithValue(repo),
          currentUserIdProvider.overrideWithValue('user1'),
        ],
      );
    });

    tearDown(() => container.dispose());

    test('setStatus saves free and busy without intervals', () async {
      final controller = container.read(
        availabilityControllerProvider.notifier,
      );
      final day = DateTime(2024, 1, 10);
      final key = dateUtc00(day);

      await controller.setStatus(
        dayLocal: day,
        status: AvailabilityStatus.free,
      );
      var view = container.read(availabilityControllerProvider).byDate[key]!;
      expect(view.status, AvailabilityStatus.free);
      expect(view.intervals, isNull);
      var saved = repo.map[('user1', key)]!;
      expect(saved.status, 'free');
      expect(saved.intervalsJson, isNull);

      await controller.setStatus(
        dayLocal: day,
        status: AvailabilityStatus.busy,
      );
      view = container.read(availabilityControllerProvider).byDate[key]!;
      expect(view.status, AvailabilityStatus.busy);
      expect(view.intervals, isNull);
      saved = repo.map[('user1', key)]!;
      expect(saved.status, 'busy');
      expect(saved.intervalsJson, isNull);
    });

    test(
      'setIntervals stores sorted non-overlapping intervals in UTC',
      () async {
        final controller = container.read(
          availabilityControllerProvider.notifier,
        );
        final day = DateTime(2024, 1, 15);
        final key = dateUtc00(day);
        final intervals = [
          (
            start: const TimeOfDay(hour: 12, minute: 0),
            end: const TimeOfDay(hour: 13, minute: 0),
          ),
          (
            start: const TimeOfDay(hour: 10, minute: 0),
            end: const TimeOfDay(hour: 12, minute: 0),
          ),
          (
            start: const TimeOfDay(hour: 13, minute: 0),
            end: const TimeOfDay(hour: 14, minute: 0),
          ),
        ];

        await controller.setIntervals(
          dayLocal: day,
          intervalsLocal: intervals,
          tz: 'Asia/Jerusalem',
        );

        final state = container.read(availabilityControllerProvider);
        expect(state.error, isNull);
        final view = state.byDate[key]!;
        expect(view.status, AvailabilityStatus.partial);
        expect(view.intervals, hasLength(3));
        expect(view.intervals![0].startUtc < view.intervals![1].startUtc, true);
        expect(view.intervals![1].startUtc < view.intervals![2].startUtc, true);

        final saved = repo.map[('user1', key)]!;
        expect(saved.status, 'partial');
        expect(saved.intervalsJson, isNotNull);
        final parsed = (jsonDecode(saved.intervalsJson!) as List)
            .cast<Map<String, dynamic>>();
        expect(parsed, hasLength(3));
        final dayStartUtc = key;
        final dayEndUtc = key + const Duration(days: 1).inMilliseconds;
        int lastEnd = dayStartUtc;
        for (final m in parsed) {
          final s = m['startUtc'] as int;
          final e = m['endUtc'] as int;
          expect(s >= lastEnd, true);
          expect(s >= dayStartUtc && e <= dayEndUtc, true);
          lastEnd = e;
        }
      },
    );

    test('setIntervals rejects overlapping intervals', () async {
      final controller = container.read(
        availabilityControllerProvider.notifier,
      );
      final day = DateTime(2024, 1, 16);
      final key = dateUtc00(day);
      final intervals = [
        (
          start: const TimeOfDay(hour: 10, minute: 0),
          end: const TimeOfDay(hour: 12, minute: 0),
        ),
        (
          start: const TimeOfDay(hour: 11, minute: 30),
          end: const TimeOfDay(hour: 13, minute: 0),
        ),
      ];

      await controller.setIntervals(
        dayLocal: day,
        intervalsLocal: intervals,
        tz: 'Asia/Jerusalem',
      );

      final state = container.read(availabilityControllerProvider);
      expect(state.error, isNotNull);
      expect(state.byDate.containsKey(key), false);
      expect(repo.map.containsKey(('user1', key)), false);
    });

    test('setIntervals rejects intervals where start >= end', () async {
      final controller = container.read(
        availabilityControllerProvider.notifier,
      );
      final day = DateTime(2024, 1, 17);
      final key = dateUtc00(day);
      final intervals = [
        (
          start: const TimeOfDay(hour: 12, minute: 0),
          end: const TimeOfDay(hour: 11, minute: 0),
        ),
      ];

      await controller.setIntervals(
        dayLocal: day,
        intervalsLocal: intervals,
        tz: 'Asia/Jerusalem',
      );

      final state = container.read(availabilityControllerProvider);
      expect(state.error, isNotNull);
      expect(state.byDate.containsKey(key), false);
      expect(repo.map.containsKey(('user1', key)), false);
    });

    test('toUtcInterval/fromUtcInterval handle DST start', () {
      final day = DateTime(2024, 3, 29);
      final expectedStart = tz.TZDateTime(location, 2024, 3, 29, 1, 30);
      final expectedEnd = tz.TZDateTime(location, 2024, 3, 29, 3, 30);
      final interval = toUtcInterval(
        day,
        const TimeOfDay(hour: 1, minute: 30),
        const TimeOfDay(hour: 3, minute: 30),
        'Asia/Jerusalem',
      );
      expect(interval.startUtc, expectedStart.millisecondsSinceEpoch);
      expect(interval.endUtc, expectedEnd.millisecondsSinceEpoch);
      final back = fromUtcInterval(
        interval.startUtc,
        interval.endUtc,
        'Asia/Jerusalem',
      );
      expect(back.startLocal.hour, 1);
      expect(back.startLocal.minute, 30);
      expect(back.endLocal.hour, 3);
      expect(back.endLocal.minute, 30);
    });

    test('toUtcInterval/fromUtcInterval handle DST end', () {
      final day = DateTime(2024, 10, 27);
      final expectedStart = tz.TZDateTime(location, 2024, 10, 27, 0, 30);
      final expectedEnd = tz.TZDateTime(location, 2024, 10, 27, 2, 30);
      final interval = toUtcInterval(
        day,
        const TimeOfDay(hour: 0, minute: 30),
        const TimeOfDay(hour: 2, minute: 30),
        'Asia/Jerusalem',
      );
      expect(interval.startUtc, expectedStart.millisecondsSinceEpoch);
      expect(interval.endUtc, expectedEnd.millisecondsSinceEpoch);
      final back = fromUtcInterval(
        interval.startUtc,
        interval.endUtc,
        'Asia/Jerusalem',
      );
      expect(back.startLocal.hour, 0);
      expect(back.startLocal.minute, 30);
      expect(back.endLocal.hour, 2);
      expect(back.endLocal.minute, 30);
    });
  });
}
