import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:rehearsal_app/core/supabase/supabase_config.dart';

class AuthService {
  static SupabaseClient get _client => SupabaseConfig.client;
  
  // Get current user
  User? get currentUser => _client.auth.currentUser;
  
  // Get auth state stream
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;
  
  // Check if user is authenticated
  bool get isAuthenticated => currentUser != null;

  /// Register with email and password
  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: displayName != null ? {'display_name': displayName} : null,
      );
      
      if (response.user != null) {
        // Create profile after successful registration
        await _createUserProfile(
          userId: response.user!.id,
          email: email,
          displayName: displayName,
        );
      }
      
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// Sign in with email and password
  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// Sign in with Google
  Future<bool> signInWithGoogle() async {
    try {
      final response = await _client.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'io.supabase.rehearsalapp://login-callback/',
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// Reset password
  Future<void> resetPassword({required String email}) async {
    try {
      await _client.auth.resetPasswordForEmail(
        email,
        redirectTo: 'io.supabase.rehearsalapp://reset-password/',
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Update password
  Future<UserResponse> updatePassword({required String newPassword}) async {
    try {
      final response = await _client.auth.updateUser(
        UserAttributes(password: newPassword),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  /// Create user profile in our profiles table
  Future<void> _createUserProfile({
    required String userId,
    required String email,
    String? displayName,
  }) async {
    try {
      // First check if profile already exists
      final existing = await _client
          .from('profiles')
          .select('id')
          .eq('id', userId)
          .maybeSingle();
      
      if (existing != null) {
        return; // Profile already exists
      }
      
      await _client.from('profiles').insert({
        'id': userId, // Use id instead of user_id to match repository
        'display_name': displayName ?? email.split('@')[0],
        'timezone': 'UTC',
        'metadata': <String, dynamic>{},
      });
    } catch (e) {
      // Profile creation failed, but auth succeeded
    }
  }

  /// Get user profile from our profiles table
  Future<Map<String, dynamic>?> getUserProfile() async {
    if (!isAuthenticated) return null;
    
    try {
      final response = await _client
          .from('profiles')
          .select()
          .eq('user_id', currentUser!.id)
          .maybeSingle();
      
      return response;
    } catch (e) {
      // Failed to get user profile
      return null;
    }
  }

  /// Update user profile
  Future<void> updateUserProfile({
    String? displayName,
    String? avatarUrl,
    String? timezone,
    String? bio,
    String? phone,
  }) async {
    if (!isAuthenticated) throw Exception('User not authenticated');
    
    try {
      final updateData = <String, dynamic>{};
      if (displayName != null) updateData['display_name'] = displayName;
      if (avatarUrl != null) updateData['avatar_url'] = avatarUrl;
      if (timezone != null) updateData['timezone'] = timezone;
      if (bio != null) updateData['bio'] = bio;
      if (phone != null) updateData['phone'] = phone;
      
      if (updateData.isNotEmpty) {
        await _client
            .from('profiles')
            .update(updateData)
            .eq('user_id', currentUser!.id);
      }
    } catch (e) {
      rethrow;
    }
  }
}