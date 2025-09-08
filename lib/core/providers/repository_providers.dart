import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rehearsal_app/domain/repositories/availability_repository.dart';
import 'package:rehearsal_app/domain/repositories/rehearsals_repository.dart';
import 'package:rehearsal_app/domain/repositories/users_repository.dart';
import 'package:rehearsal_app/domain/repositories/projects_repository.dart';
import 'package:rehearsal_app/data/repositories/users_repository_impl.dart';
import 'package:rehearsal_app/features/user/controller/user_provider.dart' show currentUserIdProvider;

/// Centralized repository providers for the application.
/// All data access goes through Supabase providers.

// Repository providers - using new repository implementations
final availabilityRepositoryProvider = Provider<AvailabilityRepository>((ref) {
  // TODO: Implement AvailabilityRepositoryImpl when needed
  throw UnsupportedError('AvailabilityRepository not yet implemented with new architecture');
});

final rehearsalsRepositoryProvider = Provider<RehearsalsRepository>((ref) {
  // TODO: Implement RehearsalsRepositoryImpl when needed  
  throw UnsupportedError('RehearsalsRepository not yet implemented with new architecture');
});

final usersRepositoryProvider = Provider<UsersRepository>((ref) {
  return UsersRepositoryImpl();
});

final projectsRepositoryProvider = Provider<ProjectsRepository>((ref) {
  // TODO: Implement ProjectsRepositoryImpl when needed
  throw UnsupportedError('ProjectsRepository not yet implemented with new architecture');
});

/// Current user id provider that gets the user from the user management system.
final repositoryCurrentUserIdProvider = Provider<String>((ref) {
  final currentUserId = ref.watch(currentUserIdProvider);
  return currentUserId ?? 'anonymous';
});