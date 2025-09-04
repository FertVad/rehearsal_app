import 'package:flutter/material.dart';

class AnimatedSwitcherWrapper extends StatelessWidget {
  const AnimatedSwitcherWrapper({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
  });

  final Widget child;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: animation.drive(
              Tween(begin: const Offset(0, 0.1), end: Offset.zero),
            ),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
