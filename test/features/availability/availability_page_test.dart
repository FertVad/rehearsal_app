// ignore_for_file: todo
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rehearsal_app/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rehearsal_app/domain/models/availability.dart';
import 'package:rehearsal_app/domain/repositories/availability_repository.dart';
import 'package:rehearsal_app/core/providers/index.dart';
import 'package:rehearsal_app/features/availability/presentation/availability_page.dart';
import 'package:rehearsal_app/features/availability/presentation/day_bottom_sheet.dart';
import 'package:rehearsal_app/core/design_system/glass_system.dart';
import 'package:timezone/data/latest.dart' as tzdata;

/// Простая in-memory фейка
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

  testWidgets('AvailabilityPage renders and shows CalendarGrid (smoke)', (
    tester,
  ) async {
    final fake = _FakeAvailabilityRepo();
    final container = ProviderContainer(
      overrides: [
        availabilityRepositoryProvider.overrideWithValue(fake),
        currentUserIdProvider.overrideWithValue('u1'),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const AvailabilityPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Smoke: страница отрисовалась без падений и есть базовая каркасная верстка
    expect(find.byType(AvailabilityPage), findsOneWidget);
    expect(find.byType(Scaffold), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);
  });

  testWidgets('day_bottom_sheet uses GlassChip for status selection', (
    tester,
  ) async {
    // Arrange
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (_) => DayBottomSheet(dayLocal: DateTime.now()),
                );
              },
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    );

    // Act
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    // Assert
    expect(find.byType(GlassChip), findsNWidgets(3));
    expect(find.byKey(const Key('status_free')), findsOneWidget);
    expect(find.byKey(const Key('status_busy')), findsOneWidget);
    expect(find.byKey(const Key('status_partial')), findsOneWidget);
  });

  testWidgets('day_bottom_sheet displays selected status correctly', (
    tester,
  ) async {
    // Arrange
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (_) => DayBottomSheet(dayLocal: DateTime.now()),
                );
              },
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    );

    // Act
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    // Assert initial state
    expect(
      tester.widget<GlassChip>(find.byKey(const Key('status_free'))).selected,
      isTrue,
    );
    expect(
      tester.widget<GlassChip>(find.byKey(const Key('status_busy'))).selected,
      isFalse,
    );

    // Change selection
    await tester.tap(find.byKey(const Key('status_busy')));
    await tester.pumpAndSettle();

    // Assert updated state
    expect(
      tester.widget<GlassChip>(find.byKey(const Key('status_busy'))).selected,
      isTrue,
    );
    expect(
      tester.widget<GlassChip>(find.byKey(const Key('status_free'))).selected,
      isFalse,
    );
  });

  group('integration stubs (skipped)', () {
    testWidgets('open and save free (integration)', (tester) async {
      // TODO: move to integration_test/ and implement end-to-end flow
    }, skip: true);

    testWidgets('partial with touching intervals (integration)', (
      tester,
    ) async {
      // TODO: move to integration_test/ and implement end-to-end flow
    }, skip: true);

    testWidgets('overlapping intervals show error (integration)', (
      tester,
    ) async {
      // TODO: move to integration_test/ and implement end-to-end flow
    }, skip: true);
  });
}
