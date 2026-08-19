import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_static/shelf_static.dart';

import 'package:react_server/react_server.dart';
import 'package:react_server_shelf/react_server_shelf.dart';
import 'package:example/.generated/server_actions.g.dart';

const _defaultRootComponent = 'package:example/lib/app.dart#App';

Future<void> main() async {
  final port = int.tryParse(Platform.environment['PORT'] ?? '') ?? 8080;
  final webDir = Directory('build/react').existsSync() ? 'build/react' : 'web';
  final staticHandler = createStaticHandler(
    webDir,
    defaultDocument: 'index.html',
  );
  final indexTemplate = File('$webDir/index.html').readAsStringSync();

  final actionRegistry = ServerFunctionRegistry();
  registerServerActions(registry: actionRegistry);

  final ssrUrl = Platform.environment['REACT_SSR_URL'];
  final ssr = ssrUrl == null
      ? null
      : ReactSsrClient(endpoint: Uri.parse(ssrUrl));
  final app = ReactServerApp(
    actionRegistry: actionRegistry,
    staticHandler: const Pipeline()
        .addMiddleware(logRequests())
        .addHandler(staticHandler),
    indexTemplate: indexTemplate,
    ssr: ssr,
    rootComponent:
        Platform.environment['REACT_ROOT_COMPONENT'] ?? _defaultRootComponent,
    pageProps: (request) => {'title': 'hi', 'path': _documentPath(request.url)},
  );

  final server = await io.serve(app.handler, InternetAddress.anyIPv4, port);
  print('Server running on http://localhost:${server.port}');
}

/// The router location for an SSR request: path plus query string, with a
/// leading slash (shelf's in-memory request URLs omit it).
String _documentPath(Uri url) {
  var path = url.path;
  if (path.isEmpty) path = '/';
  if (!path.startsWith('/')) path = '/$path';
  if (url.query.isNotEmpty) path = '$path?${url.query}';
  return path;
}
