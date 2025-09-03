import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rehearsal_app/core/utils/time.dart';
import 'package:rehearsal_app/features/availability/presentation/widgets/calendar_grid.dart';
import 'package:rehearsal_app/core/design_system/calendar_components.dart';

void main() {
  group('CalendarGrid', () {
    testWidgets('renders month with 31 days', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: CalendarGrid(month: DateTime(2024, 1), byDate: {}),
        ),
      );

      // 31 days + 4 trailing days = 35 cells
      expect(find.byType(GestureDetector), findsNWidgets(35));
      expect(find.text('31'), findsOneWidget);
    });

    testWidgets('shows status indicators', (tester) async {
      final dayFree = DateTime(2024, 1, 10);
      final dayBusy = DateTime(2024, 1, 11);
      final dayPartial = DateTime(2024, 1, 12);
      final map = <int, AvailabilityStatus>{
        dateUtc00(dayFree): AvailabilityStatus.free,
        dateUtc00(dayBusy): AvailabilityStatus.busy,
        dateUtc00(dayPartial): AvailabilityStatus.partial,
      };

      await tester.pumpWidget(
        MaterialApp(
          home: CalendarGrid(month: DateTime(2024, 1), byDate: map),
        ),
      );

      AvailabilityStatus statusFor(int dateUtc) {
        final dot = find.byKey(ValueKey('dot-$dateUtc'));
        expect(dot, findsOneWidget,
            reason: 'Expected a status dot with key dot-$dateUtc');
        final indicator = tester.widget<StatusIndicator>(dot);
        return indicator.status;
      }

      expect(statusFor(dateUtc00(dayFree)), AvailabilityStatus.free);
      expect(statusFor(dateUtc00(dayBusy)), AvailabilityStatus.busy);
      expect(statusFor(dateUtc00(dayPartial)), AvailabilityStatus.partial);
    });

    testWidgets('tapping day triggers callback', (tester) async {
      DateTime? tapped;
      final day = DateTime(2024, 1, 15);

      await tester.pumpWidget(
        MaterialApp(
          home: CalendarGrid(
            month: DateTime(2024, 1),
            byDate: const {},
            onDayTap: (d) => tapped = d,
          ),
        ),
      );

      await tester.tap(find.byKey(ValueKey('day-${dateUtc00(day)}')));
      expect(tapped, day);
    });
  });
}
