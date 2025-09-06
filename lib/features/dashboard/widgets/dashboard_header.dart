import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rehearsal_app/core/design_system/app_typography.dart';
import 'package:rehearsal_app/core/design_system/app_spacing.dart';
import 'package:rehearsal_app/core/design_system/app_colors.dart';
import 'package:rehearsal_app/core/design_system/glass_system.dart';
import 'package:rehearsal_app/core/providers/index.dart';
import 'package:rehearsal_app/features/projects/presentation/projects_page.dart' show Project;

// Провайдер для выбранных проектов в фильтре
final selectedProjectsFilterProvider = StateProvider<Set<String>>((ref) => {});

class ProjectFilterChips extends StatelessWidget {
  const ProjectFilterChips({
    super.key,
    required this.projects,
    required this.selectedProjectIds,
    required this.onSelectionChanged,
  });

  final List<Project> projects;
  final Set<String> selectedProjectIds;
  final ValueChanged<Set<String>> onSelectionChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          // "All" chip
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: _FilterChip(
              label: 'All',
              isSelected: selectedProjectIds.isEmpty,
              onTap: () => onSelectionChanged({}),
            ),
          ),
          // Project chips
          ...projects.map((project) => Padding(
                padding: const EdgeInsets.only(right: AppSpacing.sm),
                child: _FilterChip(
                  label: project.title,
                  isSelected: selectedProjectIds.contains(project.id),
                  onTap: () {
                    final newSelection = Set<String>.from(selectedProjectIds);
                    if (newSelection.contains(project.id)) {
                      newSelection.remove(project.id);
                    } else {
                      newSelection.add(project.id);
                    }
                    onSelectionChanged(newSelection);
                  },
                ),
              )),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AppGlass(
        size: GlassSize.small,
        style: isSelected ? GlassStyle.accent : GlassStyle.light,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
          child: Text(
            label,
            style: AppTypography.bodyMedium.copyWith(
              color: isSelected 
                ? AppColors.accentHotPink 
                : AppColors.textPrimary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}

class DashboardHeader extends ConsumerWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projects = ref.watch(projectsProvider);
    final selectedProjectIds = ref.watch(selectedProjectsFilterProvider);

    return Padding(
      padding: AppSpacing.paddingLG,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Projects',
                style: AppTypography.headingMedium,
              ),
              const Spacer(),
              Text(
                _getFilterText(projects, selectedProjectIds),
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ProjectFilterChips(
            projects: projects,
            selectedProjectIds: selectedProjectIds,
            onSelectionChanged: (newSelection) {
              ref.read(selectedProjectsFilterProvider.notifier).state = newSelection;
            },
          ),
        ],
      ),
    );
  }

  String _getFilterText(List<Project> projects, Set<String> selectedIds) {
    if (selectedIds.isEmpty) {
      return 'All projects (${projects.length})';
    } else if (selectedIds.length == 1) {
      final project = projects.firstWhere((p) => p.id == selectedIds.first);
      return project.title;
    } else {
      return '${selectedIds.length} selected';
    }
  }
}

