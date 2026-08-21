import 'package:react_actions/react_actions.dart';
import 'package:react_server/react_server.dart';

@serverFunction
Future<List<String>> listTodos(ServerFunctionContext context) async => [];

@serverFunction
Future<String> toggleTodo(
  ServerFunctionContext context, {
  required String todoId,
}) async => todoId;

@serverFunction
Future<String> addTodo(
  ServerFunctionContext context, {
  required String title,
}) async => title;
