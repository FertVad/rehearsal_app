import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:rehearsal_app/core/design_system/app_colors.dart';
import 'package:rehearsal_app/core/design_system/app_spacing.dart';
import 'package:rehearsal_app/core/design_system/app_typography.dart';
import 'package:rehearsal_app/core/design_system/calendar_components.dart';
import 'package:rehearsal_app/core/utils/localization_helper.dart';

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
    this.selectedDate,
    this.onDateChanged,
    this.onDayTap,
    this.onDayLongPress,
    this.eventPredicate,
    this.onHaptic,
    this.width = 388,
    this.height = 120,
    this.radius = AppSpacing.radiusXL,
    this.visibleItems = 7,
    this.backgroundBrightness = Brightness.light,
  });

  /// If null, defaults to DateTime.now().
  final DateTime? initialDate;

  /// Externally controlled selected date. If null, no day is selected.
  final DateTime? selectedDate;

  /// Called when the centered day changes after a snap.
  /// NOTE: Currently not used, selection only happens on explicit taps.
  final ValueChanged<DateTime>? onDateChanged;

  /// Called when a day is tapped.
  final ValueChanged<DateTime>? onDayTap;

  /// Called when a day is long pressed.
  final ValueChanged<DateTime>? onDayLongPress;

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
  late DateTime _baseDate; // reference date for index 0
  late DateTime _selectedDate; // currently selected/centered date

  @override
  void initState() {
    super.initState();
    _selectedDate = _stripTime(widget.initialDate ?? DateTime.now());
    _baseDate = _selectedDate.subtract(Duration(days: _anchor));
    _controller = PageController(
      initialPage: _anchor,
      viewportFraction: _viewportFractionFor(widget.width, widget.visibleItems),
    );
  }

  @override
  void didUpdateWidget(covariant DayScroller oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If size or visibleItems change, we need to rebuild controller to keep snapping crisp
    if (oldWidget.width != widget.width ||
        oldWidget.visibleItems != widget.visibleItems) {
      final oldPage = _controller.page ?? _anchor.toDouble();
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

  // maps page index to calendar date
  DateTime _dateForIndex(int index) {
    return _baseDate.add(Duration(days: index));
  }

  static DateTime _stripTime(DateTime dt) =>
      DateTime(dt.year, dt.month, dt.day);

  static double _viewportFractionFor(double width, int visibleItems) {
    final itemWidth = math.max(
      AppSpacing.calendarCell,
      (width - AppSpacing.xxl) / visibleItems,
    ); // leave some padding for edges
    return itemWidth / width;
  }

  String _monthTitle(DateTime d, BuildContext context) {
    final months = LocalizationHelper.getMonthNames(context);
    return months[d.month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final radius = Radius.circular(widget.radius);
    final brightness = widget.backgroundBrightness;
    final textColor = AppColors.onGlassText(brightness);

    // glass palette from design tokens
    final baseFill = AppColors.glassBase(brightness);
    final stroke = AppColors.glassStroke(brightness);

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
              colors: AppColors.glassStops(brightness),
            ),
            border: Border.all(color: stroke, width: 0.8),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
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
                      key: ValueKey(_monthTitle(_selectedDate, context)),
                      title: _monthTitle(_selectedDate, context),
                      color: textColor,
                    ),
                  ),
                ),

                // Day scroller (droplets)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    height: widget.height - (AppSpacing.xxxl + AppSpacing.sm),
                    child: PageView.builder(
                      controller: _controller,
                      scrollDirection: Axis.horizontal,
                      padEnds: false,
                      onPageChanged: (index) {
                        final newDate = _dateForIndex(index);
                        // Обновляем только внутреннее состояние для центрирования
                        // НЕ вызываем onDateChanged автоматически при скролле
                        setState(() => _selectedDate = newDate);
                      },
                      itemBuilder: (context, index) {
                        final date = _dateForIndex(index);
                        final bool isSelected =
                            widget.selectedDate != null &&
                            _stripTime(date) ==
                                _stripTime(widget.selectedDate!);
                        final bool hasEvent =
                            widget.eventPredicate?.call(date) ?? false;
                        return Center(
                          child: SizedBox(
                            width: 52,
                            child: CalendarDayButton(
                              day: date,
                              isSelected: isSelected,
                              hasEvent: hasEvent,
                              size: 36,
                              onTap: widget.onDayTap != null
                                  ? () => widget.onDayTap!(date)
                                  : null,
                              onLongPress: widget.onDayLongPress != null
                                  ? () => widget.onDayLongPress!(date)
                                  : null,
                            ),
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
      style: AppTypography.calendarMonth.copyWith(color: color),
    );
  }
}
