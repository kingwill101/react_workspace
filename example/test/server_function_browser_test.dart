import 'dart:convert';
import 'dart:io';

import 'package:example/server_actions.g.dart';
import 'package:react_testing/react_testing.dart';
import 'package:server_testing/server_testing.dart';

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
    projectRoot: Directory('example'),
    rootComponent: _appId,
    registerActions: (registry) => registerServerActions(registry: registry),
    pageProps: (request) => {'title': 'hi'},
  );
  final baseUrl = harness.baseUrl;

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
      expect(page, contains('location: /'));
      expect(page, contains('Home route — pick a destination above.'));

      await browser.visit('/');
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

  tearDownAll(harness.close);
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
