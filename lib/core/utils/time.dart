import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart' as tz;

/// Returns the UTC start of the day for [anyLocal].
///
/// [anyLocal] is interpreted in the local time zone of the user.
int dateUtc00(DateTime anyLocal) {
  final localMidnight = DateTime(anyLocal.year, anyLocal.month, anyLocal.day);
  return localMidnight.toUtc().millisecondsSinceEpoch;
}

/// Converts a local interval within [dayLocal] to UTC milliseconds.
({int startUtc, int endUtc}) toUtcInterval(
  DateTime dayLocal,
  TimeOfDay startLocal,
  TimeOfDay endLocal,
  String tzName,
) {
  final location = tz.getLocation(tzName);
  final start = tz.TZDateTime(
    location,
    dayLocal.year,
    dayLocal.month,
    dayLocal.day,
    startLocal.hour,
    startLocal.minute,
  );
  final end = tz.TZDateTime(
    location,
    dayLocal.year,
    dayLocal.month,
    dayLocal.day,
    endLocal.hour,
    endLocal.minute,
  );
  return (startUtc: start.millisecondsSinceEpoch, endUtc: end.millisecondsSinceEpoch);
}

/// Converts a UTC interval to local [TimeOfDay] values in [tzName].
({TimeOfDay startLocal, TimeOfDay endLocal}) fromUtcInterval(
  int startUtc,
  int endUtc,
  String tzName,
) {
  final location = tz.getLocation(tzName);
  final start = tz.TZDateTime.fromMillisecondsSinceEpoch(location, startUtc);
  final end = tz.TZDateTime.fromMillisecondsSinceEpoch(location, endUtc);
  return (
    startLocal: TimeOfDay(hour: start.hour, minute: start.minute),
    endLocal: TimeOfDay(hour: end.hour, minute: end.minute),
  );
}
