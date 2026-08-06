// GENERATED CODE - DO NOT EDIT
// ignore_for_file: type=lint

import 'package:react_server/react_server.dart';

import 'todos_actions.action.g.dart';
import 'todos_actions.dart';

void registerTodosActions({
  required ServerFunctionRegistry registry,
}) {
  registry.register(
    listTodosRef,
    (({bool? completedFilter}) args, ServerFunctionContext context) async {
      return await listTodos(context, completedFilter: args.completedFilter);
    },
  );

  registry.register(
    toggleTodoRef,
    (({String todoId, bool completed}) args, ServerFunctionContext context) async {
      return await toggleTodo(context, todoId: args.todoId, completed: args.completed);
    },
  );

  registry.register(
    addTodoRef,
    (({String title}) args, ServerFunctionContext context) async {
      return await addTodo(context, title: args.title);
    },
  );

}
