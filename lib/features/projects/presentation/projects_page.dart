import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rehearsal_app/core/design_system/app_spacing.dart';
import 'package:rehearsal_app/core/widgets/empty_state.dart';
import 'package:rehearsal_app/core/widgets/loading_state.dart';
import 'package:rehearsal_app/features/projects/widgets/project_card.dart';
import 'package:rehearsal_app/features/dashboard/widgets/dash_background.dart';
import 'package:rehearsal_app/l10n/app.dart';

// Mock projects provider - replace with real implementation
final projectsProvider = StateProvider<List<Project>>((ref) => [
  // Mock data - remove when implementing real projects
  Project(
    id: '1',
    title: 'Hamlet Production',
    memberCount: 12,
    description: 'Classic Shakespeare tragedy with modern interpretation',
    lastActivity: DateTime.now().subtract(const Duration(hours: 2)),
  ),
  Project(
    id: '2',
    title: 'Summer Workshop',
    memberCount: 8,
    description: 'Interactive workshop for beginners',
    lastActivity: DateTime.now().subtract(const Duration(days: 1)),
  ),
]);

final projectsLoadingProvider = StateProvider<bool>((ref) => false);

class ProjectsPage extends ConsumerWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projects = ref.watch(projectsProvider);
    final isLoading = ref.watch(projectsLoadingProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.navProjects),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCreateProjectDialog(context),
          ),
        ],
      ),
      body: DashBackground(
        child: SafeArea(
          child: isLoading
              ? const LoadingState(message: 'Loading projects...')
              : projects.isEmpty
                  ? EmptyState(
                      icon: Icons.folder_outlined,
                      title: context.l10n.noProjectsTitle,
                      description: context.l10n.noProjectsDescription,
                      actionLabel: context.l10n.createProject,
                      onAction: () => _showCreateProjectDialog(context),
                    )
                  : CustomScrollView(
                      slivers: [
                        SliverPadding(
                          padding: AppSpacing.paddingLG,
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final project = projects[index];
                                return Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: AppSpacing.md,
                                  ),
                                  child: ProjectCard(
                                    title: project.title,
                                    memberCount: project.memberCount,
                                    description: project.description,
                                    lastActivity: project.lastActivity,
                                    onTap: () => _openProject(context, project),
                                  ),
                                );
                              },
                              childCount: projects.length,
                            ),
                          ),
                        ),
                      ],
                    ),
        ),
      ),
      floatingActionButton: projects.isNotEmpty
          ? FloatingActionButton(
              onPressed: () => _showCreateProjectDialog(context),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  void _showCreateProjectDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const _CreateProjectDialog(),
    );
  }

  void _openProject(BuildContext context, Project project) {
    // TODO: Navigate to project details
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening ${project.title}...'),
      ),
    );
  }
}

class _CreateProjectDialog extends ConsumerStatefulWidget {
  const _CreateProjectDialog();

  @override
  ConsumerState<_CreateProjectDialog> createState() => _CreateProjectDialogState();
}

class _CreateProjectDialogState extends ConsumerState<_CreateProjectDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create New Project'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Project Title',
                hintText: 'Enter project name',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a project title';
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (Optional)',
                hintText: 'Brief project description',
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _createProject,
          child: const Text('Create'),
        ),
      ],
    );
  }

  void _createProject() {
    if (_formKey.currentState!.validate()) {
      final newProject = Project(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        memberCount: 1, // Creator is the first member
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        lastActivity: DateTime.now(),
      );

      // Add to projects list
      final currentProjects = ref.read(projectsProvider);
      ref.read(projectsProvider.notifier).state = [...currentProjects, newProject];

      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Project "${newProject.title}" created successfully!'),
        ),
      );
    }
  }
}

class Project {
  const Project({
    required this.id,
    required this.title,
    required this.memberCount,
    this.description,
    this.lastActivity,
  });

  final String id;
  final String title;
  final int memberCount;
  final String? description;
  final DateTime? lastActivity;
}

