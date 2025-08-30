import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rehearsal_app/core/db/app_database.dart';
import 'package:rehearsal_app/core/utils/time.dart';
import 'package:rehearsal_app/domain/repositories/availability_repository.dart';
import 'package:rehearsal_app/features/availability/controller/availability_provider.dart';
import 'package:rehearsal_app/features/availability/presentation/availability_page.dart';
import 'package:rehearsal_app/features/availability/presentation/day_bottom_sheet.dart';
import 'package:timezone/data/latest.dart' as tzdata;

class _FakeAvailabilityRepo implements AvailabilityRepository {
  final map = <(String, int), Availability>{};

  @override
  Future<List<Availability>> listForUserRange({
    required String userId,
    required int fromDateUtc00,
    required int toDateUtc00,
  }) async {
    final result = <Availability>[];
    for (final e in map.entries) {
      final k = e.key;
      if (k.$1 == userId && k.$2 >= fromDateUtc00 && k.$2 <= toDateUtc00) {
        result.add(e.value);
      }
    }
    result.sort((a, b) => a.dateUtc.compareTo(b.dateUtc));
    return result;
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
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  setUpAll(() {
    tzdata.initializeTimeZones();
  });

  testWidgets('open and save free', (tester) async {
    final fake = _FakeAvailabilityRepo();
    final container = ProviderContainer(overrides: [
      availabilityRepositoryProvider.overrideWithValue(fake),
      currentUserIdProvider.overrideWithValue('u1'),
    ]);
    addTearDown(container.dispose);

    await container.read(availabilityControllerProvider.notifier).loadMonth(DateTime(2024, 1));

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: AvailabilityPage()),
      ),
    );
    await tester.pumpAndSettle();

    final day = DateTime(2024, 1, 1);
    await tester.tap(find.byKey(ValueKey('day-${dateUtc00(day)}')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('status_free')));
    await tester.tap(find.byKey(const Key('save_btn')));
    await tester.pumpAndSettle();

    final key = dateUtc00(day);
    final saved = fake.map[('u1', key)]!;
    expect(saved.status, 'free');
    expect(saved.intervalsJson, isNull);
  });

  testWidgets('partial with touching intervals', (tester) async {
    final fake = _FakeAvailabilityRepo();
    final container = ProviderContainer(overrides: [
      availabilityRepositoryProvider.overrideWithValue(fake),
      currentUserIdProvider.overrideWithValue('u1'),
    ]);
    addTearDown(container.dispose);

    await container.read(availabilityControllerProvider.notifier).loadMonth(DateTime(2024, 1));

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: AvailabilityPage()),
      ),
    );
    await tester.pumpAndSettle();

    final day = DateTime(2024, 1, 2);
    await tester.tap(find.byKey(ValueKey('day-${dateUtc00(day)}')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('status_partial')));
    await tester.tap(find.byKey(const Key('add_interval')));
    await tester.tap(find.byKey(const Key('add_interval')));
    await tester.pump();

    final state = tester.state(find.byType(DayBottomSheet)) as dynamic;
    state.setState(() {
      state._intervals[1] = (
        start: const TimeOfDay(hour: 11, minute: 0),
        end: const TimeOfDay(hour: 12, minute: 0),
      );
    });
    await tester.pump();

    await tester.tap(find.byKey(const Key('save_btn')));
    await tester.pumpAndSettle();

    final key = dateUtc00(day);
    final saved = fake.map[('u1', key)]!;
    expect(saved.status, 'partial');
    expect(saved.intervalsJson, isNotNull);
    final parsed = (jsonDecode(saved.intervalsJson!) as List).cast<Map<String, dynamic>>();
    expect(parsed, hasLength(2));
    final dayStart = key;
    final dayEnd = key + const Duration(days: 1).inMilliseconds;
    for (final m in parsed) {
      final s = m['startUtc'] as int;
      final e = m['endUtc'] as int;
      expect(s >= dayStart && e <= dayEnd, true);
    }
  });

  testWidgets('overlapping intervals show error', (tester) async {
    final fake = _FakeAvailabilityRepo();
    final container = ProviderContainer(overrides: [
      availabilityRepositoryProvider.overrideWithValue(fake),
      currentUserIdProvider.overrideWithValue('u1'),
    ]);
    addTearDown(container.dispose);

    await container.read(availabilityControllerProvider.notifier).loadMonth(DateTime(2024, 1));

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: AvailabilityPage()),
      ),
    );
    await tester.pumpAndSettle();

    final day = DateTime(2024, 1, 3);
    await tester.tap(find.byKey(ValueKey('day-${dateUtc00(day)}')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('status_partial')));
    await tester.tap(find.byKey(const Key('add_interval')));
    await tester.tap(find.byKey(const Key('add_interval')));
    await tester.tap(find.byKey(const Key('save_btn')));
    await tester.pump();

    expect(find.byKey(const Key('availability_snackbar_error')), findsOneWidget);
    final key = dateUtc00(day);
    expect(fake.map.containsKey(('u1', key)), false);
  });
}

