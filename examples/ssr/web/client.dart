import 'package:react_actions/react_actions.dart';
import 'package:react_dom/react_dom.dart';
import 'package:example/.generated/app.react.dart';
import 'package:example/.generated/react_components.g.dart';

void main() {
  initReact();
  registerReactComponents();

  // Set up the server function client for action calls
  runWithServerFunctionClient(
    HttpServerFunctionClient(endpoint: Uri.parse('/__react/actions')),
    () {
      final root = getRoot('app');
      final props = getInitialProps();
      if (props.isNotEmpty) {
        // SSR content present — hydrate instead of mounting fresh. The path
        // prop is server-only: the client renders through BrowserRouter so
        // navigation follows the real URL.
        hydrate(
          root,
          App(
            title: props['title'] as String? ?? 'Hello from React',
            path: null,
          ),
        );
      } else {
        // No SSR — mount fresh.
        mount(root, App(title: 'Hello from React', path: null));
      }
    },
  );
}
