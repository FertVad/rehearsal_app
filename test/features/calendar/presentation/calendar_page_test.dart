import 'package:flutter_test/flutter_test.dart';
import 'package:rehearsal_app/app.dart';

void main() {
  testWidgets('calendar page shows tabs', (tester) async {
    await tester.pumpWidget(App());

    await tester.tap(find.text('Календарь'));
    await tester.pumpAndSettle();

    expect(find.text('Calendar'), findsOneWidget);
    expect(find.text('Month'), findsOneWidget);
    expect(find.text('Week'), findsOneWidget);
  });
}
