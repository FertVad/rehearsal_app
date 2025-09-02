import 'dart:ui';
import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

enum GlassStyle { light, dark, accent }

enum GlassSize { small, medium, large }

class AppGlass extends StatelessWidget {
  const AppGlass({
    super.key,
    required this.child,
    this.style = GlassStyle.light,
    this.size = GlassSize.medium,
    this.padding,
    this.onTap,
  });

  final Widget child;
  final GlassStyle style;
  final GlassSize size;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final config = _getConfig();
    final brightness = Theme.of(context).brightness;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(config.radius),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: config.blurIntensity,
            sigmaY: config.blurIntensity,
          ),
          child: Container(
            padding: padding ?? config.defaultPadding,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(config.radius),
              color: _getBackgroundColor(brightness),
              gradient: _getGradient(brightness),
              border: Border.all(
                color: _getBorderColor(brightness),
                width: config.borderWidth,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }

  _GlassConfig _getConfig() {
    switch (size) {
      case GlassSize.small:
        return const _GlassConfig(
          radius: AppSpacing.radiusMD,
          blurIntensity: 15,
          borderWidth: 0.8,
          defaultPadding: AppSpacing.glassSmall,
        );
      case GlassSize.medium:
        return const _GlassConfig(
          radius: AppSpacing.radiusLG,
          blurIntensity: 20,
          borderWidth: 1.0,
          defaultPadding: AppSpacing.glassMedium,
        );
      case GlassSize.large:
        return const _GlassConfig(
          radius: AppSpacing.radiusXL,
          blurIntensity: 25,
          borderWidth: 1.2,
          defaultPadding: AppSpacing.glassLarge,
        );
    }
  }

  // === Palette ===

  // Полупрозрачная подложка (light/dark/акцент)
  Color _getBackgroundColor(Brightness brightness) {
    switch (style) {
      case GlassStyle.light:
        // Белое матовое стекло
        return Colors.white.withValues(alpha: 0.22);
      case GlassStyle.dark:
        // Дымчатое стекло для дарка
        return const Color(0xFF0B0B0B).withValues(alpha: 0.32);
      case GlassStyle.accent:
        // Едва заметная подсветка акцентным
        return AppColors.accentHotPink.withValues(alpha: 0.10);
    }
  }

  // Лёгкие блики/перетекание (liquid glass)
  Gradient? _getGradient(Brightness brightness) {
    switch (style) {
      case GlassStyle.light:
        // сверху мягкий хайлайт, к низу — лёгкая дымка
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.0, 0.35, 0.65, 1.0],
          colors: [
            Colors.white.withValues(alpha: 0.20),
            Colors.white.withValues(alpha: 0.06),
            Colors.white.withValues(alpha: 0.04),
            Colors.white.withValues(alpha: 0.14),
          ],
        );
      case GlassStyle.dark:
        // немного менее заметные хайлайты
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.0, 0.4, 1.0],
          colors: [
            Colors.white.withValues(alpha: 0.10),
            Colors.white.withValues(alpha: 0.04),
            Colors.white.withValues(alpha: 0.12),
          ],
        );
      case GlassStyle.accent:
        // лёгкий диагональный «свет» в сторону акцентного
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0.0, 1.0],
          colors: [
            AppColors.accentHotPink.withValues(alpha: 0.16),
            AppColors.accentHotPink.withValues(alpha: 0.04),
          ],
        );
    }
  }

  // Обводка (тонкая, под тему)
  Color _getBorderColor(Brightness brightness) {
    switch (style) {
      case GlassStyle.light:
        return Colors.white.withValues(alpha: 0.28);
      case GlassStyle.dark:
        return Colors.white.withValues(alpha: 0.18);
      case GlassStyle.accent:
        // акцентная обводка чуть заметней
        return AppColors.accentHotPink.withValues(alpha: 0.30);
    }
  }
}

class _GlassConfig {
  const _GlassConfig({
    required this.radius,
    required this.blurIntensity,
    required this.borderWidth,
    required this.defaultPadding,
  });

