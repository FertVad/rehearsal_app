import 'dart:ui';
import 'package:flutter/material.dart';

/// iOS26-style "liquid glass" panel with light/dark tones.
/// Default tone is **light** (milky/translucent) as in the Figma mock.
class LiquidGlassPanel extends StatelessWidget {
  const LiquidGlassPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    this.borderRadiusPx = 32,
    this.intensity = 24,
    this.opacity = 1.0,
    this.tone = LiquidGlassTone.light,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadiusPx;
  final double intensity;
  final double opacity;
  final LiquidGlassTone tone;

  @override
  Widget build(BuildContext context) {
    final r = BorderRadius.circular(borderRadiusPx);

    // Palette switches between light (milky) and dark glass.
    final bool isLight = tone == LiquidGlassTone.light;
    final double k = opacity.clamp(0.0, 1.0);

    // Subtle milky/graphite base; very low alpha so the blur carries the look.
    // Alphas are multiplied by the user-provided `opacity` knob.
    final Color baseFill = isLight
        ? Colors.white.withValues(alpha: 0.04 * k)
        : Colors.black.withValues(alpha: 0.05 * k);

    // Top gloss
    final List<Color> topGradientColors = isLight
        ? [
            Colors.white.withValues(alpha: 0.42), // brighter top gloss
            Colors.white.withValues(alpha: 0.00),
          ]
        : const [
            Color.fromRGBO(102, 102, 102, 0.20),
            Color.fromRGBO(102, 102, 102, 0.00),
          ];

    // Bottom shade
    final List<Color> bottomGradientColors = isLight
        ? [
            Colors.white.withValues(alpha: 0.00),
            Colors.white.withValues(alpha: 0.00),
            Colors.white.withValues(alpha: 0.28), // soft milky rim at bottom
          ]
        : const [
            Color.fromRGBO(102, 102, 102, 0.00),
            Color.fromRGBO(102, 102, 102, 0.00),
            Color.fromRGBO(102, 102, 102, 0.40),
          ];

    // Mid overlay tint (imitates color-burn/plus-lighter stacks from CSS)
    final Color overlayTint = isLight
        ? Colors.white.withValues(alpha: 0.05 * k)
        : Colors.white.withValues(alpha: 0.02 * k);

    // Inner glow and border for the rim lighting
    final Color rimColor = isLight
        ? Colors.white.withValues(alpha: 0.55)
        : Colors.white.withValues(alpha: 0.10);

    return ClipRRect(
      borderRadius: r,
      child: Stack(
        children: [
          // 1) Frosted blur
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: intensity, sigmaY: intensity),
              child: const SizedBox.expand(),
            ),
          ),

          // 2) Base fill
          Positioned.fill(
            child: DecoratedBox(decoration: BoxDecoration(color: baseFill)),
          ),

          // 3) Top gloss gradient
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.0, 0.35],
                  colors: topGradientColors,
                ),
              ),
            ),
          ),

          // 3b) Top edge highlight band
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            height: 2,
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withValues(alpha: 0.60),
                      Colors.white.withValues(alpha: 0.00),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // 4) Bottom shade gradient
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.0, 0.55, 1.0],
                  colors: bottomGradientColors,
                ),
              ),
            ),
          ),

          // 5) Overlay tint
          Positioned.fill(
            child: DecoratedBox(decoration: BoxDecoration(color: overlayTint)),
          ),

          // 6) Soft inner glow (approx of inner shadows)
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(-0.35, -0.45),
                  radius: 1.0,
                  colors: [rimColor, Colors.transparent],
                ),
              ),
            ),
          ),

          // 7) Subtle edge/light rim
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: r,
                  border: Border.all(color: rimColor, width: 0.8),
                ),
              ),
            ),
          ),

          // 8) Content
          Positioned.fill(
            child: Padding(padding: padding, child: child),
          ),
        ],
      ),
    );
  }
}

enum LiquidGlassTone { light, dark }
