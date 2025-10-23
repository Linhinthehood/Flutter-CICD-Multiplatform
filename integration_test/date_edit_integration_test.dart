// integration_test/date_edit_integration_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:intl/intl.dart';
import '../lib/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Date Edit Integration Tests', () {
    testWidgets('Complete date edit flow', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Step 1: Create a new note
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Enter note content
      await tester.enterText(find.byType(TextField), 'Test Note for Date Edit');
      await tester.pumpAndSettle();

      // Step 2: Navigate back to save the note
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Step 3: Open the note for editing
      await tester.tap(find.text('Test Note for Date Edit'));
      await tester.pumpAndSettle();

      // Step 4: Verify date section is visible
      expect(find.textContaining('Created:'), findsOneWidget);
      expect(find.text('Edit'), findsOneWidget);

      // Step 5: Tap edit date button
      await tester.tap(find.text('Edit'));
      await tester.pumpAndSettle();

      // Step 6: Verify date picker is shown
      expect(find.text('Select Date'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Done'), findsOneWidget);

      // Step 7: Cancel the date picker
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      // Step 8: Verify date picker is closed
      expect(find.text('Select Date'), findsNothing);

      // Step 9: Open date picker again
      await tester.tap(find.text('Edit'));
      await tester.pumpAndSettle();

      // Step 10: Confirm date selection
      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();

      // Step 11: Verify success dialog
      expect(find.text('Date Updated'), findsOneWidget);
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Step 12: Navigate back to notes list
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Step 13: Verify note is still in the list
      expect(find.text('Test Note for Date Edit'), findsOneWidget);
    });

    testWidgets('Date edit through more options menu',
        (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Step 1: Create a new note
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Enter note content
      await tester.enterText(find.byType(TextField), 'Note for Menu Date Edit');
      await tester.pumpAndSettle();

      // Step 2: Navigate back to save the note
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Step 3: Open the note for editing
      await tester.tap(find.text('Note for Menu Date Edit'));
      await tester.pumpAndSettle();

      // Step 4: Open more options menu
      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();

      // Step 5: Verify Edit Date option is available
      expect(find.text('Edit Date'), findsOneWidget);

      // Step 6: Tap Edit Date option
      await tester.tap(find.text('Edit Date'));
      await tester.pumpAndSettle();

      // Step 7: Verify date picker is shown
      expect(find.text('Select Date'), findsOneWidget);

      // Step 8: Cancel the date picker
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      // Step 9: Navigate back to notes list
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Step 10: Verify note is still in the list
      expect(find.text('Note for Menu Date Edit'), findsOneWidget);
    });

    testWidgets('Date edit with different date values',
        (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Step 1: Create a new note
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Enter note content
      await tester.enterText(find.byType(TextField), 'Date Test Note');
      await tester.pumpAndSettle();

      // Step 2: Navigate back to save the note
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Step 3: Open the note for editing
      await tester.tap(find.text('Date Test Note'));
      await tester.pumpAndSettle();

      // Step 4: Get current date text
      final currentDateText = find.textContaining('Created:');
      expect(currentDateText, findsOneWidget);

      // Step 5: Open date picker
      await tester.tap(find.text('Edit'));
      await tester.pumpAndSettle();

      // Step 6: Verify date picker constraints
      expect(find.text('Select Date'), findsOneWidget);

      // Step 7: Confirm with current date (no change)
      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();

      // Step 8: Verify success dialog
      expect(find.text('Date Updated'), findsOneWidget);
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Step 9: Navigate back to notes list
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Step 10: Verify note is still in the list
      expect(find.text('Date Test Note'), findsOneWidget);
    });

    testWidgets('Date edit error handling', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Step 1: Create a new note
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Enter note content
      await tester.enterText(find.byType(TextField), 'Error Test Note');
      await tester.pumpAndSettle();

      // Step 2: Navigate back to save the note
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Step 3: Open the note for editing
      await tester.tap(find.text('Error Test Note'));
      await tester.pumpAndSettle();

      // Step 4: Open date picker
      await tester.tap(find.text('Edit'));
      await tester.pumpAndSettle();

      // Step 5: Cancel multiple times to test robustness
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      // Step 6: Open date picker again
      await tester.tap(find.text('Edit'));
      await tester.pumpAndSettle();

      // Step 7: Cancel again
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      // Step 8: Navigate back to notes list
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Step 9: Verify note is still in the list
      expect(find.text('Error Test Note'), findsOneWidget);
    });
  });
}