  final double radius;
  final double blurIntensity;
  final double borderWidth;
  final EdgeInsetsGeometry defaultPadding;
}

// Готовые компоненты

class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.onTap,
    this.size = GlassSize.medium,
    this.style = GlassStyle.light,
    this.padding,
  });

  final Widget child;
  final VoidCallback? onTap;
  final GlassSize size;
  final GlassStyle style;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return AppGlass(
      style: style,
      size: size,
      padding: padding,
      onTap: onTap,
      child: child,
    );
  }
}

class GlassButton extends StatelessWidget {
  const GlassButton({
    super.key,
    required this.child,
    required this.onTap,
    this.selected = false,
    this.size = GlassSize.small,
  });

  final Widget child;
  final VoidCallback onTap;
  final bool selected;
  final GlassSize size;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark
        ? Colors.white.withValues(alpha: 0.95)
        : Colors.black.withValues(alpha: 0.85);
    return AppGlass(
      style: selected ? GlassStyle.accent : GlassStyle.light,
      size: size,
      onTap: onTap,
      child: DefaultTextStyle.merge(
        style: TextStyle(color: textColor),
        child: child,
      ),
    );
  }
}

/// Компактный стеклянный чип для выбора опций.
/// Похож на GlassButton, но меньше и с фиксированным размером.
class GlassChip extends StatelessWidget {
  const GlassChip({
    super.key,
    required this.label,
    required this.onTap,
    this.selected = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = selected
        ? (isDark ? Colors.white : Colors.white.withValues(alpha: 0.95))
        : (isDark
            ? Colors.white.withValues(alpha: 0.70)
            : Colors.black.withValues(alpha: 0.60));

    return SizedBox(
      height: 32, // Фиксированная высота для чипов
      child: AppGlass(
        style: selected ? GlassStyle.accent : GlassStyle.light,
        size: GlassSize.small,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        onTap: onTap,
        child: Center(
          child: Text(
            label,
            style: AppTypography.label.copyWith(
              color: textColor,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}

class GlassPanel extends StatelessWidget {
  const GlassPanel({
    super.key,
    required this.child,
    this.style = GlassStyle.light,
    this.size = GlassSize.medium,
    this.padding,
    this.onTap,
  });

  final Widget child;
  final GlassStyle style;
  final GlassSize size;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppGlass(
      style: style,
      size: size,
      padding: padding,
      onTap: onTap,
      child: child,
    );
  }
}

class GlassBackground extends StatelessWidget {
  const GlassBackground({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.primaryPurple,
                AppColors.primaryPink,
                AppColors.primaryCyan,
              ],
              stops: [0.0, 0.55, 1.0],
            ),
          ),
        ),
        IgnorePointer(child: CustomPaint(painter: _GlassBackgroundBlobPainter())),
        if (padding != null)
          Padding(padding: padding!, child: child)
        else
          child,
      ],
    );
  }
}

class _GlassBackgroundBlobPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..isAntiAlias = true;

    paint.shader = RadialGradient(
      colors: [
        AppColors.white,
        AppColors.white.withValues(alpha: 0.0),
      ],
      stops: const [0.0, 1.0],
    ).createShader(
      Rect.fromCircle(
        center: Offset(size.width * 0.15, size.height * 0.0),
        radius: size.width * 0.7,
      ),
    );
    canvas.drawCircle(
      Offset(size.width * 0.15, size.height * 0.0),
      size.width * 0.65,
      paint,
    );

    paint.shader = RadialGradient(
      colors: [
        AppColors.primaryCyan.withValues(alpha: 0.8),
        AppColors.primaryCyan.withValues(alpha: 0.0),
      ],
      stops: const [0.0, 1.0],
    ).createShader(
      Rect.fromCircle(
        center: Offset(size.width * 0.85, size.height * 0.95),
        radius: size.width * 0.75,
      ),
    );
    canvas.drawCircle(
      Offset(size.width * 0.85, size.height * 0.95),
      size.width * 0.7,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
