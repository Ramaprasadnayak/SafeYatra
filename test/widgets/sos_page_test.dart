import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:safeyatra/pages/sos/sos_page.dart';

void main() {
  group('SosPage', () {
    testWidgets('SOS page renders correctly', (WidgetTester tester) async {
      bool callbackTriggered = false;

      await tester.pumpWidget(
        MaterialApp(
          home: SosPage(
            onCallEmergency: () {
              callbackTriggered = true;
            },
            locality: 'Test City',
            district: 'Test District',
            coordinates: '12.34° N, 56.78° E',
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify essential elements are present
      expect(find.text('CALL 112'), findsOneWidget);
      expect(find.text('Test City'), findsOneWidget);
      expect(find.text('Test District'), findsOneWidget);
    });

    testWidgets('Emergency call button is tappable', (WidgetTester tester) async {
      bool callbackTriggered = false;

      await tester.pumpWidget(
        MaterialApp(
          home: SosPage(
            onCallEmergency: () {
              callbackTriggered = true;
            },
            locality: 'Test City',
            district: 'Test District',
            coordinates: '12.34° N, 56.78° E',
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap the emergency call button
      await tester.tap(find.text('CALL 112'));
      await tester.pumpAndSettle();

      expect(callbackTriggered, isTrue);
    });

    testWidgets('SOS page displays location information', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SosPage(
            locality: 'Mumbai',
            district: 'Mumbai District, Maharashtra',
            coordinates: '19.0760° N, 72.8777° E',
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.textContaining('Mumbai'), findsWidgets);
      expect(find.textContaining('Maharashtra'), findsOneWidget);
    });
  });
}
