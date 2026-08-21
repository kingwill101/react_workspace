import 'package:react_server/react_server.dart';
import 'package:test/test.dart';

void main() {
  test('expires documents and invalidates by tag', () async {
    final cache = ReactDocumentCache(defaultTtl: const Duration(seconds: 1));
    cache.put('home', '<h1>Home</h1>', tags: ['home', 'public']);
    cache.put('account', '<h1>Account</h1>', tags: ['private']);

    expect(cache.get('home')?.html, '<h1>Home</h1>');
    cache.invalidateTag('public');
    expect(cache.get('home'), isNull);
    expect(cache.get('account')?.html, '<h1>Account</h1>');

    cache.put('short', 'expired', ttl: Duration.zero);
    await Future<void>.delayed(const Duration(milliseconds: 1));
    expect(cache.get('short'), isNull);
  });

  test('keeps a stale document during the revalidation window', () async {
    final cache = ReactDocumentCache(defaultTtl: Duration.zero);
    cache.put(
      'home',
      'stale html',
      staleWhileRevalidate: const Duration(seconds: 1),
    );

    expect(cache.get('home'), isNull);
    expect(cache.getStale('home')?.html, 'stale html');
  });
}
