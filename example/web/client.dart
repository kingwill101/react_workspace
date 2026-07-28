import 'package:react_dom/react_dom.dart';
import 'package:example/app.react.dart';
import 'package:example/react_components.g.dart';

void main() {
  initReact();
  registerReactComponents();
  final root = getRoot('app');
  final props = getInitialProps();
  if (props.isNotEmpty) {
    // SSR content present — hydrate instead of mounting fresh.
    hydrate(root, App(title: props['title'] as String));
  } else {
    // No SSR — mount fresh.
    mount(root, App(title: 'Hello from React'));
  }
}