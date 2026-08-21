import 'dart:convert';
import 'dart:io';

import 'package:react_actions/react_actions.dart';
import 'package:react_server/react_server.dart';
import 'package:routed_core/routed_core.dart';
import 'package:test/test.dart';

import 'package:react_server_routed/react_server_routed.dart';

void main() {
  test('renders a document through the SSR worker', () async {
    final worker = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    worker.listen((request) async {
      final response = request.response;
      response.headers.contentType = ContentType.json;
      response.write(
        jsonEncode({
          'html': '<main>Rendered</main>',
          'props': {'title': 'Test'},
        }),
      );
      await response.close();
    });

    final ssr = ReactSsrClient(
      endpoint: Uri.parse('http://127.0.0.1:${worker.port}/'),
    );
    final app = RoutedReactApplication(
      actionRegistry: ServerFunctionRegistry(),
      staticHandler: (context) => context.string('static'),
      indexTemplate: '<main>{{SSR}}</main><script>{{PROPS}}</script>',
      ssr: ssr,
      rootComponent: 'app.Root',
      pageProps: (context) => {'path': context.path},
    );

    final testContext = _context('GET', '/todos');
    final response = await app.handler(testContext.context);
    await response.close();

    expect(response.statusCode, 200);
    expect(
      utf8.decode(testContext.adapter.bytes),
      '<main><main>Rendered</main></main><script>{"title":"Test"}</script>',
    );

    ssr.close();
    await worker.close(force: true);
  });

  test('delegates asset requests to the static handler', () async {
    final app = RoutedReactApplication(
      actionRegistry: ServerFunctionRegistry(),
      staticHandler: (context) => context.string('asset'),
      indexTemplate: '<main>{{SSR}}</main>',
    );

    final testContext = _context('GET', '/styles.css');
    final response = await app.handler(testContext.context);
    await response.close();

    expect(utf8.decode(testContext.adapter.bytes), 'asset');
  });

  test('streams a document through the Routed response adapter', () async {
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
    final app = RoutedReactApplication(
      actionRegistry: ServerFunctionRegistry(),
      staticHandler: (context) => context.string('static'),
      indexTemplate: '<html><body>{{SSR}}</body><script>{{PROPS}}</script>',
      ssr: ssr,
      rootComponent: 'app.Root',
      streamingSsr: true,
    );

    final testContext = _context('GET', '/stream');
    final response = await app.handler(testContext.context);
    await response.close();

    final body = utf8.decode(testContext.adapter.bytes);
    expect(body, contains('<main>streamed</main>'));
    expect(body, contains('"title":"Stream"'));

    ssr.close();
    await worker.close(force: true);
  });

  test('mounts the composed handler on a Routed engine', () async {
    final app = RoutedReactApplication(
      actionRegistry: ServerFunctionRegistry(),
      staticHandler: (context) => context.string('mounted'),
      indexTemplate: '<main>{{SSR}}</main>',
    );
    final engine = Engine();
    app.mount(engine);

    final response = await engine.handlePortable(
      PortableRequest(
        method: 'GET',
        uri: Uri.parse('http://localhost/assets/app.js'),
      ),
    );
    final bytes = await response.body.fold<List<int>>(
      <int>[],
      (result, chunk) => result..addAll(chunk),
    );

    expect(response.statusCode, 200);
    expect(utf8.decode(bytes), 'mounted');
  });

  test('dispatches the React action protocol through Routed', () async {
    final registry = ServerFunctionRegistry();
    final ref = ServerFunctionRef<String, String>(
      id: const ServerFunctionId('test.echo'),
      contractHash: 'test-contract',
      argumentsCodec: _StringCodec(),
      resultCodec: _StringCodec(),
    );
    registry.register(ref, (value, context) => 'echo:$value');
    final app = RoutedReactApplication(
      actionRegistry: registry,
      staticHandler: (context) => context.string('static'),
      indexTemplate: '<main>{{SSR}}</main>',
    );

    final testContext = _context(
      'POST',
      '/__react/actions',
      headers: {'content-type': 'application/json'},
      body: utf8.encode(
        jsonEncode({
          'protocol': 1,
          'id': ref.id.value,
          'contract': ref.contractHash,
          'arguments': 'hello',
        }),
      ),
    );
    final response = await app.handler(testContext.context);
    await response.close();

    expect(response.statusCode, 200);
    expect(
      jsonDecode(utf8.decode(testContext.adapter.bytes)),
      equals({'ok': true, 'result': 'echo:hello'}),
    );
  });
}

final class _StringCodec extends ServerFunctionJsonCodec<String> {
  @override
  String decode(dynamic json) => json as String;

  @override
  String encode(String value) => value;
}

_TestContext _context(
  String method,
  String path, {
  Map<String, String> headers = const {},
  List<int> body = const [],
}) {
  final request = Request.fromAdapter(
    _RequestAdapter(
      method: method,
      uri: Uri.parse('http://localhost$path'),
      headers: {
        for (final entry in headers.entries) entry.key: [entry.value],
      },
      bodyBytes: body,
    ),
    const {},
    EngineConfig(),
  );
  final adapter = _ResponseAdapter();
  return _TestContext(
    EngineContext(request: request, response: Response.fromAdapter(adapter)),
    adapter,
  );
}

final class _TestContext {
  const _TestContext(this.context, this.adapter);

  final EngineContext context;
  final _ResponseAdapter adapter;
}

final class _RequestAdapter implements RequestAdapter {
  const _RequestAdapter({
    required this.method,
    required this.uri,
    required this.headers,
    required this.bodyBytes,
  });

  @override
  final String method;

  @override
  final Uri uri;

  @override
  final Map<String, List<String>> headers;

  final List<int> bodyBytes;

  @override
  Stream<List<int>> get body => Stream.value(bodyBytes);

  @override
  String? get remoteAddress => null;
}

final class _ResponseAdapter implements ResponseAdapter {
  int _statusCode = 200;
  final _bytes = <int>[];

  List<int> get bytes => List.unmodifiable(_bytes);

  @override
  int get statusCode => _statusCode;

  @override
  set statusCode(int value) => _statusCode = value;

  @override
  void addHeader(String name, String value) {}

  @override
  void setHeader(String name, String value) {}

  @override
  Future<void> close() async {}

  @override
  Future<void> flush() async {}

  @override
  void write(List<int> bytes) => _bytes.addAll(bytes);
}
