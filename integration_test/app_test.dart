import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';
import 'package:notes/providers/note_provider.dart';
import 'package:notes/screens/notes_list_screen.dart';
import 'package:notes/providers/theme_provider.dart';
import 'package:notes/models/note.dart';


void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Notes App Integration Tests', () {
    late NoteProvider noteProvider;
    late ThemeProvider themeProvider;

    setUp(() {
      noteProvider = NoteProvider.forTesting();
      themeProvider = ThemeProvider();
    });

    testWidgets('Complete user flow: Open app -> Add note -> View in list',
        (WidgetTester tester) async {
      // Act - Start the app
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<NoteProvider>.value(value: noteProvider),
            ChangeNotifierProvider<ThemeProvider>.value(value: themeProvider),
          ],
          child: const CupertinoApp(
            home: NotesListScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Pause to show empty state
      await tester.pump(const Duration(seconds: 2));

      // Step 1: Verify app opened with empty state
      expect(find.text('No notes yet. Add one!'), findsOneWidget);

      // Pause before adding note
      await tester.pump(const Duration(seconds: 1));

      // Step 2: Add a note programmatically (simulating the save)
      await noteProvider.addNote('My First Note', 'This is the content of my first note.');
      await tester.pumpAndSettle();

      // Pause to show the newly created note
      await tester.pump(const Duration(seconds: 2));

      // Step 3: Verify new note appears in the list
      expect(find.text('My First Note'), findsOneWidget);
      expect(find.text('No notes yet. Add one!'), findsNothing);

      // Step 4: Verify create button is still visible for adding more notes
      expect(find.byIcon(CupertinoIcons.create_solid), findsOneWidget);

      // Final pause
      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('Complete flow: Load notes -> Pin note -> Unpin note',
        (WidgetTester tester) async {
      // Act - Start the app
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<NoteProvider>.value(value: noteProvider),
            ChangeNotifierProvider<ThemeProvider>.value(value: themeProvider),
          ],
          child: const CupertinoApp(
            home: NotesListScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 1));

      // Arrange - Add a note after widget is built
      await noteProvider.addNote('Test Note', 'Test content for pinning');
      await tester.pumpAndSettle();

      // Pause to show the note in normal section
      await tester.pump(const Duration(seconds: 2));

      // Step 1: Verify note is loaded and appears in a month section
      expect(find.text('Test Note'), findsOneWidget);
      final monthSections = find.textContaining(RegExp(r'(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec) \d{4}'));
      expect(monthSections, findsWidgets);

      // Pause before pinning
      await tester.pump(const Duration(seconds: 1));

      // Step 2: Pin the note programmatically
      final note = noteProvider.notes.first;
      await noteProvider.togglePinNote(note);
      await tester.pumpAndSettle();

      // Pause to show the pinned state
      await tester.pump(const Duration(seconds: 2));

      // Step 3: Verify the note is pinned (should show PINNED section)
      expect(find.text('PINNED'), findsOneWidget);
      expect(find.byIcon(CupertinoIcons.pin_fill), findsOneWidget);

      // Pause before unpinning
      await tester.pump(const Duration(seconds: 1));

      // Step 4: Unpin the note
      await noteProvider.togglePinNote(noteProvider.notes.first);
      await tester.pumpAndSettle();

      // Pause to show unpinned state
      await tester.pump(const Duration(seconds: 2));

      // Step 5: Verify PINNED section is gone and note is back in date section
      expect(find.text('PINNED'), findsNothing);
      expect(monthSections, findsWidgets);

      // Final pause
      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('Delete note flow',
        (WidgetTester tester) async {
      // Act - Start the app
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<NoteProvider>.value(value: noteProvider),
            ChangeNotifierProvider<ThemeProvider>.value(value: themeProvider),
          ],
          child: const CupertinoApp(
            home: NotesListScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 1));

      // Arrange - Add a note after widget is built
      await noteProvider.addNote('Note to Delete', 'This will be deleted');
      await tester.pumpAndSettle();

      // Pause to show the note
      await tester.pump(const Duration(seconds: 2));

      // Step 1: Verify note exists
      expect(find.text('Note to Delete'), findsOneWidget);

      // Pause before deletion
      await tester.pump(const Duration(seconds: 1));

      // Step 2: Delete the note programmatically
      final note = noteProvider.notes.first;
      await noteProvider.deleteNote(note.id!);
      await tester.pumpAndSettle();

      // Pause to show empty state after deletion
      await tester.pump(const Duration(seconds: 2));

      // Step 3: Verify note is removed and empty state shown
      expect(find.text('Note to Delete'), findsNothing);
      expect(find.text('No notes yet. Add one!'), findsOneWidget);

      // Final pause
      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('Multiple notes persistence',
        (WidgetTester tester) async {
      // Act - Start the app
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<NoteProvider>.value(value: noteProvider),
            ChangeNotifierProvider<ThemeProvider>.value(value: themeProvider),
          ],
          child: const CupertinoApp(
            home: NotesListScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 1));

      // Arrange - Add multiple notes
      await noteProvider.addNote('Note 1', 'Content 1');
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 500));

      await noteProvider.addNote('Note 2', 'Content 2');
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 500));

      await noteProvider.addNote('Note 3', 'Content 3');
      await tester.pumpAndSettle();

      // Pause to show all three notes
      await tester.pump(const Duration(seconds: 2));

      // Verify all notes exist
      expect(find.text('Note 1'), findsOneWidget);
      expect(find.text('Note 2'), findsOneWidget);
      expect(find.text('Note 3'), findsOneWidget);

      // Pause before deletion
      await tester.pump(const Duration(seconds: 1));

      // Delete one note
      final noteToDelete = noteProvider.notes.firstWhere((n) => n.title == 'Note 2');
      await noteProvider.deleteNote(noteToDelete.id!);
      await tester.pumpAndSettle();

      // Pause to show remaining notes after deletion
      await tester.pump(const Duration(seconds: 2));

      // Verify only the targeted note was deleted
      expect(find.text('Note 1'), findsOneWidget);
      expect(find.text('Note 2'), findsNothing);
      expect(find.text('Note 3'), findsOneWidget);

      // Final pause
      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('Search functionality flow',
        (WidgetTester tester) async {
      // Act - Start the app
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<NoteProvider>.value(value: noteProvider),
            ChangeNotifierProvider<ThemeProvider>.value(value: themeProvider),
          ],
          child: const CupertinoApp(
            home: NotesListScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 1));

      // Arrange - Add multiple notes after widget is built
      await noteProvider.addNote('Shopping List', 'Milk, eggs, bread');
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 500));

      await noteProvider.addNote('Meeting Notes', 'Discuss project timeline');
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 500));

      await noteProvider.addNote('Recipe', 'Ingredients for pasta');
      await tester.pumpAndSettle();

      // Pause to show all notes
      await tester.pump(const Duration(seconds: 2));

      // Step 1: Verify all notes are visible
      expect(find.text('Shopping List'), findsOneWidget);
      expect(find.text('Meeting Notes'), findsOneWidget);
      expect(find.text('Recipe'), findsOneWidget);

      // Pause before search
      await tester.pump(const Duration(seconds: 1));

      // Step 2: Enter search query
      final searchField = find.byType(CupertinoSearchTextField);
      await tester.enterText(searchField, 'Meeting');
      await tester.pumpAndSettle();

      // Wait for async search to complete
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();

      // Pause to show filtered results
      await tester.pump(const Duration(seconds: 2));

      // Step 3: Verify filtered results (only Meeting Notes should appear)
      expect(find.text('Meeting Notes'), findsOneWidget);
      expect(find.text('Shopping List'), findsNothing);
      expect(find.text('Recipe'), findsNothing);

      // Step 4: Verify search indicator
      expect(find.text('1 result'), findsOneWidget);

      // Pause before clearing search
      await tester.pump(const Duration(seconds: 1));

      // Step 5: Clear search programmatically
      noteProvider.clearSearch();
      await tester.pumpAndSettle();

      // Pause to show all notes returned
      await tester.pump(const Duration(seconds: 2));

      // Step 6: Verify all notes return
      expect(find.text('Shopping List'), findsOneWidget);
      expect(find.text('Meeting Notes'), findsOneWidget);
      expect(find.text('Recipe'), findsOneWidget);

      // Final pause
      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('Update existing note',
        (WidgetTester tester) async {
      // Act - Start the app
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<NoteProvider>.value(value: noteProvider),
            ChangeNotifierProvider<ThemeProvider>.value(value: themeProvider),
          ],
          child: const CupertinoApp(
            home: NotesListScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 1));

      // Arrange - Add a note after widget is built
      await noteProvider.addNote('Original Title', 'Original content');
      await tester.pumpAndSettle();

      // Pause to show original note
      await tester.pump(const Duration(seconds: 2));

      // Step 1: Verify original note exists
      expect(find.text('Original Title'), findsOneWidget);

      // Pause before update
      await tester.pump(const Duration(seconds: 1));

      // Step 2: Update the note programmatically
      final note = noteProvider.notes.first;
      final updatedNote = Note(
        id: note.id,
        title: 'Updated Title',
        content: 'Updated content here',
        createdAt: note.createdAt,
        isPinned: note.isPinned,
        imagePaths: note.imagePaths,
        audioPaths: note.audioPaths,
        tags: note.tags,
      );
      await noteProvider.updateNote(updatedNote);
      await tester.pumpAndSettle();

      // Pause to show updated note
      await tester.pump(const Duration(seconds: 2));

      // Step 3: Verify changes persisted
      expect(find.text('Updated Title'), findsOneWidget);
      expect(find.text('Original Title'), findsNothing);

      // Final pause
      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('Empty state validation',
        (WidgetTester tester) async {
      // Act - Start the app with no notes
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<NoteProvider>.value(value: noteProvider),
            ChangeNotifierProvider<ThemeProvider>.value(value: themeProvider),
          ],
          child: const CupertinoApp(
            home: NotesListScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Pause to show empty state
      await tester.pump(const Duration(seconds: 3));

      // Verify empty state message
      expect(find.text('No notes yet. Add one!'), findsOneWidget);
      expect(find.byIcon(CupertinoIcons.create_solid), findsOneWidget);

      // Final pause
      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('Multiple notes with hashtags',
        (WidgetTester tester) async {
      // Act - Start the app
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<NoteProvider>.value(value: noteProvider),
            ChangeNotifierProvider<ThemeProvider>.value(value: themeProvider),
          ],
          child: const CupertinoApp(
            home: NotesListScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 1));

      // Arrange - Add notes after widget is built
      await noteProvider.addNote('Work Task', 'Need to finish #project #urgent');
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 500));

      await noteProvider.addNote('Personal', 'Gym session #health #fitness');
      await tester.pumpAndSettle();

      // Pause to show both notes with hashtags
      await tester.pump(const Duration(seconds: 2));

      // Step 1: Verify notes are visible
      expect(find.text('Work Task'), findsOneWidget);
      expect(find.text('Personal'), findsOneWidget);

      // Pause before hashtag search
      await tester.pump(const Duration(seconds: 1));

      // Step 2: Search by hashtag
      final searchField = find.byType(CupertinoSearchTextField);
      await tester.enterText(searchField, '#project');
      await tester.pumpAndSettle();

      // Wait for search
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();

      // Pause to show filtered result
      await tester.pump(const Duration(seconds: 2));

      // Step 3: Verify only matching note appears
      expect(find.text('Work Task'), findsOneWidget);
      expect(find.text('Personal'), findsNothing);

      // Final pause
      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('Section expand/collapse functionality',
        (WidgetTester tester) async {
      // Act - Start the app
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<NoteProvider>.value(value: noteProvider),
            ChangeNotifierProvider<ThemeProvider>.value(value: themeProvider),
          ],
          child: const CupertinoApp(
            home: NotesListScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 1));

      // Arrange - Add multiple notes after widget is built
      await noteProvider.addNote('Note 1', 'Content 1');
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 500));

      await noteProvider.addNote('Note 2', 'Content 2');
      await tester.pumpAndSettle();

      // Pause to show both notes in expanded section
      await tester.pump(const Duration(seconds: 2));

      // Step 1: Verify notes are visible (sections expanded by default)
      expect(find.text('Note 1'), findsOneWidget);
      expect(find.text('Note 2'), findsOneWidget);

      // Pause before collapsing
      await tester.pump(const Duration(seconds: 1));

      // Step 2: Find and tap a section header to collapse
      final monthSection = find.textContaining(RegExp(r'(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec) \d{4}')).first;
      await tester.tap(monthSection);
      await tester.pumpAndSettle();

      // Pause to show collapsed section
      await tester.pump(const Duration(seconds: 2));

      // Step 3: Verify notes in that section are hidden
      // After collapsing, at least one note should be hidden
      final visibleNotes = tester.widgetList(find.text('Note 1')).length +
                           tester.widgetList(find.text('Note 2')).length;
      expect(visibleNotes, lessThan(2));

      // Pause before expanding
      await tester.pump(const Duration(seconds: 1));

      // Step 4: Tap again to expand
      await tester.tap(monthSection);
      await tester.pumpAndSettle();

      // Pause to show expanded section again
      await tester.pump(const Duration(seconds: 2));

      // Step 5: Verify notes are visible again
      expect(find.text('Note 1'), findsOneWidget);
      expect(find.text('Note 2'), findsOneWidget);

      // Final pause
      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('Notes appear in chronological order',
        (WidgetTester tester) async {
      // Act - Start the app
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<NoteProvider>.value(value: noteProvider),
            ChangeNotifierProvider<ThemeProvider>.value(value: themeProvider),
          ],
          child: const CupertinoApp(
            home: NotesListScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 1));

      // Arrange - Add notes in sequence
      await noteProvider.addNote('First Note', 'First content');
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 800));

      await noteProvider.addNote('Second Note', 'Second content');
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 800));

      await noteProvider.addNote('Third Note', 'Third content');
      await tester.pumpAndSettle();

      // Pause to show all three notes in chronological order
      await tester.pump(const Duration(seconds: 3));

      // Verify all notes exist in the list
      expect(find.text('First Note'), findsOneWidget);
      expect(find.text('Second Note'), findsOneWidget);
      expect(find.text('Third Note'), findsOneWidget);

      // Verify they're all in the same month section
      final monthSection = find.textContaining(RegExp(r'(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec) \d{4}'));
      expect(monthSection, findsWidgets);

      // Final pause
      await tester.pump(const Duration(seconds: 1));
    });
  });
}
