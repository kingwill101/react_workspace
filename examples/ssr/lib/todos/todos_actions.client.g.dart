// GENERATED CODE - DO NOT EDIT

import 'package:react_actions/react_actions.dart';
import 'todos_actions.action.g.dart';
import 'todos_contract.dart';

/// Invokes the server function `#listTodos`.
///
/// Must be called from within a browser context where a
/// [ServerFunctionClient] has been configured via
/// `runWithServerFunctionClient`.
///
/// Throws [RemoteServerFunctionException] on server errors,
/// [ServerFunctionTransportException] on network failures.
Future<TodoListResult> listTodosAction({
  required bool? completedFilter,
}) async {
  final client = currentServerFunctionClient;
  return client.invoke(
    listTodosRef,
    (completedFilter: completedFilter),
  );
}

/// Invokes the server function `#toggleTodo`.
///
/// Must be called from within a browser context where a
/// [ServerFunctionClient] has been configured via
/// `runWithServerFunctionClient`.
///
/// Throws [RemoteServerFunctionException] on server errors,
/// [ServerFunctionTransportException] on network failures.
Future<TodoItem> toggleTodoAction({
  required String todoId,
  required bool completed,
}) async {
  final client = currentServerFunctionClient;
  return client.invoke(
    toggleTodoRef,
    (todoId: todoId, completed: completed),
  );
}

/// Invokes the server function `#addTodo`.
///
/// Must be called from within a browser context where a
/// [ServerFunctionClient] has been configured via
/// `runWithServerFunctionClient`.
///
/// Throws [RemoteServerFunctionException] on server errors,
/// [ServerFunctionTransportException] on network failures.
Future<TodoItem> addTodoAction({
  required String title,
}) async {
  final client = currentServerFunctionClient;
  return client.invoke(
    addTodoRef,
    (title: title),
  );
}

