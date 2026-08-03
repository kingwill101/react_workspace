import 'dart:io';

import 'package:server_testing/server_testing.dart';
import 'package:test/test.dart';

import '_static_handler.dart';

void main() {
  late StaticFileHandler handler;
  late int port;

  setUpAll(() async {
    handler = StaticFileHandler(Directory('build/react'));
    port = await handler.startServer();
  });

  tearDownAll(() => handler.close());

  serverTest('serves the home page at /', (client, _) async {
    final response = await client.get('/');
    response.assertStatus(200);
    expect(response.body, contains('<div id="app"></div>'));
    expect(response.body, contains('client.js'));
  });

  serverTest('serves the client JS bundle', (client, _) async {
    final response = await client.get('/client.js');
    response.assertStatus(200);
    expect(response.body, contains('React'));
  });

  serverTest('serves the stylesheet', (client, _) async {
    final response = await client.get('/styles.css');
    response.assertStatus(200);
    expect(response.body, contains('body'));
  });

  serverTest('serves the importmap script tag', (client, _) async {
    final response = await client.get('/');
    response.assertStatus(200);
    expect(response.body, contains('esm.sh/react'));
    expect(response.body, contains('esm.sh/react-dom'));
  });

  serverTest('returns 404 for missing files', (client, _) async {
    final response = await client.get('/nonexistent.js');
    response.assertStatus(404);
  });

  serverTest('SPA fallback serves index.html for unknown paths', (client, _) async {
    final response = await client.get('/any/route');
    response.assertStatus(200);
    expect(response.body, contains('<div id="app"></div>'));
  });
}