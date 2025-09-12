import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rehearsal_app/core/providers/index.dart';
import 'package:rehearsal_app/core/utils/time.dart';
import 'package:rehearsal_app/domain/repositories/availability_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:rehearsal_app/core/utils/logger.dart';

import 'availability_state.dart';

class AvailabilityController extends Notifier<AvailabilityState> {
  late final AvailabilityRepository _repo;

  @override
  AvailabilityState build() {
    _repo = ref.read(availabilityRepositoryProvider);
    return AvailabilityState.initial();
  }

  String? get _userId {
    // Try to get user ID from user state first
    final userStateUserId = ref.read(currentUserIdProvider);
    Logger.debug(
      'AvailabilityController._userId from user state = $userStateUserId',
    );

    if (userStateUserId != null) {
      return userStateUserId;
    }

    // Fallback to auth state if user state is not ready yet
    final authState = ref.read(currentUserProvider);
    final authUserId = authState.when(
      data: (user) => user?.id,
      loading: () => null,
      error: (_, _) => null,
    );
    Logger.debug(
      'AvailabilityController._userId from auth state = $authUserId',
    );

    if (authUserId != null) {
      return authUserId;
    }

    // Last resort - try Supabase directly
    final supabaseUserId = Supabase.instance.client.auth.currentUser?.id;
    Logger.debug(
      'AvailabilityController._userId from Supabase directly = $supabaseUserId',
    );

    return supabaseUserId;
  }

  Future<void> loadMonth(DateTime monthLocal) async {
    state = state.copyWith(
      isLoading: true,
      visibleMonth: monthLocal,
      error: null,
    );
    try {
      // Skip if user is not authenticated
      if (_userId == null) {
        state = state.copyWith(isLoading: false, byDate: {});
        return;
      }

      final from = DateTime(monthLocal.year, monthLocal.month, 1);
      final to = DateTime(
        monthLocal.year,
        monthLocal.month + 1,
        1,
      ).subtract(const Duration(days: 1));
      final fromUtc = dateUtc00(from);
      final toUtc = dateUtc00(to);

      final items = await _repo.listForUserRange(
        userId: _userId!,
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
          final raw = (jsonDecode(it.intervalsJson!) as List)
              .cast<Map<String, dynamic>>();
          intervals = raw
              .map(
                (e) => (
                  startUtc: e['startUtc'] as int,
                  endUtc: e['endUtc'] as int,
                ),
              )
              .toList();
        }
        map[it.dateUtc] = AvailabilityView(
          status: status,
          intervals: intervals,
        );
      }

      state = state.copyWith(isLoading: false, byDate: map);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> setStatus({
    required DateTime dayLocal,
    required AvailabilityStatus status,
  }) async {
    Logger.debug(
      'AvailabilityController.setStatus called with status: $status, day: $dayLocal',
    );

    // Skip if user is not authenticated
    if (_userId == null) {
      Logger.warning('No authenticated user, skipping setStatus');
      return;
    }

    final date = dateUtc00(dayLocal);
    final statusString = switch (status) {
      AvailabilityStatus.free => 'free',
      AvailabilityStatus.busy => 'busy',
      _ => 'partial',
    };

    Logger.debug(
      'Setting status for userId: $_userId, dateUtc00: $date, status: $statusString',
    );

    final view = AvailabilityView(status: status);
    state = state.copyWith(byDate: {...state.byDate, date: view}, error: null);

    try {
      await _repo.upsertForUserOnDateUtc(
        userId: _userId!,
        dateUtc00: date,
        status: statusString,
        intervalsJson: null,
        lastWriter: 'device:local',
      );
      Logger.info('Status saved successfully');
    } catch (e) {
      Logger.error('Error saving status: $e');
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> setIntervals({
    required DateTime dayLocal,
    required List<({TimeOfDay start, TimeOfDay end})> intervalsLocal,
    required String tz, // IANA
  }) async {
    Logger.debug(
      'AvailabilityController.setIntervals called with ${intervalsLocal.length} intervals, tz: $tz, day: $dayLocal',
    );

    // Skip if user is not authenticated
    if (_userId == null) {
      Logger.warning('No authenticated user, skipping setIntervals');
      return;
    }

    // Local validations → map to UTC, check overlaps
    final date = dateUtc00(dayLocal);

    Logger.debug('Mapping intervals to UTC using timezone: $tz');
    final mapped =
        intervalsLocal
            .map((i) => toUtcInterval(dayLocal, i.start, i.end, tz))
            .toList()
          ..sort((a, b) => a.startUtc.compareTo(b.startUtc));

    for (int i = 0; i < mapped.length; i++) {
      final cur = mapped[i];
      if (cur.startUtc >= cur.endUtc) {
        Logger.error('Invalid interval: start >= end');
        state = state.copyWith(error: 'start_before_end');
        return;
      }
      if (i > 0) {
        final prev = mapped[i - 1];
        final overlaps =
            !(cur.startUtc >= prev.endUtc || cur.endUtc <= prev.startUtc);
        if (overlaps) {
          Logger.error('Overlapping intervals detected');
          state = state.copyWith(error: 'overlap');
          return;
        }
      }
    }

    final jsonList = mapped
        .map((m) => {'startUtc': m.startUtc, 'endUtc': m.endUtc})
        .toList();
    final view = AvailabilityView(
      status: AvailabilityStatus.partial,
      intervals: mapped,
    );
    state = state.copyWith(byDate: {...state.byDate, date: view}, error: null);

    Logger.debug(
      'Saving intervals to database for userId: $_userId, dateUtc00: $date',
    );
    try {
      await _repo.upsertForUserOnDateUtc(
        userId: _userId!,
        dateUtc00: date,
        status: 'partial',
        intervalsJson: jsonEncode(jsonList),
        lastWriter: 'device:local',
      );
      Logger.info('Intervals saved successfully');
    } catch (e) {
      Logger.error('Error saving intervals: $e');
      state = state.copyWith(error: e.toString());
    }
  }
}
