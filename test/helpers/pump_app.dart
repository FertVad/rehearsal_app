import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rehearsal_app/l10n/app_localizations.dart';

extension PumpApp on WidgetTester {
  Future<void> pumpLocalized(Widget child, {Locale? locale}) async {
    await pumpWidget(
      MaterialApp(
        locale: locale ?? const Locale('en'),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          ...AppLocalizations.localizationsDelegates,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: child,
      ),
    );
    await pumpAndSettle();
  }
}
