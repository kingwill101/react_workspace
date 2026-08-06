import 'package:react_testing/react_testing.dart';
import 'package:test/test.dart';

void main() {
  group('client build (react_testing InMemorySsrHarness)', () {
    test('renders SSR shell without needing build output', () {
      final harness = InMemorySsrHarness(
        indexTemplate: '<html><body>{{SSR}}</body><script id="__props">{{PROPS}}</script></html>',
      );

      const ssrHtml = '<div id="app">Hello from the client</div>';
      final doc = harness.render(
        renderedHtml: ssrHtml,
        props: {'title': 'Hello from the client'},
      );

      harness.assertDocument(
        doc,
        containsHtml: ssrHtml,
        containsProps: {'title': 'Hello from the client'},
      );
      expect(doc, contains('<div id="app">'));
      expect(doc, contains('__props'));
    });

    test('SsrTestHarness mocks SSR for client app (no app build required)', () async {
      final harness = SsrTestHarness(
        indexTemplate: '<div>{{SSR}}</div>',
      );
      harness.mockRender('<div>mocked client</div>', props: {'title': 'Mock'});
      await harness.start(rootComponent: 'package:client/lib/app.dart#App');
      final client = harness.createClient();
      final response = await client.get('/');
      response.assertStatus(200);
      expect(response.body, contains('mocked client'));
      await harness.close();
    });
  });
}
