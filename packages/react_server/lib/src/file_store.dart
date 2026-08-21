import 'dart:convert';
import 'dart:io';

import 'cache.dart';

/// A disk-backed [ReactDocumentStore] for single-host SSR deployments.
///
/// Each document is stored as a JSON record containing its HTML, expiry
/// timestamps, and invalidation tags. The store is safe to recreate after a
/// process restart. Use a shared database or edge-KV implementation when
/// multiple hosts must observe the same writes.
final class FileReactDocumentStore implements ReactDocumentStore {
  /// Creates a store rooted at [directory].
  FileReactDocumentStore(this.directory);

  /// Directory containing the document records.
  final Directory directory;

  @override
  Future<ReactStoredDocument?> read(String key) async {
    final file = _fileFor(key);
    if (!await file.exists()) return null;

    try {
      final decoded = jsonDecode(await file.readAsString());
      if (decoded is! Map) return null;
      final expiresAt = DateTime.fromMillisecondsSinceEpoch(
        decoded['expiresAt'] as int,
      );
      final staleUntil = DateTime.fromMillisecondsSinceEpoch(
        decoded['staleUntil'] as int,
      );
      final now = DateTime.now();
      if (!staleUntil.isAfter(now)) {
        await file.delete();
        return null;
      }
      return ReactStoredDocument(
        html: decoded['html'] as String,
        stale: !expiresAt.isAfter(now),
        tags: ((decoded['tags'] as List?) ?? const [])
            .whereType<String>()
            .toSet(),
      );
    } on FormatException {
      return null;
    } on IOException {
      return null;
    } on TypeError {
      return null;
    }
  }

  @override
  Future<void> write(
    String key,
    String html, {
    required Duration ttl,
    required Duration staleWhileRevalidate,
    Iterable<String> tags = const <String>[],
  }) async {
    if (ttl.isNegative || staleWhileRevalidate.isNegative) {
      throw ArgumentError('Document cache durations cannot be negative.');
    }
    await directory.create(recursive: true);
    final now = DateTime.now();
    final record = jsonEncode({
      'html': html,
      'expiresAt': now.add(ttl).millisecondsSinceEpoch,
      'staleUntil': now.add(ttl + staleWhileRevalidate).millisecondsSinceEpoch,
      'tags': tags.toSet().toList(),
    });
    final file = _fileFor(key);
    final temporary = File(
      '${file.path}.tmp-${DateTime.now().microsecondsSinceEpoch}',
    );
    await temporary.writeAsString(record, flush: true);
    try {
      await temporary.rename(file.path);
    } on FileSystemException {
      // Windows cannot replace an existing file with rename. Remove the
      // previous record and retry while retaining the atomic temp write.
      if (await file.exists()) await file.delete();
      await temporary.rename(file.path);
    }
  }

  @override
  Future<void> invalidate(String key) async {
    final file = _fileFor(key);
    if (await file.exists()) await file.delete();
  }

  @override
  Future<void> invalidateTag(String tag) async {
    if (!await directory.exists()) return;
    await for (final entity in directory.list()) {
      if (entity is! File || !entity.path.endsWith('.json')) continue;
      try {
        final decoded = jsonDecode(await entity.readAsString());
        final tags = decoded is Map ? decoded['tags'] : null;
        if (tags is List && tags.contains(tag)) await entity.delete();
      } on FormatException {
        // Ignore an incomplete or unrelated record.
      } on IOException {
        // Ignore records removed concurrently by another invalidation.
      }
    }
  }

  File _fileFor(String key) {
    final encoded = base64Url.encode(utf8.encode(key));
    if (encoded.length > 200) {
      throw ArgumentError('Document cache keys must be 200 bytes or fewer.');
    }
    return File('${directory.path}${Platform.pathSeparator}$encoded.json');
  }
}
