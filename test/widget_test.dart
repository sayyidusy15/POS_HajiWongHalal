// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:restoran_china_pos/main.dart';

void main() {
  testWidgets('Login screen elements test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const DynastyPOSApp());

    // Verify that our app shows the restaurant logo name.
    expect(find.text('Restoran Dynasty'), findsOneWidget);
    
    // Verify that our app shows the Login heading.
    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Access your account to continue'), findsOneWidget);

    // Verify that the login button is present.
    expect(find.byType(ElevatedButton), findsOneWidget);
  });
}
