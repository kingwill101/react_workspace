import 'package:react_dom/react_dom.dart';
import 'package:example/app.react.dart';
import 'package:example/app.react.g.dart' as app;
import 'package:example/avatar.react.g.dart' as av;
import 'package:example/badge.react.g.dart' as badge;

void main() {
  initReact();
  app.registerApp();
  av.registerAvatar();
  badge.registerBadge();
  final initialProps = getInitialProps();
  final root = getRoot('app');
  final node = App(title: initialProps['title'] as String? ?? 'hi');
  hasSSRContent(root) ? hydrate(root, node) : mount(root, node);
}
