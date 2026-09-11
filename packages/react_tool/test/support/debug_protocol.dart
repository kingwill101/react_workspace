import 'dart:async';
import 'dart:convert';
import 'dart:io';

/// Minimal protocol transport shared by the real CDP and Dart VM debug checks.
final class DebugProtocol {
  DebugProtocol._(this.socket, this.jsonRpc) {
    subscription = socket.listen(
      (data) {
        final message = jsonDecode(data as String) as Map<String, dynamic>;
        final reply = pending.remove(message['id']);
        if (reply != null) {
          if (message['error'] != null) {
            reply.completeError(StateError('${message['error']}'));
          } else {
            reply.complete(message['result'] as Map<String, dynamic>);
          }
        } else {
          events.add(message);
        }
      },
      onError: _failPending,
      onDone: () => _failPending(
        StateError('Debug socket closed (code ${socket.closeCode}).'),
      ),
    );
  }
  final WebSocket socket;
  final bool jsonRpc;
  late final StreamSubscription<dynamic> subscription;
  final pending = <int, Completer<Map<String, dynamic>>>{};
  final events = StreamController<Map<String, dynamic>>.broadcast();
  int sequence = 0;
  Object? _failure;
  Future<void>? _eventsClosed;

  void _failPending(Object error, [StackTrace? stackTrace]) {
    _failure ??= error;
    final replies = pending.values.toList();
    pending.clear();
    for (final reply in replies) {
      if (!reply.isCompleted) reply.completeError(error, stackTrace);
    }
    _eventsClosed ??= events.close();
  }

  static Future<DebugProtocol> connect(
    String uri, {
    bool jsonRpc = false,
  }) async => DebugProtocol._(await WebSocket.connect(uri), jsonRpc);

  Future<Map<String, dynamic>> call(
    String method, [
    Map<String, Object?> params = const {},
  ]) {
    if (_failure != null) return Future.error(_failure!);
    final id = ++sequence;
    final reply = Completer<Map<String, dynamic>>();
    pending[id] = reply;
    socket.add(
      jsonEncode({
        if (jsonRpc) 'jsonrpc': '2.0',
        'id': id,
        'method': method,
        'params': params,
      }),
    );
    return reply.future.timeout(
      const Duration(seconds: 30),
      onTimeout: () {
        pending.remove(id);
        throw TimeoutException('No reply to $method');
      },
    );
  }

  Future<void> close() async {
    _failPending(StateError('Debug transport closed locally.'));
    await subscription.cancel();
    await socket.close();
    await _eventsClosed;
  }
}
