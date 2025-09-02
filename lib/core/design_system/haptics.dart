import 'dart:async';
import 'package:flutter/services.dart';

/// Унифицированные тактильные эффекты с мягким троттлингом,
/// чтобы не «звенеть» при быстрой прокрутке.
final class Haptics {
  Haptics._();

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

  /// Ненавязчивый импакт для действий/кнопок
  static Future<void> light() async {
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

  /// Совместимость со старым API
  static Future<void> success() async => light();
}

// Backward-compat alias
typedef AppHaptics = Haptics;
