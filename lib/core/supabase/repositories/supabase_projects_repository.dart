import 'package:rehearsal_app/domain/repositories/projects_repository.dart';
import 'package:rehearsal_app/core/supabase/supabase_config.dart';
import 'package:rehearsal_app/domain/models/project.dart';

class SupabaseProjectsRepository implements ProjectsRepository {
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
      
      // Only add fields that have values
      if (description != null && description.isNotEmpty) data['description'] = description;
      if (startDate != null) data['start_date'] = startDate.toIso8601String();
      if (endDate != null) data['end_date'] = endDate.toIso8601String();
      if (venue != null && venue.isNotEmpty) data['venue'] = venue;
      if (directorId != null && directorId.isNotEmpty) data['director_id'] = directorId;
      if (ownerId != null && ownerId.isNotEmpty) data['owner_id'] = ownerId;

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
    try {
      final now = DateTime.now().toUtc();
      
      await SupabaseConfig.client
          .from(_tableName)
          .update({
            'deleted_at': now.toIso8601String(),
            'updated_at': now.toIso8601String(),
          })
          .eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete project: $e');
    }
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
          .eq('owner_id', userId)
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
    final createdAt = DateTime.parse(data['created_at']);
    final updatedAt = DateTime.parse(data['updated_at']);
    final deletedAt = data['deleted_at'] != null 
        ? DateTime.parse(data['deleted_at']) 
        : null;

    return Project(
      id: data['id'],
      name: data['name'],
      description: data['description'],
      startDate: data['start_date'] != null ? DateTime.parse(data['start_date']) : null,
      endDate: data['end_date'] != null ? DateTime.parse(data['end_date']) : null,
      venue: data['venue'],
      directorId: data['director_id'],
      createdAtUtc: createdAt.millisecondsSinceEpoch,
      updatedAtUtc: updatedAt.millisecondsSinceEpoch,
      deletedAtUtc: deletedAt?.millisecondsSinceEpoch,
      ownerId: data['owner_id'],
      memberCount: data['member_count'] ?? 1,
    );
  }
}