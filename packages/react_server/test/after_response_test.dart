import 'package:react_server/react_server.dart';
import 'package:test/test.dart';

void main() {
  test('runs callbacks in order and isolates failures', () async {
    final lifecycle = ReactAfterResponse();
    final events = <String>[];
    lifecycle.add(() => events.add('first'));
    lifecycle.add(() {
      events.add('failure');
      throw StateError('ignored');
    });
    lifecycle.add(() async {
      await Future<void>.delayed(Duration.zero);
      events.add('last');
    });

    await lifecycle.run();
    expect(events, ['first', 'failure', 'last']);
    await lifecycle.run();
    expect(events, ['first', 'failure', 'last']);
  });
}
