import 'package:flutter/material.dart';

/// \u0423\u043d\u0438\u0444\u0438\u0446\u0438\u0440\u043e\u0432\u0430\u043d\u043d\u0430\u044f \u043f\u0430\u043b\u0438\u0442\u0440\u0430 \u043f\u0440\u0438\u043b\u043e\u0436\u0435\u043d\u0438\u044f.
/// \u0418\u0441\u043f\u043e\u043b\u044c\u0437\u0443\u0435\u043c \u043a\u043e\u043d\u0441\u0442\u0430\u043d\u0442\u044b, \u0447\u0442\u043e\u0431\u044b \u0438\u0437\u0431\u0435\u0436\u0430\u0442\u044c \u201c\u043c\u0430\u0433\u0438\u0447\u0435\u0441\u043a\u0438\u0445\u201d \u0437\u043d\u0430\u0447\u0435\u043d\u0438\u0439 \u043f\u043e \u043a\u043e\u0434\u0443.
final class AppColors {
  AppColors._();

  // === BRAND / ACCENT ===
  static const Color primaryPurple = Color(0xFF8D7BFF);
  static const Color primaryPink   = Color(0xFFF149B8);
  static const Color primaryCyan   = Color(0xFF3DE8E1);
  static const Color accentHotPink = Color(0xFFFF1493);

  // === NEUTRALS ===
  static const Color black = Color(0xFF0B0B0B);
  static const Color white = Color(0xFFFFFFFF);
  static const Color darkBase = black;

  // === TEXT (\u043f\u043e \u0443\u043c\u043e\u043b\u0447\u0430\u043d\u0438\u044e \u0434\u043b\u044f light) ===
  static final Color textPrimary        = black.withValues(alpha: 0.85);
  static final Color textSecondary      = black.withValues(alpha: 0.60);
  static final Color textTertiary       = black.withValues(alpha: 0.40);
  static final Color textOnGlassPrimary = white.withValues(alpha: 0.95);
  static final Color textOnGlassMuted   = white.withValues(alpha: 0.70);

  // === STATUS ===
  static const Color statusFree    = Color(0xFF4CAF50);
  static const Color statusBusy    = Color(0xFFF44336);
  static const Color statusPartial = Color(0xFFFF9800);

  // === GLASS BACKGROUNDS ===
  // \u0421\u0432\u0435\u0442\u043b\u043e\u0435 \u0441\u0442\u0435\u043a\u043b\u043e
  static final Color glassLightBase   = white.withValues(alpha: 0.25);
  static final Color glassLightTop    = white.withValues(alpha: 0.20);
  static final Color glassLightMid    = white.withValues(alpha: 0.07);
  static final Color glassLightBottom = white.withValues(alpha: 0.30);
  static final Color glassLightStroke = white.withValues(alpha: 0.30);

  // \u0422\u0451\u043c\u043d\u043e\u0435 \u0441\u0442\u0435\u043a\u043b\u043e
  static final Color glassDarkBase   = black.withValues(alpha: 0.35);
  static final Color glassDarkTop    = white.withValues(alpha: 0.08);
  static final Color glassDarkMid    = white.withValues(alpha: 0.04);
  static final Color glassDarkBottom = white.withValues(alpha: 0.18);
  static final Color glassDarkStroke = white.withValues(alpha: 0.18);

  // === GLASS OVERLAYS & BACKGROUNDS ===
  static final Color glassOverlayLight  = white.withValues(alpha: 0.22);
  static final Color glassOverlayDark   = black.withValues(alpha: 0.32);
  static final Color glassOverlayAccent = accentHotPink.withValues(alpha: 0.10);

  static const Color bgGradTop = primaryPurple;
  static const Color bgGradMid = primaryPink;
  static const Color bgGradBot = primaryCyan;

  static const Color bgBlobPrimary   = white;
  static const Color bgBlobSecondary = primaryCyan;

  static final Color glassAccentTop    = accentHotPink.withValues(alpha: 0.16);
  static final Color glassAccentBottom = accentHotPink.withValues(alpha: 0.04);
  static final Color glassAccentStroke = accentHotPink.withValues(alpha: 0.30);

  /// \u0423\u0442\u0438\u043b\u0438\u0442\u0430 \u0434\u043b\u044f \u0432\u044b\u0431\u043e\u0440\u0430 \u0446\u0432\u0435\u0442\u0430 \u0442\u0435\u043a\u0441\u0442\u0430 \u043f\u043e\u0432\u0435\u0440\u0445 \u0441\u0442\u0435\u043a\u043b\u0430.
  static Color onGlassText(Brightness b, {bool muted = false}) =>
      muted ? textOnGlassMuted : textOnGlassPrimary;

  /// \u0423\u0442\u0438\u043b\u0438\u0442\u0430 \u0434\u043b\u044f \u0432\u044b\u0431\u043e\u0440\u0430 \u0446\u0432\u0435\u0442\u0430 \u043e\u0431\u0432\u043e\u0434\u043a\u0438 \u0441\u0442\u0435\u043a\u043b\u0430.
  static Color glassStroke(Brightness b) =>
      b == Brightness.light ? glassLightStroke : glassDarkStroke;

  /// \u0411\u0430\u0437\u0430 \u0437\u0430\u043b\u0438\u0432\u043a\u0438 \u0441\u0442\u0435\u043a\u043b\u0430 (\u043f\u043e\u0434 \u0433\u0440\u0430\u0434\u0438\u0435\u043d\u0442).
  static Color glassBase(Brightness b) =>
      b == Brightness.light ? glassLightBase : glassDarkBase;

  /// \u0413\u0440\u0430\u0434\u0438\u0435\u043d\u0442\u043d\u044b\u0435 \u0441\u043b\u043e\u0438 \u0434\u043b\u044f \u0441\u0442\u0435\u043a\u043b\u0430 \u0441\u0432\u0435\u0440\u0445\u0443 \u2192 \u0432\u043d\u0438\u0437.
  static List<Color> glassStops(Brightness b) => b == Brightness.light
      ? [glassLightTop, glassLightMid, glassLightMid, glassLightBottom]
      : [glassDarkTop, glassDarkMid, glassDarkMid, glassDarkBottom];
}
