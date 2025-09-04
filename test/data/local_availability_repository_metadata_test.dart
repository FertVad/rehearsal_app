import 'package:flutter_test/flutter_test.dart';
import 'package:rehearsal_app/core/constants/time_constants.dart';
import 'package:rehearsal_app/core/db/app_database.dart';
import 'package:rehearsal_app/core/db/connection_test.dart';
import 'package:rehearsal_app/data/repositories/local_availability_repository.dart';
import 'package:rehearsal_app/data/repositories/local_users_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LocalAvailabilityRepository upsert metadata', () {
    late AppDatabase db;
    late LocalAvailabilityRepository repo;
    late LocalUsersRepository users;

    setUp(() {
      db = AppDatabase.forTesting(connection: testConnection());
      repo = LocalAvailabilityRepository(db);
      users = LocalUsersRepository(db);
    });

    tearDown(() async {
      await db.close();
    });

    test('insert sets updatedAtUtc and lastWriter', () async {
      await users.create(id: 'u1', tz: 'UTC');
      final day = DateTime.utc(2024, 1, 1).millisecondsSinceEpoch;
      final day00 = day - day % TimeConstants.millisecondsPerDay;

      await repo.upsertForUserOnDateUtc(
        userId: 'u1',
        dateUtc00: day00,
        status: 'free',
      );

      final saved = await repo.getForUserOnDateUtc(
        userId: 'u1',
        dateUtc00: day00,
      );

      expect(saved, isNotNull);
      expect(saved!.updatedAtUtc, greaterThan(0));
      expect(saved.lastWriter, 'device:local');
    });

    test('update refreshes updatedAtUtc and lastWriter', () async {
      await users.create(id: 'u1', tz: 'UTC');
      final day = DateTime.utc(2024, 1, 1).millisecondsSinceEpoch;
      final day00 = day - day % TimeConstants.millisecondsPerDay;

      await repo.upsertForUserOnDateUtc(
        userId: 'u1',
        dateUtc00: day00,
        status: 'free',
      );
      final first = await repo.getForUserOnDateUtc(
        userId: 'u1',
        dateUtc00: day00,
      );
      final firstUpdated = first!.updatedAtUtc;
      final firstCreated = first.createdAtUtc;

      await Future.delayed(const Duration(milliseconds: 1));

      await repo.upsertForUserOnDateUtc(
        userId: 'u1',
        dateUtc00: day00,
        status: 'busy',
        lastWriter: 'device:test',
      );

      final second = await repo.getForUserOnDateUtc(
        userId: 'u1',
        dateUtc00: day00,
      );

      expect(second!.updatedAtUtc, greaterThan(firstUpdated));
      expect(second.createdAtUtc, firstCreated);
      expect(second.lastWriter, 'device:test');
    });
  });
}
