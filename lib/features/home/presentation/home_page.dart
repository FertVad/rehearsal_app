import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rehearsal_app/l10n/app.dart';
import 'package:rehearsal_app/features/settings/presentation/language_menu.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.appTitle), actions: const [LanguageMenu()]),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(context.l10n.homeWelcome),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/about'),
              child: Text(context.l10n.homeAboutButton),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/calendar'),
              child: Text(context.l10n.homeCalendarButton),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/availability'),
              child: Text(context.l10n.homeAvailabilityButton),
            ),
          ],
        ),
      ),
    );
  }
}
