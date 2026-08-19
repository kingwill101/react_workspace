import 'dart:io';

import 'package:example/.generated/greeting.action.g.dart' show greetRef;
import 'package:example/.generated/server_actions.g.dart';
import 'package:path/path.dart' as p;
import 'package:react_server/react_server.dart';
import 'package:react_server_routed/react_server_routed.dart';
import 'package:react_testing/react_testing.dart';
import 'package:routed_core/routed_core.dart';
import 'package:routed_testing/routed_testing.dart';
import 'package:server_testing/server_testing.dart';

void main() {
  ReactTestHarness? harness;
  TestClient? client;

  setUpAll(() async {
    final testHarness = await ReactTestHarness.start(
      projectRoot: Directory.current,
    );
    harness = testHarness;
    final registry = ServerFunctionRegistry();
    registerServerActions(registry: registry);
    final app = RoutedReactApplication(
      actionRegistry: registry,
      staticHandler: (context) =>
          _serveStatic(context, testHarness.outputDirectory),
      indexTemplate: testHarness.indexTemplate,
      ssr: testHarness.ssrClient,
      rootComponent: 'package:example/lib/app.dart#App',
      pageProps: (_) => {'title': 'Hello from SSR'},
    );
    final engine = Engine();
    app.mount(engine);
    client = testHarness.createClient(RoutedRequestHandler(engine, true));
  });

  tearDownAll(() async {
    await client?.close();
    await harness?.close();
  });

  test('serves the freshly built SSR document and browser module', () async {
    final document = await client!.get('/');
    document.assertStatus(200).assertIsHtml();
    expect(document.body, contains('<h1>Hello from SSR</h1>'));
    expect(document.body, contains('Who should the server greet?'));
    expect(document.body, contains('browser.entry.mjs'));

    final browserModule = await client!.get('/browser.entry.mjs');
    browserModule.assertStatus(200);
    expect(browserModule.body, isNotEmpty);
  });

  test(
    'dispatches the generated server function through the full app',
    () async {
      final response = await client!.postJson('/__react/actions', {
        'protocol': 1,
        'id': greetRef.id.value,
        'contract': greetRef.contractHash,
        'arguments': greetRef.argumentsCodec.encode((name: 'Ada')),
      });

      response.assertStatus(200);
      final payload = response.json() as Map<String, dynamic>;
      expect(payload['ok'], isTrue);
      expect(payload['result'], contains('Hello, Ada!'));
    },
  );
}

Future<Response> _serveStatic(
  EngineContext context,
  Directory outputDirectory,
) async {
  final requested = context.path == '/'
      ? 'index.html'
      : context.path.substring(1);
  final relative = p.normalize(requested);
  if (relative == '..' ||
      relative.startsWith('../') ||
      p.isAbsolute(relative)) {
    return context.string('Not found', statusCode: HttpStatus.notFound);
  }

  final file = File(p.join(outputDirectory.path, relative));
  if (!file.existsSync()) {
    return context.string('Not found', statusCode: HttpStatus.notFound);
  }

  context.setHeader('content-type', _contentType(file.path));
  context.response.writeBytes(await file.readAsBytes());
  await context.close();
  return context.response;
}

String _contentType(String path) => switch (p.extension(path).toLowerCase()) {
  '.css' => 'text/css; charset=utf-8',
  '.html' => 'text/html; charset=utf-8',
  '.js' || '.mjs' => 'text/javascript; charset=utf-8',
  '.json' => 'application/json',
  '.svg' => 'image/svg+xml',
  '.wasm' => 'application/wasm',
  _ => 'application/octet-stream',
};
