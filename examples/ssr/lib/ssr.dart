import '.generated/app.react.dart';
import '.generated/counter.react.dart';
import 'package:react_server/react_server.dart';
import '.generated/react_components.g.dart';
import '.generated/ssr_registry.g.dart';
import '.generated/todos/todos_ui.react.dart';

void main() {
  registerReactComponents();
  SsrComponentRegistry.register(
    idApp.value,
    (props) => App(
      title: props['title'] as String? ?? 'hi from SSR',
      path: props['path'] as String? ?? '/',
    ),
  );

  SsrComponentRegistry.register(
    idCounter.value,
    (props) => Counter(
      title: props['title'] as String? ?? 'Counter',
      initialCount: props['initialCount'] as int? ?? 0,
      subtitle: props['subtitle'] as String?,
      onChange: (_) {},
    ),
  );

  SsrComponentRegistry.register(
    idTodoApp.value,
    (props) => TodoApp(title: props['title'] as String? ?? 'Todos'),
  );

  registerGlobalRenderer((id, props) => SsrComponentRegistry.build(id, props));
}
