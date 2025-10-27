import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:integration_test/integration_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:notes/data/services/todo_api_service.dart';
import 'package:notes/presentation/pages/todo_list_page.dart';
import 'package:notes/presentation/providers/todo_provider.dart';

// Reuse mocks from test directory
import '../test/unit/todo_api_service_test.mocks.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Todo App Integration Tests', () {
    late MockClient mockClient;
    late TodoApiService todoApiService;
    late TodoProvider todoProvider;

    setUp(() {
      mockClient = MockClient();
      todoApiService = TodoApiService(client: mockClient);
      todoProvider = TodoProvider(apiService: todoApiService);
    });

    testWidgets('Complete user flow: Open app -> Add todo -> View in list',
        (WidgetTester tester) async {
      // Arrange - Mock initial empty list
      when(mockClient.get(
        Uri.parse('https://jsonplaceholder.typicode.com/todos'),
        headers: {'Content-Type': 'application/json'},
      )).thenAnswer((_) async => http.Response('[]', 200));

      // Mock create todo response
      when(mockClient.post(
        Uri.parse('https://jsonplaceholder.typicode.com/todos'),
        headers: {'Content-Type': 'application/json'},
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(
            json.encode({
              'id': 201,
              'userId': 1,
              'title': 'Integration Test Todo',
              'completed': false,
            }),
            201,
          ));

      // Act - Start the app
      await tester.pumpWidget(
        ChangeNotifierProvider<TodoProvider>.value(
          value: todoProvider,
          child: const MaterialApp(
            home: TodoListPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Step 1: Verify app opened with empty state
      expect(find.byKey(const Key('empty_state')), findsOneWidget);
      expect(find.text('No todos yet. Add one!'), findsOneWidget);

      // Step 2: Click add button (FAB)
      await tester.tap(find.byKey(const Key('add_todo_fab')));
      await tester.pumpAndSettle();

      // Verify dialog opened
      expect(find.text('Add New Todo'), findsOneWidget);

      // Step 3: Enter text in input field
      await tester.enterText(
        find.byKey(const Key('todo_input_field')),
        'Integration Test Todo',
      );
      await tester.pumpAndSettle();

      // Step 4: Click save/add button
      await tester.tap(find.byKey(const Key('add_button')));
      await tester.pumpAndSettle();

      // Step 5: Verify dialog closed and returned to list
      expect(find.text('Add New Todo'), findsNothing);

      // Step 6: Verify new item appears in the list
      expect(find.text('Integration Test Todo'), findsOneWidget);
      expect(find.byKey(const Key('empty_state')), findsNothing);

      // Verify the todo item widget is displayed
      expect(find.byKey(const Key('todo_item_0')), findsOneWidget);
    });

    testWidgets('Complete flow: Load todos -> Toggle completion -> Delete todo',
        (WidgetTester tester) async {
      // Arrange - Mock initial list with one todo
      final initialTodos = [
        {
          'id': 1,
          'userId': 1,
          'title': 'Test Todo Item',
          'completed': false,
        },
      ];

      when(mockClient.get(
        Uri.parse('https://jsonplaceholder.typicode.com/todos'),
        headers: {'Content-Type': 'application/json'},
      )).thenAnswer((_) async => http.Response(
            json.encode(initialTodos),
            200,
          ));

      // Act - Start the app
      await tester.pumpWidget(
        ChangeNotifierProvider<TodoProvider>.value(
          value: todoProvider,
          child: const MaterialApp(
            home: TodoListPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Step 1: Verify todo is loaded
      expect(find.text('Test Todo Item'), findsOneWidget);

      // Step 2: Verify initial state (uncompleted)
      final initialCheckbox = tester.widget<Checkbox>(
        find.byKey(const Key('checkbox_1')),
      );
      expect(initialCheckbox.value, false);

      // Step 3: Toggle completion
      await tester.tap(find.byKey(const Key('checkbox_1')));
      await tester.pumpAndSettle();

      // Verify checkbox is now checked
      final updatedCheckbox = tester.widget<Checkbox>(
        find.byKey(const Key('checkbox_1')),
      );
      expect(updatedCheckbox.value, true);

      // Step 4: Delete the todo
      await tester.tap(find.byKey(const Key('delete_1')));
      await tester.pumpAndSettle();

      // Step 5: Verify todo is removed and empty state is shown
      expect(find.text('Test Todo Item'), findsNothing);
      expect(find.byKey(const Key('empty_state')), findsOneWidget);
    });

    testWidgets('Error handling flow: API error -> Retry -> Success',
        (WidgetTester tester) async {
      // Arrange - Mock initial error
      when(mockClient.get(
        Uri.parse('https://jsonplaceholder.typicode.com/todos'),
        headers: {'Content-Type': 'application/json'},
      )).thenAnswer((_) async => http.Response('Server Error', 500));

      // Act - Start the app
      await tester.pumpWidget(
        ChangeNotifierProvider<TodoProvider>.value(
          value: todoProvider,
          child: const MaterialApp(
            home: TodoListPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Step 1: Verify error is displayed
      expect(find.byKey(const Key('error_text')), findsOneWidget);
      expect(find.byKey(const Key('retry_button')), findsOneWidget);

      // Step 2: Mock successful response for retry
      when(mockClient.get(
        Uri.parse('https://jsonplaceholder.typicode.com/todos'),
        headers: {'Content-Type': 'application/json'},
      )).thenAnswer((_) async => http.Response(
            json.encode([
              {
                'id': 1,
                'userId': 1,
                'title': 'Retry Success Todo',
                'completed': false,
              }
            ]),
            200,
          ));

      // Step 3: Click retry button
      await tester.tap(find.byKey(const Key('retry_button')));
      await tester.pumpAndSettle();

      // Step 4: Verify todos loaded successfully
      expect(find.byKey(const Key('error_text')), findsNothing);
      expect(find.text('Retry Success Todo'), findsOneWidget);
    });

    testWidgets('Multiple todos flow: Add multiple -> Verify all displayed',
        (WidgetTester tester) async {
      // Arrange - Mock initial empty list
      when(mockClient.get(
        Uri.parse('https://jsonplaceholder.typicode.com/todos'),
        headers: {'Content-Type': 'application/json'},
      )).thenAnswer((_) async => http.Response('[]', 200));

      // Mock create todo responses
      int todoId = 201;
      when(mockClient.post(
        Uri.parse('https://jsonplaceholder.typicode.com/todos'),
        headers: {'Content-Type': 'application/json'},
        body: anyNamed('body'),
      )).thenAnswer((invocation) async {
        // Parse the body to get the actual title
        final body = invocation.namedArguments[const Symbol('body')] as String;
        final bodyJson = json.decode(body) as Map<String, dynamic>;
        final actualTitle = bodyJson['title'] as String;
        
        final response = {
          'id': todoId,
          'userId': 1,
          'title': actualTitle,
          'completed': false,
        };
        todoId++;
        return http.Response(json.encode(response), 201);
      });

      // Act - Start the app
      await tester.pumpWidget(
        ChangeNotifierProvider<TodoProvider>.value(
          value: todoProvider,
          child: const MaterialApp(
            home: TodoListPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Add first todo
      await tester.tap(find.byKey(const Key('add_todo_fab')));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const Key('todo_input_field')),
        'First Todo',
      );
      await tester.tap(find.byKey(const Key('add_button')));
      await tester.pumpAndSettle();

      // Add second todo
      await tester.tap(find.byKey(const Key('add_todo_fab')));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const Key('todo_input_field')),
        'Second Todo',
      );
      await tester.tap(find.byKey(const Key('add_button')));
      await tester.pumpAndSettle();

      // Add third todo
      await tester.tap(find.byKey(const Key('add_todo_fab')));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const Key('todo_input_field')),
        'Third Todo',
      );
      await tester.tap(find.byKey(const Key('add_button')));
      await tester.pumpAndSettle();

      // Verify all todos are displayed
      expect(find.text('First Todo'), findsOneWidget);
      expect(find.text('Second Todo'), findsOneWidget);
      expect(find.text('Third Todo'), findsOneWidget);

      // Verify list has 3 items
      expect(find.byKey(const Key('todo_item_0')), findsOneWidget);
      expect(find.byKey(const Key('todo_item_1')), findsOneWidget);
      expect(find.byKey(const Key('todo_item_2')), findsOneWidget);
    });

    testWidgets('Dialog cancel flow: Open dialog -> Cancel -> No changes',
        (WidgetTester tester) async {
      // Arrange
      when(mockClient.get(
        Uri.parse('https://jsonplaceholder.typicode.com/todos'),
        headers: {'Content-Type': 'application/json'},
      )).thenAnswer((_) async => http.Response('[]', 200));

      // Act - Start the app
      await tester.pumpWidget(
        ChangeNotifierProvider<TodoProvider>.value(
          value: todoProvider,
          child: const MaterialApp(
            home: TodoListPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Step 1: Open dialog
      await tester.tap(find.byKey(const Key('add_todo_fab')));
      await tester.pumpAndSettle();

      // Step 2: Enter some text
      await tester.enterText(
        find.byKey(const Key('todo_input_field')),
        'Cancelled Todo',
      );
      await tester.pumpAndSettle();

      // Step 3: Click cancel button
      await tester.tap(find.byKey(const Key('cancel_button')));
      await tester.pumpAndSettle();

      // Step 4: Verify dialog closed and no todo was added
      expect(find.text('Add New Todo'), findsNothing);
      expect(find.text('Cancelled Todo'), findsNothing);
      expect(find.byKey(const Key('empty_state')), findsOneWidget);
    });

    testWidgets('Validation flow: Open dialog -> Submit empty -> Show error',
        (WidgetTester tester) async {
      // Arrange
      when(mockClient.get(
        Uri.parse('https://jsonplaceholder.typicode.com/todos'),
        headers: {'Content-Type': 'application/json'},
      )).thenAnswer((_) async => http.Response('[]', 200));

      // Act - Start the app
      await tester.pumpWidget(
        ChangeNotifierProvider<TodoProvider>.value(
          value: todoProvider,
          child: const MaterialApp(
            home: TodoListPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Step 1: Open dialog
      await tester.tap(find.byKey(const Key('add_todo_fab')));
      await tester.pumpAndSettle();

      // Step 2: Don't enter any text, just click add
      await tester.tap(find.byKey(const Key('add_button')));
      await tester.pumpAndSettle();

      // Step 3: Verify validation error is shown
      expect(find.text('Please enter a todo title'), findsOneWidget);

      // Step 4: Verify dialog is still open
      expect(find.text('Add New Todo'), findsOneWidget);

      // Step 5: Now enter valid text
      await tester.enterText(
        find.byKey(const Key('todo_input_field')),
        '   ',
      ); // Just spaces
      await tester.tap(find.byKey(const Key('add_button')));
      await tester.pumpAndSettle();

      // Step 6: Verify validation error still shown (trimmed to empty)
      expect(find.text('Please enter a todo title'), findsOneWidget);
    });
  });
}
