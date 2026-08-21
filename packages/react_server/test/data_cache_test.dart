import 'dart:async';

import 'package:react_server/react_server.dart';
import 'package:test/test.dart';

void main() {
  test('deduplicates concurrent typed loads', () async {
    final cache = ReactDataCache();
    var loads = 0;
    final futures = [
      cache.getOrLoad<String>('greeting', () async {
        loads++;
        await Future<void>.delayed(const Duration(milliseconds: 1));
        return 'hello';
      }),
      cache.getOrLoad<String>('greeting', () async {
        loads++;
        return 'unexpected';
      }),
    ];

    expect(await Future.wait(futures), ['hello', 'hello']);
    expect(loads, 1);
  });

  test(
    'invalidates values by tag and serves stale data while refreshing',
    () async {
      final cache = ReactDataCache(defaultTtl: Duration.zero);
      var value = 'first';
      expect(
        await cache.getOrLoad<String>(
          'item',
          () => value,
          staleWhileRevalidate: const Duration(seconds: 1),
          tags: ['items'],
        ),
        'first',
      );

      value = 'second';
      expect(
        await cache.getOrLoad<String>(
          'item',
          () => value,
          staleWhileRevalidate: const Duration(seconds: 1),
          tags: ['items'],
        ),
        'first',
      );
      await Future<void>.delayed(const Duration(milliseconds: 1));
      expect(await cache.getOrLoad<String>('item', () => value), 'second');

      cache.invalidateTag('items');
      expect(await cache.getOrLoad<String>('item', () => 'third'), 'third');
    },
  );
}
