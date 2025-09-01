import 'package:flutter/material.dart';

/// Liquid glass-like gradient background used on the Dashboard.
///
/// Wrap screen content with [DashBackground] to get the iOS‑style
/// vibrant gradient and soft blobs similar to the mock.
class DashBackground extends StatelessWidget {
  const DashBackground({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Base vertical gradient.
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF8D7BFF), // purple tint
                Color(0xFFF149B8), // pink
                Color(0xFF3DE8E1), // cyan
              ],
              stops: [0.0, 0.55, 1.0],
            ),
          ),
        ),

        // Big soft blobs to create a "liquid" feel.
        IgnorePointer(child: CustomPaint(painter: _BlobPainter())),

        // Foreground content.
        if (padding != null)
          Padding(padding: padding!, child: child)
        else
          child,
      ],
    );
  }
}

/// Paints two huge translucent blobs that curve into the screen.
class _BlobPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..isAntiAlias = true;

    // Top-left soft purple/white blob
    paint.shader =
        const RadialGradient(
          colors: [Color(0xFFFFFFFF), Color(0x00FFFFFF)],
          stops: [0.0, 1.0],
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

    // Bottom-right bright cyan blob
    paint.shader =
        const RadialGradient(
          colors: [
            Color(0xCC8DF9F6), // cyan with alpha
            Color(0x008DF9F6),
          ],
          stops: [0.0, 1.0],
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
