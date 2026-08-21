import 'dart:convert';
import 'dart:io';

import 'package:react_server/react_server.dart';
import 'package:react_server_shelf/react_server_shelf.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

void main() {
  test(
    'ReactServerApp composes independently cached partial regions',
    () async {
      var shellRenders = 0;
      var regionRenders = 0;
      final app = ReactServerApp(
        actionRegistry: ServerFunctionRegistry(),
        staticHandler: (request) => Response.ok('static'),
        indexTemplate: '',
        partialDocument: (request) => ReactPartialDocument(
          shellKey: 'home-shell',
          shell: () {
            shellRenders++;
            return '<html><!--react-partial:banner--><main>shell</main></html>';
          },
          regions: [
            ReactPartialRegion(
              key: 'banner',
              ttl: Duration.zero,
              render: () {
                regionRenders++;
                return '<aside>region $regionRenders</aside>';
              },
            ),
          ],
        ),
      );

      final first = await app.handler(
        Request('GET', Uri.parse('http://localhost/')),
      );
      final second = await app.handler(
        Request('GET', Uri.parse('http://localhost/')),
      );

      expect(await first.readAsString(), contains('<aside>region 1</aside>'));
      expect(await second.readAsString(), contains('<aside>region 2</aside>'));
      expect(shellRenders, 1);
      expect(regionRenders, 2);
    },
  );

  test('ReactServerApp reads and writes a persistent document store', () async {
    final worker = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    var renders = 0;
    worker.listen((request) async {
      renders++;
      final response = request.response;
      response.headers.contentType = ContentType.json;
      response.write(
        jsonEncode({
          'html': '<main>render $renders</main>',
          'props': <String, dynamic>{},
        }),
      );
      await response.close();
    });

    final store = _MemoryDocumentStore();
    final app = ReactServerApp(
      actionRegistry: ServerFunctionRegistry(),
      staticHandler: (request) => Response.ok('static'),
      indexTemplate: '<div>{{SSR}}</div>',
      ssr: ReactSsrClient(
        endpoint: Uri.parse('http://127.0.0.1:${worker.port}/'),
      ),
      rootComponent: 'test.root',
      documentStore: store,
      documentTtl: const Duration(minutes: 5),
      cacheTags: (request) => const ['homepage'],
    );

    final first = await app.handler(
      Request('GET', Uri.parse('http://localhost/')),
    );
    final second = await app.handler(
      Request('GET', Uri.parse('http://localhost/')),
    );

    expect(first.statusCode, 200);
    expect(second.statusCode, 200);
    expect(await first.readAsString(), contains('render 1'));
    expect(await second.readAsString(), contains('render 1'));
    expect(renders, 1);
    expect(store.writes, 1);
    expect(store.lastTags, contains('homepage'));

    app.ssr!.close();
    await worker.close(force: true);
  });

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

final class _MemoryDocumentStore implements ReactDocumentStore {
  ReactStoredDocument? document;
  int writes = 0;
  Set<String> lastTags = const {};

  @override
  Future<ReactStoredDocument?> read(String key) async => document;

  @override
  Future<void> write(
    String key,
    String html, {
    required Duration ttl,
    required Duration staleWhileRevalidate,
    Iterable<String> tags = const <String>[],
  }) async {
    writes++;
    lastTags = tags.toSet();
    document = ReactStoredDocument(html: html, stale: false, tags: lastTags);
  }

  @override
  Future<void> invalidate(String key) async {
    document = null;
  }

  @override
  Future<void> invalidateTag(String tag) async {
    if (document?.tags.contains(tag) ?? false) document = null;
  }
}
