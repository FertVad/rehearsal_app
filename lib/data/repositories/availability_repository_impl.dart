import 'dart:convert';
import 'package:rehearsal_app/core/utils/logger.dart';
import 'package:rehearsal_app/data/repositories/base_repository.dart';
import 'package:rehearsal_app/data/datasources/supabase_datasource.dart';
import 'package:rehearsal_app/domain/repositories/availability_repository.dart';
import 'package:rehearsal_app/domain/models/availability.dart';

class AvailabilityRepositoryImpl extends BaseRepository
    implements AvailabilityRepository {
  static const String _tableName = 'user_availability';

  final SupabaseDataSource _dataSource;

  AvailabilityRepositoryImpl({SupabaseDataSource? dataSource})
    : _dataSource = dataSource ?? SupabaseDataSource();

  @override
  Future<Availability?> getForUserOnDateUtc({
    required String userId,
    required int dateUtc00,
  }) async {
    return await safeExecute(
      () async {
        // Convert milliseconds to date string for query
        final date = DateTime.fromMillisecondsSinceEpoch(
          dateUtc00,
          isUtc: true,
        );
        final dateString =
            '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

        Logger.repository(
          'GET_FOR_USER_ON_DATE',
          _tableName,
          recordId: '${userId}_$dateUtc00',
          data: {'date': dateString},
        );

        final response = await _dataSource.select(
          table: _tableName,
          filters: {'user_id': userId, 'date': dateString},
          excludeDeleted: true,
        );

        if (response.isEmpty) {
          Logger.debug(
            'No availability found for user $userId on date $dateString',
          );
          return null;
        }

        return _mapToAvailability(
          response.first,
          lastWriter: 'supabase:availability',
        );
      },
      operationName: 'GET_FOR_USER_ON_DATE',
      tableName: _tableName,
      recordId: '${userId}_$dateUtc00',
    );
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
    await safeExecute(
      () async {
        // Convert milliseconds to date string for storage
        final date = DateTime.fromMillisecondsSinceEpoch(
          dateUtc00,
          isUtc: true,
        );
        final dateString =
            '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

        final upsertData = buildDataMap({
          'user_id': userId,
          'date': dateString,
          'status': status,
          if (intervalsJson != null) 'time_slots': intervalsJson,
          if (note != null) 'notes': note,
        });

        Logger.repository(
          'UPSERT_FOR_USER_ON_DATE',
          _tableName,
          recordId: '${userId}_$dateUtc00',
          data: upsertData,
        );

        await _dataSource.upsert(
          table: _tableName,
          data: upsertData,
          onConflict: 'user_id,date',
        );
      },
      operationName: 'UPSERT_FOR_USER_ON_DATE',
      tableName: _tableName,
      recordId: '${userId}_$dateUtc00',
    );
  }

  @override
  Future<List<Availability>> listForUserRange({
    required String userId,
    required int fromDateUtc00,
    required int toDateUtc00,
  }) async {
    return await safeExecute(
      () async {
        // Convert milliseconds to date strings for query
        final fromDate = DateTime.fromMillisecondsSinceEpoch(
          fromDateUtc00,
          isUtc: true,
        );
        final toDate = DateTime.fromMillisecondsSinceEpoch(
          toDateUtc00,
          isUtc: true,
        );

        final fromDateString =
            '${fromDate.year.toString().padLeft(4, '0')}-${fromDate.month.toString().padLeft(2, '0')}-${fromDate.day.toString().padLeft(2, '0')}';
        final toDateString =
            '${toDate.year.toString().padLeft(4, '0')}-${toDate.month.toString().padLeft(2, '0')}-${toDate.day.toString().padLeft(2, '0')}';

        Logger.repository(
          'LIST_FOR_USER_RANGE',
          _tableName,
          recordId: userId,
          data: {'from': fromDateString, 'to': toDateString},
        );

        final response = await _dataSource.select(
          table: _tableName,
          filters: {'user_id': userId},
          orderBy: 'date',
          ascending: true,
          excludeDeleted: true,
        );

        // Filter by date range manually since Supabase filtering might be complex
        final filtered = response.where((json) {
          final dateString = json['date'] as String;
          return dateString.compareTo(fromDateString) >= 0 &&
              dateString.compareTo(toDateString) < 0;
        }).toList();

        return filtered
            .map<Availability>(
              (json) =>
                  _mapToAvailability(json, lastWriter: 'supabase:availability'),
            )
            .toList();
      },
      operationName: 'LIST_FOR_USER_RANGE',
      tableName: _tableName,
      recordId: userId,
    );
  }

  @override
  Future<void> blockTimeSlot({
    required String userId,
    required int dateUtc00,
    required int startMinutes,
    required int endMinutes,
    String lastWriter = 'system:rehearsal',
  }) async {
    await safeExecute(
      () async {
        // Convert date to string format
        final date = DateTime.fromMillisecondsSinceEpoch(dateUtc00, isUtc: true);
        final dateString = '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

        Logger.repository(
          'BLOCK_TIME_SLOT',
          _tableName,
          recordId: '${userId}_$dateUtc00',
          data: {'startMinutes': startMinutes, 'endMinutes': endMinutes},
        );

        // Get existing availability for this user/date
        final existingAvailability = await getForUserOnDateUtc(
          userId: userId,
          dateUtc00: dateUtc00,
        );

        if (existingAvailability == null) {
          // User has no availability record - create 'busy' status for this time
          await upsertForUserOnDateUtc(
            userId: userId,
            dateUtc00: dateUtc00,
            status: 'partial',
            intervalsJson: jsonEncode([]),
            note: 'Rehearsal scheduled',
            lastWriter: lastWriter,
          );
          return;
        }

        // Handle different availability statuses
        List<Map<String, int>> updatedIntervals = [];
        String newStatus = existingAvailability.status;

        if (existingAvailability.status == 'free') {
          // User was completely free - now becomes partial with all day available except rehearsal time
          updatedIntervals = _removeTimeSlotFromFullDay(startMinutes, endMinutes);
          newStatus = 'partial';
        } else if (existingAvailability.status == 'partial') {
          // User has specific available intervals - remove rehearsal time from them
          if (existingAvailability.intervalsJson != null) {
            try {
              final currentIntervals = (jsonDecode(existingAvailability.intervalsJson!) as List)
                  .map((interval) => {'start': interval['start'] as int, 'end': interval['end'] as int})
                  .toList();
              
              updatedIntervals = _removeTimeSlotFromIntervals(currentIntervals, startMinutes, endMinutes);
              
              // If no intervals left, user becomes busy
              if (updatedIntervals.isEmpty) {
                newStatus = 'busy';
              }
            } catch (e) {
              Logger.debug('Error parsing intervals JSON: $e');
              updatedIntervals = [];
              newStatus = 'busy';
            }
          }
        }
        // If status is 'busy', no changes needed

        // Update availability
        await upsertForUserOnDateUtc(
          userId: userId,
          dateUtc00: dateUtc00,
          status: newStatus,
          intervalsJson: updatedIntervals.isNotEmpty ? jsonEncode(updatedIntervals) : null,
          note: existingAvailability.note != null 
              ? '${existingAvailability.note}; Rehearsal scheduled'
              : 'Rehearsal scheduled',
          lastWriter: lastWriter,
        );

        Logger.debug('Blocked time slot $startMinutes-$endMinutes for user $userId');
      },
      operationName: 'BLOCK_TIME_SLOT',
      tableName: _tableName,
      recordId: '${userId}_$dateUtc00',
    );
  }

  /// Remove time slot from full day (9 AM to 6 PM default)
  List<Map<String, int>> _removeTimeSlotFromFullDay(int startMinutes, int endMinutes) {
    const dayStart = 9 * 60; // 9 AM
    const dayEnd = 18 * 60; // 6 PM
    
    final List<Map<String, int>> intervals = [];
    
    // Add morning slot if rehearsal doesn't start at beginning of day
    if (startMinutes > dayStart) {
      intervals.add({'start': dayStart, 'end': startMinutes});
    }
    
    // Add evening slot if rehearsal doesn't end at end of day
    if (endMinutes < dayEnd) {
      intervals.add({'start': endMinutes, 'end': dayEnd});
    }
    
    return intervals;
  }

  /// Remove time slot from existing intervals
  List<Map<String, int>> _removeTimeSlotFromIntervals(
    List<Map<String, int>> intervals, 
    int startMinutes, 
    int endMinutes,
  ) {
    final List<Map<String, int>> result = [];
    
    for (final interval in intervals) {
      final intervalStart = interval['start']!;
      final intervalEnd = interval['end']!;
      
      // No overlap - keep the interval as is
      if (endMinutes <= intervalStart || startMinutes >= intervalEnd) {
        result.add(interval);
        continue;
      }
      
      // Rehearsal completely covers this interval - skip it
      if (startMinutes <= intervalStart && endMinutes >= intervalEnd) {
        continue;
      }
      
      // Partial overlap - split the interval
      if (intervalStart < startMinutes) {
        // Keep the part before rehearsal
        result.add({'start': intervalStart, 'end': startMinutes});
      }
      
      if (intervalEnd > endMinutes) {
        // Keep the part after rehearsal  
        result.add({'start': endMinutes, 'end': intervalEnd});
      }
    }
    
    return result;
  }

  /// Map Supabase response to Availability domain model
  Availability _mapToAvailability(
    Map<String, dynamic> json, {
    required String lastWriter,
  }) {
    // Use base repository method for timestamp extraction
    final timestamps = extractTimestamps(json);

    // Convert date from string to milliseconds
    final dateString = json['date'] as String; // '2025-01-15'
    final date = DateTime.parse('${dateString}T00:00:00.000Z');

    return Availability(
      id: json['id'],
      createdAtUtc: timestamps['createdAtUtc']!,
      updatedAtUtc: timestamps['updatedAtUtc']!,
      deletedAtUtc: timestamps['deletedAtUtc'],
      lastWriter: lastWriter,
      userId: json['user_id'],
      dateUtc: date.millisecondsSinceEpoch,
      status: json['status'], // 'free'|'busy'|'partial'
      intervalsJson: json['time_slots']?.toString(),
      note: json['notes']?.toString(),
    );
  }
}
