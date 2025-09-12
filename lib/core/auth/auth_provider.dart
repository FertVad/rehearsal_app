import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:rehearsal_app/core/auth/auth_service.dart';

/// Auth service provider - Singleton instance of AuthService
/// Provides access to Supabase authentication functionality
final authServiceProvider = Provider<AuthService>((ref) => AuthService());

/// Current user provider - Stream of authenticated user
/// Returns User object when authenticated, null when not
/// DO NOT confuse with currentUserIdProvider from user_provider.dart
final currentUserProvider = StreamProvider<User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges.map((state) => state.session?.user);
});

/// User profile provider - Async user profile data
/// Fetches complete user profile from Supabase including metadata
final userProfileProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final authService = ref.watch(authServiceProvider);
  return await authService.getUserProfile();
});

// Auth state notifier
class AuthNotifier extends StateNotifier<AsyncValue<User?>> {
  AuthNotifier(this._authService) : super(const AsyncValue.loading()) {
    _init();
  }

  final AuthService _authService;

  void _init() {
    // Listen to auth state changes
    _authService.authStateChanges.listen((authState) {
      state = AsyncValue.data(authState.session?.user);
    });

    // Set initial state
    final currentUser = _authService.currentUser;
    state = AsyncValue.data(currentUser);
  }

  /// Sign up with email and password
  Future<String?> signUp({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      state = const AsyncValue.loading();

      final response = await _authService.signUpWithEmail(
        email: email,
        password: password,
        displayName: displayName,
      );

      if (response.user != null) {
        state = AsyncValue.data(response.user);
        return null; // Success
      } else {
        state = const AsyncValue.data(null);
        return 'Registration failed';
      }
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return e.toString();
    }
  }

  /// Sign in with email and password
  Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      state = const AsyncValue.loading();

      final response = await _authService.signInWithEmail(
        email: email,
        password: password,
      );

      if (response.user != null) {
        state = AsyncValue.data(response.user);
        return null; // Success
      } else {
        state = const AsyncValue.data(null);
        return 'Sign in failed';
      }
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return e.toString();
    }
  }

  /// Sign in with Google
  Future<String?> signInWithGoogle() async {
    try {
      state = const AsyncValue.loading();

      final success = await _authService.signInWithGoogle();

      if (success) {
        // State will be updated by the auth stream listener
        return null; // Success
      } else {
        state = const AsyncValue.data(null);
        return 'Google sign in failed';
      }
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return e.toString();
    }
  }

  /// Reset password
  Future<String?> resetPassword({required String email}) async {
    try {
      await _authService.resetPassword(email: email);
      return null; // Success
    } catch (e) {
      return e.toString();
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await _authService.signOut();
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  /// Update password
  Future<String?> updatePassword({required String newPassword}) async {
    try {
      await _authService.updatePassword(newPassword: newPassword);
      return null; // Success
    } catch (e) {
      return e.toString();
    }
  }
}

// Auth notifier provider
final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<User?>>((ref) {
      final authService = ref.watch(authServiceProvider);
      return AuthNotifier(authService);
    });
