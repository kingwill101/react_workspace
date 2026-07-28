import 'package:react/react.dart';
import 'package:react_server/react_server.dart';
import 'app.react.dart';
import 'app.react.g.dart' as app;
import 'avatar.react.g.dart' as av;
import 'badge.react.g.dart' as badge;

void main() {
  initReact();
  app.registerApp();
  av.registerAvatar();
  badge.registerBadge();
  registerGlobalRenderer((id, props) => switch (id) {
        'package:react_workspace/example/lib/app.dart#App' =>
          App(title: props['title'] as String? ?? 'hi from SSR'),
        _ => const Empty(),
      });
}
