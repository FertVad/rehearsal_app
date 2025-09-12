import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rehearsal_app/domain/repositories/availability_repository.dart';
import 'package:rehearsal_app/domain/repositories/rehearsals_repository.dart';
import 'package:rehearsal_app/domain/repositories/users_repository.dart';
import 'package:rehearsal_app/domain/repositories/projects_repository.dart';
import 'package:rehearsal_app/domain/repositories/project_members_repository.dart';
import 'package:rehearsal_app/data/repositories/availability_repository_impl.dart';
import 'package:rehearsal_app/data/repositories/rehearsals_repository_impl.dart';
import 'package:rehearsal_app/data/repositories/users_repository_impl.dart';
import 'package:rehearsal_app/data/repositories/projects_repository_impl.dart';
import 'package:rehearsal_app/data/repositories/project_members_repository_impl.dart';
import 'package:rehearsal_app/features/user/controller/user_provider.dart'
    show currentUserIdProvider;

/// Centralized repository providers for the application.
/// All data access goes through Supabase providers.

// Repository providers - using new repository implementations
final availabilityRepositoryProvider = Provider<AvailabilityRepository>((ref) {
  return AvailabilityRepositoryImpl();
});

final rehearsalsRepositoryProvider = Provider<RehearsalsRepository>((ref) {
  return RehearsalsRepositoryImpl(
    availabilityRepository: ref.read(availabilityRepositoryProvider),
    projectMembersRepository: ref.read(projectMembersRepositoryProvider),
  );
});

final usersRepositoryProvider = Provider<UsersRepository>((ref) {
  return UsersRepositoryImpl();
});

final projectsRepositoryProvider = Provider<ProjectsRepository>((ref) {
  return ProjectsRepositoryImpl();
});

final projectMembersRepositoryProvider = Provider<ProjectMembersRepository>((
  ref,
) {
  return ProjectMembersRepositoryImpl();
});

/// Current user id provider that gets the user from the user management system.
/// Returns null if the user is not authenticated.
final repositoryCurrentUserIdProvider = Provider<String?>((ref) {
  return ref.watch(currentUserIdProvider);
});
