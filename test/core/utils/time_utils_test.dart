import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rehearsal_app/core/utils/time.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() {
  setUpAll(() {
    tz.initializeTimeZones();
  });

  test('dateUtc00 returns start of the day in UTC', () {
    final date = DateTime(2024, 3, 15, 12, 34);
    final expected = DateTime(
      date.year,
      date.month,
      date.day,
    ).toUtc().millisecondsSinceEpoch;
    expect(dateUtc00(date), expected);
  });

  test('toUtcInterval and fromUtcInterval handle DST start in Jerusalem', () {
    const tzName = 'Asia/Jerusalem';
    final day = DateTime(2024, 3, 29); // DST starts on this day at 02:00
    final startLocal = const TimeOfDay(hour: 1, minute: 30);
    final endLocal = const TimeOfDay(hour: 3, minute: 30);

    final interval = toUtcInterval(day, startLocal, endLocal, tzName);

    final location = tz.getLocation(tzName);
    final expectedStart = tz.TZDateTime(
      location,
      day.year,
      day.month,
      day.day,
      1,
      30,
    );
    final expectedEnd = tz.TZDateTime(
      location,
      day.year,
      day.month,
      day.day,
      3,
      30,
    );

    expect(interval.startUtc, expectedStart.millisecondsSinceEpoch);
    expect(interval.endUtc, expectedEnd.millisecondsSinceEpoch);

    final roundTrip = fromUtcInterval(
      interval.startUtc,
      interval.endUtc,
      tzName,
    );
    expect(roundTrip.startLocal, startLocal);
    expect(roundTrip.endLocal, endLocal);
  });

  test('toUtcInterval and fromUtcInterval handle DST end in Jerusalem', () {
    const tzName = 'Asia/Jerusalem';
    final day = DateTime(2024, 10, 27); // DST ends on this day at 02:00
    final startLocal = const TimeOfDay(hour: 0, minute: 30);
    final endLocal = const TimeOfDay(hour: 2, minute: 30);

    final interval = toUtcInterval(day, startLocal, endLocal, tzName);

    final location = tz.getLocation(tzName);
    final expectedStart = tz.TZDateTime(
      location,
      day.year,
      day.month,
      day.day,
      0,
      30,
    );
    final expectedEnd = tz.TZDateTime(
      location,
      day.year,
      day.month,
      day.day,
      2,
      30,
    );

    expect(interval.startUtc, expectedStart.millisecondsSinceEpoch);
    expect(interval.endUtc, expectedEnd.millisecondsSinceEpoch);

    final roundTrip = fromUtcInterval(
      interval.startUtc,
      interval.endUtc,
      tzName,
    );
    expect(roundTrip.startLocal, startLocal);
    expect(roundTrip.endLocal, endLocal);
  });
}
