import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rehearsal_app/core/l10n/locale_provider.dart';import 'package:rehearsal_app/app.dart';
import 'package:rehearsal_app/l10n/app_localizations.dart';

void main() {
  testWidgets('calendar page shows tabs', (tester) async {
    await tester.pumpWidget(ProviderScope(overrides:[localeProvider.overrideWith((ref)=> const Locale('en'))], child: App()));
    await tester.pumpAndSettle();

    final l10n = await AppLocalizations.delegate.load(const Locale('en'));

    await tester.tap(find.text(l10n.homeCalendarButton));
    await tester.pumpAndSettle();

    expect(find.text(l10n.calendarTitle), findsOneWidget);
    expect(find.text(l10n.calendarTabMonth), findsOneWidget);
    expect(find.text(l10n.calendarTabWeek), findsOneWidget);
  });
}
