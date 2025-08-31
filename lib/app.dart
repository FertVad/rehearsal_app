import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/design_system/theme.dart';
import 'core/l10n/locale_provider.dart';
import 'package:rehearsal_app/l10n/app.dart';
import 'package:rehearsal_app/l10n/app_localizations.dart';
import 'core/router/app_router.dart';

class App extends ConsumerWidget {
  App({super.key});

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      locale: ref.watch(localeProvider),
      onGenerateTitle: (context) => context.l10n.appTitle,
      theme: buildAppTheme(),
      routerConfig: _appRouter.router,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
