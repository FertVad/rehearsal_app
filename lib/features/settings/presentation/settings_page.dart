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
                child: Column(
                  children: [
                    _ThemeOption(
                      title: 'System Default',
                      subtitle: 'Follow system theme',
                      value: ThemeMode.system,
                      groupValue: themeMode,
                      onChanged: (value) {
                        ref.read(themeModeProvider.notifier).state = value!;
                      },
                    ),
                    const Divider(),
                    _ThemeOption(
                      title: 'Light Theme',
                      subtitle: 'Always use light theme',
                      value: ThemeMode.light,
                      groupValue: themeMode,
                      onChanged: (value) {
                        ref.read(themeModeProvider.notifier).state = value!;
                      },
                    ),
                    const Divider(),
                    _ThemeOption(
                      title: 'Dark Theme',
                      subtitle: 'Always use dark theme',
                      value: ThemeMode.dark,
                      groupValue: themeMode,
                      onChanged: (value) {
                        ref.read(themeModeProvider.notifier).state = value!;
                      },
                    ),
                  ],
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
    required this.groupValue,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final ThemeMode value;
  final ThemeMode groupValue;
  final Function(ThemeMode?) onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      leading: Radio<ThemeMode>(
        value: value,
        groupValue: groupValue,
        onChanged: onChanged,
      ),
      onTap: () => onChanged(value),
    );
  }
}

