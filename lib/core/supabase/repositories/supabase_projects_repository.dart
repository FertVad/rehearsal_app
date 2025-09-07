import 'package:rehearsal_app/domain/repositories/projects_repository.dart';
import 'package:rehearsal_app/core/supabase/supabase_config.dart';
import 'package:rehearsal_app/core/supabase/base_repository.dart';
import 'package:rehearsal_app/domain/models/project.dart';

class SupabaseProjectsRepository extends BaseSupabaseRepository implements ProjectsRepository {
  static const String _tableName = 'projects';

  @override
  Future<Project> create({
    required String id,
    required String name,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    String? venue,
    String? directorId,
    String? ownerId,
  }) async {
    try {
      final now = DateTime.now().toUtc();
      
      // Build data object, only including non-null values for optional fields
      final data = <String, dynamic>{
        'id': id,
        'name': name,
        'created_at': now.toIso8601String(),
        'updated_at': now.toIso8601String(),
      };
      
      // Only add fields that have values (fix_db schema)
      if (description != null && description.isNotEmpty) data['description'] = description;
      if (startDate != null) data['start_date'] = startDate.toIso8601String().split('T')[0]; // DATE format
      if (endDate != null) data['end_date'] = endDate.toIso8601String().split('T')[0]; // DATE format
      if (venue != null && venue.isNotEmpty) data['venue'] = venue;
      if (directorId != null && directorId.isNotEmpty) data['director_id'] = directorId;
      // Note: owner_id doesn't exist in fix_db schema - use director_id
      data['is_active'] = true; // Default to active
      data['invite_code'] = _generateInviteCode(); // Generate unique invite code

      final response = await SupabaseConfig.client
          .from(_tableName)
          .insert(data)
          .select()
          .single();

      return _mapToProject(response);
    } catch (e) {
      throw Exception('Failed to create project: $e');
    }
  }

  @override
  Future<Project> update({
    required String id,
    String? name,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    String? venue,
    String? directorId,
    int? memberCount,
  }) async {
    try {
      final now = DateTime.now().toUtc();
      
      final data = <String, dynamic>{
        'updated_at': now.toIso8601String(),
      };
      
      if (name != null) data['name'] = name;
      if (description != null) data['description'] = description;
      if (startDate != null) data['start_date'] = startDate.toIso8601String();
      if (endDate != null) data['end_date'] = endDate.toIso8601String();
      if (venue != null) data['venue'] = venue;
      if (directorId != null) data['director_id'] = directorId;
      if (memberCount != null) data['member_count'] = memberCount;

      final response = await SupabaseConfig.client
          .from(_tableName)
          .update(data)
          .eq('id', id)
          .select()
          .single();

      return _mapToProject(response);
    } catch (e) {
      throw Exception('Failed to update project: $e');
    }
  }

  @override
  Future<void> delete(String id) async {
    // Use base repository method for consistent soft delete
    await performSoftDelete(_tableName, id);
  }

  @override
  Future<Project?> getById(String id) async {
    try {
      final response = await SupabaseConfig.client
          .from(_tableName)
          .select()
          .eq('id', id)
          .isFilter('deleted_at', null)
          .single();

      return _mapToProject(response);
    } catch (e) {
      return null; // Project not found
    }
  }

  @override
  Future<List<Project>> listForUser(String userId) async {
    try {
      final response = await SupabaseConfig.client
          .from(_tableName)
          .select()
          .eq('director_id', userId)
          .isFilter('deleted_at', null)
          .order('updated_at', ascending: false);

      return response.map<Project>((data) => _mapToProject(data)).toList();
    } catch (e) {
      throw Exception('Failed to list projects for user: $e');
    }
  }

  @override
  Future<List<Project>> listAll() async {
    try {
      final response = await SupabaseConfig.client
          .from(_tableName)
          .select()
          .isFilter('deleted_at', null)
          .order('updated_at', ascending: false);

      return response.map<Project>((data) => _mapToProject(data)).toList();
    } catch (e) {
      throw Exception('Failed to list all projects: $e');
    }
  }

  @override
  Future<List<Project>> searchByName(String query) async {
    try {
      final response = await SupabaseConfig.client
          .from(_tableName)
          .select()
          .ilike('name', '%$query%')
          .isFilter('deleted_at', null)
          .order('updated_at', ascending: false);

      return response.map<Project>((data) => _mapToProject(data)).toList();
    } catch (e) {
      throw Exception('Failed to search projects: $e');
    }
  }

  Project _mapToProject(Map<String, dynamic> data) {
    // Use base repository method for timestamp extraction
    final timestamps = extractTimestamps(data);

    return Project(
      id: data['id'],
      name: data['name'],
      description: data['description'],
      startDate: data['start_date'] != null ? DateTime.parse(data['start_date'] + 'T00:00:00Z') : null,
      endDate: data['end_date'] != null ? DateTime.parse(data['end_date'] + 'T00:00:00Z') : null,
      venue: data['venue'],
      directorId: data['director_id'],
      createdAtUtc: timestamps['createdAtUtc']!,
      updatedAtUtc: timestamps['updatedAtUtc']!,
      deletedAtUtc: timestamps['deletedAtUtc'],
      ownerId: data['director_id'], // Use director_id as owner in fix_db schema
      memberCount: data['member_count'] ?? 1,
    );
  }

  /// Generate a unique invite code for the project
  String _generateInviteCode() {
    final now = DateTime.now().millisecondsSinceEpoch;
    final random = (now % 10000).toString().padLeft(4, '0');
    return 'INV$random';
  }
}