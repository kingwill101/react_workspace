import 'package:react/react.dart';
import 'package:react_testing/react_testing.dart';
import 'package:superdesk/app.dart';
import 'package:test/test.dart';

void main() {
  group('Superdesk App (react_testing)', () {
    test('renders via ReactComponentHarness', () {
      final harness = ReactComponentHarness();
      final node = harness.run(() => App((title: 'Superdesk')));
      expect(node, isA<HostNode>());
    });

    test('InMemorySsrHarness renders shell', () {
      final harness = InMemorySsrHarness(
        indexTemplate: '<div>{{SSR}}</div><script>{{PROPS}}</script>',
      );
      final doc = harness.render(
        renderedHtml: '<div>Superdesk</div>',
        props: {'title': 'Superdesk'},
      );
      expect(doc, contains('Superdesk'));
      expect(doc, contains('"title":"Superdesk"'));
      harness.assertDocument(
        doc,
        containsHtml: '<div>Superdesk</div>',
        containsProps: {'title': 'Superdesk'},
      );
    });

    test('SsrTestHarness mocks SSR without build', () async {
      final harness = SsrTestHarness(
        indexTemplate: '<html>{{SSR}}</html>',
      );
      harness.mockRender('<div>mocked superdesk</div>');
      await harness.start(
        rootComponent: 'package:superdesk/lib/app.dart#App',
      );
      final client = harness.createClient();
      final response = await client.get('/dashboard');
      response.assertStatus(200);
      expect(response.body, contains('mocked superdesk'));
      await harness.close();
    });

    test('TestRuntimes standard supports hooks', () {
      final runtime = TestRuntimes.standard;
      final result = runWithReactRuntime(runtime, () {
        final (value, setValue) = useState<String>('hi');
        return value;
      });
      expect(result, 'hi');
    });
  });
}
