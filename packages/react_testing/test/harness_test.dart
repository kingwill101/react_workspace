import 'dart:io';

import 'package:react/react.dart';
import 'package:react_actions/react_actions.dart';
import 'package:react_server/react_server.dart';
import 'package:react_testing/react_testing.dart';
import 'package:server_testing/server_testing.dart';
import 'package:server_testing_shelf/server_testing_shelf.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

class _StringCodec extends ServerFunctionJsonCodec<String> {
  @override
  String decode(dynamic json) => json as String;
  @override
  String encode(String value) => value;
}

class _ArgsCodec extends ServerFunctionJsonCodec<({String name})> {
  @override
  ({String name}) decode(dynamic json) => (name: (json as Map)['name'] as String);
  @override
  Map<String, dynamic> encode(({String name}) value) => {'name': value.name};
}

final _echoRef = ServerFunctionRef<String, String>(
  id: const ServerFunctionId('test.echo'),
  contractHash: 'sha256:echo-v1',
  argumentsCodec: _StringCodec(),
  resultCodec: _StringCodec(),
);

final _greetRef = ServerFunctionRef<({String name}), String>(
  id: const ServerFunctionId('test.greet'),
  contractHash: 'sha256:greet-v1',
  argumentsCodec: _ArgsCodec(),
  resultCodec: _StringCodec(),
);

void main() {
  group('ServerFunctionHarness', () {
    test('dispatch round-trips typed arguments and result', () async {
      final harness = ServerFunctionHarness();
      harness.registry.register(_echoRef, (args, ctx) => 'echo:$args');
      final result = await harness.dispatch(_echoRef, 'hello');
      expect(result, 'echo:hello');
    });

    test('dispatch with complex record codec', () async {
      final harness = ServerFunctionHarness();
      harness.registry.register(_greetRef, (args, ctx) => 'Hi ${args.name}');
      final result = await harness.dispatch(_greetRef, (name: 'Ada'));
      expect(result, 'Hi Ada');
    });

    test('envelope builds correct JSON structure', () {
      final harness = ServerFunctionHarness();
      final env = harness.envelope(_echoRef, 'test');
      expect(env['protocol'], serverFunctionProtocolVersion);
      expect(env['id'], 'test.echo');
      expect(env['contract'], 'sha256:echo-v1');
      expect(env['arguments'], 'test');
    });

    test('staleEnvelope uses wrong contract', () {
      final harness = ServerFunctionHarness();
      final env = harness.staleEnvelope(_echoRef, 'test');
      expect(env['contract'], 'sha256:stale-contract');
      expect(env['contract'], isNot(_echoRef.contractHash));
    });

    test('createClient dispatches via HTTP and validates success', () async {
      final harness = ServerFunctionHarness();
      harness.registry.register(_greetRef, (args, ctx) => 'Hello ${args.name}');
      final client = harness.createClient();
      final response = await client.postJson('/__react/actions', harness.envelope(_greetRef, (name: 'Ada')));
      response.assertServerFunctionSuccess('Hello Ada');
    });

    test('expectFailure validates failure code', () async {
      final harness = ServerFunctionHarness();
      harness.registry.register(_echoRef, (args, ctx) {
        throw const ServerFunctionFailure(code: 'bad_input', message: 'bad', statusCode: 400);
      });
      await harness.expectFailure(_echoRef, 'x', code: 'bad_input');
    });

    test('expectFailure throws if dispatch succeeds', () async {
      final harness = ServerFunctionHarness();
      harness.registry.register(_echoRef, (args, ctx) => 'ok');
      expect(() => harness.expectFailure(_echoRef, 'x', code: 'bad_input'), throwsStateError);
    });

    test('HTTP-level contract mismatch is rejected', () async {
      final harness = ServerFunctionHarness();
      harness.registry.register(_echoRef, (args, ctx) => args);
      final client = harness.createClient();
      final response = await client.postJson('/__react/actions', harness.staleEnvelope(_echoRef, 'hi'));
      response.assertContractMismatch();
    });

    test('in-memory client rejects unauthenticated when authenticate returns null', () async {
      final harness = ServerFunctionHarness(authenticate: (_) => null);
      final privilegedRef = ServerFunctionRef<String, String>(
        id: const ServerFunctionId('test.priv'),
        contractHash: 'sha256:priv',
        argumentsCodec: _StringCodec(),
        resultCodec: _StringCodec(),
      );
      harness.registry.register(privilegedRef, (args, ctx) {
        ctx.requireUser();
        return 'secret';
      });
      final client = harness.createClient();
      final response = await client.postJson('/__react/actions', harness.envelope(privilegedRef, 'x'));
      response.assertUnauthenticated();
    });

    test('SsrTestHarness mockRender injects HTML', () async {
      final ssrHarness = SsrTestHarness(indexTemplate: '<html>{{SSR}} - {{PROPS}}</html>');
      ssrHarness.mockRender('<div>mocked</div>', props: {'a': 1});
      final app = await ssrHarness.start();
      final client = TestClient.inMemory(ShelfRequestHandler(app.handler));
      final resp = await client.get('/');
      expect(await resp.body, contains('<div>mocked</div>'));
      expect(await resp.body, contains('"a":1'));
      await ssrHarness.close();
    });

    test('InMemorySsrHarness renders template', () {
      final harness = InMemorySsrHarness(indexTemplate: 'HEAD:{{SSR}}:PROPS:{{PROPS}}');
      final doc = harness.render(renderedHtml: '<p>hi</p>', props: {'x': 1});
      expect(doc, contains('<p>hi</p>'));
      expect(doc, contains('"x":1'));
      harness.assertDocument(doc, containsHtml: '<p>hi</p>', containsProps: {'x': 1});
    });

    test('ReactComponentHarness renders nodes', () {
      final harness = ReactComponentHarness();
      final node = harness.run(() => const Text('hello'));
      expect(node, isA<Text>());
      expect((node as Text).value, 'hello');

      final div = harness.renderDiv(props: {'id': 'main'}, children: const [Text('child')]);
      expect(div.type.name, 'div');
      expect(div.children, hasLength(1));
    });

    test('TestRuntimes provide distinct targets', () {
      expect(TestRuntimes.standard.target, ReactRenderTarget.test);
      expect(TestRuntimes.browser.target, ReactRenderTarget.browser);
      expect(TestRuntimes.server.target, ReactRenderTarget.server);
    });
  });

  group('ServerFunctionResponseAssertions', () {
    test('assertServerFunctionSuccess validates envelope', () async {
      final harness = ServerFunctionHarness();
      harness.registry.register(_echoRef, (args, ctx) => 'ok');
      final client = harness.createClient();
      final response = await client.postJson('/__react/actions', harness.envelope(_echoRef, 'hi'));
      expect(() => response.assertServerFunctionSuccess('ok'), returnsNormally);
    });

    test('assertServerFunctionError validates error code', () async {
      final harness = ServerFunctionHarness();
      harness.registry.register(_echoRef, (args, ctx) => throw const ServerFunctionFailure(code: 'fail', message: 'x', statusCode: 400));
      final client = harness.createClient();
      final response = await client.postJson('/__react/actions', harness.envelope(_echoRef, 'hi'));
      expect(() => response.assertServerFunctionError('fail'), returnsNormally);
    });
  });
}
