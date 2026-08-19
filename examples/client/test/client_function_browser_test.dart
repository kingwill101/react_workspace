import 'dart:io';

import 'package:server_testing/server_testing.dart';
import 'dart:convert';
import '_static_handler.dart';

Future<void> main() async {
  if (Platform.environment['RUN_BROWSER_E2E'] != '1') {
    test(
      'client hydrates and renders the greeting',
      () {},
      skip: 'Set RUN_BROWSER_E2E=1 to run the browser E2E test.',
    );
    return;
  }

  final handler = StaticFileHandler(Directory('examples/client/build/react'));
  final port = await handler.startServer();
  final baseUrl = 'http://127.0.0.1:$port';

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
      logDir: '/tmp/opencode/react_client_e2e_logs',
      defaultWaitTimeout: const Duration(seconds: 20),
    ),
  );

  browserTest(
    'client hydrates and renders the greeting',
    (browser) async {
      final page = await _get(baseUrl);
      expect(page, contains('<div id="app"></div>'));

      await browser.visit('/');
      await browser.waitForText('Hello from the client');

      final appText = await browser.executeScript(
        'return document.querySelector("#app").textContent;',
      );
      expect(appText, contains('Hello from the client'));
    },
    headless: true,
    baseUrl: baseUrl,
    timeout: const Duration(seconds: 30),
  );

  await handler.close();
}

Future<String> _get(String url) async {
  final uri = Uri.parse(url);
  final client = HttpClient();
  try {
    final response = await client
        .getUrl(uri)
        .then((request) => request.close());
    return response.transform(utf8.decoder).join();
  } finally {
    client.close(force: true);
  }
}
