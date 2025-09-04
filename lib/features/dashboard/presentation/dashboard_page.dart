import 'package:flutter/material.dart';

import 'package:rehearsal_app/core/design_system/app_spacing.dart';
import 'package:rehearsal_app/features/dashboard/widgets/day_scroller.dart';
import 'package:rehearsal_app/features/dashboard/widgets/dashboard_header.dart';
import 'package:rehearsal_app/features/dashboard/widgets/upcoming_rehearsals.dart';
import 'package:rehearsal_app/features/dashboard/widgets/project_availability.dart';
import 'package:rehearsal_app/features/dashboard/widgets/quick_actions.dart';
import 'package:rehearsal_app/features/dashboard/widgets/dash_background.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  DateTime _selectedDate = DateTime.now();

  void _handleDateChanged(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DashBackground(
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              // Header with greeting
              const SliverToBoxAdapter(
                child: DashboardHeader(),
              ),

              // Day scroller
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                  child: SizedBox(
                    height: 120,
                    child: DayScroller(
                      initialDate: _selectedDate,
                      onDateChanged: _handleDateChanged,
                    ),
                  ),
                ),
              ),

              // Upcoming rehearsals
              const SliverToBoxAdapter(
                child: UpcomingRehearsals(),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: AppSpacing.lg),
              ),

              // Project availability
              const SliverToBoxAdapter(
                child: ProjectAvailability(),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: AppSpacing.lg),
              ),

              // Quick actions
              const SliverToBoxAdapter(
                child: QuickActions(),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: AppSpacing.xl),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

