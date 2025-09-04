import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rehearsal_app/core/db/app_database.dart';
import 'package:rehearsal_app/domain/repositories/availability_repository.dart';
import 'package:rehearsal_app/domain/repositories/rehearsals_repository.dart';
import 'package:rehearsal_app/domain/repositories/users_repository.dart';
import 'package:rehearsal_app/core/supabase/repositories/supabase_availability_repository.dart';
import 'package:rehearsal_app/core/supabase/repositories/supabase_rehearsals_repository.dart';
import 'package:rehearsal_app/core/supabase/repositories/supabase_profiles_repository.dart';
import 'package:rehearsal_app/features/user/controller/user_provider.dart';

/// Centralized repository providers for the application.
/// All data access goes through these providers.

// Database provider (kept for migration period)
final appDatabaseProvider = Provider<AppDatabase>((ref) => AppDatabase());

// Repository providers - now using Supabase
final availabilityRepositoryProvider = Provider<AvailabilityRepository>((ref) {
  return SupabaseAvailabilityRepository();
});

final rehearsalsRepositoryProvider = Provider<RehearsalsRepository>((ref) {
  return SupabaseRehearsalsRepository();
});

final usersRepositoryProvider = Provider<UsersRepository>((ref) {
  return SupabaseProfilesRepository();
});

/// Current user id provider that gets the user from the user management system.
final currentUserIdProvider = Provider<String>((ref) {
  final currentUserId = ref.watch(currentUserProvider);
  return currentUserId ?? 'anonymous';
});