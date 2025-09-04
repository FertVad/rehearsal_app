import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rehearsal_app/core/design_system/glass_system.dart';
import 'package:rehearsal_app/core/design_system/app_spacing.dart';
import 'package:rehearsal_app/core/design_system/app_typography.dart';

final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.paddingLG,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Appearance',
                style: AppTypography.headingMedium,
              ),
              const SizedBox(height: AppSpacing.md),
              GlassCard(
                child: RadioGroup<ThemeMode>(
                  value: themeMode,
                  onChanged: (value) {
                    if (value != null) {
                      ref.read(themeModeProvider.notifier).state = value;
                    }
                  },
                  child: Column(
                    children: [
                      _ThemeOption(
                        title: 'System Default',
                        subtitle: 'Follow system theme',
                        value: ThemeMode.system,
                      ),
                      const Divider(),
                      _ThemeOption(
                        title: 'Light Theme',
                        subtitle: 'Always use light theme',
                        value: ThemeMode.light,
                      ),
                      const Divider(),
                      _ThemeOption(
                        title: 'Dark Theme',
                        subtitle: 'Always use dark theme',
                        value: ThemeMode.dark,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  const _ThemeOption({
    required this.title,
    required this.subtitle,
    required this.value,
  });

  final String title;
  final String subtitle;
  final ThemeMode value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      leading: Radio<ThemeMode>(
        value: value,
      ),
      onTap: () => RadioGroup.of<ThemeMode>(context)?.setValue(value),
    );
  }
}

