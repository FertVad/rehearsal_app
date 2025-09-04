import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rehearsal_app/features/calendar/presentation/calendar_page.dart';
import 'package:rehearsal_app/features/calendar/widgets/calendar_view.dart';
import 'package:rehearsal_app/l10n/app_localizations.dart';

void main() {
  testWidgets('calendar page shows title and navigation buttons',
      (tester) async {
    // Load English strings for stable assertions
    final l10n = await AppLocalizations.delegate.load(const Locale('en'));

    // Pump CalendarPage with ProviderScope for Riverpod
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const CalendarPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Title and main UI components
    expect(find.text(l10n.navCalendar), findsOneWidget);
    expect(find.byIcon(Icons.today), findsOneWidget);
    expect(find.byIcon(Icons.chevron_left), findsOneWidget);
    expect(find.byIcon(Icons.chevron_right), findsOneWidget);
    expect(find.byType(CalendarView), findsOneWidget);
  });
}
