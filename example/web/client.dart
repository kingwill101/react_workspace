import 'package:react_actions/react_actions.dart';
import 'package:react_dom/react_dom.dart';
import 'package:react_web/react_web.dart' show HttpServerFunctionClient;
import 'package:example/app.react.dart';
import 'package:example/react_components.g.dart';

void main() {
  initReact();
  registerReactComponents();

  // Set up the server function client for action calls
  runWithServerFunctionClient(
    HttpServerFunctionClient(
      endpoint: Uri.parse('/__react/actions'),
    ),
    () {
      final root = getRoot('app');
      final props = getInitialProps();
      if (props.isNotEmpty) {
        // SSR content present — hydrate instead of mounting fresh.
        hydrate(root, App(title: props['title'] as String));
      } else {
        // No SSR — mount fresh.
        mount(root, App(title: 'Hello from React'));
      }
    },
  );
}
