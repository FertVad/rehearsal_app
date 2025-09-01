import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:rehearsal_app/core/design_system/haptics.dart';

/// A glassy, horizontally scrollable strip of days with:
///  • centered month label (updates as you scroll)
///  • one-day snapping with haptics hook (provided via [onHaptic])
///  • droplets with day number, weekday label, and optional event dot
///
/// This widget is self-contained (draws its own glass panel). Width/height and
/// radius are configurable so you can reuse anywhere on the dashboard.
class DayScroller extends StatefulWidget {
  const DayScroller({
    super.key,
    this.initialDate,
    this.onDateChanged,
    this.eventPredicate,
    this.onHaptic,
    this.width = 388,
    this.height = 120,
    this.radius = 32,
    this.visibleItems = 7,
    this.backgroundBrightness = Brightness.light,
  });

  /// If null, defaults to DateTime.now().
  final DateTime? initialDate;

  /// Called when the centered day changes after a snap.
  final ValueChanged<DateTime>? onDateChanged;

  /// Return true if a small event dot should be shown for the date.
  final bool Function(DateTime date)? eventPredicate;

  /// Optional haptics trigger; called once per day change.
  final VoidCallback? onHaptic;

  /// Panel size & rounding.
  final double width;
  final double height;
  final double radius;

  /// How many day items roughly visible at once (affects item width/viewportFraction).
  final int visibleItems;

  /// Influences glass tint (light = whitey glass, dark = smokey glass).
  final Brightness backgroundBrightness;

  @override
  State<DayScroller> createState() => _DayScrollerState();
}

class _DayScrollerState extends State<DayScroller> {
  static const int _anchor =
      10000; // large center to allow scrolling in both directions
  late PageController _controller;
  late int _currentIndex; // absolute page index

  // cache of currently selected date (normalized to date-only)
  late DateTime _selected;

  @override
  void initState() {
    super.initState();
    _selected = _stripTime(widget.initialDate ?? DateTime.now());
    _currentIndex = _anchor;
    _controller = PageController(
      initialPage: _currentIndex,
      viewportFraction: _viewportFractionFor(widget.width, widget.visibleItems),
    );
  }

