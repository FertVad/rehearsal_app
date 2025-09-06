import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rehearsal_app/app.dart';
import 'package:rehearsal_app/l10n/app_localizations.dart';

void main() {
  testWidgets('app starts with bottom navigation', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(ProviderScope(child: App()));
    await tester.pumpAndSettle();

    final l10n = await AppLocalizations.delegate.load(const Locale('en'));

    // Check that the app shows navigation items
    expect(find.text(l10n.navDashboard), findsOneWidget);
    expect(find.text(l10n.navCalendar), findsOneWidget);
    expect(find.text(l10n.navAvailability), findsOneWidget);
    expect(find.text(l10n.navProjects), findsOneWidget);
  });
}
