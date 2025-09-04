import 'package:rehearsal_app/domain/repositories/rehearsals_repository.dart';
import 'package:rehearsal_app/core/supabase/supabase_config.dart';
import 'package:rehearsal_app/core/db/app_database.dart';

class SupabaseRehearsalsRepository implements RehearsalsRepository {
  static const String _tableName = 'rehearsals';

  @override
  Future<Rehearsal> create({
    required String id,
    String? troupeId,
    required int startsAtUtc,
    required int endsAtUtc,
    String? place,
    String? note,
    String lastWriter = 'device:local',
  }) async {
    try {
      // Convert UTC timestamps to ISO strings
      final startTime = DateTime.fromMillisecondsSinceEpoch(startsAtUtc, isUtc: true);
      final endTime = DateTime.fromMillisecondsSinceEpoch(endsAtUtc, isUtc: true);
      
      final data = {
        'id': id,
        'project_id': troupeId, // Changed from troupe_id to project_id
        'title': note ?? 'Rehearsal', // Use note as title or default
        'description': note,
        'location': place,
        'start_time': startTime.toIso8601String(),
        'end_time': endTime.toIso8601String(),
        'is_mandatory': false,
        'created_by': null, // Will be set based on auth context
        'metadata': <String, dynamic>{},
      };

      final response = await SupabaseConfig.client
          .from(_tableName)
          .insert(data)
          .select()
          .single();

      // Convert back to Drift format for compatibility
      final responseStartTime = DateTime.parse(response['start_time']);
      final responseEndTime = DateTime.parse(response['end_time']);
      final createdAt = DateTime.parse(response['created_at']);
      final updatedAt = DateTime.parse(response['updated_at']);
      final deletedAt = response['deleted_at'] != null ? DateTime.parse(response['deleted_at']) : null;

      return Rehearsal(
        id: response['id'],
        createdAtUtc: createdAt.millisecondsSinceEpoch,
        updatedAtUtc: updatedAt.millisecondsSinceEpoch,
        deletedAtUtc: deletedAt?.millisecondsSinceEpoch,
        lastWriter: lastWriter,
        troupeId: response['project_id'], // Map back to troupeId for compatibility
        startsAtUtc: responseStartTime.millisecondsSinceEpoch,
        endsAtUtc: responseEndTime.millisecondsSinceEpoch,
        place: response['location'],
        note: response['description'],
      );
    } catch (e) {
      throw Exception('Failed to create rehearsal: $e');
    }
  }

  @override
  Future<Rehearsal?> getById(String id) async {
    try {
      final response = await SupabaseConfig.client
          .from(_tableName)
          .select()
          .eq('id', id)
          .maybeSingle();

      if (response == null) return null;

      final startTime = DateTime.parse(response['start_time']);
      final endTime = DateTime.parse(response['end_time']);
      final createdAt = DateTime.parse(response['created_at']);
      final updatedAt = DateTime.parse(response['updated_at']);
      final deletedAt = response['deleted_at'] != null ? DateTime.parse(response['deleted_at']) : null;
      
      return Rehearsal(
        id: response['id'],
        createdAtUtc: createdAt.millisecondsSinceEpoch,
        updatedAtUtc: updatedAt.millisecondsSinceEpoch,
        deletedAtUtc: deletedAt?.millisecondsSinceEpoch,
        lastWriter: 'supabase:user',
        troupeId: response['project_id'],
        startsAtUtc: startTime.millisecondsSinceEpoch,
        endsAtUtc: endTime.millisecondsSinceEpoch,
        place: response['location'],
        note: response['description'],
      );
    } catch (e) {
      throw Exception('Failed to get rehearsal by ID: $e');
    }
  }

