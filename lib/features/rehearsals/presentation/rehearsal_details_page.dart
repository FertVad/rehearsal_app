import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rehearsal_app/core/db/app_database.dart';
import 'package:rehearsal_app/core/design_system/app_colors.dart';
import 'package:rehearsal_app/core/design_system/app_spacing.dart';
import 'package:rehearsal_app/core/design_system/app_typography.dart';
import 'package:rehearsal_app/core/widgets/loading_state.dart';
import 'package:rehearsal_app/features/dashboard/widgets/dash_background.dart';
import 'package:rehearsal_app/core/providers/repository_providers.dart';
import 'package:rehearsal_app/features/rehearsals/presentation/rehearsal_edit_page.dart';

class RehearsalDetailsPage extends ConsumerStatefulWidget {
  const RehearsalDetailsPage({
    super.key,
    required this.rehearsalId,
  });

  final String rehearsalId;

  @override
  ConsumerState<RehearsalDetailsPage> createState() => _RehearsalDetailsPageState();
}

class _RehearsalDetailsPageState extends ConsumerState<RehearsalDetailsPage> {
  Rehearsal? _rehearsal;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadRehearsal();
  }

  Future<void> _loadRehearsal() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final rehearsalsRepo = ref.read(rehearsalsRepositoryProvider);
      final rehearsal = await rehearsalsRepo.getById(widget.rehearsalId);
      
      setState(() {
        _rehearsal = rehearsal;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load rehearsal: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: LoadingState(),
      );
    }

    if (_error != null || _rehearsal == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Rehearsal Details')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: AppColors.statusBusy,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                _error ?? 'Rehearsal not found',
                style: AppTypography.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.lg),
              ElevatedButton(
                onPressed: _loadRehearsal,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final rehearsal = _rehearsal!;
    final startTime = DateTime.fromMillisecondsSinceEpoch(rehearsal.startsAtUtc, isUtc: true).toLocal();
    final endTime = DateTime.fromMillisecondsSinceEpoch(rehearsal.endsAtUtc, isUtc: true).toLocal();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rehearsal Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _editRehearsal(rehearsal),
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: AppColors.statusBusy),
                    const SizedBox(width: AppSpacing.sm),
                    const Text('Delete'),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 'delete') {
                _confirmDelete(rehearsal);
              }
            },
          ),
        ],
      ),
      body: DashBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: AppSpacing.paddingLG,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Main Info Card
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
                      // Date
                      Row(
                        children: [
                          Icon(Icons.calendar_today, color: AppColors.primaryPurple),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            _formatDate(startTime),
                            style: AppTypography.headingMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // Time Range
                      Row(
                        children: [
                          Icon(Icons.access_time, color: AppColors.primaryPink),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            '${_formatTime(startTime)} - ${_formatTime(endTime)}',
                            style: AppTypography.bodyLarge,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // Duration
                      Row(
                        children: [
                          Icon(Icons.schedule, color: AppColors.primaryCyan),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            _formatDuration(endTime.difference(startTime)),
                            style: AppTypography.bodyLarge.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.xl),

                // Location
                if (rehearsal.place != null && rehearsal.place!.isNotEmpty) ...[
                  Text(
                    'Location',
                    style: AppTypography.headingMedium,
                  ),
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
                        const Icon(Icons.location_on),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            rehearsal.place!,
                            style: AppTypography.bodyLarge,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                ],

                // Notes
                if (rehearsal.note != null && rehearsal.note!.isNotEmpty) ...[
                  Text(
                    'Notes',
                    style: AppTypography.headingMedium,
                  ),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.note),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            rehearsal.note!,
                            style: AppTypography.bodyLarge,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                ],

                // Metadata
                Text(
                  'Details',
                  style: AppTypography.headingMedium,
                ),
                const SizedBox(height: AppSpacing.md),
                Container(
                  width: double.infinity,
                  padding: AppSpacing.paddingMD,
                  decoration: BoxDecoration(
                    color: AppColors.textTertiary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ID: ${rehearsal.id}',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Created: ${_formatDateTime(DateTime.fromMillisecondsSinceEpoch(rehearsal.createdAtUtc, isUtc: true).toLocal())}',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      if (rehearsal.updatedAtUtc != rehearsal.createdAtUtc) ...[
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'Updated: ${_formatDateTime(DateTime.fromMillisecondsSinceEpoch(rehearsal.updatedAtUtc, isUtc: true).toLocal())}',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String _formatTime(DateTime time) {
    return TimeOfDay.fromDateTime(time).format(context);
  }

  String _formatDateTime(DateTime dateTime) {
    return '${_formatDate(dateTime)} at ${_formatTime(dateTime)}';
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  Future<void> _editRehearsal(Rehearsal rehearsal) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => RehearsalEditPage(rehearsal: rehearsal),
      ),
    );

    if (result == true) {
      // Reload the rehearsal if it was edited
      _loadRehearsal();
    }
  }

  Future<void> _confirmDelete(Rehearsal rehearsal) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Rehearsal'),
        content: const Text('Are you sure you want to delete this rehearsal? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.statusBusy),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _deleteRehearsal(rehearsal);
    }
  }

  Future<void> _deleteRehearsal(Rehearsal rehearsal) async {
    try {
      final rehearsalsRepo = ref.read(rehearsalsRepositoryProvider);
      await rehearsalsRepo.softDelete(rehearsal.id);

      if (mounted) {
        Navigator.of(context).pop(true); // Return to previous screen
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete rehearsal: $e'),
            backgroundColor: AppColors.statusBusy,
          ),
        );
      }
    }
  }
}