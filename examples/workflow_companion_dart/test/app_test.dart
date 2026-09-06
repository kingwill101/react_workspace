import 'package:react_core/react.dart';
import 'package:react_testing/react_testing.dart';
import 'package:test/test.dart';

import 'package:workflow_companion_dart/react/app.dart';
import 'package:workflow_companion_dart/react/app_shell.dart';

void main() {
  group('App (client)', () {
    test('renders via ReactComponentHarness', () {
      final harness = ReactComponentHarness();
      final node = harness.run(
        () => AppShell((children: [App((title: 'Hello'))])),
      );
      // The shell returns the outer theme context provider. The browser
      // entrypoint renders the provider's children below this node.
      expect(node, isA<ContextProvider>());
    });

    test('InMemorySsrHarness for shell (client-only)', () {
      final harness = InMemorySsrHarness(
        indexTemplate: '<div id="app">{{SSR}}</div>',
      );
      final doc = harness.render(renderedHtml: '<div>Client</div>', props: {});
      expect(doc, contains('Client'));
      harness.assertDocument(doc, containsHtml: '<div>Client</div>');
    });

    test('react_testing assertions', () {
      const host = HostNode(HostType('web', 'div'), {'id': 'app'});
      host.shouldBeHost('div');
      '<div>hi</div>'.shouldContainTag('div');
    });
  });
}
