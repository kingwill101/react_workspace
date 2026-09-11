import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:react_tool/src/debug_proxy.dart';
import 'package:test/test.dart';

void main() {
  late HttpServer app;
  late HttpServer ddc;
  late Directory web;
  late ReactDebugProxy proxy;
  late HttpClient client;
  setUp(() async {
    app = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    ddc = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    web = await Directory.systemTemp.createTemp('react_debug_proxy_');
    proxy = await ReactDebugProxy.start(
      application: Uri.parse('http://127.0.0.1:${app.port}'),
      webdev: Uri.parse('http://127.0.0.1:${ddc.port}'),
      webDirectory: web,
    );
    client = HttpClient();
  });
  tearDown(() async {
    client.close(force: true);
    await proxy.close();
    await app.close(force: true);
    await ddc.close(force: true);
    await web.delete(recursive: true);
  });
  Uri url(String path) => Uri.parse('http://127.0.0.1:${proxy.port}$path');

  test(
    'documents and actions retain SSR, props, cookies, query and body',
    () async {
      app.listen((request) async {
        request.response.headers.contentType = ContentType.html;
        request.response.headers.add('set-cookie', 'session=next; HttpOnly');
        if (request.method == 'POST') {
          request.response.statusCode = 201;
          request.response.write(
            '${request.uri}|'
            '${request.headers.value('cookie')}|'
            '${await utf8.decoder.bind(request).join()}',
          );
        } else {
          request.response.write(
            '<div id="app">SSR</div>'
            '<script id="__props">{"title":"SSR"}</script>',
          );
        }
        await request.response.close();
      });
      final page = await (await client.getUrl(url('/nested/page'))).close();
      expect(await utf8.decoder.bind(page).join(), contains('"title":"SSR"'));
      final action = await client.postUrl(url('/__react/actions?x=1'));
      action.headers.set('cookie', 'session=original');
      action.write('{"argument":42}');
      final response = await action.close();
      expect(response.statusCode, 201);
      expect(response.headers.value('set-cookie'), contains('session=next'));
      expect(
        await utf8.decoder.bind(response).join(),
        '/__react/actions?x=1|session=original|{"argument":42}',
      );
    },
  );

  test('DDC modules, source maps and static assets reach webdev', () async {
    File('${web.path}/favicon.ico').writeAsStringSync('fixture');
    ddc.listen((request) async {
      request.response.write('DDC ${request.uri}');
      await request.response.close();
    });
    for (final path in [
      '/client.dart.js',
      '/client.dart.bootstrap.js',
      '/client.dart.js.map',
      '/packages/app/app.lib.js',
      '/react-debug/foreign.mjs',
      '/favicon.ico',
    ]) {
      final response = await (await client.getUrl(url(path))).close();
      expect(await utf8.decoder.bind(response).join(), 'DDC $path');
    }
  });

  test(
    'debug WebSockets forward messages and close with the session',
    () async {
      ddc.listen((request) async {
        final socket = await WebSocketTransformer.upgrade(request);
        socket.listen((message) => socket.add('echo:$message'));
      });
      final socket = await WebSocket.connect(
        url(r'/$dwdsSseHandler').replace(scheme: 'ws').toString(),
      );
      socket.add('breakpoint');
      expect(await socket.first, 'echo:breakpoint');
      await socket.close();
      await proxy.close();
      await proxy.close();
      await expectLater(
        Socket.connect('127.0.0.1', proxy.port),
        throwsA(isA<SocketException>()),
      );
    },
  );

  test('unavailable upstream gives an actionable gateway error', () async {
    await app.close(force: true);
    final response = await (await client.getUrl(url('/'))).close();
    expect(response.statusCode, 502);
    expect(await utf8.decoder.bind(response).join(), contains('unavailable'));
  });

  test(
    'application WebSockets retain authentication and select a protocol',
    () async {
      final headers = Completer<Map<String, String?>>();
      app.listen((request) async {
        headers.complete({
          for (final name in ['cookie', 'authorization', 'origin', 'x-session'])
            name: request.headers.value(name),
        });
        final socket = await WebSocketTransformer.upgrade(
          request,
          protocolSelector: (protocols) =>
              protocols.contains('chat') ? 'chat' : null,
        );
        socket.listen((message) => socket.add(message));
      });
      final socket = await WebSocket.connect(
        url('/chat').replace(scheme: 'ws').toString(),
        protocols: ['other', 'chat'],
        headers: {
          'cookie': 'session=secret',
          'authorization': 'Bearer token',
          'origin': 'http://localhost',
          'x-session': 'custom',
        },
      );
      addTearDown(socket.close);
      expect(socket.protocol, 'chat');
      expect(await headers.future, {
        'cookie': 'session=secret',
        'authorization': 'Bearer token',
        'origin': 'http://localhost',
        'x-session': 'custom',
      });
      socket.add('authenticated');
      expect(await socket.first, 'authenticated');
    },
  );

  test(
    'repeated protocol headers and malformed requests do not kill gateway',
    () async {
      final protocols = Completer<List<String>>();
      app.listen((request) async {
        if (WebSocketTransformer.isUpgradeRequest(request)) {
          protocols.complete(
            request.headers['sec-websocket-protocol']!
                .expand((v) => v.split(','))
                .map((v) => v.trim())
                .toList(),
          );
          expect(request.headers.value('x-hop'), isNull);
          final socket = await WebSocketTransformer.upgrade(request);
          socket.listen((_) {});
        } else {
          request.response.write('healthy');
          await request.response.close();
        }
      });
      final raw = await Socket.connect('127.0.0.1', proxy.port);
      addTearDown(raw.destroy);
      final reply = raw.first;
      raw.write(
        'GET /chat HTTP/1.1\r\nHost: localhost\r\n'
        'Connection: Upgrade, x-hop\r\nUpgrade: websocket\r\nX-Hop: omit\r\n'
        'Sec-WebSocket-Key: dGhlIHNhbXBsZSBub25jZQ==\r\nSec-WebSocket-Version: 13\r\n'
        'Sec-WebSocket-Protocol: alpha\r\nSec-WebSocket-Protocol: beta, gamma\r\n\r\n',
      );
      expect(utf8.decode(await reply), contains('101'));
      expect(await protocols.future, ['alpha', 'beta', 'gamma']);
      raw.destroy();
      final malformed = await Socket.connect('127.0.0.1', proxy.port);
      final ignored = malformed.listen((_) {}, onError: (Object _) {});
      malformed.write('not-http\r\n\r\n');
      await malformed.flush();
      malformed.destroy();
      await ignored.cancel();
      final response = await (await client.getUrl(url('/'))).close();
      expect(await utf8.decoder.bind(response).join(), 'healthy');
    },
  );

  test('DWDS event frames arrive before the upstream stream closes', () async {
    final finish = Completer<void>();
    ddc.listen((request) async {
      request.response.headers.contentType = ContentType(
        'text',
        'event-stream',
      );
      request.response.bufferOutput = false;
      request.response.write('data: ready\n\n');
      await request.response.flush();
      await finish.future;
      await request.response.close();
    });
    try {
      final response = await (await client.getUrl(
        url(r'/$dwdsSseHandler'),
      )).close().timeout(const Duration(seconds: 2));
      final frame = await response.first.timeout(const Duration(seconds: 2));
      expect(utf8.decode(frame), contains('data: ready'));
      expect(finish.isCompleted, isFalse);
    } finally {
      finish.complete();
    }
  });
}
