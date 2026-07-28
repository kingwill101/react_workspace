import 'package:react_dom/react_dom.dart';
import 'package:example/app.react.dart';
import 'package:example/app.react.g.dart' as app;

void main() {
  initReact();
  app.registerApp();
  final root = getRoot('root');
  mount(root, App(title: 'Hello from React'));
}
