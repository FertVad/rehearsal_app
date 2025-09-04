import 'package:flutter/material.dart';
import 'package:rehearsal_app/core/design_system/glass_system.dart' as ds;

/// Dashboard-specific background using the app's glass design system.
class DashBackground extends StatelessWidget {
  const DashBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ds.GlassBackground(child: child);
  }
}

