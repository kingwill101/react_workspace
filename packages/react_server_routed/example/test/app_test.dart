import 'package:react/react.dart';
import 'package:react_server/react_server.dart';
import 'package:react_server_routed/react_server_routed.dart';
import 'package:react_testing/react_testing.dart';
import 'package:routed_core/routed_core.dart';
import 'package:routed_testing/routed_testing.dart';
import 'package:server_testing/server_testing.dart';

import 'package:react_server_routed_example/app.dart';

void main() {
  group('App', () {
    test('renders title via ReactComponentHarness (no build)', () {
      final harness = ReactComponentHarness();
      final node = harness.run(() => App((title: 'Hello')));
      expect(node, isA<HostNode>());
      harness.assertHostNode(node, namespace: 'html', name: 'div');
    });

    test('renders SSR document via InMemorySsrHarness', () {
      final harness = InMemorySsrHarness(
        indexTemplate: '<div id="app">{{SSR}}</div><script>{{PROPS}}</script>',
      );
      final doc = harness.render(
        renderedHtml: '<div>SSR: Hello</div>',
        props: {'title': 'Hello'},
      );
      expect(doc, contains('SSR: Hello'));
      expect(doc, contains('"title":"Hello"'));
      harness.assertDocument(
        doc,
        containsHtml: 'SSR: Hello',
        containsProps: {'title': 'Hello'},
      );
    });

    test('SSR mock via SsrTestHarness (no Node build)', () async {
      final harness = SsrTestHarness();
      harness.mockRender('<div>mocked</div>', props: {'title': 'Mock'});
      final ssr = await harness.start();
      final app = RoutedReactApplication(
        actionRegistry: ServerFunctionRegistry(),
        staticHandler: (context) => context.string('static'),
        indexTemplate: '<div>{{SSR}}</div>',
        ssr: ssr,
        rootComponent: 'package:react_server_routed_example/lib/app.dart#App',
      );
      final engine = Engine();
      app.mount(engine);
      final client = TestClient.inMemory(RoutedRequestHandler(engine, true));
      final response = await client.get('/');
      response.assertStatus(200);
      expect(response.body, contains('mocked'));
      await client.close();
      await harness.close();
    });

    test('TestRuntimes covers browser/server/test targets', () {
      expect(TestRuntimes.standard.target, ReactRenderTarget.test);
      expect(TestRuntimes.browser.capabilities.supportsEffects, isTrue);
      expect(TestRuntimes.server.capabilities.supportsEvents, isFalse);
    });
  });
}
