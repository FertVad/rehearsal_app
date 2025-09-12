import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rehearsal_app/core/design_system/app_colors.dart';
import 'package:rehearsal_app/core/design_system/app_spacing.dart';
import 'package:rehearsal_app/core/design_system/app_typography.dart';
import 'package:rehearsal_app/features/dashboard/widgets/dash_background.dart';
import 'package:rehearsal_app/core/providers/repository_providers.dart';
import 'package:rehearsal_app/features/user/controller/user_provider.dart';

class JoinProjectPage extends ConsumerStatefulWidget {
  const JoinProjectPage({super.key});

  @override
  ConsumerState<JoinProjectPage> createState() => _JoinProjectPageState();
}

class _JoinProjectPageState extends ConsumerState<JoinProjectPage> {
  final _formKey = GlobalKey<FormState>();
  final _inviteCodeController = TextEditingController();

  bool _isLoading = false;
  String? _error;
  String? _successMessage;

  @override
  void dispose() {
    _inviteCodeController.dispose();
    super.dispose();
  }

  Future<void> _joinProject() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
      _successMessage = null;
    });

    try {
      final membersRepo = ref.read(projectMembersRepositoryProvider);
      final userId = ref.read(currentUserIdProvider);

      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final inviteCode = _inviteCodeController.text.trim();

      await membersRepo.joinProjectByInviteCode(
        inviteCode: inviteCode,
        userId: userId,
      );

      setState(() {
        _successMessage = 'Successfully joined the project!';
        _inviteCodeController.clear();
      });

      // Navigate back after a delay
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          Navigator.of(context).pop(true);
        }
      });
    } catch (e) {
      setState(() {
        _error = e.toString().replaceAll('Exception: ', '');
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Join Project'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: DashBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: AppSpacing.paddingLG,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.xl),

                  // Header
                  Text('Join a Project', style: AppTypography.displayMedium),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Enter the invite code to join an existing project.',
                    style: AppTypography.bodyLarge.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // Invite Code Input
                  Text('Invite Code', style: AppTypography.headingMedium),
                  const SizedBox(height: AppSpacing.md),
                  TextFormField(
                    controller: _inviteCodeController,
                    decoration: InputDecoration(
                      labelText: 'Enter invite code',
                      hintText: 'ABC123',
                      prefixIcon: Icon(Icons.vpn_key),
                      border: OutlineInputBorder(),
                      errorText: _error,
                    ),
                    textCapitalization: TextCapitalization.characters,
                    validator: (value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Please enter an invite code';
                      }
                      return null;
                    },
                    onFieldSubmitted: (_) => _joinProject(),
                  ),

                  if (_successMessage != null) ...[
                    const SizedBox(height: AppSpacing.md),
                    Container(
                      padding: AppSpacing.paddingMD,
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusMD,
                        ),
                        border: Border.all(
                          color: Colors.green.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              _successMessage!,
                              style: AppTypography.bodyMedium.copyWith(
                                color: Colors.green.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: AppSpacing.xl),

                  // Join Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _joinProject,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.md,
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text('Join Project'),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // Info
                  Container(
                    padding: AppSpacing.paddingMD,
                    decoration: BoxDecoration(
                      color: AppColors.glassLightBase,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                      border: Border.all(color: AppColors.glassLightStroke),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.info_outline, size: 20),
                            const SizedBox(width: AppSpacing.sm),
                            Text('How to join', style: AppTypography.titleSm),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          '• Ask the project creator for their invite code\n'
                          '• Enter the code above to join the project\n'
                          '• You\'ll become a member and see all project activities',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
