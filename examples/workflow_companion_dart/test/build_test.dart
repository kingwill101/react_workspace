import 'dart:io';

import 'package:react_testing/react_testing.dart';
import 'package:test/test.dart';

void main() {
  test('release build emits the browser entrypoint and stylesheet', () async {
    final harness = await ReactTestHarness.start(
      projectRoot: Directory.current,
      release: true,
      ssr: false,
      runCodegen: false,
    );
    addTearDown(harness.close);

    final document = harness.asset('index.html').readAsStringSync();
    expect(document, contains('<link rel="stylesheet" href="/styles.css">'));
    expect(
      document,
      contains('<script type="module" src="/browser.js"></script>'),
    );
    expect(harness.asset('browser.js').existsSync(), isTrue);
    expect(harness.asset('styles.css').existsSync(), isTrue);
    expect(harness.asset('bundle_manifest.json').existsSync(), isTrue);
  }, timeout: const Timeout(Duration(minutes: 10)));
}
