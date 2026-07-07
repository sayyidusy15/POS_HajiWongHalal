// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:restoran_china_pos/main.dart';

void main() {
  testWidgets('PIN login screen and navigation test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const DynastyPOSApp());

    // Verify that our app shows the restaurant logo name.
    expect(find.text('Haji Wong Halal'), findsOneWidget);
    
    // Verify that our app shows the PIN login headers.
    expect(find.text('Enter PIN'), findsOneWidget);

    // Tap '5' six times to enter the correct PIN '555555'
    for (int i = 0; i < 6; i++) {
      await tester.tap(find.text('5'));
      await tester.pump();
    }

    // Pump with delay to allow transition timer (500ms) to fire and page routing to complete
    await tester.pumpAndSettle(const Duration(milliseconds: 600));

    // Verify that we are transitioned to the POS Dashboard screen.
    // Dashboard must contain the search textfield.
    expect(find.text('Search Product...'), findsOneWidget);
    expect(find.text('All Menu'), findsOneWidget);
    expect(find.text('Order Details'), findsOneWidget);

    // Verify that all total prices are formatted in Rupiah (Rp 0)
    expect(find.text('Rp 0'), findsNWidgets(3)); // Subtotal, Tax, Total
  });
}
