import 'package:react/react.dart';
import 'package:react_server/react_server.dart';
import 'app.react.dart';
import 'app.react.g.dart' as app;
import 'avatar.react.g.dart' as av;
import 'badge.react.g.dart' as badge;
import 'counter.react.dart';
import 'counter.react.g.dart' as counter;

void main() {
  initReact();
  app.registerApp();
  av.registerAvatar();
  badge.registerBadge();
  counter.registerCounter();
  registerGlobalRenderer((id, props) => switch (id) {
        'package:react_workspace/example/lib/app.dart#App' =>
          App(title: props['title'] as String? ?? 'hi from SSR'),
        'package:react_workspace/example/lib/counter.dart#Counter' =>
          Counter(
            title: props['title'] as String? ?? 'Counter',
            initialCount: props['initialCount'] as int? ?? 0,
            subtitle: props['subtitle'] as String?,
            onChange: (_) {},
          ),
        _ => const Empty(),
      });
}
