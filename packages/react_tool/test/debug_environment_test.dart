import 'package:react_tool/src/debug_environment.dart';
import 'package:test/test.dart';

void main() {
  test('puts the running SDK ahead of PATH wrappers and preserves temp', () {
    final original = {'PATH': '/wrapper/bin:/usr/bin', 'TMP': '.tmp'};
    final result = debugEnvironment(
      executable: '/sdk/bin/dart',
      environment: original,
      windows: false,
    );
    expect(result['PATH'], '/sdk/bin:/wrapper/bin:/usr/bin');
    expect(result['TMP'], '.tmp');
    expect(original['PATH'], '/wrapper/bin:/usr/bin');
  });

  test('preserves Windows Path casing and uses semicolons', () {
    final result = debugEnvironment(
      executable: r'C:\sdk\bin\dart.exe',
      environment: {'Path': r'C:\wrapper;C:\Windows'},
      windows: true,
    );
    expect(result, {'Path': r'C:\sdk\bin;C:\wrapper;C:\Windows'});
  });

  test('handles an absent PATH', () {
    expect(
      debugEnvironment(
        executable: '/sdk/bin/dart',
        environment: {},
        windows: false,
      ),
      {'PATH': '/sdk/bin'},
    );
  });
}
