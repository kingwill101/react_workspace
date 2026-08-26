import 'package:client/app.dart';
import 'package:client/greeting.dart';
import 'package:client/shadcn.dart';
import 'package:react_core/react.dart';
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

  test('generated shadcn wrapper preserves the foreign component contract', () {
    final harness = ReactComponentHarness();
    var pressed = false;

    final node = harness.run(
      () => shadcnButton(
        size: 'lg',
        disabled: false,
        onClick: ReactCallback.zero(() => pressed = true),
        children: [const Text('Continue')],
      ),
    );

    expect(node, isA<ForeignComponent>());
    final foreign = node as ForeignComponent;
    expect(foreign.name, 'shadcn.Button');
    expect(foreign.props['size'], 'lg');
    expect(foreign.props['disabled'], false);
    expect(foreign.props['onClick'], isA<ReactCallback>());
    expect(_textContent(node), 'Continue');

    (foreign.props['onClick'] as ReactCallback).invoke(const []);
    expect(pressed, isTrue);
  });
}

String _textContent(ReactNode node) => switch (node) {
  Text(:final value) => value,
  HostNode(:final children) ||
  Fragment(:final children) => children.map(_textContent).join(),
  ForeignComponent(:final children) => children.map(_textContent).join(),
  _ => '',
};
