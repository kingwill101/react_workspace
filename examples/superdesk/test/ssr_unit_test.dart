import 'package:react_testing/react_testing.dart';
import 'package:test/test.dart';

void main() {
  group('Superdesk static assets (react_testing)', () {
    test('InMemorySsrHarness documents props', () {
      final harness = InMemorySsrHarness(
        indexTemplate: '<head>{{SSR}}</head>',
      );
      final doc = harness.render(renderedHtml: '<p>ok</p>', props: {});
      expect(doc, contains('<p>ok</p>'));
    });
  });
}
