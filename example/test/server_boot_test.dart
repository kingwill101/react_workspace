import 'dart:io';

import 'package:example/server_actions.g.dart';
import 'package:react_testing/react_testing.dart';
import 'package:server_testing/server_testing.dart';

const _appId = 'package:example/lib/app.dart#App';

void main() {
  late ReactTestHarness harness;

  setUpAll(() async {
    harness = await ReactTestHarness.start(
      projectRoot: Directory('example'),
      rootComponent: _appId,
      registerActions: (registry) => registerServerActions(registry: registry),
      pageProps: (request) => {'title': 'hi'},
    );
  });

  tearDownAll(() => harness.close());

  test('server boots and serves SSR-rendered content at /', () async {
    final client = harness.createClient();
    final response = await client.get('/');

    response.assertStatus(200);
    final body = response.body;

    // Router renders through the SSR worker.
    expect(body, contains('location: /'));
    expect(body, contains('Home route — pick a destination above.'));

    // Foreign component surfaces render.
    expect(body, contains('Count (zustand)'));
    expect(body, contains('Count (riverpod)'));
    expect(body, contains('Count (bloc)'));

    // Server-function surface starts in its loading state.
    expect(body, contains('Loading tasks…'));

    // Hydration contract: props are embedded for the client mount.
    expect(body, contains('id="__props"'));
    expect(body, contains('title'));
  });
}
