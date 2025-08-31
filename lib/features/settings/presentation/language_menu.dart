import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rehearsal_app/core/l10n/locale_provider.dart';

class LanguageMenu extends ConsumerWidget {
  const LanguageMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(localeProvider);
    PopupMenuEntry<Locale?> item(String title, Locale? value) {
      final selected =
          (current == null && value == null) ||
          (current != null && value != null && current == value);
      return PopupMenuItem<Locale?>(
        value: value,
        child: Row(
          children: [
            if (selected) const Icon(Icons.check, size: 18),
            if (selected) const SizedBox(width: 8),
            Text(title),
          ],
        ),
      );
    }

    return PopupMenuButton<Locale?>(
      icon: const Icon(Icons.language),
      tooltip: 'Language',
      onSelected: (value) => ref.read(localeProvider.notifier).state = value,
      itemBuilder: (context) => [
        item('System', null),
        item('English', const Locale('en')),
        item('Русский', const Locale('ru')),
      ],
    );
  }
}
