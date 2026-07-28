import 'package:react/react.dart';
import 'package:react_js/react_js.dart';
import 'package:react_dom/react_dom.dart';
import 'package:example/app.react.dart';
import 'package:example/app.react.g.dart' as app;
import 'package:example/avatar.react.g.dart' as av;
import 'package:example/badge.react.g.dart' as badge;

void main() {
  ReactInternal.init(binding: JsBinding(), renderer: JsRenderer());
  app.registerApp();
  av.registerAvatar();
  badge.registerBadge();
  final root = findRoot('app');
  if (root != null) {
    mount(root, App(title: 'hi', key: 'root', children: const []), const Attach());
  }
}