  @override
  void didUpdateWidget(covariant DayScroller oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If size or visibleItems change, we need to rebuild controller to keep snapping crisp
    if (oldWidget.width != widget.width ||
        oldWidget.visibleItems != widget.visibleItems) {
      final oldPage = _controller.page ?? _currentIndex.toDouble();
      _controller.dispose();
      _controller = PageController(
        initialPage: oldPage.round(),
        viewportFraction: _viewportFractionFor(
          widget.width,
          widget.visibleItems,
        ),
      );
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // maps an absolute page index to a calendar date, with _anchor == _selected
  DateTime _dateForIndex(int index) =>
      _selected.add(Duration(days: index - _currentIndex));

  static DateTime _stripTime(DateTime dt) =>
      DateTime(dt.year, dt.month, dt.day);

  static double _viewportFractionFor(double width, int visibleItems) {
    final itemWidth = math.max(
      48.0,
      (width - 24) / visibleItems,
    ); // leave some padding for edges
    return itemWidth / width;
  }

  String _monthTitle(DateTime d) {
    // Use built-in month names (en) to avoid intl dependency for now.
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[d.month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final radius = Radius.circular(widget.radius);
    final isLight = widget.backgroundBrightness == Brightness.light;
    final textColor =
        isLight ? const Color(0xFF111111) : Colors.white; // near-black on light
    final strokeColor = isLight ? const Color(0xFF111111) : Colors.white;

    // glass palette tuned for “liquid glass” look
    final baseFill = isLight
        ? const Color(0x66FFFFFF)
        : const Color(0x661D1D1D);
    final stroke = isLight
        ? Colors.white.withValues(alpha: 0.12)
        : Colors.white.withValues(alpha: 0.08);

    return ClipRRect(
      borderRadius: BorderRadius.all(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(radius),
            color: baseFill, // semi-translucent fill
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0.0, 0.35, 0.65, 1.0],
              colors: [
                const Color(0x33FFFFFF),
                const Color(0x11FFFFFF),
                const Color(0x0FFFFFFF),
                const Color(0x26FFFFFF),
              ],
            ),
            border: Border.all(color: stroke, width: 0.8),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Stack(
              children: [
                // Centered month title
                Align(
                  alignment: Alignment.topCenter,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder: (child, animation) =>
                        FadeTransition(opacity: animation, child: child),
                    child: _MonthText(
                      key: ValueKey(_monthTitle(_selected)),
                      title: _monthTitle(_selected),
                      color: textColor,
                    ),
                  ),
                ),

                // Day scroller (droplets)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    height: widget.height - 40,
                    child: PageView.builder(
                      controller: _controller,
                      scrollDirection: Axis.horizontal,
                      padEnds: false,
                      onPageChanged: (index) {
                        final newDate = _dateForIndex(index);
                        // Fire haptics once per day change
                        if (_selected != newDate) {
                          AppHaptics.selection();
                          widget.onHaptic?.call();
                        }
                        setState(() => _selected = newDate);
                        widget.onDateChanged?.call(newDate);
                      },
                      itemBuilder: (context, index) {
                        final date = _dateForIndex(index);
                        final bool isSelected =
                            _stripTime(date) == _stripTime(_selected);
                        final bool hasEvent =
                            widget.eventPredicate?.call(date) ?? false;
                        return Center(
                          child: _DayDroplet(
                            date: date,
                            selected: isSelected,
                            hasEvent: hasEvent,
                            textColor: textColor,
                            strokeColor: strokeColor,
                            isLightBackground: isLight,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MonthText extends StatelessWidget {
  const _MonthText({super.key, required this.title, required this.color});
  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        // iOS vibe: SF Pro Light–ish
        fontSize: 16,
        fontWeight: FontWeight.w300,
        letterSpacing: 0.3,
        color: color,
      ),
    );
  }
}

class _DayDroplet extends StatelessWidget {
  const _DayDroplet({
    required this.date,
    required this.selected,
    required this.hasEvent,
    required this.textColor,
    required this.strokeColor,
    required this.isLightBackground,
  });

  final DateTime date;
  final bool selected;
  final bool hasEvent;
  final Color textColor;
  final Color strokeColor;
  final bool isLightBackground;

  String get _weekdayShort {
    const map = {
      DateTime.monday: 'Mon',
      DateTime.tuesday: 'Tue',
      DateTime.wednesday: 'Wed',
      DateTime.thursday: 'Thu',
      DateTime.friday: 'Fri',
      DateTime.saturday: 'Sat',
      DateTime.sunday: 'Sun',
    };
    return map[date.weekday] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final Color baseStroke = strokeColor.withValues(
      alpha: selected ? 0.35 : 0.18,
    );
    final Color numeral = textColor;

    return SizedBox(
      width: 52,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Weekday label
          Opacity(
            opacity: 0.7,
            child: Text(
              _weekdayShort,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w300,
                color: textColor,
              ),
            ),
          ),
          const SizedBox(height: 6),

          // Droplet shape with number inside
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: baseStroke, width: 1),
              gradient: selected
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isLightBackground
                          ? [
                              const Color(0x22000000),
                              const Color(0x0F000000),
                            ]
                          : [
                              const Color(0x22FFFFFF),
                              const Color(0x0FFFFFFF),
                            ],
                    )
                  : null,
            ),
            child: Center(
              child: Text(
                '${date.day}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: numeral,
                ),
              ),
            ),
          ),

          const SizedBox(height: 4),

          // Event dot
          AnimatedOpacity(
            duration: const Duration(milliseconds: 180),
            opacity: hasEvent ? 1.0 : 0.0,
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
}
