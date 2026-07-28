import 'app.react.dart';
import 'counter.react.dart';
import 'package:react_server/react_server.dart';
import 'ssr_registry.g.dart';

void main() {
  initReact();
  registerKnownSsComponentIds();

  SsrComponentRegistry.register(
    idApp.value,
    (props) => App(
      title: props['title'] as String? ?? 'hi from SSR',
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

  registerGlobalRenderer((id, props) => SsrComponentRegistry.build(id, props));
}