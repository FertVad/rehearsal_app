import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:rehearsal_app/core/providers/repository_providers.dart';
import 'package:rehearsal_app/core/auth/auth_provider.dart';
import 'package:rehearsal_app/domain/models/user.dart' as domain;
import 'package:rehearsal_app/core/utils/logger.dart';
import 'user_state.dart';

class UserController extends Notifier<UserState> {

  @override
  UserState build() {
    _initializeUser();
    return const UserState(currentUser: null, isLoading: true);
  }

  Future<void> _initializeUser() async {
    try {
      // Check if user is authenticated via Supabase
      final authService = ref.read(authServiceProvider);
      final supabaseUser = authService.currentUser;
      
      if (supabaseUser != null) {
        // User is authenticated, load their profile
        await _loadUser(supabaseUser.id);
      } else {
        // Not authenticated - set appropriate state
        state = state.copyWith(
          currentUser: null,
          isLoading: false,
          error: 'No authenticated user. Please sign up or log in.',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to initialize user: $e',
      );
    }
  }

  Future<void> _loadUser(String userId) async {
    final usersRepo = ref.read(usersRepositoryProvider);
    
    try {
      Logger.debug('UserController._loadUser: Loading user with id: $userId');
      final user = await usersRepo.getById(userId);

      if (user != null) {
        Logger.info('UserController._loadUser: User loaded successfully: ${user.name}');
        state = state.copyWith(currentUser: user, isLoading: false);
      } else {
        Logger.info('UserController._loadUser: User not found, attempting to create profile');
        
        // Check authentication state
        final authService = ref.read(authServiceProvider);
        final supabaseUser = authService.currentUser;
        
        Logger.debug('UserController._loadUser: Current Supabase user: ${supabaseUser?.id}, email: ${supabaseUser?.email}');
        
        if (supabaseUser != null) {
          // Add small delay to ensure auth session is fully established
          await Future.delayed(const Duration(milliseconds: 500));
          
          // Ensure profile exists using auth service
          await authService.ensureUserProfile(
            userId: supabaseUser.id,
            email: supabaseUser.email ?? 'unknown@example.com',
            displayName: supabaseUser.userMetadata?['display_name'],
          );
          
          // Add another small delay before trying to load
          await Future.delayed(const Duration(milliseconds: 200));
          
          // Try loading again after ensuring profile exists
          final user = await usersRepo.getById(userId);
          if (user != null) {
            Logger.info('UserController._loadUser: Successfully loaded user after profile creation');
            state = state.copyWith(currentUser: user, isLoading: false);
          } else {
            Logger.warning('UserController._loadUser: Still could not load user, using fallback');
            // Create a temporary user object with known data
            final fallbackUser = await _createFallbackUser(supabaseUser);
            state = state.copyWith(currentUser: fallbackUser, isLoading: false);
          }
        } else {
          // No authenticated user - set appropriate state
          state = state.copyWith(
            currentUser: null,
            isLoading: false,
            error: 'No authenticated user. Please sign up or log in.',
          );
        }
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load user: $e',
      );
    }
  }


  Future<domain.User> _createFallbackUser(supabase.User supabaseUser) async {
    // Create a fallback user object based on Supabase auth data
    // This ensures the user can use the app even if profile creation fails
    final now = DateTime.now();
    
    return domain.User(
      id: supabaseUser.id,
      createdAtUtc: now.millisecondsSinceEpoch,
      updatedAtUtc: now.millisecondsSinceEpoch,
      deletedAtUtc: null,
      lastWriter: 'fallback:auth',
      name: supabaseUser.userMetadata?['full_name'] ?? supabaseUser.email?.split('@')[0] ?? 'Unknown User',
      avatarUrl: supabaseUser.userMetadata?['avatar_url'],
      tz: 'UTC',
      metadata: 'fallback_user',
    );
  }

  Future<void> updateProfile({
    String? name,
    String? avatarUrl,
    String? timezone,
  }) async {
    if (state.currentUser == null) return;

    state = state.copyWith(isLoading: true);

    try {
      final usersRepo = ref.read(usersRepositoryProvider);
      await usersRepo.update(
        id: state.currentUser!.id,
        name: name,
        avatarUrl: avatarUrl,
        tz: timezone,
      );

      final updatedUser = await usersRepo.getById(state.currentUser!.id);
      state = state.copyWith(currentUser: updatedUser, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to update profile: $e',
      );
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}
