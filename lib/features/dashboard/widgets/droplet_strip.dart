import 'dart:ui';

import 'package:flutter/material.dart';

/// A horizontally scrollable strip of "liquid glass" day droplets
/// with weekday labels above. Intended to sit under the weekly header.
///
/// Usage:
/// ```dart
/// DropletStrip(
///   start: currentWeekStart, // typically Monday of the visible week
///   days: 14,                // how many days to show (defaults to 7)
///   selected: DateTime.now(),
///   eventPredicate: (day) => {...}, // optional
///   onSelect: (day) { ... },
/// )
/// ```
class DropletStrip extends StatelessWidget {
  const DropletStrip({
    super.key,
    required this.start,
    this.days = 7,
    this.selected,
    this.onSelect,
    this.eventPredicate,
  });

  /// First day shown in the strip (e.g., Monday). Time-of-day is ignored.
  final DateTime start;

  /// Number of consecutive days to render.
  final int days;

  /// Currently selected day (for highlight). Date part only matters.
  final DateTime? selected;

  /// Tap callback.
  final ValueChanged<DateTime>? onSelect;

  /// Optional marker: return true to show a small dot under the droplet.
  final bool Function(DateTime day)? eventPredicate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    final textColor = brightness == Brightness.dark
        ? Colors.white.withValues(alpha: 0.85)
        : const Color(0xFF0B0B0B).withValues(alpha: 0.85);

    return SizedBox(
      height: 72, // 49px spec + paddings
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: List.generate(days, (index) {
            final day = DateTime(start.year, start.month, start.day + index);
            final isSelected = selected != null && _isSameDate(day, selected!);
            final hasEvent = eventPredicate?.call(day) ?? false;
            return _DropletDay(
              day: day,
              isSelected: isSelected,
              hasEvent: hasEvent,
              textColor: textColor,
              onTap: () => onSelect?.call(day),
            );
          }),
        ),
      ),
    );
  }

  bool _isSameDate(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

class _DropletDay extends StatelessWidget {
  const _DropletDay({
    required this.day,
    required this.isSelected,
    required this.hasEvent,
    required this.textColor,
    required this.onTap,
  });

  final DateTime day;
  final bool isSelected;
  final bool hasEvent;
  final Color textColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final weekday = _weekdayShort(day);
    final number = day.day.toString();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            weekday,
            style: TextStyle(
              fontFamily: 'SF Pro',
              fontWeight: FontWeight.w400,
              fontSize: 10,
              color: textColor.withValues(alpha: 0.6),
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 6),
          _LiquidDroplet(
            selected: isSelected,
            onTap: onTap,
            child: Center(
              child: Text(
                number,
                style: TextStyle(
                  fontFamily: 'SF Pro',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: textColor,
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          AnimatedOpacity(
            opacity: hasEvent ? 1 : 0,
            duration: const Duration(milliseconds: 180),
            child: Container(
              width: 4,
              height: 4,
              decoration: const BoxDecoration(
                color: Color(0xFFFF1493),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _weekdayShort(DateTime d) {
    // Mon, Tue, ... (in English for now; hook into l10n later)
    const names = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    // DateTime.weekday: 1=Mon..7=Sun
    return names[d.weekday - 1];
  }
}

/// A small circular glassy capsule that adapts to brightness and supports a
/// subtle "liquid glass" look. Size is fixed to 32x32 to match the spec.
class _LiquidDroplet extends StatelessWidget {
  const _LiquidDroplet({
    required this.child,
    required this.selected,
    required this.onTap,
  });

  final Widget child;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Base fill uses different alphas in light/dark to keep true transparency
    final base = isDark
        ? const Color(0xFF0B0B0B).withValues(alpha: 0.35)
        : const Color(0xFFFFFFFF).withValues(alpha: 0.30);

    final border = isDark
        ? Colors.white.withValues(alpha: selected ? 0.30 : 0.20)
        : Colors.black.withValues(alpha: selected ? 0.12 : 0.10);

    final highlightA = Colors.white.withValues(alpha: 0.08);
    final highlightB = Colors.white.withValues(alpha: 0.03);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: base,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [highlightA, highlightB],
              ),
              border: Border.all(width: selected ? 1.2 : 1.0, color: border),
              // Soft inner-ish glow imitation
              boxShadow: [
                if (selected)
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.10),
                    blurRadius: 10,
                    spreadRadius: 0,
                    offset: const Offset(0, 0),
                  ),
              ],
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
