// This is a basic Flutter widget test for the Spool Coder App.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:spool_coder_app/presentation/app.dart';

void main() {
  testWidgets('App loads and displays home screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SpoolCoderApp());

    // Verify that our app displays the expected home screen content.
    expect(find.text('Spool Coder'), findsOneWidget);
    expect(find.text('Ready to scan and program filament spools'), findsOneWidget);
  });
}
