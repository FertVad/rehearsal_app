import 'package:flutter/foundation.dart';
import 'package:rehearsal_app/core/supabase/supabase_config.dart';

abstract class BaseRepository {
  // Common field names
  static const String deletedAtField = 'deleted_at';
  static const String createdAtField = 'created_at';
  static const String updatedAtField = 'updated_at';
  static const String idField = 'id';

  /// Extract timestamps from Supabase response
  /// Returns a map with millisecondsSinceEpoch values
  Map<String, int?> extractTimestamps(Map<String, dynamic> response) {
    final createdAt = DateTime.parse(response[createdAtField]);
    final updatedAt = DateTime.parse(response[updatedAtField]);
    final deletedAt = response[deletedAtField] != null 
        ? DateTime.parse(response[deletedAtField]) 
        : null;
    
    return {
      'createdAtUtc': createdAt.millisecondsSinceEpoch,
      'updatedAtUtc': updatedAt.millisecondsSinceEpoch,
      'deletedAtUtc': deletedAt?.millisecondsSinceEpoch,
    };
  }

  /// Universal soft delete operation
  /// Marks record as deleted by setting deleted_at timestamp
  Future<void> performSoftDelete(String tableName, String id) async {
    try {
      await SupabaseConfig.client
          .from(tableName)
          .update({
            deletedAtField: DateTime.now().toUtc().toIso8601String(),
            updatedAtField: DateTime.now().toUtc().toIso8601String(),
          })
          .eq(idField, id);
    } catch (e) {
      throw Exception('Failed to soft delete from $tableName: $e');
    }
  }

  /// Safe execution wrapper with consistent error handling
  Future<T> safeExecute<T>(
    Future<T> Function() operation, {
    required String operationName,
    required String tableName,
    String? recordId,
  }) async {
    try {
      if (kDebugMode) {
        print('$operationName on $tableName${recordId != null ? ' (id: $recordId)' : ''}');
      }
      return await operation();
    } catch (e) {
      final errorMessage = 'Failed to $operationName on $tableName: $e';
      if (kDebugMode) {
        print(errorMessage);
      }
      throw Exception(errorMessage);
    }
  }

  /// Helper to build current timestamp for inserts/updates
  String getCurrentTimestamp() {
    return DateTime.now().toUtc().toIso8601String();
  }

  /// Helper to check if a field should be included in update/insert
  bool shouldIncludeField(dynamic value) {
    if (value == null) return false;
    if (value is String && value.isEmpty) return false;
    return true;
  }

  /// Build data map with only non-null, non-empty values
  Map<String, dynamic> buildDataMap(Map<String, dynamic> fields) {
    final data = <String, dynamic>{};
    fields.forEach((key, value) {
      if (shouldIncludeField(value)) {
        data[key] = value;
      }
    });
    return data;
  }

  /// Convert DateTime to UTC milliseconds for domain models
  int dateTimeToUtcMs(DateTime dateTime) {
    return dateTime.toUtc().millisecondsSinceEpoch;
  }

  /// Convert UTC milliseconds to DateTime
  DateTime utcMsToDateTime(int milliseconds) {
    return DateTime.fromMillisecondsSinceEpoch(milliseconds).toUtc();
  }

  /// Get current authenticated user ID
  String? getCurrentUserId() {
    return SupabaseConfig.client.auth.currentUser?.id;
  }

  /// Validate required fields before operations
  void validateRequiredFields(Map<String, dynamic> fields, List<String> requiredFields) {
    for (final field in requiredFields) {
      if (!shouldIncludeField(fields[field])) {
        throw ArgumentError('Required field $field is missing or empty');
      }
    }
  }
}

/// Custom exception for repository operations
class RepositoryException implements Exception {
  final String message;
  final dynamic originalException;

  const RepositoryException(this.message, [this.originalException]);

  @override
  String toString() {
    if (originalException != null) {
      return 'RepositoryException: $message\nCaused by: $originalException';
    }
    return 'RepositoryException: $message';
  }
}