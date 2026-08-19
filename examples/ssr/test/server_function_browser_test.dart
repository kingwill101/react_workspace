import 'dart:convert';
import 'dart:io';

import 'package:example/.generated/server_actions.g.dart';
import 'package:react_server/react_server.dart';
import 'package:react_server_shelf/react_server_shelf.dart';
import 'package:react_testing/react_testing.dart';
import 'package:server_testing/server_testing.dart';
import 'package:server_testing_shelf/server_testing_shelf.dart';
import 'package:shelf_static/shelf_static.dart';

const _appId = 'package:example/lib/app.dart#App';

Future<void> main() async {
  // Browser tests require a local Chromium/Chrome binary and the WebDriver
  // bootstrap. Keep them opt-in so the normal VM suite remains lightweight.
  if (Platform.environment['RUN_BROWSER_E2E'] != '1') {
    test(
      'SSR hydrates and invokes a generated server function',
      () {},
      skip: 'Set RUN_BROWSER_E2E=1 to run the browser E2E test.',
    );
    return;
  }

  final harness = await ReactTestHarness.start(
    projectRoot: Directory('examples/ssr'),
  );
  final registry = ServerFunctionRegistry();
  registerServerActions(registry: registry);
  final app = ReactServerApp(
    actionRegistry: registry,
    staticHandler: createStaticHandler(
      harness.outputDirectory.path,
      defaultDocument: 'index.html',
    ),
    indexTemplate: harness.indexTemplate,
    ssr: harness.ssrClient,
    rootComponent: _appId,
    pageProps: (request) => {'title': 'hi'},
  );
  final serverClient = harness.createClient(
    ShelfRequestHandler(app.handler),
    mode: TransportMode.ephemeralServer,
  );
  final baseUrl = await serverClient.baseUrlFuture;

  await testBootstrap(
    BrowserConfig(
      browserName: 'chromium',
      baseUrl: baseUrl,
      headless: true,
      binaryOverrides: {
        if (File('/usr/bin/chromium').existsSync())
          'chromium': '/usr/bin/chromium',
      },
      loggingEnabled: true,
      logDir: '/tmp/opencode/react_e2e_logs',
      defaultWaitTimeout: const Duration(seconds: 20),
    ),
  );

  browserTest(
    'SSR hydrates and invokes a generated server function',
    (browser) async {
      final page = await _get('$baseUrl/');
      expect(page, contains('Build interfaces with'));
      expect(page, contains('Explore routing →'));

      // Navigate to the server-actions page.
      await browser.visit('/state/todos');
      await browser.waitForText('4 open');
      await browser.waitForText('Build server functions');

      final initiallyChecked = await browser.executeScript(
        'return document.querySelector("input[type=checkbox]").checked;',
      );
      expect(initiallyChecked, isTrue);

      await browser.click('input[type=checkbox]');
      await browser.waitUntil(
        () async =>
            (await browser.executeScript(
              'return document.querySelector("input[type=checkbox]").checked;',
            )) ==
            false,
        timeout: const Duration(seconds: 10),
      );
    },
    headless: true,
    baseUrl: baseUrl,
    timeout: const Duration(seconds: 30),
  );

  browserTest(
    'home page invokes greetAction and displays the greeting',
    (browser) async {
      await browser.visit('/');
      await browser.waitForText('Hello, world!');
    },
    headless: true,
    baseUrl: baseUrl,
    timeout: const Duration(seconds: 30),
  );

  tearDownAll(() async {
    await serverClient.close();
    await harness.close();
  });
}

Future<String> _get(String url) async {
  final uri = Uri.parse(url);
  final client = HttpClient();
  try {
    final response = await client
        .getUrl(uri)
        .then((request) => request.close());
    return await response.transform(utf8.decoder).join();
  } finally {
    client.close(force: true);
  }
}
