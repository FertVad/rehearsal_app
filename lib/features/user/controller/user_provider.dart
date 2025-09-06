import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rehearsal_app/core/auth/auth_provider.dart';
import 'user_controller.dart';
import 'user_state.dart';

/// User controller provider - Manages user profile state and operations
/// Handles CRUD operations for user profiles, settings, and metadata
final userControllerProvider = NotifierProvider<UserController, UserState>(
  UserController.new,
);

/// Current user ID provider - Extracts user ID from UserState
/// Returns String? of current user ID, null if no user is logged in
/// NOTE: Different from currentUserProvider in auth_provider.dart (which returns User object)
final currentUserIdProvider = Provider<String?>((ref) {
  final userState = ref.watch(userControllerProvider);
  return userState.currentUser?.id;
});

/// Auth-aware user controller provider - Automatically reloads user data on auth changes
/// Watches auth state and invalidates user controller when user logs in/out
/// Use this instead of userControllerProvider when you need auth-reactive user data
final authAwareUserControllerProvider = Provider<UserState>((ref) {
  // Watch auth state to trigger user reload when auth changes
  ref.watch(authNotifierProvider);
  final userController = ref.watch(userControllerProvider);
  
  // When auth state changes, invalidate user controller to reload
  ref.listen(authNotifierProvider, (previous, next) {
    next.whenData((user) {
      if (user != null) {
        // User logged in, reload user controller
        ref.invalidate(userControllerProvider);
      } else if (previous?.hasValue == true && previous?.value != null) {
        // User logged out, reload user controller  
        ref.invalidate(userControllerProvider);
      }
    });
  });
  
  return userController;
});