import 'dart:async';
import 'package:flutter/services.dart';

/// Lightweight haptics helper with built‑in rate limiting.
///
/// Usage:
///   Haptics.selection();
///   Haptics.impact();
///   Haptics.light(); // alias for subtle feedback
///
/// To avoid spamming during fast scroll (e.g., DayScroller), all public
/// methods are throttled by [minGap]. You can override per call.
class Haptics {
  Haptics._();

  /// Minimal gap between haptic triggers to prevent spam.
  static Duration minGap = const Duration(milliseconds: 35);

  static DateTime? _last;
  static bool _canFire([Duration? gap]) {
    final g = gap ?? minGap;
    final now = DateTime.now();
    if (_last == null || now.difference(_last!) >= g) {
      _last = now;
      return true;
    }
    return false;
  }

  /// iOS/Android friendly selection click (very light tick).
  static Future<void> selection({Duration? gap}) async {
    if (!_canFire(gap)) return;
    try {
      await HapticFeedback.selectionClick();
    } catch (_) {
      // no-op on platforms that don't support haptics
    }
  }

  /// Subtle impact (alias for light vibration on Android).
  static Future<void> light({Duration? gap}) async {
    if (!_canFire(gap)) return;
    try {
      // On iOS, this maps to light impact; on Android it's a short vibration.
      await HapticFeedback.lightImpact();
    } catch (_) {}
  }

  /// Medium impact.
  static Future<void> medium({Duration? gap}) async {
    if (!_canFire(gap)) return;
    try {
      await HapticFeedback.mediumImpact();
    } catch (_) {}
  }

  /// Strong impact.
  static Future<void> heavy({Duration? gap}) async {
    if (!_canFire(gap)) return;
    try {
      await HapticFeedback.heavyImpact();
    } catch (_) {}
  }

  /// Higher energy impact (iOS 13+ maps to rigid; gracefully degrades).
  static Future<void> impact({Duration? gap}) async {
    if (!_canFire(gap)) return;
    try {
      await HapticFeedback.heavyImpact();
    } catch (_) {}
  }
}

/// Convenience enum if you want to switch on type elsewhere.
enum HapticType { selection, light, medium, heavy, impact }

Future<void> triggerHaptic(HapticType type, {Duration? gap}) async {
  switch (type) {
    case HapticType.selection:
      return Haptics.selection(gap: gap);
    case HapticType.light:
      return Haptics.light(gap: gap);
    case HapticType.medium:
      return Haptics.medium(gap: gap);
    case HapticType.heavy:
      return Haptics.heavy(gap: gap);
    case HapticType.impact:
      return Haptics.impact(gap: gap);
  }
}
