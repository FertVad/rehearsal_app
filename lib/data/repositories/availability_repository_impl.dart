import 'package:rehearsal_app/core/utils/logger.dart';
import 'package:rehearsal_app/data/repositories/base_repository.dart';
import 'package:rehearsal_app/data/datasources/supabase_datasource.dart';
import 'package:rehearsal_app/domain/repositories/availability_repository.dart';
import 'package:rehearsal_app/domain/models/availability.dart';

class AvailabilityRepositoryImpl extends BaseRepository implements AvailabilityRepository {
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
        final date = DateTime.fromMillisecondsSinceEpoch(dateUtc00, isUtc: true);
        final dateString = '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
        
        Logger.repository('GET_FOR_USER_ON_DATE', _tableName, recordId: '${userId}_$dateUtc00', data: {'date': dateString});

        final response = await _dataSource.select(
          table: _tableName,
          filters: {
            'user_id': userId,
            'date': dateString,
          },
          excludeDeleted: true,
        );

        if (response.isEmpty) {
          Logger.debug('No availability found for user $userId on date $dateString');
          return null;
        }

        return _mapToAvailability(response.first, lastWriter: 'supabase:availability');
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
        final date = DateTime.fromMillisecondsSinceEpoch(dateUtc00, isUtc: true);
        final dateString = '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

        final upsertData = buildDataMap({
          'user_id': userId,
          'date': dateString,
          'status': status,
          if (intervalsJson != null) 'time_slots': intervalsJson,
          if (note != null) 'notes': note,
        });

        Logger.repository('UPSERT_FOR_USER_ON_DATE', _tableName, recordId: '${userId}_$dateUtc00', data: upsertData);

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
        final fromDate = DateTime.fromMillisecondsSinceEpoch(fromDateUtc00, isUtc: true);
        final toDate = DateTime.fromMillisecondsSinceEpoch(toDateUtc00, isUtc: true);
        
        final fromDateString = '${fromDate.year.toString().padLeft(4, '0')}-${fromDate.month.toString().padLeft(2, '0')}-${fromDate.day.toString().padLeft(2, '0')}';
        final toDateString = '${toDate.year.toString().padLeft(4, '0')}-${toDate.month.toString().padLeft(2, '0')}-${toDate.day.toString().padLeft(2, '0')}';

        Logger.repository('LIST_FOR_USER_RANGE', _tableName, recordId: userId, data: {
          'from': fromDateString,
          'to': toDateString
        });

        final response = await _dataSource.select(
          table: _tableName,
          filters: {
            'user_id': userId,
          },
          orderBy: 'date',
          ascending: true,
          excludeDeleted: true,
        );

        // Filter by date range manually since Supabase filtering might be complex
        final filtered = response.where((json) {
          final dateString = json['date'] as String;
          return dateString.compareTo(fromDateString) >= 0 && dateString.compareTo(toDateString) < 0;
        }).toList();

        return filtered.map<Availability>((json) => _mapToAvailability(json, lastWriter: 'supabase:availability')).toList();
      },
      operationName: 'LIST_FOR_USER_RANGE',
      tableName: _tableName,
      recordId: userId,
    );
  }

  /// Map Supabase response to Availability domain model
  Availability _mapToAvailability(Map<String, dynamic> json, {required String lastWriter}) {
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