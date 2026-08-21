import 'package:client/app.dart';
import 'package:react/react.dart';
import 'package:react_testing/react_testing.dart';
import 'package:test/test.dart';

void main() {
  group('App (react_testing)', () {
    test('renders title via ReactComponentHarness', () {
      final harness = ReactComponentHarness();

      final node = harness.run(() => App((title: 'Hello')));

      expect(node, isA<HostNode>());
      final host = node as HostNode<Map<String, Object?>>;
      expect(host.type.name, 'div');
      // App contains an h1 with the title
      expect(host.children, isNotEmpty);
    });

    test('uses TestRuntimes for isolated hook test', () {
      final runtime = TestRuntimes.standard;
      final result = runWithReactRuntime(runtime, () {
        final (value, setter) = useState<int>(0);
        expect(value, 0);
        expect(setter, isA<StateSetter<int>>());
        return value;
      });
      expect(result, 0);
    });

    test('InMemorySsrHarness renders template for client shell', () {
      final harness = InMemorySsrHarness(
        indexTemplate: '<div id="app">{{SSR}}</div><script>{{PROPS}}</script>',
      );
      final doc = harness.render(
        renderedHtml: '<p>Hello</p>',
        props: {'title': 'Hello'},
      );
      expect(doc, contains('<p>Hello</p>'));
      expect(doc, contains('"title":"Hello"'));
      harness.assertDocument(
        doc,
        containsHtml: '<p>Hello</p>',
        containsProps: {'title': 'Hello'},
      );
    });

    test('assertions helpers work on nodes', () {
      const divNode = HostNode(
        HostType('web', 'div'),
        {'id': 'app'},
        children: [Text('hi')],
      );
      divNode.shouldBeHost('div');
      const Text('hi').shouldBeText('hi');

      '<div>hi</div>'.shouldContainHtml('<div>');
      '<div>hi</div>'.shouldContainTag('div');
    });
  });
}
