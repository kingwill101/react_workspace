import 'package:react_actions/react_actions.dart';
import 'package:react_dom/react_dom.dart';
import 'package:superdesk/.generated/app.react.dart';
import 'package:superdesk/.generated/react_components.g.dart';

void main() {
  initReact();
  registerReactComponents();
  installBrowserWebRuntime();
  registerBrowserAdapters();

  // Server-function calls run through this client.
  runWithServerFunctionClient(
    HttpServerFunctionClient(endpoint: Uri.parse('/__react/actions')),
    () {
      final root = getRoot('app');
      final props = getInitialProps();
      final app = App(title: props['title'] as String? ?? 'Hello from React');
      if (props.isNotEmpty) {
        // The server rendered the same props — hydrate the existing markup.
        hydrate(root, app);
      } else {
        mount(root, app);
      }
    },
  );
}
