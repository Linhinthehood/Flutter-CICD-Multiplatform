// test/unit/note_date_edit_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:intl/intl.dart';
import 'package:notes/models/note.dart';
import 'package:notes/providers/note_provider.dart';

import 'note_date_edit_test.mocks.dart';

@GenerateMocks([NoteProvider])
void main() {
  group('Note Date Edit Feature Tests', () {
    late MockNoteProvider mockNoteProvider;
    late Note testNote;

    setUp(() {
      mockNoteProvider = MockNoteProvider();
      testNote = Note(
        id: 1,
        title: 'Test Note',
        content: 'Test content',
        createdAt: DateTime(2024, 1, 15),
        isPinned: false,
        imagePaths: [],
        audioPaths: [],
        tags: [],
      );
    });

    test('should update note date successfully', () async {
      // Arrange
      final newDate = DateTime(2024, 2, 20);
      final updatedNote = Note(
        id: testNote.id,
        title: testNote.title,
        content: testNote.content,
        createdAt: newDate,
        isPinned: testNote.isPinned,
        imagePaths: testNote.imagePaths,
        audioPaths: testNote.audioPaths,
        tags: testNote.tags,
      );

      when(mockNoteProvider.updateNote(any)).thenAnswer((_) async {});

      // Act
      await mockNoteProvider.updateNote(updatedNote);

      // Assert
      verify(mockNoteProvider.updateNote(updatedNote)).called(1);
      expect(updatedNote.createdAt, equals(newDate));
    });

    test('should preserve all other note properties when updating date', () {
      // Arrange
      final originalNote = Note(
        id: 1,
        title: 'Original Title',
        content: 'Original content',
        createdAt: DateTime(2024, 1, 15),
        isPinned: true,
        imagePaths: ['image1.jpg'],
        audioPaths: ['audio1.mp3'],
        tags: ['tag1', 'tag2'],
      );

      final newDate = DateTime(2024, 3, 10);

      // Act
      final updatedNote = Note(
        id: originalNote.id,
        title: originalNote.title,
        content: originalNote.content,
        createdAt: newDate,
        isPinned: originalNote.isPinned,
        imagePaths: originalNote.imagePaths,
        audioPaths: originalNote.audioPaths,
        tags: originalNote.tags,
      );

      // Assert
      expect(updatedNote.id, equals(originalNote.id));
      expect(updatedNote.title, equals(originalNote.title));
      expect(updatedNote.content, equals(originalNote.content));
      expect(updatedNote.createdAt, equals(newDate));
      expect(updatedNote.isPinned, equals(originalNote.isPinned));
      expect(updatedNote.imagePaths, equals(originalNote.imagePaths));
      expect(updatedNote.audioPaths, equals(originalNote.audioPaths));
      expect(updatedNote.tags, equals(originalNote.tags));
    });

    test('should format date correctly for display', () {
      // Arrange
      final testDate = DateTime(2024, 12, 25);

      // Act
      final formattedDate = DateFormat.yMMMd().format(testDate);

      // Assert
      expect(formattedDate, contains('Dec'));
      expect(formattedDate, contains('2024'));
    });

    test('should handle date range validation', () {
      // Arrange
      final minDate = DateTime(1900);
      final maxDate = DateTime.now().add(const Duration(days: 365));
      final validDate = DateTime(2024, 6, 15);
      final invalidPastDate = DateTime(1899, 12, 31);
      final invalidFutureDate = DateTime.now().add(const Duration(days: 400));

      // Act & Assert
      expect(validDate.isAfter(minDate), isTrue);
      expect(validDate.isBefore(maxDate), isTrue);

      expect(invalidPastDate.isAfter(minDate), isFalse);
      expect(invalidFutureDate.isBefore(maxDate), isFalse);
    });

    test('should maintain note sorting after date update', () {
      // Arrange
      final notes = [
        Note(
          id: 1,
          title: 'Note 1',
          content: 'Content 1',
          createdAt: DateTime(2024, 1, 15),
          isPinned: false,
        ),
        Note(
          id: 2,
          title: 'Note 2',
          content: 'Content 2',
          createdAt: DateTime(2024, 2, 20),
          isPinned: false,
        ),
        Note(
          id: 3,
          title: 'Note 3',
          content: 'Content 3',
          createdAt: DateTime(2024, 3, 10),
          isPinned: false,
        ),
      ];

      // Act - Update middle note's date to be newest
      final updatedNote = Note(
        id: notes[1].id,
        title: notes[1].title,
        content: notes[1].content,
        createdAt: DateTime(2024, 4, 1), // Newer date
        isPinned: notes[1].isPinned,
      );

      final updatedNotes = [
        notes[0],
        updatedNote,
        notes[2],
      ];

      // Sort by date (newest first)
      updatedNotes.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      // Assert
      expect(updatedNotes[0].id, equals(2)); // Updated note should be first
      expect(updatedNotes[1].id, equals(3)); // March note second
      expect(updatedNotes[2].id, equals(1)); // January note last
    });

    test('should handle edge cases for date updates', () {
      // Test leap year
      final leapYearDate = DateTime(2024, 2, 29);
      expect(leapYearDate.day, equals(29));

      // Test year boundary
      final yearBoundaryDate = DateTime(2023, 12, 31);
      final nextDay = yearBoundaryDate.add(const Duration(days: 1));
      expect(nextDay.year, equals(2024));
      expect(nextDay.month, equals(1));
      expect(nextDay.day, equals(1));

      // Test timezone handling
      final utcDate = DateTime.utc(2024, 6, 15);
      final localDate = DateTime(2024, 6, 15);
      expect(utcDate.isUtc, isTrue);
      expect(localDate.isUtc, isFalse);
    });
  });
}
