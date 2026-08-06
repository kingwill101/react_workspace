// GENERATED CODE - DO NOT EDIT
// ignore_for_file: type=lint

import 'package:react_actions/react_actions.dart';
import 'todos_contract.dart';

// ------------------------------------------------------------------
// Codecs
// ------------------------------------------------------------------

final class _$listTodos_argsCodec extends ServerFunctionJsonCodec<({bool? completedFilter})> {
  @override
  ({bool? completedFilter}) decode(dynamic json) {
    if (json == null || json is! Map) json = <String, dynamic>{};
    final m = json as Map<String, dynamic>;
    final completedFilter = m['completedFilter'] as bool?;
    return (completedFilter: completedFilter);
  }

  @override
  Map<String, dynamic> encode(({bool? completedFilter}) value) {
    return {
      'completedFilter': value.completedFilter,
    };
  }
}


final class _$listTodos_resultCodec extends ServerFunctionJsonCodec<TodoListResult> {
  @override
  TodoListResult decode(dynamic json) {
    return switch (json) { dynamic m when m is Map<String, dynamic> => TodoListResult(items: (m['items'] as List?)?.map<TodoItem>((__e) => switch (__e) { dynamic m when m is Map<String, dynamic> => TodoItem(id: m['id'] as String, title: m['title'] as String, completed: m['completed'] as bool), _ => throw ArgumentError('Expected a JSON object') }).toList() ?? <TodoItem>[], total: (m['total'] as num).toInt()), _ => throw ArgumentError('Expected a JSON object') };
  }
  @override
  dynamic encode(TodoListResult value) {
    return {'items': value.items.map((__e) => {'id': __e.id, 'title': __e.title, 'completed': __e.completed}).toList(), 'total': value.total};
  }
}


final class _$toggleTodo_argsCodec extends ServerFunctionJsonCodec<({String todoId, bool completed})> {
  @override
  ({String todoId, bool completed}) decode(dynamic json) {
    if (json == null || json is! Map) json = <String, dynamic>{};
    final m = json as Map<String, dynamic>;
    final todoId = m['todoId'] as String;
    final completed = m['completed'] as bool;
    return (todoId: todoId, completed: completed);
  }

  @override
  Map<String, dynamic> encode(({String todoId, bool completed}) value) {
    return {
      'todoId': value.todoId,
      'completed': value.completed,
    };
  }
}


final class _$toggleTodo_resultCodec extends ServerFunctionJsonCodec<TodoItem> {
  @override
  TodoItem decode(dynamic json) {
    return switch (json) { dynamic m when m is Map<String, dynamic> => TodoItem(id: m['id'] as String, title: m['title'] as String, completed: m['completed'] as bool), _ => throw ArgumentError('Expected a JSON object') };
  }
  @override
  dynamic encode(TodoItem value) {
    return {'id': value.id, 'title': value.title, 'completed': value.completed};
  }
}


final class _$addTodo_argsCodec extends ServerFunctionJsonCodec<({String title})> {
  @override
  ({String title}) decode(dynamic json) {
    if (json == null || json is! Map) json = <String, dynamic>{};
    final m = json as Map<String, dynamic>;
    final title = m['title'] as String;
    return (title: title);
  }

  @override
  Map<String, dynamic> encode(({String title}) value) {
    return {
      'title': value.title,
    };
  }
}


final class _$addTodo_resultCodec extends ServerFunctionJsonCodec<TodoItem> {
  @override
  TodoItem decode(dynamic json) {
    return switch (json) { dynamic m when m is Map<String, dynamic> => TodoItem(id: m['id'] as String, title: m['title'] as String, completed: m['completed'] as bool), _ => throw ArgumentError('Expected a JSON object') };
  }
  @override
  dynamic encode(TodoItem value) {
    return {'id': value.id, 'title': value.title, 'completed': value.completed};
  }
}


// ------------------------------------------------------------------
// Refs
// ------------------------------------------------------------------

final listTodosRef = ServerFunctionRef<
  ({bool? completedFilter}), TodoListResult>(
  id: ServerFunctionId('package:example/todos/todos_actions.dart#listTodos'),
  contractHash: 'a98421d61d8f41d765dc363f189a5aa02f0dada0875b89fba5b5d1d7e02e08d6',
  argumentsCodec: _$listTodos_argsCodec(),
  resultCodec: _$listTodos_resultCodec(),
);

final toggleTodoRef = ServerFunctionRef<
  ({String todoId, bool completed}), TodoItem>(
  id: ServerFunctionId('package:example/todos/todos_actions.dart#toggleTodo'),
  contractHash: '02956b4c85d72150668042cd2375146e0bacfea5968c7ca3a729f8636fcfbc92',
  argumentsCodec: _$toggleTodo_argsCodec(),
  resultCodec: _$toggleTodo_resultCodec(),
);

final addTodoRef = ServerFunctionRef<
  ({String title}), TodoItem>(
  id: ServerFunctionId('package:example/todos/todos_actions.dart#addTodo'),
  contractHash: '759e5196f42593181f1c607271d94521a1ffe704b5a50ef5b969ef1881c0ebaf',
  argumentsCodec: _$addTodo_argsCodec(),
  resultCodec: _$addTodo_resultCodec(),
);

