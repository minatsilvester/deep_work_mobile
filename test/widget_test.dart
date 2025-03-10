// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

// import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// import 'package:provider/provider.dart';
import 'package:deep_work_mobile/main.dart';
// import 'package:deep_work_mobile/screens/home.dart';
// import 'package:deep_work_mobile/screens/register.dart';

void main() {
  testWidgets('HomeScreen renders correctly and navigates to SignUpScreen',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const DeepWork());

    // Verify that our counter starts at 0.
    expect(find.text('Deep Work'), findsOneWidget);
    expect(find.text('Go to Registration'), findsOneWidget);
    // expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.text('Go to Registration'));
    await tester.pump();

    expect(find.text('Sign Up'),
        findsOneWidget); // Checks that the SignUpScreen is displayed
    expect(find.text('First Name'), findsOneWidget);
    expect(find.text('Last Name'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Sign Up'), findsOneWidget);
  });
}
