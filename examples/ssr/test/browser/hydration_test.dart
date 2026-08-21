import 'dart:async' as async;
import 'dart:io';

import 'package:example/.generated/server_actions.g.dart';
import 'package:react_server/react_server.dart';
import 'package:react_server_shelf/react_server_shelf.dart';
import 'package:react_testing/react_testing.dart';
import 'package:server_testing/server_testing.dart';
import 'package:server_testing_shelf/server_testing_shelf.dart';
import 'package:shelf/shelf.dart' show Request;
import 'package:shelf_static/shelf_static.dart';

const _appId = 'package:example/lib/app.dart#App';

void main() async {
  await testBootstrap(
    BrowserConfig(
      browserName: 'chromium',
      headless: true,
      autoInstall: true,
      loggingEnabled: false,
    ),
  );

  ReactTestHarness? react;
  ShelfRequestHandler? handler;
  late Uri origin;
  final exchanges = <String>[];

  setUpAll(() async {
    final testHarness = await ReactTestHarness.start(
      projectRoot: Directory.current,
      runCodegen: Platform.environment['REACT_TESTING_PREGENERATED'] != 'true',
    );
    react = testHarness;
    final registry = ServerFunctionRegistry();
    registerServerActions(registry: registry);

    final app = ReactServerApp(
      actionRegistry: registry,
      staticHandler: createStaticHandler(
        testHarness.outputDirectory.path,
        defaultDocument: 'index.html',
      ),
      indexTemplate: testHarness.indexTemplate,
      ssr: testHarness.ssrClient,
      rootComponent: _appId,
      pageProps: (request) => {
        'title': 'React Dart',
        'path': _documentPath(request.url),
      },
    );
    final appHandler = app.handler;
    final requestHandler = ShelfRequestHandler((Request request) async {
      final requestLabel = '${request.method} /${request.url}';
      exchanges.add('$requestLabel -> pending');
      final response = await appHandler(request);
      exchanges.add('$requestLabel -> ${response.statusCode}');
      return response;
    });
    handler = requestHandler;
    final port = await requestHandler.startServer();
    origin = Uri.parse('http://127.0.0.1:$port');
  });

  tearDownAll(() async {
    await handler?.close();
    await react?.close();
  });

  browserTest(
    'hydrates SSR, handles events, and calls a typed server function',
    (browser) async {
      await browser.visit(origin.toString());
      await browser.assertSee('Quick counter');
      await browser.assertSeeIn('.counter-widget .count-value', '0');

      // The heading and initial count come from SSR. Wait for the counter's
      // effect to commit before clicking so this assertion also proves the
      // browser bundle hydrated and attached its event handlers.
      await browser.waitForText(
        'Effect ready',
        timeout: const Duration(seconds: 15),
      );

      await browser.click('.counter-widget button');
      await browser.waitUntil(() async {
        return await browser.getElementText('.counter-widget .count-value') ==
            '1';
      }, timeout: const Duration(seconds: 15));
      await browser.assertSeeIn('.counter-widget .count-value', '1');

      await browser.visit(origin.resolve('/state/todos').toString());
      try {
        await browser.waitUntil(() async {
          final body = await browser.getElementText('body');
          return body.contains('SERVER ACTIONS') && body.contains('4 open') ||
              body.contains('Error:');
        }, timeout: const Duration(seconds: 15));
      } on async.TimeoutException {
        final body = await browser.getElementText('body');
        fail(
          'The server-function page did not settle.\n'
          'HTTP exchanges:\n${exchanges.join('\n')}\n'
          'Rendered body:\n$body',
        );
      }
      final todoPage = await browser.getElementText('body');
      expect(
        todoPage,
        allOf(contains('SERVER ACTIONS'), contains('4 open')),
        reason:
            'The server-function page did not load successfully:\n$todoPage',
      );
      await browser.assertSee('4 open');

      await browser.click('input[type="checkbox"]');
      await browser.waitForText('sync 1');
      await browser.assertSee('Changes are persisted by a typed RPC');
    },
  );
}

String _documentPath(Uri url) {
  var path = url.path;
  if (path.isEmpty) path = '/';
  if (!path.startsWith('/')) path = '/$path';
  if (url.query.isNotEmpty) path = '$path?${url.query}';
  return path;
}
