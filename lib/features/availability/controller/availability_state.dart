import 'package:flutter/material.dart';

enum AvailabilityStatus { free, busy, partial }

class AvailabilityView {
  final AvailabilityStatus status;
  final List<({int startUtc, int endUtc})>? intervals; // only for partial
  const AvailabilityView({required this.status, this.intervals});
}

class AvailabilityState {
  final DateTime visibleMonth; // local
  final Map<int, AvailabilityView> byDate; // key: dateUtc00
  final bool isLoading;
  final String? error;

  const AvailabilityState({
    required this.visibleMonth,
    required this.byDate,
    required this.isLoading,
    this.error,
  });

  AvailabilityState copyWith({
    DateTime? visibleMonth,
    Map<int, AvailabilityView>? byDate,
    bool? isLoading,
    String? error,
  }) {
    return AvailabilityState(
      visibleMonth: visibleMonth ?? this.visibleMonth,
      byDate: byDate ?? this.byDate,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  static AvailabilityState initial() => AvailabilityState(
        visibleMonth: DateTime.now(),
        byDate: const {},
        isLoading: false,
      );
}
