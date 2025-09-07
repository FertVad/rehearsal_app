import 'package:rehearsal_app/domain/models/project.dart';

abstract class ProjectsRepository {
  /// Creates a new project
  Future<Project> create({
    required String id,
    required String name,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    String? venue,
    String? directorId,
    String? ownerId,
  });

  /// Updates an existing project
  Future<Project> update({
    required String id,
    String? name,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    String? venue,
    String? directorId,
    int? memberCount,
  });

  /// Deletes a project (soft delete)
  Future<void> delete(String id);

  /// Gets a project by ID
  Future<Project?> getById(String id);

  /// Lists all projects for a user
  Future<List<Project>> listForUser(String userId);

  /// Lists all projects
  Future<List<Project>> listAll();

  /// Searches projects by name
  Future<List<Project>> searchByName(String query);
}