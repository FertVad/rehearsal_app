import 'package:flutter/material.dart';
import 'core/design_system/theme.dart';
import 'package:rehearsal_app/l10n/app.dart';
import 'package:rehearsal_app/l10n/app_localizations.dart';
import 'core/router/app_router.dart';

class App extends StatelessWidget {
  App({super.key});

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      onGenerateTitle: (context) => context.l10n.appTitle,
      theme: buildAppTheme(),
      routerConfig: _appRouter.router,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
