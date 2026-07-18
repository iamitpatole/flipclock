import 'package:flip_clock/app/flip_clock_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('FlipClock renders and opens settings', (tester) async {
    await tester.pumpWidget(const FlipClockApp());
    await tester.pumpAndSettle();

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byIcon(Icons.tune), findsOneWidget);

    await tester.tap(find.byIcon(Icons.tune));
    await tester.pumpAndSettle();

    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('24-hour mode'), findsOneWidget);
    expect(find.text('Theme'), findsOneWidget);
  });
}
