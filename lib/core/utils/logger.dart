import 'package:flutter/foundation.dart';

class Logger {
  static const String _tag = 'RehearsalApp';

  static void debug(String message, {String? tag}) {
    if (kDebugMode) {
      print('🐛 ${tag ?? _tag}: $message');
    }
  }

  static void info(String message, {String? tag}) {
    if (kDebugMode) {
      print('ℹ️ ${tag ?? _tag}: $message');
    }
  }

  static void warning(String message, {String? tag}) {
    if (kDebugMode) {
      print('⚠️ ${tag ?? _tag}: $message');
    }
  }

  static void error(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (kDebugMode) {
      print('❌ ${tag ?? _tag}: $message');
      if (error != null) {
        print('Error details: $error');
      }
      if (stackTrace != null) {
        print('Stack trace: $stackTrace');
      }
    }
  }

  static void repository(
    String operation,
    String table, {
    String? recordId,
    Map<String, dynamic>? data,
  }) {
    if (kDebugMode) {
      final recordInfo = recordId != null ? ' (id: $recordId)' : '';
      final dataInfo = data != null ? '\nData: $data' : '';
      print('🔍 Repository: $operation on $table$recordInfo$dataInfo');
    }
  }

  static void auth(String message) {
    if (kDebugMode) {
      print('🔐 Auth: $message');
    }
  }

  static void navigation(String message) {
    if (kDebugMode) {
      print('🧭 Navigation: $message');
    }
  }
}
