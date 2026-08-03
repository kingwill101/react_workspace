import 'dart:io';

import 'package:server_testing/server_testing.dart';

/// Serves files from [root] as a static file handler for [server_testing].
class StaticFileHandler implements RequestHandler {
  StaticFileHandler(this.root);

  final Directory root;
  HttpServer? _server;

  static final _contentTypes = {
    '.html': ContentType.html,
    '.js': ContentType('application', 'javascript'),
    '.mjs': ContentType('application', 'javascript'),
    '.css': ContentType('text', 'css'),
    '.json': ContentType.json,
    '.png': ContentType('image', 'png'),
    '.jpg': ContentType('image', 'jpeg'),
    '.jpeg': ContentType('image', 'jpeg'),
    '.gif': ContentType('image', 'gif'),
    '.svg': ContentType('image', 'svg+xml'),
    '.wasm': ContentType('application', 'wasm'),
    '.woff': ContentType('font', 'woff'),
    '.woff2': ContentType('font', 'woff2'),
    '.ttf': ContentType('font', 'ttf'),
    '.ico': ContentType('image', 'x-icon'),
    '.map': ContentType('application', 'json'),
  };

  @override
  Future<void> handleRequest(HttpRequest request) async {
    final path = request.uri.path;
    final file = File('${root.path}$path');
    if (await file.exists()) {
      final bytes = await file.readAsBytes();
      final ext = '.${path.split('.').last.toLowerCase()}';
      request.response.headers.contentType = _contentTypes[ext];
      request.response.add(bytes);
    } else {
      final index = File('${root.path}/index.html');
      if (await index.exists()) {
        final bytes = await index.readAsBytes();
        request.response.headers.contentType = ContentType.html;
        request.response.add(bytes);
      } else {
        request.response.statusCode = HttpStatus.notFound;
      }
    }
    await request.response.close();
  }

  @override
  Future<int> startServer({int port = 0}) async {
    _server = await HttpServer.bind(InternetAddress.loopbackIPv4, port);
    _server!.listen(handleRequest);
    return _server!.port;
  }

  @override
  Future<void> close([bool force = true]) async {
    await _server?.close(force: force);
    _server = null;
  }
}