import 'dart:convert';
import 'dart:io';

import 'package:react_server/react_server.dart';
import 'package:react_server_shelf/react_server_shelf.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

void main() {
  test('ReactServerApp renders a worker document into the template', () async {
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
    );

    final response = await app.handler(
      Request('GET', Uri.parse('http://localhost/')),
    );
    expect(response.statusCode, 200);
    final body = await response.readAsString();
    expect(body, contains('<main>SSR content</main>'));
    expect(body, contains('"title":"Test"'));

    ssr.close();
    await worker.close(force: true);
  });

  test('ReactServerApp delegates assets to the static handler', () async {
    final app = ReactServerApp(
      actionRegistry: ServerFunctionRegistry(),
      staticHandler: (request) => Response.ok('asset:${request.url.path}'),
      indexTemplate: '{{SSR}}',
    );

    final response = await app.handler(
      Request('GET', Uri.parse('http://localhost/client.js')),
    );
    expect(await response.readAsString(), 'asset:client.js');
  });

  test('ReactServerApp streams the document when enabled', () async {
    final worker = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    worker.listen((request) async {
      final response = request.response;
      response.headers.contentType = ContentType('application', 'x-ndjson');
      response.write('{"type":"start"}\n');
      response.write('{"type":"chunk","html":"<main>"}\n');
      await response.flush();
      response.write('{"type":"chunk","html":"streamed</main>"}\n');
      response.write('{"type":"end","props":{"title":"Stream"}}\n');
      await response.close();
    });

    final ssr = ReactSsrClient(
      endpoint: Uri.parse('http://127.0.0.1:${worker.port}/'),
    );
    final app = ReactServerApp(
      actionRegistry: ServerFunctionRegistry(),
      staticHandler: (request) => Response.ok('static'),
      indexTemplate: '<html><body>{{SSR}}</body><script>{{PROPS}}</script>',
      ssr: ssr,
      rootComponent: 'test.root',
      streamingSsr: true,
    );

    final response = await app.handler(
      Request('GET', Uri.parse('http://localhost/')),
    );
    final body = await response.readAsString();
    expect(body, contains('<main>streamed</main>'));
    expect(body, contains('"title":"Stream"'));

    ssr.close();
    await worker.close(force: true);
  });
}
