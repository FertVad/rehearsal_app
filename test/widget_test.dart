import 'package:flutter_test/flutter_test.dart';
import 'package:rehearsal_app/app.dart';

void main() {
  testWidgets('shows welcome text and about button', (WidgetTester tester) async {
    await tester.pumpWidget(App());

    expect(
      find.text('Добро пожаловать! Это стартовый экран.'),
      findsOneWidget,
    );

    expect(
      find.text('О приложении'),
      findsOneWidget,
    );
  });
}
