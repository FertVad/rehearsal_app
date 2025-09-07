import 'package:rehearsal_app/domain/repositories/availability_repository.dart';
import 'package:rehearsal_app/core/supabase/supabase_config.dart';
import 'package:rehearsal_app/domain/models/availability.dart';

class SupabaseAvailabilityRepository implements AvailabilityRepository {
  static const String _tableName = 'availability';

  @override
  Future<Availability?> getForUserOnDateUtc({
    required String userId,
    required int dateUtc00,
  }) async {
    try {
      final response = await SupabaseConfig.client
          .from(_tableName)
          .select()
          .eq('user_id', userId)
          .eq('date', DateTime.fromMillisecondsSinceEpoch(dateUtc00).toIso8601String().split('T')[0])
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
        lastWriter: 'supabase:user',
        userId: userId,
        dateUtc: dateUtc00,
        status: response['status'],
        intervalsJson: response['intervals_json'],
        note: response['note'],
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
      final data = {
        'user_id': userId,
        'date_utc': dateUtc00,
        'status': status,
        'intervals_json': intervalsJson,
        'note': note,
      };

      await SupabaseConfig.client
          .from(_tableName)
          .upsert(data, onConflict: 'user_id,date_utc');
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
      final response = await SupabaseConfig.client
          .from(_tableName)
          .select()
          .eq('user_id', userId)
          .gte('date_utc', fromDateUtc00)
          .lt('date_utc', toDateUtc00)
          .order('date_utc', ascending: true);

      return response.map<Availability>((json) {
        final createdAt = DateTime.parse(json['created_at']);
        final updatedAt = DateTime.parse(json['updated_at']);
        final deletedAt = json['deleted_at'] != null ? DateTime.parse(json['deleted_at']) : null;
        
        return Availability(
          id: json['id'],
          createdAtUtc: createdAt.millisecondsSinceEpoch,
          updatedAtUtc: updatedAt.millisecondsSinceEpoch,
          deletedAtUtc: deletedAt?.millisecondsSinceEpoch,
          lastWriter: 'supabase:user',
          userId: userId,
          dateUtc: json['date_utc'] as int,
          status: json['status'],
          intervalsJson: json['intervals_json'],
          note: json['note'],
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to list availability for user in range: $e');
    }
  }
}