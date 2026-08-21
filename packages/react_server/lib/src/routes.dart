/// A route policy used by request-time document ISR.
final class ReactRoutePolicy {
  /// Creates a policy for [pattern].
  factory ReactRoutePolicy({
    required String pattern,
    Duration ttl = const Duration(minutes: 1),
    Duration staleWhileRevalidate = Duration.zero,
    List<String> tags = const <String>[],
  }) {
    if (ttl.isNegative || staleWhileRevalidate.isNegative) {
      throw ArgumentError('Route cache durations cannot be negative.');
    }
    return ReactRoutePolicy._(
      pattern: pattern,
      ttl: ttl,
      staleWhileRevalidate: staleWhileRevalidate,
      tags: tags,
    );
  }

  const ReactRoutePolicy._({
    required this.pattern,
    required this.ttl,
    required this.staleWhileRevalidate,
    required this.tags,
  });

  /// Path pattern, supporting `:parameter` segments and a trailing `*`.
  final String pattern;

  /// Fresh lifetime for documents matching this pattern.
  final Duration ttl;

  /// Stale-serving window after [ttl].
  final Duration staleWhileRevalidate;

  /// Tags written with the rendered document.
  final List<String> tags;

  /// Returns whether [path] matches this policy's pattern.
  bool matches(String path) {
    final expected = _segments(pattern);
    final actual = _segments(path);
    for (var index = 0; index < expected.length; index++) {
      final segment = expected[index];
      if (segment == '*') return true;
      if (index >= actual.length) return false;
      if (segment.startsWith(':')) continue;
      if (segment != actual[index]) return false;
    }
    return expected.length == actual.length;
  }

  List<String> _segments(String path) => path
      .split('/')
      .where((segment) => segment.isNotEmpty)
      .toList(growable: false);
}

/// A declarative set of route policies for ISR.
final class ReactRouteManifest {
  /// Creates a manifest from route policies.
  ReactRouteManifest(Iterable<ReactRoutePolicy> routes)
    : routes = List<ReactRoutePolicy>.unmodifiable(routes);

  /// Reads `{ "routes": [...] }` JSON configuration.
  factory ReactRouteManifest.fromJson(Map<String, dynamic> json) {
    final rawRoutes = json['routes'];
    if (rawRoutes is! List) {
      throw const FormatException('Route manifest requires a routes array.');
    }
    return ReactRouteManifest(
      rawRoutes.map((raw) {
        if (raw is String) return ReactRoutePolicy(pattern: raw);
        if (raw is! Map) {
          throw const FormatException('Route entries must be strings or maps.');
        }
        final pattern = raw['pattern'];
        if (pattern is! String || pattern.isEmpty) {
          throw const FormatException('Route entries require a pattern.');
        }
        final ttlSeconds = raw['ttlSeconds'];
        final staleSeconds = raw['staleWhileRevalidateSeconds'];
        return ReactRoutePolicy(
          pattern: pattern,
          ttl: Duration(seconds: ttlSeconds is num ? ttlSeconds.toInt() : 60),
          staleWhileRevalidate: Duration(
            seconds: staleSeconds is num ? staleSeconds.toInt() : 0,
          ),
          tags: (raw['tags'] is List)
              ? (raw['tags'] as List).whereType<String>().toList()
              : const <String>[],
        );
      }),
    );
  }

  /// Route policies in declaration order. The first matching policy wins.
  final List<ReactRoutePolicy> routes;

  /// Finds the first policy matching [path].
  ReactRoutePolicy? match(String path) {
    for (final route in routes) {
      if (route.matches(path)) return route;
    }
    return null;
  }
}
