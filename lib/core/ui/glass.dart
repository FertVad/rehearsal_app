import 'dart:ui';
import 'package:flutter/material.dart';

/// A reusable frosted "liquid glass" container used across the app.
///
/// Features:
/// - Backdrop blur of the content behind it
/// - Subtle translucent gradient fill
/// - Thin white border to simulate glass rim
/// - Optional padding/constraints/child
class Glass extends StatelessWidget {
  const Glass({
    super.key,
    this.child,
    this.padding,
    this.constraints,
    this.borderRadius = const BorderRadius.all(Radius.circular(28)),
    this.blur = 20,
    this.borderOpacity = 0.35,
    this.backgroundOpacity = 0.18,
    this.gradient,
  });

  /// Child placed inside the glass surface.
  final Widget? child;

  /// Inner padding for [child].
  final EdgeInsetsGeometry? padding;

  /// Optional constraints for the container.
  final BoxConstraints? constraints;

  /// Corner radius of the glass surface.
  final BorderRadius borderRadius;

  /// Backdrop blur amount (sigmaX/Y).
  final double blur;

  /// Opacity for the thin white border.
  final double borderOpacity;

  /// Overall base opacity for the gradient background.
  final double backgroundOpacity;

  /// Optional override of the default subtle gradient.
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Subtle light gradient that works on both light/dark themes.
    final defaultGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Colors.white.withValues(alpha: backgroundOpacity * 0.9),
        (theme.colorScheme.surfaceTint).withValues(
          alpha: backgroundOpacity * 0.5,
        ),
        Colors.white.withValues(alpha: backgroundOpacity * 0.6),
      ],
      stops: const [0.05, 0.55, 1.0],
    );

    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: gradient ?? defaultGradient,
            border: Border.all(
              color: Colors.white.withValues(alpha: borderOpacity),
            ),
          ),
          child: ConstrainedBox(
            constraints: constraints ?? const BoxConstraints(),
            child: Padding(
              padding: padding ?? const EdgeInsets.all(16),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

/// A convenience pre-styled card with common paddings used for widgets
/// like the weekly calendar header.
class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    this.borderRadius = const BorderRadius.all(Radius.circular(28)),
  });

  final Widget? child;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return Glass(padding: padding, borderRadius: borderRadius, child: child);
  }
}
