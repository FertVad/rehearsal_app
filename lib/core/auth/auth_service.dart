import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:rehearsal_app/core/supabase/supabase_config.dart';

class AuthService {
  static SupabaseClient get _client => SupabaseConfig.client;
  
  // Helper method to validate UUID format
  bool _isValidUUID(String uuid) {
    return RegExp(r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$').hasMatch(uuid);
  }
  
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
        await ensureUserProfile(
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
      
      if (response.user != null) {
        // Ensure profile exists for existing user
        await ensureUserProfile(
          userId: response.user!.id,
          email: email,
          displayName: response.user!.userMetadata?['display_name'],
        );
      }
      
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

  /// Ensure user profile exists in our profiles table
  Future<void> ensureUserProfile({
    required String userId,
    required String email,
    String? displayName,
  }) async {
    try {
      if (kDebugMode) {
        print('ensureUserProfile: Checking profile for user $userId with email $email');
        print('ensureUserProfile: Current auth user: ${currentUser?.id}');
        print('ensureUserProfile: Is authenticated: $isAuthenticated');
      }
      
      // Validate that we have a proper UUID
      if (userId.isEmpty || !_isValidUUID(userId)) {
        if (kDebugMode) print('ensureUserProfile: Invalid userId format: $userId');
        return;
      }
      
      // Ensure user is authenticated before creating profile
      if (!isAuthenticated || currentUser?.id != userId) {
        if (kDebugMode) print('ensureUserProfile: User not authenticated or ID mismatch. Auth: $isAuthenticated, Current: ${currentUser?.id}, Target: $userId');
        return;
      }
      
      // First check if profile already exists
      final existing = await _client
          .from('profiles')
          .select('id')
          .eq('id', userId)
          .maybeSingle();
      
      if (existing != null) {
        if (kDebugMode) print('ensureUserProfile: Profile already exists for user $userId');
        return; // Profile already exists
      }
      
      // Create profile with actual schema fields
      final profileData = <String, dynamic>{
        'id': userId,
      };
      
      // Add fields that actually exist in the database
      if (displayName != null && displayName.isNotEmpty) {
        profileData['display_name'] = displayName;
      }
      
      if (kDebugMode) print('ensureUserProfile: Creating profile with data: $profileData');
      
      // Create new profile - timestamps are set automatically by DB
      await _client.from('profiles').insert(profileData);
      
      if (kDebugMode) print('ensureUserProfile: Profile created successfully for user $userId');
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('ensureUserProfile: Failed to create profile for $userId: $e');
        print('ensureUserProfile: Stack trace: $stackTrace');
      }
      // Profile creation failed, but auth succeeded - this is not critical
    }
  }

  /// Get user profile from our profiles table
  Future<Map<String, dynamic>?> getUserProfile() async {
    if (!isAuthenticated) return null;
    
    try {
      final response = await _client
          .from('profiles')
          .select()
          .eq('id', currentUser!.id)
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
      if (bio != null) updateData['bio'] = bio;
      if (phone != null) updateData['phone'] = phone;
      
      if (updateData.isNotEmpty) {
        await _client
            .from('profiles')
            .update(updateData)
            .eq('id', currentUser!.id);
      }
    } catch (e) {
      rethrow;
    }
  }
}