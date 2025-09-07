import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rehearsal_app/core/design_system/app_spacing.dart';
import 'package:rehearsal_app/core/widgets/empty_state.dart';
import 'package:rehearsal_app/core/widgets/loading_state.dart';
import 'package:rehearsal_app/features/projects/widgets/project_card.dart';
import 'package:rehearsal_app/features/dashboard/widgets/dash_background.dart';
import 'package:rehearsal_app/l10n/app.dart';
import 'package:rehearsal_app/core/providers/index.dart';
import 'package:rehearsal_app/domain/models/project.dart';

// Real projects provider connected to database
final projectsProvider = FutureProvider<List<Project>>((ref) async {
  final repository = ref.watch(projectsRepositoryProvider);
  final userId = ref.watch(currentUserIdProvider);
  
  if (userId != null) {
    return await repository.listForUser(userId);
  } else {
    return await repository.listAll();
  }
});

final projectsLoadingProvider = StateProvider<bool>((ref) => false);

class ProjectsPage extends ConsumerWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsAsync = ref.watch(projectsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.navProjects),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCreateProjectDialog(context, ref),
          ),
        ],
      ),
      body: DashBackground(
        child: SafeArea(
          child: projectsAsync.when(
            loading: () => const LoadingState(message: 'Loading projects...'),
            error: (error, stackTrace) => EmptyState(
              icon: Icons.error_outline,
              title: 'Failed to load projects',
              description: 'Please check your connection and try again.',
              actionLabel: 'Retry',
              onAction: () => ref.refresh(projectsProvider),
            ),
            data: (projects) => projects.isEmpty
                ? EmptyState(
                    icon: Icons.folder_outlined,
                    title: context.l10n.noProjectsTitle,
                    description: context.l10n.noProjectsDescription,
                    actionLabel: context.l10n.createProject,
                    onAction: () => _showCreateProjectDialog(context, ref),
                  )
                : RefreshIndicator(
                    onRefresh: () async {
                      ref.invalidate(projectsProvider);
                    },
                    child: CustomScrollView(
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
        ),
      ),
      floatingActionButton: projectsAsync.maybeWhen(
        data: (projects) => projects.isNotEmpty
            ? FloatingActionButton(
                onPressed: () => _showCreateProjectDialog(context, ref),
                child: const Icon(Icons.add),
              )
            : null,
        orElse: () => null,
      ),
    );
  }

  void _showCreateProjectDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => _CreateProjectDialog(ref: ref),
    );
  }

  void _openProject(BuildContext context, Project project) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening ${project.title}...'),
      ),
    );
  }
}

class _CreateProjectDialog extends ConsumerStatefulWidget {
  const _CreateProjectDialog({required this.ref});
  
  final WidgetRef ref;

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

  void _createProject() async {
    if (_formKey.currentState!.validate()) {
      try {
        final repository = ref.read(projectsRepositoryProvider);
        final userId = ref.read(currentUserIdProvider);
        
        // Debug: Check if user is authenticated
        if (userId == null) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('User not authenticated. Please log in first.'),
                backgroundColor: Colors.red,
              ),
            );
          }
          return;
        }
        
        final projectId = DateTime.now().millisecondsSinceEpoch.toString();
        final title = _titleController.text.trim();
        final description = _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim();

        await repository.create(
          id: projectId,
          name: title,
          description: description,
          ownerId: userId,
        );

        // Refresh the projects list
        widget.ref.invalidate(projectsProvider);

        if (mounted) {
          Navigator.of(context).pop();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Project "$title" created successfully!'),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to create project: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}
