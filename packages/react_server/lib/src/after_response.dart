import 'dart:async';

/// A request-scoped queue for work that should run after a response is built.
final class ReactAfterResponse {
  final _callbacks = <FutureOr<void> Function()>[];

  /// Adds [callback] to the post-response queue.
  void add(FutureOr<void> Function() callback) => _callbacks.add(callback);

  /// Runs queued callbacks once, in registration order.
  Future<void> run() async {
    final callbacks = List<FutureOr<void> Function()>.of(_callbacks);
    _callbacks.clear();
    for (final callback in callbacks) {
      try {
        await callback();
      } catch (_) {
        // Post-response work must not affect the completed response.
      }
    }
  }
}
