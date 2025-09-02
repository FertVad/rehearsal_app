import 'package:flutter/material.dart';
import 'package:rehearsal_app/core/design_system/app_spacing.dart';
import 'package:rehearsal_app/l10n/app.dart';

import 'day_sheet.dart';
import 'month_view.dart';
import 'week_view.dart';

/// Main calendar page with Month/Week tabs.
class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  DateTime _anchor = DateTime.now();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _openDay(DateTime date) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusXL),
        ),
      ),
      builder: (context) => DaySheet(date: date),
    );
  }

  void _next() {
    setState(() {
      if (_tabController.index == 0) {
        _anchor = DateTime(_anchor.year, _anchor.month + 1, 1);
      } else {
        _anchor = _anchor.add(const Duration(days: 7));
      }
    });
  }

  void _prev() {
    setState(() {
      if (_tabController.index == 0) {
        _anchor = DateTime(_anchor.year, _anchor.month - 1, 1);
      } else {
        _anchor = _anchor.subtract(const Duration(days: 7));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.calendarTitle),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: context.l10n.calendarTabMonth),
            Tab(text: context.l10n.calendarTabWeek),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: _prev,
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: _next,
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          MonthView(
            anchor: _anchor,
            onDaySelected: _openDay,
          ),
          WeekView(
            anchor: _anchor,
            onDaySelected: _openDay,
          ),
        ],
      ),
    );
  }
}
