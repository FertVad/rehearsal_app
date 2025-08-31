import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rehearsal_app/app.dart';

void main() {
  testWidgets('shows welcome text and about button', (WidgetTester tester) async {
    await tester.pumpWidget(App());
    await tester.pumpAndSettle();

    final l10n = await AppLocalizations.delegate.load(const Locale('en'));

    expect(find.text(l10n.homeWelcome), findsOneWidget);
    expect(find.text(l10n.homeAboutButton), findsOneWidget);
    expect(find.text(l10n.homeCalendarButton), findsOneWidget);
  });
}
