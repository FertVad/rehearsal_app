import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rehearsal_app/domain/repositories/availability_repository.dart';
import 'package:rehearsal_app/domain/repositories/rehearsals_repository.dart';
import 'package:rehearsal_app/domain/repositories/users_repository.dart';
import 'package:rehearsal_app/core/supabase/repositories/supabase_availability_repository.dart';
import 'package:rehearsal_app/core/supabase/repositories/supabase_rehearsals_repository.dart';
import 'package:rehearsal_app/core/supabase/repositories/supabase_profiles_repository.dart';
import 'package:rehearsal_app/features/user/controller/user_provider.dart' show currentUserIdProvider;

/// Centralized repository providers for the application.
/// All data access goes through Supabase providers.

// Repository providers - using Supabase only
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
final repositoryCurrentUserIdProvider = Provider<String>((ref) {
  final currentUserId = ref.watch(currentUserIdProvider);
  return currentUserId ?? 'anonymous';
});