import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rehearsal_app/core/db/app_database.dart';
import 'package:rehearsal_app/data/repositories/local_availability_repository.dart';
import 'package:rehearsal_app/domain/repositories/availability_repository.dart';

import 'availability_controller.dart';
import 'availability_state.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) => AppDatabase());

final availabilityRepositoryProvider =
    Provider<AvailabilityRepository>((ref) {
  final db = ref.read(appDatabaseProvider);
  return LocalAvailabilityRepository(db);
});

/// Temporary current user id provider.
final currentUserIdProvider = Provider<String>((ref) => 'local-user');

final availabilityControllerProvider = NotifierProvider<AvailabilityController,
    AvailabilityState>(AvailabilityController.new);
