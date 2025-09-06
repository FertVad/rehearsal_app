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
      // Convert milliseconds to DateTime for Supabase
      final startTime = DateTime.fromMillisecondsSinceEpoch(startsAtUtc).toUtc();
      final endTime = DateTime.fromMillisecondsSinceEpoch(endsAtUtc).toUtc();
      
      final data = {
        'title': note ?? 'Rehearsal', // Use note as title, fallback to 'Rehearsal'
        'description': note,
        'location': place,
        'start_time': startTime.toIso8601String(),
        'end_time': endTime.toIso8601String(),
        'project_id': troupeId, // Map troupeId to project_id
        'is_mandatory': true, // Default to mandatory
      };

      final response = await SupabaseConfig.client
          .from(_tableName)
          .insert(data)
          .select()
          .single();

      // Convert Supabase response back to Drift format
      final createdAt = DateTime.parse(response['created_at']);
      final updatedAt = DateTime.parse(response['updated_at']);
      final deletedAt = response['deleted_at'] != null ? DateTime.parse(response['deleted_at']) : null;
      
      final startDateTime = DateTime.parse(response['start_time']);
      final endDateTime = DateTime.parse(response['end_time']);

      return Rehearsal(
        id: response['id'],
        createdAtUtc: createdAt.millisecondsSinceEpoch,
        updatedAtUtc: updatedAt.millisecondsSinceEpoch,
        deletedAtUtc: deletedAt?.millisecondsSinceEpoch,
        lastWriter: lastWriter,
        troupeId: response['project_id'], // Map project_id back to troupeId
        startsAtUtc: startDateTime.millisecondsSinceEpoch,
        endsAtUtc: endDateTime.millisecondsSinceEpoch,
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

      final createdAt = DateTime.parse(response['created_at']);
      final updatedAt = DateTime.parse(response['updated_at']);
      final deletedAt = response['deleted_at'] != null ? DateTime.parse(response['deleted_at']) : null;
      
      final startDateTime = DateTime.parse(response['start_time']);
      final endDateTime = DateTime.parse(response['end_time']);
      
      return Rehearsal(
        id: response['id'],
        createdAtUtc: createdAt.millisecondsSinceEpoch,
        updatedAtUtc: updatedAt.millisecondsSinceEpoch,
        deletedAtUtc: deletedAt?.millisecondsSinceEpoch,
        lastWriter: 'supabase:user',
        troupeId: response['project_id'],
        startsAtUtc: startDateTime.millisecondsSinceEpoch,
        endsAtUtc: endDateTime.millisecondsSinceEpoch,
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
      // Convert milliseconds to DateTime for Supabase query
      final startOfDay = DateTime.fromMillisecondsSinceEpoch(dateUtc00).toUtc();
      final endOfDay = startOfDay.add(const Duration(days: 1));

      // Query rehearsals where user is a participant
      final response = await SupabaseConfig.client
          .from(_tableName)
          .select('*, rehearsal_participants!inner(profile_id)')
          .eq('rehearsal_participants.profile_id', userId)
          .gte('start_time', startOfDay.toIso8601String())
          .lt('start_time', endOfDay.toIso8601String())
          .order('start_time', ascending: true);

      return response.map<Rehearsal>((json) {
        final createdAt = DateTime.parse(json['created_at']);
        final updatedAt = DateTime.parse(json['updated_at']);
        final deletedAt = json['deleted_at'] != null ? DateTime.parse(json['deleted_at']) : null;
        
        final startDateTime = DateTime.parse(json['start_time']);
        final endDateTime = DateTime.parse(json['end_time']);
        
        return Rehearsal(
          id: json['id'],
          createdAtUtc: createdAt.millisecondsSinceEpoch,
          updatedAtUtc: updatedAt.millisecondsSinceEpoch,
          deletedAtUtc: deletedAt?.millisecondsSinceEpoch,
          lastWriter: 'supabase:user',
          troupeId: json['project_id'],
          startsAtUtc: startDateTime.millisecondsSinceEpoch,
          endsAtUtc: endDateTime.millisecondsSinceEpoch,
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
      // Convert milliseconds to DateTime for Supabase query
      final fromDateTime = DateTime.fromMillisecondsSinceEpoch(fromUtc).toUtc();
      final toDateTime = DateTime.fromMillisecondsSinceEpoch(toUtc).toUtc();

      // Query rehearsals where user is a participant
      final response = await SupabaseConfig.client
          .from(_tableName)
          .select('*, rehearsal_participants!inner(profile_id)')
          .eq('rehearsal_participants.profile_id', userId)
          .gte('start_time', fromDateTime.toIso8601String())
          .lte('start_time', toDateTime.toIso8601String())
          .order('start_time', ascending: true);

      return response.map<Rehearsal>((json) {
        final createdAt = DateTime.parse(json['created_at']);
        final updatedAt = DateTime.parse(json['updated_at']);
        final deletedAt = json['deleted_at'] != null ? DateTime.parse(json['deleted_at']) : null;
        
        final startDateTime = DateTime.parse(json['start_time']);
        final endDateTime = DateTime.parse(json['end_time']);
        
        return Rehearsal(
          id: json['id'],
          createdAtUtc: createdAt.millisecondsSinceEpoch,
          updatedAtUtc: updatedAt.millisecondsSinceEpoch,
          deletedAtUtc: deletedAt?.millisecondsSinceEpoch,
          lastWriter: 'supabase:user',
          troupeId: json['project_id'],
          startsAtUtc: startDateTime.millisecondsSinceEpoch,
          endsAtUtc: endDateTime.millisecondsSinceEpoch,
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
        final startTime = DateTime.fromMillisecondsSinceEpoch(startsAtUtc).toUtc();
        updateData['start_time'] = startTime.toIso8601String();
      }
      if (endsAtUtc != null) {
        final endTime = DateTime.fromMillisecondsSinceEpoch(endsAtUtc).toUtc();
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