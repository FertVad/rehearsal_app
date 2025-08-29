import 'package:flutter_test/flutter_test.dart';
import 'package:rehearsal_app/app.dart';

void main() {
  testWidgets('shows welcome text', (WidgetTester tester) async {
    await tester.pumpWidget(const App());

    expect(
      find.text('Добро пожаловать! Это стартовый экран.'),
      findsOneWidget,
    );
  });
}
