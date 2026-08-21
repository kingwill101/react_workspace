import 'dart:async';

import 'data_cache.dart';

/// Produces already-rendered HTML for a partial document boundary.
typedef ReactPartialMarkupBuilder = FutureOr<String> Function();

/// A separately cached dynamic region in a [ReactPartialDocument].
final class ReactPartialRegion {
  /// Creates a dynamic region identified by [key].
  const ReactPartialRegion({
    required this.key,
    required this.render,
    this.ttl = const Duration(minutes: 1),
    this.staleWhileRevalidate = Duration.zero,
  });

  /// Stable cache key for this region.
  final String key;

  /// Renders the region's HTML when its cache entry is missing or refreshed.
  final ReactPartialMarkupBuilder render;

  /// Lifetime of a fresh region value.
  final Duration ttl;

  /// How long an expired region may be served while it refreshes.
  final Duration staleWhileRevalidate;
}

/// A static shell with independently cached dynamic HTML regions.
///
/// The [shell] must contain one `<!--react-partial:KEY-->` marker for every
/// region in [regions]. The shell and each region are loaded through the
/// supplied [ReactDataCache], so a frequently changing region can revalidate
/// without expiring the route shell or unrelated regions.
final class ReactPartialDocument {
  /// Creates a partial document descriptor.
  const ReactPartialDocument({
    required this.shellKey,
    required this.shell,
    required this.regions,
    this.shellTtl = const Duration(minutes: 5),
    this.shellStaleWhileRevalidate = Duration.zero,
  });

  /// Stable cache key for the static shell.
  final String shellKey;

  /// Produces the shell HTML containing region markers.
  final ReactPartialMarkupBuilder shell;

  /// Dynamic regions inserted into the shell.
  final List<ReactPartialRegion> regions;

  /// Lifetime of a fresh shell value.
  final Duration shellTtl;

  /// How long an expired shell may be served while it refreshes.
  final Duration shellStaleWhileRevalidate;

  /// Resolves the shell and regions into one response document.
  Future<String> render(ReactDataCache cache) async {
    var document = await cache.getOrLoad<String>(
      shellKey,
      shell,
      ttl: shellTtl,
      staleWhileRevalidate: shellStaleWhileRevalidate,
    );
    for (final region in regions) {
      final marker = '<!--react-partial:${region.key}-->';
      if (!document.contains(marker)) {
        throw StateError(
          'Partial document shell is missing the marker for "${region.key}".',
        );
      }
      final html = await cache.getOrLoad<String>(
        region.key,
        region.render,
        ttl: region.ttl,
        staleWhileRevalidate: region.staleWhileRevalidate,
      );
      document = document.replaceFirst(marker, html);
    }
    return document;
  }
}
