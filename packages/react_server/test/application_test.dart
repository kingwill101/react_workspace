import 'dart:convert';
import 'dart:io';

import 'package:react_server/react_server.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

void main() {
  test(
    'ReactServerApp renders a worker document into the index template',
    () async {
      final worker = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      worker.listen((request) async {
        final response = request.response;
        response.headers.contentType = ContentType.json;
        response.write(
          jsonEncode({
            'html': '<main>SSR content</main>',
            'props': {'title': 'Test'},
          }),
        );
        await response.close();
      });

      final ssr = ReactSsrClient(
        endpoint: Uri.parse('http://127.0.0.1:${worker.port}/'),
      );
      final app = ReactServerApp(
        actionRegistry: ServerFunctionRegistry(),
        staticHandler: (request) => Response.ok('static'),
        indexTemplate: '<div>{{SSR}}</div><script>{{PROPS}}</script>',
        ssr: ssr,
        rootComponent: 'test.root',
        pageProps: (request) => {'title': 'Test'},
      );

      final response = await app.handler(
        Request('GET', Uri.parse('http://localhost/')),
      );

      expect(response.statusCode, 200);
      final body = await response.readAsString();
      expect(body, contains('<main>SSR content</main>'));
      expect(body, contains('{"title":"Test"}'));

      ssr.close();
      await worker.close(force: true);
    },
  );

  test(
    'ReactServerApp delegates non-SSR pages to the static handler',
    () async {
      final app = ReactServerApp(
        actionRegistry: ServerFunctionRegistry(),
        staticHandler: (request) => Response.ok('static'),
        indexTemplate: '<div>{{SSR}}</div>',
      );

      final response = await app.handler(
        Request('GET', Uri.parse('http://localhost/')),
      );

      expect(response.statusCode, 200);
      expect(await response.readAsString(), 'static');
    },
  );

  test(
    'ReactServerApp SSR-renders deep links without a file extension',
    () async {
      final worker = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      worker.listen((request) async {
        final response = request.response;
        response.headers.contentType = ContentType.json;
        response.write(
          jsonEncode({
            'html': '<main>Rendered /todos</main>',
            'props': {'title': 'Test', 'path': '/todos'},
          }),
        );
        await response.close();
      });

      final ssr = ReactSsrClient(
        endpoint: Uri.parse('http://127.0.0.1:${worker.port}/'),
      );
      final app = ReactServerApp(
        actionRegistry: ServerFunctionRegistry(),
        staticHandler: (request) => Response.notFound('static'),
        indexTemplate: '<div>{{SSR}}</div>',
        ssr: ssr,
        rootComponent: 'test.root',
        pageProps: (request) => {'title': 'Test', 'path': request.url.path},
      );

      final response = await app.handler(
        Request('GET', Uri.parse('http://localhost/todos')),
      );

      expect(response.statusCode, 200);
      expect(await response.readAsString(), contains('Rendered /todos'));

      final asset = await app.handler(
        Request('GET', Uri.parse('http://localhost/foreign/ssr/bundle.mjs')),
      );
      expect(asset.statusCode, 404);
      expect(await asset.readAsString(), 'static');

      ssr.close();
      await worker.close(force: true);
    },
  );
}
