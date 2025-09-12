import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rehearsal_app/core/design_system/app_colors.dart';
import 'package:rehearsal_app/core/design_system/app_spacing.dart';
import 'package:rehearsal_app/core/design_system/app_typography.dart';
import 'package:rehearsal_app/features/dashboard/widgets/dash_background.dart';
import 'package:rehearsal_app/domain/models/project.dart';
import 'package:rehearsal_app/core/providers/repository_providers.dart';
import 'package:rehearsal_app/domain/models/project_member.dart';
import 'package:rehearsal_app/core/services/invite_service.dart';

final projectMembersProvider =
    FutureProvider.family<List<ProjectMember>, String>((ref, projectId) async {
      final repository = ref.watch(projectMembersRepositoryProvider);
      return await repository.getProjectMembers(projectId);
    });

class ProjectDetailsPage extends ConsumerWidget {
  const ProjectDetailsPage({super.key, required this.project});

  final Project project;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final membersAsync = ref.watch(projectMembersProvider(project.id));

    return Scaffold(
      appBar: AppBar(
        title: Text(project.title),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: DashBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: AppSpacing.paddingLG,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.xl),

                // Project Info Card
                Container(
                  width: double.infinity,
                  padding: AppSpacing.paddingLG,
                  decoration: BoxDecoration(
                    color: AppColors.glassLightBase,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusLG),
                    border: Border.all(color: AppColors.glassLightStroke),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(project.title, style: AppTypography.displayMedium),
                      if (project.description != null) ...[
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          project.description!,
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        children: [
                          Icon(
                            Icons.people,
                            size: 16,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            '${project.memberCount} members',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.xl),

                // Invite Code Section
                if (project.inviteCode != null) ...[
                  Text('Invite Code', style: AppTypography.headingMedium),
                  const SizedBox(height: AppSpacing.md),
                  Container(
                    width: double.infinity,
                    padding: AppSpacing.paddingMD,
                    decoration: BoxDecoration(
                      color: AppColors.glassLightBase,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                      border: Border.all(color: AppColors.glassLightStroke),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Share this code with others to invite them:',
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                project.inviteCode!,
                                style: AppTypography.headingMedium.copyWith(
                                  fontFamily: 'monospace',
                                  letterSpacing: 2.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy),
                          onPressed: () => _copyInviteCode(context),
                          tooltip: 'Copy invite code',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                ],

                // Invite Link Section
                if (project.inviteSlug != null && project.inviteActive) ...[
                  Text('Invite Link', style: AppTypography.headingMedium),
                  const SizedBox(height: AppSpacing.md),
                  Container(
                    width: double.infinity,
                    padding: AppSpacing.paddingMD,
                    decoration: BoxDecoration(
                      color: AppColors.glassLightBase,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                      border: Border.all(color: AppColors.glassLightStroke),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Share this link to invite others:',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Container(
                          padding: AppSpacing.paddingSM,
                          decoration: BoxDecoration(
                            color: AppColors.glassLightBase.withValues(
                              alpha: 0.5,
                            ),
                            borderRadius: BorderRadius.circular(
                              AppSpacing.radiusSM,
                            ),
                            border: Border.all(
                              color: AppColors.glassLightStroke.withValues(
                                alpha: 0.5,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: SelectableText(
                                  InviteService.generateInviteUrl(
                                    project.inviteSlug!,
                                  ),
                                  style: AppTypography.bodyMedium.copyWith(
                                    fontFamily: 'monospace',
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              IconButton(
                                icon: const Icon(Icons.copy, size: 20),
                                onPressed: () => _copyInviteLink(context),
                                tooltip: 'Copy invite link',
                                constraints: const BoxConstraints(
                                  minWidth: 32,
                                  minHeight: 32,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                ],

                // Members Section
                Text('Members', style: AppTypography.headingMedium),
                const SizedBox(height: AppSpacing.md),

                membersAsync.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, stackTrace) => Container(
                    padding: AppSpacing.paddingMD,
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                      border: Border.all(
                        color: Colors.red.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error, color: Colors.red),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            'Failed to load members: ${error.toString()}',
                            style: AppTypography.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                  data: (members) => members.isEmpty
                      ? Container(
                          padding: AppSpacing.paddingLG,
                          decoration: BoxDecoration(
                            color: AppColors.glassLightBase,
                            borderRadius: BorderRadius.circular(
                              AppSpacing.radiusMD,
                            ),
                            border: Border.all(
                              color: AppColors.glassLightStroke,
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.people_outline,
                                size: 48,
                                color: AppColors.textSecondary,
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              Text(
                                'No members yet',
                                style: AppTypography.bodyMedium.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Column(
                          children: members
                              .map((member) => _buildMemberCard(member))
                              .toList(),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMemberCard(ProjectMember member) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: AppSpacing.paddingMD,
      decoration: BoxDecoration(
        color: AppColors.glassLightBase,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
        border: Border.all(color: AppColors.glassLightStroke),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.primaryPurple.withValues(alpha: 0.1),
            child: Text(
              _getInitials(member.userFullName ?? member.userEmail ?? 'U'),
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.primaryPurple,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.userFullName ?? member.userEmail ?? 'Unknown User',
                  style: AppTypography.bodyMedium,
                ),
                if (member.userEmail != null &&
                    member.userFullName != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    member.userEmail!,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: _getRoleColor(member.role).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusXS),
              border: Border.all(
                color: _getRoleColor(member.role).withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              _formatRole(member.role),
              style: AppTypography.bodySmall.copyWith(
                color: _getRoleColor(member.role),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    final words = name.trim().split(' ');
    if (words.isEmpty) return 'U';
    if (words.length == 1) return words[0].substring(0, 1).toUpperCase();
    return '${words[0].substring(0, 1)}${words[1].substring(0, 1)}'
        .toUpperCase();
  }

  String _formatRole(String role) {
    switch (role.toLowerCase()) {
      case 'creator':
        return 'Creator';
      case 'admin':
        return 'Admin';
      case 'member':
        return 'Member';
      default:
        return role;
    }
  }

  Color _getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'creator':
        return Colors.purple;
      case 'admin':
        return Colors.orange;
      case 'member':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  void _copyInviteCode(BuildContext context) {
    if (project.inviteCode != null) {
      Clipboard.setData(ClipboardData(text: project.inviteCode!));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invite code copied to clipboard!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _copyInviteLink(BuildContext context) {
    if (project.inviteSlug != null && project.inviteActive) {
      final inviteUrl = InviteService.generateInviteUrl(project.inviteSlug!);
      Clipboard.setData(ClipboardData(text: inviteUrl));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invite link copied to clipboard!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
