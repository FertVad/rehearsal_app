import 'package:flutter/material.dart';
import 'package:rehearsal_app/core/design_system/glass_system.dart';
import 'package:rehearsal_app/core/design_system/app_spacing.dart';
import 'package:rehearsal_app/core/design_system/app_typography.dart';
import 'package:rehearsal_app/core/design_system/app_colors.dart';

class ProjectCard extends StatelessWidget {
  const ProjectCard({
    super.key,
    required this.title,
    required this.memberCount,
    this.description,
    this.lastActivity,
    this.onTap,
  });

  final String title;
  final int memberCount;
  final String? description;
  final DateTime? lastActivity;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: onTap,
      child: Padding(
        padding: AppSpacing.paddingLG,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.primaryPurple,
                        AppColors.primaryPink,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
                  ),
                  child: const Icon(
                    Icons.folder,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTypography.headingMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Row(
                        children: [
                          Icon(
                            Icons.people,
                            size: 16,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            '$memberCount members',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: AppColors.textTertiary,
                ),
              ],
            ),
            
            if (description != null) ...[
              const SizedBox(height: AppSpacing.md),
              Text(
                description!,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            
            if (lastActivity != null) ...[
              const SizedBox(height: AppSpacing.md),
              Text(
                'Last activity: ${_formatLastActivity(lastActivity!)}',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatLastActivity(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

