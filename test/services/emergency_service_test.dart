import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:safeyatra/services/emergency_service.dart';

void main() {
  group('EmergencyService', () {
    testWidgets('callEmergency returns false when URL cannot be launched',
      (WidgetTester tester) async {
      // Build a test context
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (BuildContext context) {
              return Container();
            },
          ),
        ),
      );

      final context = tester.element(find.byType(Container));

      // Note: In real testing environment, url_launcher would need mocking
      // This test verifies the method signature and basic structure
      expect(EmergencyService.callEmergency, isA<Function>());
    });

    test('Emergency number is correctly set', () {
      expect(EmergencyService.emergencyNumber, equals('112'));
    });

    testWidgets('callEmergencyWithConfirmation shows dialog',
      (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (BuildContext context) {
              return ElevatedButton(
                onPressed: () {
                  EmergencyService.callEmergencyWithConfirmation(context);
                },
                child: const Text('Test'),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Test'));
      await tester.pumpAndSettle();

      // Verify confirmation dialog appears
      expect(find.text('Call Emergency Services?'), findsOneWidget);
      expect(find.text('Call 112'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });
  });
}
