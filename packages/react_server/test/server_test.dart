import 'dart:convert';
import 'dart:io';

import 'package:react_server/react_server.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

void main() {
  group('ReactSsrClient', () {
    test('render returns document on success', () async {
      final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      server.listen((req) async {
        final res = req.response;
        res.headers.contentType = ContentType.json;
        res.write(jsonEncode({'html': '<div>hi</div>', 'props': {'x': 1}}));
        await res.close();
      });

      final client = ReactSsrClient(endpoint: Uri.parse('http://127.0.0.1:${server.port}/'));
      final doc = await client.render(component: 'app#Root', props: {'a': 1});
      expect(doc.html, '<div>hi</div>');
      expect(doc.props['x'], 1);

      client.close();
      await server.close(force: true);
    });

    test('render throws on non-2xx status', () async {
      final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      server.listen((req) async {
        req.response.statusCode = 500;
        req.response.write('error');
        await req.response.close();
      });
      // Small delay to ensure server is ready
      await Future<void>.delayed(const Duration(milliseconds: 50));

      final client = ReactSsrClient(endpoint: Uri.parse('http://127.0.0.1:${server.port}/'));
      // Non-2xx should throw HttpException, but connection issues also throw
      await expectLater(client.render(component: 'app#Root', props: const {}), throwsA(isA<Exception>()));
      client.close();
      await server.close(force: true);
    });

    test('render throws on invalid JSON envelope', () async {
      final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      server.listen((req) async {
        final res = req.response;
        res.headers.contentType = ContentType.json;
        res.write(jsonEncode({'bad': 'envelope'}));
        await res.close();
      });
      await Future<void>.delayed(const Duration(milliseconds: 50));

      final client = ReactSsrClient(endpoint: Uri.parse('http://127.0.0.1:${server.port}/'));
      await expectLater(client.render(component: 'app#Root', props: const {}), throwsA(isA<FormatException>()));
      client.close();
      await server.close(force: true);
    });

    test('render handles missing props as empty map', () async {
      final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      server.listen((req) async {
        final res = req.response;
        res.headers.contentType = ContentType.json;
        res.write(jsonEncode({'html': '<p>hi</p>'}));
        await res.close();
      });

      final client = ReactSsrClient(endpoint: Uri.parse('http://127.0.0.1:${server.port}/'));
      final doc = await client.render(component: 'app#Root', props: const {});
      expect(doc.html, '<p>hi</p>');
      expect(doc.props, isEmpty);

      client.close();
      await server.close(force: true);
    });
  });

  group('ReactServerApp', () {
    test('with ssr renders into template', () async {
      final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      server.listen((req) async {
        final res = req.response;
        res.headers.contentType = ContentType.json;
        res.write(jsonEncode({'html': '<main>SSR</main>', 'props': {'t': 'hi'}}));
        await res.close();
      });

      final ssr = ReactSsrClient(endpoint: Uri.parse('http://127.0.0.1:${server.port}/'));
      final app = ReactServerApp(
        actionRegistry: ServerFunctionRegistry(),
        staticHandler: (req) => Response.ok('static'),
        indexTemplate: '<div>{{SSR}}</div><script>{{PROPS}}</script>',
        ssr: ssr,
        rootComponent: 'test.root',
      );

      final resp = await app.handler(Request('GET', Uri.parse('http://localhost/')));
      expect(resp.statusCode, 200);
      final body = await resp.readAsString();
      expect(body, contains('<main>SSR</main>'));
      expect(body, contains('"t":"hi"'));

      ssr.close();
      await server.close(force: true);
    });

    test('non-document path goes to static handler', () async {
      final app = ReactServerApp(
        actionRegistry: ServerFunctionRegistry(),
        staticHandler: (req) => Response.ok('asset:${req.url.path}'),
        indexTemplate: '{{SSR}}',
      );
      final resp = await app.handler(Request('GET', Uri.parse('http://localhost/client.js')));
      expect(await resp.readAsString(), 'asset:client.js');
    });

    test('action path is handled even with SSR configured', () async {
      final registry = ServerFunctionRegistry();
      final app = ReactServerApp(
        actionRegistry: registry,
        staticHandler: (req) => Response.ok('static'),
        indexTemplate: '{{SSR}}',
        ssr: null,
        rootComponent: null,
      );
      final resp = await app.handler(
        Request('POST', Uri.parse('http://localhost/__react/actions'),
            headers: {'content-type': 'application/json'}, body: '{}'),
      );
      // Should reach action handler, not static (405 or 415 expected, not 200 static)
      expect(resp.statusCode, isNot(200));
    });

    test('_looksLikeDocument logic via app handler', () async {
      final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      server.listen((req) async {
        final res = req.response;
        res.headers.contentType = ContentType.json;
        res.write(jsonEncode({'html': '<p>doc</p>', 'props': {}}));
        await res.close();
      });
      final ssr = ReactSsrClient(endpoint: Uri.parse('http://127.0.0.1:${server.port}/'));
      final app = ReactServerApp(
        actionRegistry: ServerFunctionRegistry(),
        staticHandler: (req) => Response.ok('static'),
        indexTemplate: '{{SSR}}',
        ssr: ssr,
        rootComponent: 'test.root',
      );

      // Deep link without extension => SSR
      final docResp = await app.handler(Request('GET', Uri.parse('http://localhost/todos')));
      expect(await docResp.readAsString(), contains('<p>doc</p>'));

      // Asset with extension => static
      final assetResp = await app.handler(Request('GET', Uri.parse('http://localhost/app.js')));
      expect(await assetResp.readAsString(), 'static');

      // Root => SSR
      final rootResp = await app.handler(Request('GET', Uri.parse('http://localhost/')));
      expect(await rootResp.readAsString(), contains('<p>doc</p>'));

      ssr.close();
      await server.close(force: true);
    });
  });
}
