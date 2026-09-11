import 'dart:async';
import 'dart:io';

/// Loopback-only development gateway for a Dart app and webdev/DDC assets.
///
/// Application routes, including server actions, retain their request methods,
/// cookies, bodies, status codes, and streaming responses. Browser compiler
/// assets and debugger WebSockets are forwarded to webdev.
final class ReactDebugProxy {
  ReactDebugProxy._(this._server, this._client) : port = _server.port;

  final HttpServer _server;
  final HttpClient _client;
  final _sockets = <WebSocket>{};
  final _requests = <Future<void>>{};
  bool _closed = false;

  final int port;

  static Future<ReactDebugProxy> start({
    required Uri application,
    required Uri webdev,
    required Directory webDirectory,
    int port = 0,
  }) async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, port);
    final proxy = ReactDebugProxy._(
      server,
      HttpClient()..autoUncompress = false,
    );
    server.listen(
      (request) {
        final task = proxy._forward(request, application, webdev, webDirectory);
        proxy._requests.add(task);
        unawaited(task.whenComplete(() => proxy._requests.remove(task)));
      },
      onError: (Object error, StackTrace stack) {
        // A failed incoming connection must not escape into the CLI's zone.
        // HttpServer keeps accepting subsequent connections after stream errors.
      },
    );
    return proxy;
  }

  Future<void> close() async {
    if (_closed) return;
    _closed = true;
    await _server.close(force: true);
    _client.close(force: true);
    await Future.wait(_sockets.toList().map((socket) => socket.close()));
    await Future.wait(_requests.toList());
  }

  Future<void> _forward(
    HttpRequest request,
    Uri application,
    Uri webdev,
    Directory webDirectory,
  ) async {
    try {
      final path = request.uri.path;
      final segments = request.uri.pathSegments;
      final isAsset =
          path.startsWith('/packages/') ||
          path.startsWith('/react-debug/') ||
          path.startsWith(r'/$dwds') ||
          path.startsWith(r'/$dart') ||
          path.endsWith('.dart.js') ||
          path.endsWith('.dart.js.map') ||
          path.endsWith('.dart.bootstrap.js') ||
          path.endsWith('.lib.js') ||
          path.endsWith('.lib.js.map') ||
          path.endsWith('.ddc.js') ||
          (path != '/' &&
              !path.endsWith('.html') &&
              !segments.contains('..') &&
              File.fromUri(
                webDirectory.uri.resolve(segments.join('/')),
              ).existsSync());
      final base = isAsset ? webdev : application;
      final target = base.replace(
        path: path,
        query: request.uri.hasQuery ? request.uri.query : null,
      );
      if (WebSocketTransformer.isUpgradeRequest(request)) {
        final upstream = await WebSocket.connect(
          target.replace(scheme: 'ws').toString(),
          protocols: _headerTokens(request.headers, 'sec-websocket-protocol'),
          headers: _forwardHeaders(request.headers, websocket: true),
        );
        final downstream = await WebSocketTransformer.upgrade(
          request,
          protocolSelector: upstream.protocol == null
              ? null
              : (_) => upstream.protocol!,
        );
        _sockets.addAll([upstream, downstream]);
        void dispose() {
          _sockets.removeAll([upstream, downstream]);
          unawaited(upstream.close());
          unawaited(downstream.close());
        }

        upstream.listen(
          downstream.add,
          onDone: dispose,
          onError: (_) => dispose(),
        );
        downstream.listen(
          upstream.add,
          onDone: dispose,
          onError: (_) => dispose(),
        );
        return;
      }
      final outgoing = await _client.openUrl(request.method, target);
      outgoing.followRedirects = false;
      _copyHeaders(request.headers, outgoing.headers);
      outgoing.headers.set(
        'x-forwarded-host',
        request.headers.value('host') ?? 'localhost',
      );
      outgoing.headers.set('x-forwarded-proto', 'http');
      await outgoing.addStream(request);
      final response = await outgoing.close();
      request.response.statusCode = response.statusCode;
      _copyHeaders(response.headers, request.response.headers);
      // DWDS uses long-lived SSE streams whose handshake frames are tiny.
      // Buffering them until a full buffer or EOF prevents Dart main from
      // starting and stalls the browser's debugger connection.
      request.response.bufferOutput = false;
      await request.response.addStream(response);
      await request.response.close();
    } catch (_) {
      if (!_closed) {
        try {
          request.response.statusCode = HttpStatus.badGateway;
          request.response.write('Development upstream is unavailable.');
          await request.response.close();
        } catch (_) {
          // The browser may have disconnected or headers may already be sent.
        }
      }
    }
  }
}

void _copyHeaders(HttpHeaders source, HttpHeaders target) {
  _forwardHeaders(source).forEach(target.set);
}

Iterable<String> _headerTokens(HttpHeaders headers, String name) =>
    (headers[name] ?? const <String>[])
        .expand((value) => value.split(','))
        .map((value) => value.trim())
        .where((value) => value.isNotEmpty);

Map<String, List<String>> _forwardHeaders(
  HttpHeaders source, {
  bool websocket = false,
}) {
  final excluded = <String>{
    'connection',
    'keep-alive',
    'proxy-authenticate',
    'proxy-authorization',
    'te',
    'trailer',
    'transfer-encoding',
    'upgrade',
    'host',
    ..._headerTokens(source, 'connection').map((v) => v.toLowerCase()),
    if (websocket) ...{
      'sec-websocket-key',
      'sec-websocket-version',
      'sec-websocket-protocol',
      'sec-websocket-extensions',
      'sec-websocket-accept',
      'content-length',
    },
  };
  final headers = <String, List<String>>{};
  source.forEach((name, values) {
    if (!excluded.contains(name.toLowerCase())) headers[name] = values;
  });
  return headers;
}
