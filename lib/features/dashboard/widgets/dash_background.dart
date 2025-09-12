import 'package:flutter/material.dart';

/// Dashboard-specific background with solid graphite color.
class DashBackground extends StatelessWidget {
  const DashBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF2C2C2E), // Graphite color
      ),
      child: child,
    );
  }
}
