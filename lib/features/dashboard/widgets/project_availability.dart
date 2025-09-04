import 'package:flutter/material.dart';
import 'package:rehearsal_app/core/design_system/glass_system.dart';
import 'package:rehearsal_app/core/design_system/app_spacing.dart';
import 'package:rehearsal_app/core/design_system/app_typography.dart';
import 'package:rehearsal_app/core/design_system/app_colors.dart';

class ProjectAvailability extends StatelessWidget {
  const ProjectAvailability({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Project Availability This Week',
            style: AppTypography.headingMedium,
          ),
          const SizedBox(height: AppSpacing.md),
          GlassCard(
            child: SizedBox(
              height: 120,
              child: _AvailabilityChart(),
            ),
          ),
        ],
      ),
    );
  }
}

class _AvailabilityChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: Implement availability visualization
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(7, (index) {
          final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
          final availability = [0.8, 0.6, 0.9, 0.4, 0.7, 0.3, 0.5][index];
          
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      AppColors.statusFree.withOpacity(0.3),
                      AppColors.statusFree,
                    ],
                    stops: [1 - availability, 1 - availability],
                  ),
                  border: Border.all(
                    color: AppColors.glassBorder,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                days[index],
                style: AppTypography.calendarWeekday,
              ),
            ],
          );
        }),
      ),
    );
  }
}

