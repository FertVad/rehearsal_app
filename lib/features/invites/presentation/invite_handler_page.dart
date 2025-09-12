import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rehearsal_app/core/design_system/app_colors.dart';
import 'package:rehearsal_app/core/design_system/app_spacing.dart';
import 'package:rehearsal_app/core/design_system/app_typography.dart';
import 'package:rehearsal_app/features/dashboard/widgets/dash_background.dart';
import 'package:rehearsal_app/core/providers/repository_providers.dart';
import 'package:rehearsal_app/domain/models/project.dart';
import 'package:rehearsal_app/features/user/controller/user_provider.dart';

/// Provider to get project by invite slug
final projectBySlugProvider = FutureProvider.family<Project?, String>((
  ref,
  slug,
) async {
  final repository = ref.watch(projectsRepositoryProvider);

  try {
    return await repository.getByInviteSlug(slug);
  } catch (e) {
    throw Exception('Failed to find project with invite slug: $slug');
  }
});

/// Join button state
enum JoinButtonState { idle, loading, success, error }

/// State provider for join button
final joinButtonStateProvider = StateProvider<JoinButtonState>(
  (ref) => JoinButtonState.idle,
);

/// Error message provider
final joinErrorProvider = StateProvider<String?>((ref) => null);

/// Provider to check if current user is already a member of the project
final isMemberProvider = FutureProvider.family<bool, String>((
  ref,
  projectId,
) async {
  final membersRepository = ref.watch(projectMembersRepositoryProvider);
  final userId = ref.watch(currentUserIdProvider);

  if (userId == null) {
    return false;
  }

  return await membersRepository.isUserMemberOfProject(
    projectId: projectId,
    userId: userId,
  );
});

class InviteHandlerPage extends ConsumerWidget {
  const InviteHandlerPage({super.key, required this.inviteSlug});

