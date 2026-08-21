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
}
