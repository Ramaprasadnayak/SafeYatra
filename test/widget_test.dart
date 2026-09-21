import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:safeyatra/app.dart';

void main() {
  testWidgets('App launches without errors', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Verify app initializes
    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('App has proper theme configuration', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    final MaterialApp app = tester.widget(find.byType(MaterialApp));
    expect(app.theme, isNotNull);
    expect(app.darkTheme, isNotNull);
  });
}
