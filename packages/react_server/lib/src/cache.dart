/// A small in-process cache for rendered SSR documents.
///
/// Use [ReactDocumentStore] when entries must survive process restarts or be
/// shared across instances.
final class ReactDocumentCache {
  /// Creates a cache with a default lifetime for new entries.
  ReactDocumentCache({
    this.defaultTtl = const Duration(minutes: 1),
    this.maxEntries = 256,
  }) : assert(!defaultTtl.isNegative),
       assert(maxEntries > 0);

  /// Default lifetime assigned by [put].
  final Duration defaultTtl;

  /// Maximum number of documents retained in the cache.
  final int maxEntries;

  final _entries = <String, _CacheEntry>{};

  /// Returns a live entry, or `null` when absent or expired.
  ReactCachedDocument? get(String key) {
    return _read(key, allowStale: false);
  }

  /// Returns an expired document while it remains inside its stale window.
  ReactCachedDocument? getStale(String key) =>
      _read(key, allowStale: true, staleOnly: true);

  ReactCachedDocument? _read(
    String key, {
    required bool allowStale,
    bool staleOnly = false,
  }) {
    final entry = _entries[key];
    if (entry == null) return null;
    final now = DateTime.now();
    if (entry.expiresAt.isAfter(now)) {
      return staleOnly ? null : entry.document;
    }
    if (entry.staleUntil.isAfter(now)) {
      return allowStale ? entry.document : null;
    }
    _entries.remove(key);
    return null;
  }

  /// Stores a rendered document under [key].
  void put(
    String key,
    String html, {
    Duration? ttl,
    Duration staleWhileRevalidate = Duration.zero,
    Iterable<String> tags = const <String>[],
  }) {
    while (_entries.length >= maxEntries && !_entries.containsKey(key)) {
      _entries.remove(_entries.keys.first);
    }
    _entries[key] = _CacheEntry(
      document: ReactCachedDocument(html: html, tags: tags.toSet()),
      expiresAt: DateTime.now().add(ttl ?? defaultTtl),
      staleUntil: DateTime.now().add(
        (ttl ?? defaultTtl) + staleWhileRevalidate,
      ),
    );
  }

  /// Removes every entry associated with [tag].
  void invalidateTag(String tag) {
    _entries.removeWhere((_, entry) => entry.document.tags.contains(tag));
  }

  /// Removes one cached document.
  void invalidate(String key) => _entries.remove(key);

  /// Removes all cached documents.
  void clear() => _entries.clear();
}

/// Persistent or distributed storage for rendered SSR documents.
///
/// Implementations may use a database, Redis, disk, or an edge KV service.
/// The store owns serialization and concurrency; adapters only depend on this
/// small asynchronous contract.
abstract interface class ReactDocumentStore {
  /// Reads a document and reports whether it is inside its stale window.
  Future<ReactStoredDocument?> read(String key);

  /// Writes a document with its revalidation policy and invalidation tags.
  Future<void> write(
    String key,
    String html, {
    required Duration ttl,
    required Duration staleWhileRevalidate,
    Iterable<String> tags,
  });

  /// Invalidates one document.
  Future<void> invalidate(String key);

  /// Invalidates every document associated with [tag].
  Future<void> invalidateTag(String tag);
}

/// A document returned by a [ReactDocumentStore].
final class ReactStoredDocument {
  const ReactStoredDocument({
    required this.html,
    required this.stale,
    this.tags = const <String>{},
  });

  /// Complete HTML ready to send to the browser.
  final String html;

  /// Whether the document is expired but still eligible for stale serving.
  final bool stale;

  /// Invalidation tags associated with the document.
  final Set<String> tags;
}

/// A cached SSR document and its invalidation tags.
final class ReactCachedDocument {
  const ReactCachedDocument({required this.html, required this.tags});

  /// Complete HTML ready to send to the browser.
  final String html;

  /// Tags that can invalidate this document.
  final Set<String> tags;
}

final class _CacheEntry {
  const _CacheEntry({
    required this.document,
    required this.expiresAt,
    required this.staleUntil,
  });

  final ReactCachedDocument document;
  final DateTime expiresAt;
  final DateTime staleUntil;
}
