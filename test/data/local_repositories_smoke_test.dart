import 'package:flutter_test/flutter_test.dart';
import 'package:rehearsal_app/core/db/connection_test.dart';
import 'package:rehearsal_app/core/db/app_database.dart';
import 'package:rehearsal_app/data/repositories/local_users_repository.dart';
import 'package:rehearsal_app/data/repositories/local_rehearsals_repository.dart';
import 'package:rehearsal_app/data/repositories/local_availability_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('local repos: basic CRUD & day list', () async {
    final db = AppDatabase.forTesting(connection: testConnection());
    final users = LocalUsersRepository(db);
    final rehearsals = LocalRehearsalsRepository(db);
    final availability = LocalAvailabilityRepository(db);

    final user = await users.create(id: 'u1', tz: 'UTC');
    expect(user.id, 'u1');

    final day = DateTime.utc(2025, 1, 2).millisecondsSinceEpoch;
    final day00 = day - day % 86400000;

    await availability.upsertForUserOnDateUtc(
      userId: user.id,
      dateUtc00: day00,
      status: 'free',
    );
    final av = await availability.getForUserOnDateUtc(
      userId: user.id,
      dateUtc00: day00,
    );
    expect(av?.status, 'free');

    await rehearsals.create(
      id: 'r1',
      startsAtUtc: day00 + 10 * 60 * 60 * 1000,
      endsAtUtc: day00 + 12 * 60 * 60 * 1000,
    );
    await db.into(db.rehearsalAttendees).insert(
          RehearsalAttendeesCompanion.insert(
            id: 'a1',
            rehearsalId: 'r1',
            userId: user.id,
            role: 'required',
            createdAtUtc: day00,
            updatedAtUtc: day00,
            lastWriter: 'device:local',
          ),
        );

    final list = await rehearsals.listForUserOnDateUtc(
      userId: user.id,
      dateUtc00: day00,
    );
    expect(list.length, 1);

    await db.close();
  });
}
