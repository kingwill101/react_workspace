import 'package:react_actions/react_actions.dart';
import 'package:react_server/react_server.dart';

import 'todos_contract.dart';

// ---------------------------------------------------------------------------
// In-memory store — simulates a real database for the example.
// ---------------------------------------------------------------------------

final List<TodoItem> _todos = [
  const TodoItem(id: '1', title: 'Learn React Dart', completed: true),
  const TodoItem(id: '2', title: 'Build server functions', completed: true),
  const TodoItem(id: '3', title: 'Write integration test', completed: false),
  const TodoItem(id: '4', title: 'Deploy to production', completed: false),
];

// ---------------------------------------------------------------------------
// Server functions
// ---------------------------------------------------------------------------

/// Lists todos, with optional completed filter.
@serverFunction
Future<TodoListResult> listTodos(
  ServerFunctionContext context, {
  required bool? completedFilter,
}) async {
  // Simulate async I/O
  await Future.delayed(const Duration(milliseconds: 10));

  final items = completedFilter != null
      ? _todos.where((t) => t.completed == completedFilter).toList()
      : List<TodoItem>.of(_todos);

  return TodoListResult(items: items, total: _todos.length);
}

/// Toggles the completed state of a todo.
@serverFunction
Future<TodoItem> toggleTodo(
  ServerFunctionContext context, {
  required String todoId,
  required bool completed,
}) async {
  // Simulate async I/O
  await Future.delayed(const Duration(milliseconds: 15));

  final index = _todos.indexWhere((t) => t.id == todoId);
  if (index == -1) {
    throw ServerFunctionFailure(
      code: 'todo_not_found',
      message: 'Todo with id "$todoId" not found.',
      statusCode: 404,
    );
  }

  final updated = TodoItem(
    id: todoId,
    title: _todos[index].title,
    completed: completed,
  );
  _todos[index] = updated;
  return updated;
}

/// Adds a new todo.
@serverFunction
Future<TodoItem> addTodo(
  ServerFunctionContext context, {
  required String title,
}) async {
  await Future.delayed(const Duration(milliseconds: 10));

  if (title.trim().isEmpty) {
    throw ServerFunctionFailure(
      code: 'invalid_title',
      message: 'Todo title must not be empty.',
      statusCode: 422,
    );
  }

  final id = (_todos.length + 1).toString();
  final todo = TodoItem(id: id, title: title.trim(), completed: false);
  _todos.add(todo);
  return todo;
}
