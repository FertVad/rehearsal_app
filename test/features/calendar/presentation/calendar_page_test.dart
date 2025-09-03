import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rehearsal_app/features/calendar/presentation/calendar_page.dart';
import 'package:rehearsal_app/l10n/app_localizations.dart';

void main() {
  testWidgets('calendar page shows title and tabs', (tester) async {
    // Load English strings for stable assertions
    final l10n = await AppLocalizations.delegate.load(const Locale('en'));

    // Pump CalendarPage directly with proper localization context
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const CalendarPage(),
      ),
    );
    await tester.pumpAndSettle();

    // Title and tabs
    expect(find.text(l10n.calendarTitle), findsOneWidget);
    expect(find.text(l10n.calendarTabMonth), findsOneWidget);
    expect(find.text(l10n.calendarTabWeek), findsOneWidget);
    expect(find.byType(TabBar), findsOneWidget);

    // Navigation buttons exist
    expect(find.byIcon(Icons.chevron_left), findsOneWidget);
    expect(find.byIcon(Icons.chevron_right), findsOneWidget);
  });
}
