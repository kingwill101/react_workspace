import 'package:client/app.dart';
import 'package:client/greeting.dart';
import 'package:react/react.dart';
import 'package:react_testing/react_testing.dart';
import 'package:test/test.dart';

void main() {
  test('client app renders its initial greeting', () {
    final harness = ReactComponentHarness();

    final node = harness.run(() => App((title: 'Client example')));

    expect(_textContent(node), contains('Client example'));
    expect(_textContent(node), contains('Hello from the client'));
  });

  test('plain client helper remains usable without a server transport', () {
    expect(greet('Ada'), 'Hello, Ada! (client-only)');
  });
}

String _textContent(ReactNode node) => switch (node) {
  Text(:final value) => value,
  HostNode(:final children) ||
  Fragment(:final children) => children.map(_textContent).join(),
  _ => '',
};
