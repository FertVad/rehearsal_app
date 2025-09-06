import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rehearsal_app/core/design_system/theme.dart';
import 'package:rehearsal_app/core/providers/index.dart';
import 'package:rehearsal_app/l10n/app.dart';
import 'package:rehearsal_app/l10n/app_localizations.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final themeMode = ref.watch(themeProvider);
    final router = ref.watch(routerProvider);
    
    return MaterialApp.router(
      key: ValueKey('app_${locale?.languageCode ?? 'system'}_${themeMode.name}'),
      locale: locale,
      onGenerateTitle: (context) => context.l10n.appTitle,
      theme: buildAppTheme(),
      darkTheme: buildAppDarkTheme(),
      themeMode: themeMode, // Now using settings-based theme
      routerConfig: router,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
