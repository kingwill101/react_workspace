import 'dart:io';

import 'package:react_server/react_server.dart';
import 'package:test/test.dart';

void main() {
  late Directory directory;
  late FileReactDocumentStore store;

  setUp(() async {
    directory = await Directory.systemTemp.createTemp('react_document_store_');
    store = FileReactDocumentStore(directory);
  });

  tearDown(() async {
    if (directory.existsSync()) await directory.delete(recursive: true);
  });

  test('persists documents and reports stale records', () async {
    await store.write(
      '/home',
      '<main>home</main>',
      ttl: Duration.zero,
      staleWhileRevalidate: const Duration(minutes: 1),
      tags: const ['home'],
    );

    final stored = await store.read('/home');
    expect(stored?.html, '<main>home</main>');
    expect(stored?.stale, isTrue);
    expect(stored?.tags, contains('home'));

    // A newly-created store reads the same on-disk record.
    final restarted = FileReactDocumentStore(directory);
    expect((await restarted.read('/home'))?.html, '<main>home</main>');
  });

  test('invalidates records by tag and key', () async {
    await store.write(
      'one',
      'one',
      ttl: const Duration(minutes: 1),
      staleWhileRevalidate: Duration.zero,
      tags: const ['group'],
    );
    await store.write(
      'two',
      'two',
      ttl: const Duration(minutes: 1),
      staleWhileRevalidate: Duration.zero,
      tags: const ['other'],
    );

    await store.invalidateTag('group');
    expect(await store.read('one'), isNull);
    expect((await store.read('two'))?.html, 'two');
    await store.invalidate('two');
    expect(await store.read('two'), isNull);
  });
}