  final String inviteSlug;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectAsync = ref.watch(projectBySlugProvider(inviteSlug));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Join Project'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: DashBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: AppSpacing.paddingLG,
            child: projectAsync.when(
              loading: () => const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: AppSpacing.md),
                    Text('Loading project details...'),
                  ],
                ),
              ),
              error: (error, stackTrace) =>
                  _buildErrorState(context, error.toString()),
              data: (project) {
                if (project == null) {
                  return _buildInvalidInviteState(context);
                }

                if (!project.inviteActive) {
                  return _buildInactiveInviteState(context);
                }

                // Check if user is already a member
                final membershipAsync = ref.watch(isMemberProvider(project.id));

                return membershipAsync.when(
                  loading: () => const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: AppSpacing.md),
                        Text('Checking membership...'),
                      ],
                    ),
                  ),
                  error: (error, stackTrace) =>
                      _buildErrorState(context, error.toString()),
                  data: (isMember) {
                    if (isMember) {
                      return _buildAlreadyMemberState(context, project);
                    }

                    return _buildProjectInviteState(context, ref, project);
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Error loading invitation',
            style: AppTypography.displayMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            error,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xl),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Go Back'),
          ),
        ],
      ),
    );
  }

  Widget _buildInvalidInviteState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.link_off, size: 64, color: Colors.orange),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Invalid Invitation',
            style: AppTypography.displayMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'This invitation link is not valid or has expired.',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xl),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Go Back'),
          ),
        ],
      ),
    );
  }

  Widget _buildInactiveInviteState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.block, size: 64, color: Colors.red),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Invitation Deactivated',
            style: AppTypography.displayMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'This invitation has been deactivated by the project administrator.',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xl),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Go Back'),
          ),
        ],
      ),
    );
  }

  Widget _buildAlreadyMemberState(BuildContext context, Project project) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: AppSpacing.xl),

          // Project icon/avatar
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusLG),
              border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
            ),
            child: Icon(Icons.check_circle, size: 40, color: Colors.green),
          ),

          const SizedBox(height: AppSpacing.lg),

          Text(
            'Already a Member!',
            style: AppTypography.displayMedium,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppSpacing.sm),

          Text(
            'You are already a member of "${project.title}".',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppSpacing.xl),

          // Go to project button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _navigateToProject(context, project.id),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              ),
              child: const Text('Go to Project'),
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // Cancel button
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectInviteState(
    BuildContext context,
    WidgetRef ref,
    Project project,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: AppSpacing.xl),

        // Project icon/avatar
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.primaryPurple.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppSpacing.radiusLG),
            border: Border.all(
              color: AppColors.primaryPurple.withValues(alpha: 0.3),
            ),
          ),
          child: Icon(
            Icons.theater_comedy,
            size: 40,
            color: AppColors.primaryPurple,
          ),
        ),

        const SizedBox(height: AppSpacing.lg),

        // Project title
        Text(
          project.title,
          style: AppTypography.displayMedium,
          textAlign: TextAlign.center,
        ),

        if (project.description != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            project.description!,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],

        const SizedBox(height: AppSpacing.md),

        // Project info
        Container(
          padding: AppSpacing.paddingMD,
          decoration: BoxDecoration(
            color: AppColors.glassLightBase,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
            border: Border.all(color: AppColors.glassLightStroke),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.people, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: AppSpacing.sm),
              Text(
                '${project.memberCount} members',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.xl),

        // Invitation message
        Text(
          'You\'ve been invited to join this project',
          style: AppTypography.bodyLarge,
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: AppSpacing.xl),

        // Join button
        SizedBox(
          width: double.infinity,
          child: _buildJoinButton(context, ref, project),
        ),

        const SizedBox(height: AppSpacing.lg),

        // Cancel button
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
      ],
    );
  }

  Widget _buildJoinButton(
    BuildContext context,
    WidgetRef ref,
    Project project,
  ) {
    return Consumer(
      builder: (context, ref, child) {
        final buttonState = ref.watch(joinButtonStateProvider);
        final errorMessage = ref.watch(joinErrorProvider);

        switch (buttonState) {
          case JoinButtonState.idle:
            return ElevatedButton(
              onPressed: () => _joinProject(context, ref, project),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              ),
              child: const Text('Join Project'),
            );

          case JoinButtonState.loading:
            return ElevatedButton(
              onPressed: null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: AppSpacing.sm),
                  Text('Joining...'),
                ],
              ),
            );

          case JoinButtonState.success:
            // Navigate after showing success state
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (context.mounted) {
                _showSuccessAndNavigate(context);
              }
            });

            return ElevatedButton.icon(
              onPressed: null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.check, size: 20),
              label: const Text('Joined Successfully!'),
            );

          case JoinButtonState.error:
            return Column(
              children: [
                if (errorMessage != null) ...[
                  Container(
                    width: double.infinity,
                    padding: AppSpacing.paddingSM,
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
                      border: Border.all(
                        color: Colors.red.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      'Failed to join: $errorMessage',
                      style: AppTypography.bodySmall.copyWith(
                        color: Colors.red.shade700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
                ElevatedButton(
                  onPressed: () => _joinProject(context, ref, project),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.md,
                    ),
                  ),
                  child: const Text('Try Again'),
                ),
              ],
            );
        }
      },
    );
  }

  void _joinProject(
    BuildContext context,
    WidgetRef ref,
    Project project,
  ) async {
    // Reset error state
    ref.read(joinErrorProvider.notifier).state = null;

    // Set loading state
    ref.read(joinButtonStateProvider.notifier).state = JoinButtonState.loading;

    try {
      final membersRepository = ref.read(projectMembersRepositoryProvider);
      final userId = ref.read(currentUserIdProvider);

      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Add user to project as member
      await membersRepository.addMemberToProject(
        projectId: project.id,
        userId: userId,
        role: 'member',
        invitedBy: null, // Invite link invitation - no specific inviter
      );

      // Set success state
      ref.read(joinButtonStateProvider.notifier).state =
          JoinButtonState.success;
    } catch (e) {
      // Set error state
      ref.read(joinErrorProvider.notifier).state = e.toString();
      ref.read(joinButtonStateProvider.notifier).state = JoinButtonState.error;
    }
  }

  void _navigateToProject(BuildContext context, String projectId) {
    // Navigate to the app (will show projects tab by default)
    context.go('/');
  }

  void _showSuccessAndNavigate(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Successfully joined the project!'),
        backgroundColor: Colors.green,
      ),
    );

    // Navigate to the main app (projects tab)
    context.go('/');
  }
}
