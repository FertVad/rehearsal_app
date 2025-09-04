import 'package:rehearsal_app/core/db/app_database.dart';

class UserState {
  const UserState({
    required this.currentUser,
    this.isLoading = false,
    this.error,
  });

  final User? currentUser;
  final bool isLoading;
  final String? error;

  UserState copyWith({
    User? currentUser,
    bool? isLoading,
    String? error,
  }) {
    return UserState(
      currentUser: currentUser ?? this.currentUser,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  bool get isAuthenticated => currentUser != null;
}