import 'package:rehearsal_app/domain/repositories/availability_repository.dart';
import 'package:rehearsal_app/core/supabase/supabase_config.dart';
import 'package:rehearsal_app/core/db/app_database.dart';
import 'dart:convert';

class SupabaseAvailabilityRepository implements AvailabilityRepository {
  static const String _tableName = 'user_availability';

  @override
  Future<Availability?> getForUserOnDateUtc({
    required String userId,
    required int dateUtc00,
  }) async {
    try {
      // Convert UTC timestamp to date string
      final dateTime = DateTime.fromMillisecondsSinceEpoch(dateUtc00, isUtc: true);
      final dateString = dateTime.toIso8601String().split('T')[0];
      
      final response = await SupabaseConfig.client
          .from(_tableName)
          .select()
          .eq('profile_id', userId)
          .eq('date', dateString)
          .maybeSingle();

      if (response == null) return null;
      
      // Convert Supabase response to Drift Availability object
      final createdAt = DateTime.parse(response['created_at']);
      final updatedAt = DateTime.parse(response['updated_at']);
      final deletedAt = response['deleted_at'] != null ? DateTime.parse(response['deleted_at']) : null;
      
      return Availability(
        id: response['id'],
        createdAtUtc: createdAt.millisecondsSinceEpoch,
        updatedAtUtc: updatedAt.millisecondsSinceEpoch,
        deletedAtUtc: deletedAt?.millisecondsSinceEpoch,
        lastWriter: 'supabase:user', // Default for new schema
        userId: userId, // Keep the userId from parameter since we searched by profile_id
        dateUtc: dateUtc00,
        status: response['status'],
        intervalsJson: response['time_intervals'] != null ? jsonEncode(response['time_intervals']) : null,
        note: response['notes'],
      );
    } catch (e) {
      throw Exception('Failed to get availability for user and date: $e');
    }
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
    try {
      // Convert UTC timestamp to date string
      final dateTime = DateTime.fromMillisecondsSinceEpoch(dateUtc00, isUtc: true);
      final dateString = dateTime.toIso8601String().split('T')[0];
      
      // Parse intervals JSON if provided
      List<Map<String, String>> timeIntervals = [];
      if (intervalsJson != null && intervalsJson.isNotEmpty) {
        final decoded = jsonDecode(intervalsJson);
        if (decoded is List) {
          timeIntervals = decoded.cast<Map<String, dynamic>>()
              .map((item) => Map<String, String>.from(item))
              .toList();
        }
      }
      
      final data = {
        'profile_id': userId,
        'date': dateString,
        'status': status,
        'time_intervals': timeIntervals,
        'notes': note,
        'metadata': <String, dynamic>{},
      };

      await SupabaseConfig.client
          .from(_tableName)
          .upsert(data, onConflict: 'profile_id,date');
    } catch (e) {
      throw Exception('Failed to upsert availability: $e');
    }
  }

  @override
  Future<List<Availability>> listForUserRange({
    required String userId,
    required int fromDateUtc00,
    required int toDateUtc00,
  }) async {
    try {
      // Convert UTC timestamps to date strings
      final fromDateTime = DateTime.fromMillisecondsSinceEpoch(fromDateUtc00, isUtc: true);
      final toDateTime = DateTime.fromMillisecondsSinceEpoch(toDateUtc00, isUtc: true);
      final fromDateString = fromDateTime.toIso8601String().split('T')[0];
      final toDateString = toDateTime.toIso8601String().split('T')[0];
      
      final response = await SupabaseConfig.client
          .from(_tableName)
          .select()
          .eq('profile_id', userId)
          .gte('date', fromDateString)
          .lt('date', toDateString)
          .order('date', ascending: true);

      return response.map<Availability>((json) {
        final createdAt = DateTime.parse(json['created_at']);
        final updatedAt = DateTime.parse(json['updated_at']);
        final deletedAt = json['deleted_at'] != null ? DateTime.parse(json['deleted_at']) : null;
        final dateTime = DateTime.parse(json['date']);
        
        return Availability(
          id: json['id'],
          createdAtUtc: createdAt.millisecondsSinceEpoch,
          updatedAtUtc: updatedAt.millisecondsSinceEpoch,
          deletedAtUtc: deletedAt?.millisecondsSinceEpoch,
          lastWriter: 'supabase:user',
          userId: userId,
          dateUtc: dateTime.millisecondsSinceEpoch,
          status: json['status'],
          intervalsJson: json['time_intervals'] != null ? jsonEncode(json['time_intervals']) : null,
          note: json['notes'],
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to list availability for user in range: $e');
    }
  }
}