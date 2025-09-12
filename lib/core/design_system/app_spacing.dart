import 'package:flutter/widgets.dart';

/// Единая шкала отступов, радиусов и размеров для всего приложения.
final class AppSpacing {
  AppSpacing._();

  // === Базовая единица ===
  static const double unit = 4.0;

  // === Шкала отступов ===
  static const double xs = unit; // 4
  static const double sm = unit * 2; // 8
  static const double md = unit * 3; // 12
  static const double lg = unit * 4; // 16
  static const double xl = unit * 5; // 20
  static const double xxl = unit * 6; // 24
  static const double xxxl = unit * 8; // 32

  // === Паддинги ===
  static const EdgeInsets paddingXS = EdgeInsets.all(xs);
  static const EdgeInsets paddingSM = EdgeInsets.all(sm);
  static const EdgeInsets paddingMD = EdgeInsets.all(md);
  static const EdgeInsets paddingLG = EdgeInsets.all(lg);
  static const EdgeInsets paddingXL = EdgeInsets.all(xl);
  static const EdgeInsets paddingXXL = EdgeInsets.all(xxl);

  // === Радиусы ===
  static const double radiusXS = unit * 2; // 8
  static const double radiusSM = unit * 3; // 12
  static const double radiusMD = unit * 4; // 16
  static const double radiusLG = unit * 6; // 24
  static const double radiusXL = unit * 8; // 32

  // === Размеры интерактивных элементов ===
  static const double buttonHeight = 44.0;
  static const double iconSize = 24.0;
  static const double avatarSize = 32.0;
  static const double calendarCell = 48.0;

  // === Специфичные паддинги для стеклянных компонентов ===
  static const EdgeInsets glassSmall = EdgeInsets.all(sm);
  static const EdgeInsets glassMedium = EdgeInsets.all(lg);
  static const EdgeInsets glassLarge = EdgeInsets.all(xxl);
}
