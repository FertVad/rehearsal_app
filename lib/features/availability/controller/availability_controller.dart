import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rehearsal_app/core/utils/time.dart';
import 'package:rehearsal_app/domain/repositories/availability_repository.dart';

import 'availability_state.dart';
import 'availability_provider.dart';

class AvailabilityController extends Notifier<AvailabilityState> {
  late final AvailabilityRepository _repo;
  late final String _userId; // temporary — local user

  @override
  AvailabilityState build() {
    _repo = ref.read(availabilityRepositoryProvider);
    _userId = ref.read(currentUserIdProvider); // provider stub should return a string
    return AvailabilityState.initial();
  }

  Future<void> loadMonth(DateTime monthLocal) async {
    state = state.copyWith(isLoading: true, visibleMonth: monthLocal, error: null);
    try {
      final from = DateTime(monthLocal.year, monthLocal.month, 1);
      final to = DateTime(monthLocal.year, monthLocal.month + 1, 1).subtract(const Duration(days: 1));
      final fromUtc = dateUtc00(from);
      final toUtc = dateUtc00(to);

      final items = await _repo.listForUserRange(
        userId: _userId,
        fromDateUtc00: fromUtc,
        toDateUtc00: toUtc,
      );
      final map = <int, AvailabilityView>{};
      for (final it in items) {
        final status = switch (it.status) {
          'free' => AvailabilityStatus.free,
          'busy' => AvailabilityStatus.busy,
          _ => AvailabilityStatus.partial,
        };
        List<({int startUtc, int endUtc})>? intervals;
        if (status == AvailabilityStatus.partial && it.intervalsJson != null) {
          final raw = (jsonDecode(it.intervalsJson!) as List).cast<Map<String, dynamic>>();
          intervals = raw
              .map((e) => (startUtc: e['startUtc'] as int, endUtc: e['endUtc'] as int))
              .toList();
        }
        map[it.dateUtc] = AvailabilityView(status: status, intervals: intervals);
      }

      state = state.copyWith(isLoading: false, byDate: map);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> setStatus({required DateTime dayLocal, required AvailabilityStatus status}) async {
    final date = dateUtc00(dayLocal);
    final view = AvailabilityView(status: status);
    state = state.copyWith(byDate: {...state.byDate, date: view}, error: null);

    await _repo.upsertForUserOnDateUtc(
      userId: _userId,
      dateUtc00: date,
      status: switch (status) {
        AvailabilityStatus.free => 'free',
        AvailabilityStatus.busy => 'busy',
        _ => 'partial'
      },
      intervalsJson: null,
      lastWriter: 'device:local',
    );
  }

  Future<void> setIntervals({
    required DateTime dayLocal,
    required List<({TimeOfDay start, TimeOfDay end})> intervalsLocal,
    required String tz, // IANA
  }) async {
    // Local validations → map to UTC, check overlaps
    final date = dateUtc00(dayLocal);
    final mapped = intervalsLocal
        .map((i) => toUtcInterval(dayLocal, i.start, i.end, tz))
        .toList()
      ..sort((a, b) => a.startUtc.compareTo(b.startUtc));

    for (int i = 0; i < mapped.length; i++) {
      final cur = mapped[i];
      if (cur.startUtc >= cur.endUtc) {
        state = state.copyWith(error: 'start_before_end');
        return;
      }
      if (i > 0) {
        final prev = mapped[i - 1];
        final overlaps = !(cur.startUtc >= prev.endUtc || cur.endUtc <= prev.startUtc);
        if (overlaps) {
          state = state.copyWith(error: 'overlap');
          return;
        }
      }
    }

    final jsonList = mapped.map((m) => {'startUtc': m.startUtc, 'endUtc': m.endUtc}).toList();
    final view = AvailabilityView(status: AvailabilityStatus.partial, intervals: mapped);
    state = state.copyWith(byDate: {...state.byDate, date: view}, error: null);

    await _repo.upsertForUserOnDateUtc(
      userId: _userId,
      dateUtc00: date,
      status: 'partial',
      intervalsJson: jsonEncode(jsonList),
      lastWriter: 'device:local',
    );
  }
}
