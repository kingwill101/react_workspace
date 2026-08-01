import 'package:react_actions/react_actions.dart';

/// A single todo item returned by server functions.
@serverData
final class TodoItem {
  final String id;
  final String title;
  final bool completed;

  const TodoItem({
    required this.id,
    required this.title,
    required this.completed,
  });
}

/// Result of listing todos, with total count for pagination.
@serverData
final class TodoListResult {
  final List<TodoItem> items;
  final int total;

  const TodoListResult({
    required this.items,
    required this.total,
  });
}
