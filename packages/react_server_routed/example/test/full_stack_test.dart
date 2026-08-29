import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:react_server_routed_example/.generated/greeting.action.g.dart'
    show greetRef;
import 'package:react_server_routed_example/.generated/server_actions.g.dart';
import 'package:path/path.dart' as p;
import 'package:react_server/react_server.dart';
import 'package:react_actions/react_actions.dart';
import 'package:react_server_routed/react_server_routed.dart';
import 'package:react_testing/react_testing.dart';
import 'package:react_tool/react_tool.dart' show ReactVersionPolicy;
import 'package:routed_core/routed_core.dart';
import 'package:routed_testing/routed_testing.dart';
import 'package:server_testing/server_testing.dart';

void main() {
  ReactTestHarness? harness;
  TestClient? client;

  setUpAll(() async {
    final packageRoot = await _resolveProjectRootFromTestHarness();
    final testHarness = await ReactTestHarness.start(
      projectRoot: packageRoot,
      reactVersion: ReactVersionPolicy.compatibilityBaselines.last,
      // The deployed example uses Fetch SSR for Cloudflare. The local
      // integration harness boots a Node worker, so override only this build.
      ssrRuntime: 'node',
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
      rootComponent: 'package:react_server_routed_example/lib/app.dart#App',
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
    expect(document.body, contains('browser.js'));

    final browserModule = await client!.get('/browser.js');
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

  test('dispatches a compact protocol frame through the full app', () async {
    final request = ReactFrame(
      kind: ReactMessageKind.invoke,
      actionId: compactActionId(greetRef.id.value),
      requestId: 7,
      payload: {
        'id': greetRef.id.value,
        'contract': greetRef.contractHash,
        'arguments': greetRef.argumentsCodec.encode((name: 'Compact')),
      },
    );
    final response = await client!.post(
      '/__react/actions',
      request.encode(),
      headers: {
        'content-type': [compactProtocolContentType],
        serverFunctionProtocolHeader: ['$compactProtocolVersion'],
        serverFunctionIdHeader: [greetRef.id.value],
        serverFunctionContractHeader: [greetRef.contractHash],
      },
    );

    response.assertStatus(200);
    final frame = ReactFrame.decode(response.bodyBytes);
    expect(frame.kind, ReactMessageKind.result);
    expect(frame.payload, isA<Map>());
    final payload = Map<String, dynamic>.from(frame.payload! as Map);
    expect(payload['ok'], isTrue);
    expect(payload['result'], contains('Hello, Compact!'));
  });
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

Future<Directory> _resolveProjectRootFromTestHarness() async {
  final configRoot = await _resolveProjectRootFromPackageConfig(
    'react_server_routed_example',
  );
  if (configRoot != null) {
    return configRoot;
  }

  Directory candidate = File(
    Platform.script.toFilePath(),
  ).absolute.parent.parent;
  for (var i = 0; i < 8; i++) {
    if (_containsPubspec(
      candidate,
      expectedPackageName: 'react_server_routed_example',
    )) {
      return candidate;
    }
    if (candidate.path == candidate.parent.path) break;
    candidate = candidate.parent;
  }

  throw StateError(
    'Could not locate react_server_routed_example root from '
    '${Platform.script}; tried package config and ancestor traversal.',
  );
}

Future<Directory?> _resolveProjectRootFromPackageConfig(
  String packageName,
) async {
  final configUri = await Isolate.packageConfig;
  if (configUri == null) return null;

  final contents = await File.fromUri(configUri).readAsString();
  final decoded = jsonDecode(contents) as Map<String, dynamic>;
  final packages = decoded['packages'];
  if (packages is! List) return null;

  for (final entry in packages) {
    if (entry is! Map<String, dynamic>) continue;
    if (entry['name'] != packageName) continue;
    final rawRootUri = entry['rootUri'];
    if (rawRootUri is! String) continue;
    final root = Directory.fromUri(configUri.resolve(rawRootUri));
    if (root.existsSync()) return root;
  }
  return null;
}

bool _containsPubspec(
  Directory directory, {
  required String expectedPackageName,
}) {
  final pubspec = File(p.join(directory.path, 'pubspec.yaml'));
  if (!pubspec.existsSync()) return false;

  final raw = pubspec.readAsStringSync();
  return raw.contains('name: $expectedPackageName');
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
