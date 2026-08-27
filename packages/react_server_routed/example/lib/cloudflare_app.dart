import 'package:react_server/react_server.dart';
import 'package:react_server_routed/react_server_routed.dart';
import 'package:routed_node/cloudflare.dart';
import 'package:routed_core/routed_core.dart';

import '.generated/server_actions.g.dart';

const _rootComponent = 'package:react_server_routed_example/lib/app.dart#App';

/// Builds the edge-safe Routed engine used by `routed_cli deploy`.
///
/// Static assets are intentionally delegated to the deployment layer in this
/// minimal example. The React SSR endpoint is mounted by the generated
/// Cloudflare wrapper at `/__react/ssr`.
Future<Engine> createEngine() async {
  final actions = ServerFunctionRegistry();
  registerServerActions(registry: actions);

  final app = RoutedReactApplication(
    actionRegistry: actions,
    staticHandler: (context) => context.string('Not found', statusCode: 404),
    indexTemplate: '''<!doctype html>
<html>
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Routed React</title>
    <link rel="stylesheet" href="/styles.css">
    <script type="importmap">
    {"imports":{"react":"https://esm.sh/react@18.2.0","react-dom":"https://esm.sh/react-dom@18.2.0","react-dom/":"https://esm.sh/react-dom@18.2.0/"}}
    </script>
  </head>
  <body>
    <div id="app">{{SSR}}</div>
    <script id="__props" type="application/json">{{PROPS}}</script>
    <script type="module" src="/browser.entry.mjs"></script>
  </body>
</html>''',
    ssr: ReactSsrClient(endpoint: Uri.parse('/__react/ssr')),
    ssrEndpoint: (context) {
      final request = cloudflareRequestOf(context);
      return Uri.parse(request?.url ?? context.request.uri.toString());
    },
    rootComponent: _rootComponent,
    pageProps: (context) => {'title': 'Hello from Cloudflare'},
  );

  final engine = Engine();
  app.mount(engine);
  return engine;
}
