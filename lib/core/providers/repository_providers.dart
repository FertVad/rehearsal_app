import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rehearsal_app/core/db/app_database.dart';
import 'package:rehearsal_app/data/repositories/local_availability_repository.dart';
import 'package:rehearsal_app/data/repositories/local_rehearsals_repository.dart';
import 'package:rehearsal_app/data/repositories/local_users_repository.dart';
import 'package:rehearsal_app/domain/repositories/availability_repository.dart';
import 'package:rehearsal_app/domain/repositories/rehearsals_repository.dart';
import 'package:rehearsal_app/domain/repositories/users_repository.dart';
import 'package:rehearsal_app/features/user/controller/user_provider.dart';

/// Centralized repository providers for the application.
/// All data access goes through these providers.

// Database provider
final appDatabaseProvider = Provider<AppDatabase>((ref) => AppDatabase());

// Repository providers
final availabilityRepositoryProvider = Provider<AvailabilityRepository>((ref) {
  final db = ref.read(appDatabaseProvider);
  return LocalAvailabilityRepository(db);
});

final rehearsalsRepositoryProvider = Provider<RehearsalsRepository>((ref) {
  final db = ref.read(appDatabaseProvider);
  return LocalRehearsalsRepository(db);
});

final usersRepositoryProvider = Provider<UsersRepository>((ref) {
  final db = ref.read(appDatabaseProvider);
  return LocalUsersRepository(db);
});

/// Current user id provider that gets the user from the user management system.
final currentUserIdProvider = Provider<String>((ref) {
  final currentUserId = ref.watch(currentUserProvider);
  return currentUserId ?? 'anonymous';
});