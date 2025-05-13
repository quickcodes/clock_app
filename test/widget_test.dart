// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:clock_app/features/home_page/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // await tester.pumpWidget(const HomePage());
    tester.view.physicalSize = const Size(1000, 800);
    
    await tester.pumpWidget(
      MaterialApp(
        home: HomePage(),
      ),
    );
    // final now = DateTime.now();
    // final formattedDate =
    //     DateFormat('EEE dd MMM yyyy').format(now).toUpperCase();
    // Verify that our counter starts at 0.
    await tester.pumpAndSettle(const Duration(seconds: 10));
    expect(find.byKey(Key("clock-home-page")), findsOneWidget);
    // expect(find.text('1'), findsNothing);

    // // Tap the '+' icon and trigger a frame.
    // await tester.tap(find.byIcon(Icons.add));
    // await tester.pump();

    // // Verify that our counter has incremented.
    // expect(find.text('0'), findsNothing);
    // expect(find.text('1'), findsOneWidget);
  });
}
