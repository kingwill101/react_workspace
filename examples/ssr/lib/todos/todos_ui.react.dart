import 'package:react/react.dart';

const idTodoApp = ComponentId('package:example/lib/todos/todos_ui.dart#TodoApp');

ReactNode TodoApp({
  required String title,
  String? key,
  List<ReactNode> children = const []
}) {
  final props = (title: title);
  return Component(idTodoApp, props, key: key, children: children);
}

