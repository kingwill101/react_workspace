import 'dart:async';

/// A typed, request-friendly cache for server data loaders.
///
/// Concurrent loads for the same key are deduplicated. Expired values may be
/// served during the stale window while one background refresh runs.
final class ReactDataCache {
  /// Creates a data cache with default expiry and stale policies.
  ReactDataCache({
    this.defaultTtl = const Duration(minutes: 1),
    this.defaultStaleWhileRevalidate = Duration.zero,
  }) : assert(!defaultTtl.isNegative),
       assert(!defaultStaleWhileRevalidate.isNegative);

  /// Default lifetime for loaded values.
  final Duration defaultTtl;

  /// Default stale-serving window after [defaultTtl].
  final Duration defaultStaleWhileRevalidate;

  final _entries = <String, _DataEntry>{};
  final _inFlight = <String, Future<Object?>>{};

  /// Loads [key] once and returns its typed value.
  Future<T> getOrLoad<T>(
    String key,
    FutureOr<T> Function() loader, {
    Duration? ttl,
    Duration? staleWhileRevalidate,
    Iterable<String> tags = const <String>[],
  }) async {
    final existing = _read(key);
    if (existing != null) {
      if (!existing.stale) return existing.value as T;
      unawaited(
        _refresh(
          key,
          loader,
          ttl: ttl,
          staleWhileRevalidate: staleWhileRevalidate,
          tags: tags,
        ),
      );
      return existing.value as T;
    }

    return _load(
      key,
      loader,
      ttl: ttl,
      staleWhileRevalidate: staleWhileRevalidate,
      tags: tags,
    );
  }

  /// Removes one data value.
  void invalidate(String key) => _entries.remove(key);

  /// Removes all values associated with [tag].
  void invalidateTag(String tag) {
    _entries.removeWhere((_, entry) => entry.tags.contains(tag));
  }

  /// Removes all values and in-flight results.
  void clear() {
    _entries.clear();
    _inFlight.clear();
  }

  _DataEntry? _read(String key) {
    final entry = _entries[key];
    if (entry == null) return null;
    final now = DateTime.now();
    if (entry.expiresAt.isAfter(now)) return entry;
    if (entry.staleUntil.isAfter(now)) {
      return _DataEntry(
        value: entry.value,
        expiresAt: entry.expiresAt,
        staleUntil: entry.staleUntil,
        tags: entry.tags,
        stale: true,
      );
    }
    _entries.remove(key);
    return null;
  }

  Future<T> _load<T>(
    String key,
    FutureOr<T> Function() loader, {
    Duration? ttl,
    Duration? staleWhileRevalidate,
    required Iterable<String> tags,
  }) async {
    final existing = _inFlight[key];
    if (existing != null) return await existing as T;

    final future = Future<T>.sync(loader);
    _inFlight[key] = future.then<Object?>((value) => value);
    try {
      final value = await future;
      final lifetime = ttl ?? defaultTtl;
      final staleWindow = staleWhileRevalidate ?? defaultStaleWhileRevalidate;
      final now = DateTime.now();
      _entries[key] = _DataEntry(
        value: value,
        expiresAt: now.add(lifetime),
        staleUntil: now.add(lifetime + staleWindow),
        tags: tags.toSet(),
      );
      return value;
    } finally {
      _inFlight.remove(key);
    }
  }

  Future<void> _refresh<T>(
    String key,
    FutureOr<T> Function() loader, {
    Duration? ttl,
    Duration? staleWhileRevalidate,
    required Iterable<String> tags,
  }) async {
    try {
      await _load(
        key,
        loader,
        ttl: ttl,
        staleWhileRevalidate: staleWhileRevalidate,
        tags: tags,
      );
    } catch (_) {
      // Keep the stale value available until its stale window closes.
    }
  }
}

final class _DataEntry {
  const _DataEntry({
    required this.value,
    required this.expiresAt,
    required this.staleUntil,
    required this.tags,
    this.stale = false,
  });

  final Object? value;
  final DateTime expiresAt;
  final DateTime staleUntil;
  final Set<String> tags;
  final bool stale;
}
