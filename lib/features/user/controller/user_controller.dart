import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rehearsal_app/core/providers/repository_providers.dart';
import 'user_state.dart';

class UserController extends Notifier<UserState> {
  static const String _currentUserIdKey = 'current_user_id';

  @override
  UserState build() {
    _initializeUser();
    return const UserState(currentUser: null, isLoading: true);
  }

  Future<void> _initializeUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedUserId = prefs.getString(_currentUserIdKey);

      if (savedUserId != null) {
        await _loadUser(savedUserId);
      } else {
        await _createDefaultUser();
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
    final user = await usersRepo.getById(userId);

    if (user != null) {
      state = state.copyWith(currentUser: user, isLoading: false);
    } else {
      await _createDefaultUser();
    }
  }

  Future<void> _createDefaultUser() async {
    final usersRepo = ref.read(usersRepositoryProvider);
    final userId = 'user_${DateTime.now().millisecondsSinceEpoch}';

    final user = await usersRepo.create(
      id: userId,
      name: 'Local User',
      tz: 'UTC',
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentUserIdKey, userId);

    state = state.copyWith(currentUser: user, isLoading: false);
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
