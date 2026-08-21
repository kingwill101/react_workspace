import 'package:react/react.dart';
import 'package:react_actions/react_actions.dart';
import 'package:react_testing/react_testing.dart';
import 'package:server_testing/server_testing.dart';

class _StringCodec extends ServerFunctionJsonCodec<String> {
  @override
  String decode(dynamic json) => json as String;
  @override
  String encode(String value) => value;
}

class _ArgsCodec extends ServerFunctionJsonCodec<({String name})> {
  @override
  ({String name}) decode(dynamic json) =>
      (name: (json as Map)['name'] as String);
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

    test('expectFailure validates failure code', () async {
      final harness = ServerFunctionHarness();
      harness.registry.register(_echoRef, (args, ctx) {
        throw const ServerFunctionFailure(
          code: 'bad_input',
          message: 'bad',
          statusCode: 400,
        );
      });
      await harness.expectFailure(_echoRef, 'x', code: 'bad_input');
    });

    test('expectFailure throws if dispatch succeeds', () async {
      final harness = ServerFunctionHarness();
      harness.registry.register(_echoRef, (args, ctx) => 'ok');
      expect(
        () => harness.expectFailure(_echoRef, 'x', code: 'bad_input'),
        throwsStateError,
      );
    });

    test('SsrTestHarness returns configured worker output', () async {
      final ssrHarness = SsrTestHarness();
      ssrHarness.mockRender('<div>mocked</div>', props: {'a': 1});
      final ssr = await ssrHarness.start();
      final rendered = await ssr.render(
        component: 'test.Root',
        props: const {},
      );
      expect(rendered.html, '<div>mocked</div>');
      expect(rendered.props, {'a': 1});
      await ssrHarness.close();
    });

    test('createClient accepts a server_testing handler', () async {
      final harness = ServerFunctionHarness();
      final client = harness.createClient(
        const FixedResponseClient({'ok': true}),
      );
      final response = await client.get('/');
      response.assertStatus(200).assertJsonContains({'ok': true});
      await client.close();
    });

    test('InMemorySsrHarness renders template', () {
      final harness = InMemorySsrHarness(
        indexTemplate: 'HEAD:{{SSR}}:PROPS:{{PROPS}}',
      );
      final doc = harness.render(renderedHtml: '<p>hi</p>', props: {'x': 1});
      expect(doc, contains('<p>hi</p>'));
      expect(doc, contains('"x":1'));
      harness.assertDocument(
        doc,
        containsHtml: '<p>hi</p>',
        containsProps: {'x': 1},
      );
    });

    test('ReactComponentHarness renders nodes', () {
      final harness = ReactComponentHarness();
      final node = harness.run(() => const Text('hello'));
      expect(node, isA<Text>());
      expect(node.value, 'hello');

      final div = harness.renderDiv(
        props: {'id': 'main'},
        children: const [Text('child')],
      );
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
      final client = TestClient.inMemory(
        const FixedResponseClient({
          'ok': true,
          'result': 'ok',
        }, contentType: serverFunctionContentType),
      );
      final response = await client.get('/');
      expect(() => response.assertServerFunctionSuccess('ok'), returnsNormally);
      await client.close();
    });

    test('assertServerFunctionError validates error code', () async {
      final client = TestClient.inMemory(
        const FixedResponseClient(
          {
            'ok': false,
            'error': {'code': 'fail'},
          },
          status: 400,
          contentType: serverFunctionContentType,
        ),
      );
      final response = await client.get('/');
      expect(() => response.assertServerFunctionError('fail'), returnsNormally);
      await client.close();
    });

    test('assertIsHtml accepts canonical header casing', () {
      final response = TestResponse(
        uri: '/',
        statusCode: 200,
        headers: const {
          'Content-Type': ['text/html; charset=utf-8'],
        },
        bodyBytes: const [],
      );

      expect(response.assertIsHtml, returnsNormally);
    });
  });
}
