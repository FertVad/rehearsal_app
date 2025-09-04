import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'user_controller.dart';
import 'user_state.dart';

final userControllerProvider = NotifierProvider<UserController, UserState>(
  UserController.new,
);

final currentUserProvider = Provider<String?>((ref) {
  final userState = ref.watch(userControllerProvider);
  return userState.currentUser?.id;
});