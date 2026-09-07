import 'package:finpal/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LaunchFailureApp', () {
    testWidgets('offers a way out instead of a black screen', (tester) async {
      await tester.pumpWidget(const MainApp());

      expect(find.text("FinPal couldn't start"), findsOneWidget);
      expect(find.widgetWithText(FilledButton, 'Try again'), findsOneWidget);
      expect(find.widgetWithText(TextButton, 'Reset app data'), findsOneWidget);
    });

    testWidgets('confirms before erasing data', (tester) async {
      await tester.pumpWidget(const MainApp());

      await tester.tap(find.widgetWithText(TextButton, 'Reset app data'));
      await tester.pumpAndSettle();

      expect(find.text('Reset app data?'), findsOneWidget);
      expect(find.widgetWithText(TextButton, 'Cancel'), findsOneWidget);

      await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
      await tester.pumpAndSettle();

      // Dismissing the dialog must leave the recovery screen intact.
      expect(find.text('Reset app data?'), findsNothing);
      expect(find.widgetWithText(FilledButton, 'Try again'), findsOneWidget);
    });
  });
}
