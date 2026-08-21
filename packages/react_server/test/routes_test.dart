import 'package:react_server/react_server.dart';
import 'package:test/test.dart';

void main() {
  test('loads route policies and matches parameterized paths', () {
    final manifest = ReactRouteManifest.fromJson({
      'routes': [
        {
          'pattern': '/blog/:slug',
          'ttlSeconds': 30,
          'staleWhileRevalidateSeconds': 60,
          'tags': ['blog'],
        },
        {'pattern': '/assets/*', 'ttlSeconds': 300},
      ],
    });

    final blog = manifest.match('/blog/hello-world');
    expect(blog?.ttl, const Duration(seconds: 30));
    expect(blog?.staleWhileRevalidate, const Duration(seconds: 60));
    expect(blog?.tags, ['blog']);
    expect(manifest.match('/assets/app.js')?.ttl, const Duration(seconds: 300));
    expect(manifest.match('/missing'), isNull);
  });
}
