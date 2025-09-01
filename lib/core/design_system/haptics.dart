import 'dart:async';
import 'package:flutter/services.dart';

/// Унифицированные тактильные эффекты с мягким троттлингом,
/// чтобы не «звенеть» при быстрой прокрутке.
final class AppHaptics {
  AppHaptics._();

  static DateTime _last = DateTime.fromMillisecondsSinceEpoch(0);
  static const _minGap = Duration(milliseconds: 40); // ~25 Hz максимум

  static bool _canFire() {
    final now = DateTime.now();
    if (now.difference(_last) >= _minGap) {
      _last = now;
      return true;
    }
    return false;
  }

  /// Лёгкая отдача для выбора/скролла по дням
  static Future<void> selection() async {
    if (_canFire()) {
      await HapticFeedback.selectionClick();
    }
  }

  /// Чёткий «успех»
  static Future<void> success() async {
    if (_canFire()) {
      await HapticFeedback.lightImpact();
    }
  }

  /// Более ощутимый «ошибка/стук»
  static Future<void> error() async {
    if (_canFire()) {
      await HapticFeedback.heavyImpact();
    }
  }
}
