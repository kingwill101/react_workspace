import 'dart:io';

import 'package:react_testing/react_testing.dart';
import 'package:server_testing/server_testing.dart';

import '_static_handler.dart';

void main() {
  late ReactTestHarness react;
  final handler = StaticFileHandler(Directory('build/react'));

  setUpAll(() async {
    react = await ReactTestHarness.start(
      projectRoot: Directory.current,
      ssr: false,
    );
    await handler.startServer();
  });

  tearDownAll(() async {
    await handler.close();
    await react.close();
  });

  serverTest('serves the home page at /', (client, _) async {
    final response = await client.get('/');
    response.assertStatus(200);
    expect(response.body, contains('<div id="app"></div>'));
    expect(response.body, contains('browser.entry.mjs'));
  }, handler: handler);

  serverTest('serves the client JS bundle', (client, _) async {
    final response = await client.get('/browser.entry.mjs');
    response.assertStatus(200);
    expect(response.body, contains('React'));
  }, handler: handler);

  serverTest('serves the stylesheet', (client, _) async {
    final response = await client.get('/styles.css');
    response.assertStatus(200);
    expect(response.body, contains('body'));
  }, handler: handler);

  serverTest('serves the importmap script tag', (client, _) async {
    final response = await client.get('/');
    response.assertStatus(200);
    expect(response.body, contains('esm.sh/react'));
    expect(response.body, contains('esm.sh/react-dom'));
  }, handler: handler);

  serverTest('SPA fallback serves index.html for unknown paths', (
    client,
    _,
  ) async {
    final response = await client.get('/any/route');
    response.assertStatus(200);
    expect(response.body, contains('<div id="app"></div>'));
  }, handler: handler);
}
