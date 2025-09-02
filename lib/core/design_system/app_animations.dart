import 'package:flutter/material.dart';

/// Унифицированные настройки анимаций приложения.
final class AppAnimations {
  AppAnimations._();

  // === Длительности ===
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 350);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration verySlow = Duration(milliseconds: 800);

  // === Кривые ===
  static const Curve ease = Curves.easeInOut;
  static const Curve easeOut = Curves.easeOut;
  static const Curve bounce = Curves.bounceOut;
  static const Curve elastic = Curves.elasticOut;
  static const Curve spring = Curves.fastLinearToSlowEaseIn;

  // === Готовые переходы ===
  
  /// Плавное появление/исчезновение
  static Widget fadeTransition({
    required Widget child,
    required Animation<double> animation,
  }) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }

  /// Масштабирование с затуханием
  static Widget scaleTransition({
    required Widget child,
    required Animation<double> animation,
  }) {
    return ScaleTransition(
      scale: animation,
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }

  /// Слайд снизу
  static Widget slideFromBottomTransition({
    required Widget child,
    required Animation<double> animation,
  }) {
    final tween = Tween(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    );
    return SlideTransition(
      position: animation.drive(tween),
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }
}