  @override
  Future<List<Rehearsal>> listForUserOnDateUtc({
    required String userId,
    required int dateUtc00,
  }) async {
    try {
      // Convert UTC timestamp to date and time range
      final dateTime = DateTime.fromMillisecondsSinceEpoch(dateUtc00, isUtc: true);
      final startOfDay = DateTime(dateTime.year, dateTime.month, dateTime.day).toIso8601String();
      final endOfDay = DateTime(dateTime.year, dateTime.month, dateTime.day, 23, 59, 59).toIso8601String();

      final response = await SupabaseConfig.client
          .from(_tableName)
          .select()
          .gte('start_time', startOfDay)
          .lte('start_time', endOfDay)
          .order('start_time', ascending: true);

      return response.map<Rehearsal>((json) {
        final startTime = DateTime.parse(json['start_time']);
        final endTime = DateTime.parse(json['end_time']);
        final createdAt = DateTime.parse(json['created_at']);
        final updatedAt = DateTime.parse(json['updated_at']);
        final deletedAt = json['deleted_at'] != null ? DateTime.parse(json['deleted_at']) : null;
        
        return Rehearsal(
          id: json['id'],
          createdAtUtc: createdAt.millisecondsSinceEpoch,
          updatedAtUtc: updatedAt.millisecondsSinceEpoch,
          deletedAtUtc: deletedAt?.millisecondsSinceEpoch,
          lastWriter: 'supabase:user',
          troupeId: json['project_id'],
          startsAtUtc: startTime.millisecondsSinceEpoch,
          endsAtUtc: endTime.millisecondsSinceEpoch,
          place: json['location'],
          note: json['description'],
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to list rehearsals for user on date: $e');
    }
  }

  @override
  Future<List<Rehearsal>> listForUserInRange({
    required String userId,
    required int fromUtc,
    required int toUtc,
  }) async {
    try {
      // Convert UTC timestamps to ISO strings
      final fromDateTime = DateTime.fromMillisecondsSinceEpoch(fromUtc, isUtc: true);
      final toDateTime = DateTime.fromMillisecondsSinceEpoch(toUtc, isUtc: true);
      
      final response = await SupabaseConfig.client
          .from(_tableName)
          .select()
          .gte('start_time', fromDateTime.toIso8601String())
          .lte('start_time', toDateTime.toIso8601String())
          .order('start_time', ascending: true);

      return response.map<Rehearsal>((json) {
        final startTime = DateTime.parse(json['start_time']);
        final endTime = DateTime.parse(json['end_time']);
        final createdAt = DateTime.parse(json['created_at']);
        final updatedAt = DateTime.parse(json['updated_at']);
        final deletedAt = json['deleted_at'] != null ? DateTime.parse(json['deleted_at']) : null;
        
        return Rehearsal(
          id: json['id'],
          createdAtUtc: createdAt.millisecondsSinceEpoch,
          updatedAtUtc: updatedAt.millisecondsSinceEpoch,
          deletedAtUtc: deletedAt?.millisecondsSinceEpoch,
          lastWriter: 'supabase:user',
          troupeId: json['project_id'],
          startsAtUtc: startTime.millisecondsSinceEpoch,
          endsAtUtc: endTime.millisecondsSinceEpoch,
          place: json['location'],
          note: json['description'],
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to list rehearsals for user in range: $e');
    }
  }

  @override
  Future<void> update({
    required String id,
    int? startsAtUtc,
    int? endsAtUtc,
    String? place,
    String? note,
    String lastWriter = 'device:local',
  }) async {
    try {
      final updateData = <String, dynamic>{};

      if (startsAtUtc != null) {
        final startTime = DateTime.fromMillisecondsSinceEpoch(startsAtUtc, isUtc: true);
        updateData['start_time'] = startTime.toIso8601String();
      }
      if (endsAtUtc != null) {
        final endTime = DateTime.fromMillisecondsSinceEpoch(endsAtUtc, isUtc: true);
        updateData['end_time'] = endTime.toIso8601String();
      }
      if (place != null) updateData['location'] = place;
      if (note != null) {
        updateData['description'] = note;
        updateData['title'] = note; // Update title as well
      }

      await SupabaseConfig.client
          .from(_tableName)
          .update(updateData)
          .eq('id', id);
    } catch (e) {
      throw Exception('Failed to update rehearsal: $e');
    }
  }

  @override
  Future<void> softDelete(String id, {String lastWriter = 'device:local'}) async {
    try {
      await SupabaseConfig.client
          .from(_tableName)
          .update({
            'deleted_at': DateTime.now().toUtc().toIso8601String(),
          })
          .eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete rehearsal: $e');
    }
  }
}