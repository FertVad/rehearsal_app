import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rehearsal_app/core/design_system/app_colors.dart';
import 'package:rehearsal_app/core/design_system/app_spacing.dart';
import 'package:rehearsal_app/core/design_system/app_typography.dart';
import 'package:rehearsal_app/core/widgets/loading_state.dart';
import 'package:rehearsal_app/features/dashboard/widgets/dash_background.dart';
import 'package:rehearsal_app/features/user/controller/user_provider.dart';
import 'package:rehearsal_app/core/l10n/locale_provider.dart';
import 'package:rehearsal_app/l10n/app.dart';

class UserProfilePage extends ConsumerStatefulWidget {
  const UserProfilePage({super.key});

  @override
  ConsumerState<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends ConsumerState<UserProfilePage> {
  final _nameController = TextEditingController();
  final _timezoneController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _timezoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userControllerProvider);
    
    if (userState.isLoading) {
      return const Scaffold(
        body: LoadingState(),
      );
    }

    final user = userState.currentUser;
    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: Center(
          child: Text(context.l10n.noUserFound),
        ),
      );
    }

    // Update controllers when user data changes
    if (_nameController.text.isEmpty) {
      _nameController.text = user.name ?? '';
      _timezoneController.text = user.tz;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.navProfile),
        actions: [
          TextButton(
            onPressed: _saveProfile,
            child: Text(context.l10n.save),
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
                // User Info Card
                Container(
                  width: double.infinity,
                  padding: AppSpacing.paddingLG,
                  decoration: BoxDecoration(
                    color: AppColors.glassLightBase,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusLG),
                    border: Border.all(
                      color: AppColors.glassLightStroke,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: AppColors.primaryPurple,
                        child: Text(
                          (user.name ?? 'U').substring(0, 1).toUpperCase(),
                          style: AppTypography.headingMedium.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'User ID: ${user.id}',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.xl),

                // Profile Form
                Text(
                  context.l10n.profileSettings,
                  style: AppTypography.headingMedium,
                ),
                const SizedBox(height: AppSpacing.lg),

                // Name Field
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: context.l10n.name,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Timezone Field  
                TextFormField(
                  controller: _timezoneController,
                  decoration: InputDecoration(
                    labelText: context.l10n.timezone,
                    border: OutlineInputBorder(),
                    hintText: context.l10n.timezoneHint,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),

                // Language Selector
                Text(
                  'Language / Язык',
                  style: AppTypography.headingMedium,
                ),
                const SizedBox(height: AppSpacing.md),
                
                Container(
                  padding: AppSpacing.paddingMD,
                  decoration: BoxDecoration(
                    color: AppColors.glassLightBase,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                    border: Border.all(color: AppColors.glassLightStroke),
                  ),
                  child: Column(
                    children: [
                      _LanguageOption(
                        title: 'English',
                        value: const Locale('en'),
                        currentValue: ref.watch(localeProvider),
                        onChanged: (locale) => ref.read(localeProvider.notifier).state = locale,
                      ),
                      _LanguageOption(
                        title: 'Русский',
                        value: const Locale('ru'),
                        currentValue: ref.watch(localeProvider),
                        onChanged: (locale) => ref.read(localeProvider.notifier).state = locale,
                      ),
                      _LanguageOption(
                        title: 'System / Системный',
                        value: null,
                        currentValue: ref.watch(localeProvider),
                        onChanged: (locale) => ref.read(localeProvider.notifier).state = locale,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: AppSpacing.xl),

                // Error Display
                if (userState.error != null)
                  Container(
                    padding: AppSpacing.paddingMD,
                    decoration: BoxDecoration(
                      color: AppColors.statusBusy.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: AppColors.statusBusy),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            userState.error!,
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.statusBusy,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => ref.read(userControllerProvider.notifier).clearError(),
                        ),
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

  void _saveProfile() {
    ref.read(userControllerProvider.notifier).updateProfile(
          name: _nameController.text.trim().isEmpty ? null : _nameController.text.trim(),
          timezone: _timezoneController.text.trim().isEmpty ? null : _timezoneController.text.trim(),
        );
  }
}

class _LanguageOption extends StatelessWidget {
  const _LanguageOption({
    required this.title,
    required this.value,
    required this.currentValue,
    required this.onChanged,
  });

  final String title;
  final Locale? value;
  final Locale? currentValue;
  final ValueChanged<Locale?> onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: GestureDetector(
        onTap: () => onChanged(value),
        child: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.primaryPurple,
              width: 2,
            ),
          ),
          child: _isSelected 
            ? Center(
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryPurple,
                  ),
                ),
              )
            : null,
        ),
      ),
      onTap: () => onChanged(value),
    );
  }

  bool get _isSelected => value == currentValue;
}