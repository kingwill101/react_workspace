import 'dart:async';
import 'dart:convert';
import 'dart:io';

/// Minimal protocol transport shared by the real CDP and Dart VM debug checks.
final class DebugProtocol {
  DebugProtocol._(this.socket, this.jsonRpc) {
    subscription = socket.listen((data) {
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
    });
  }
  final WebSocket socket;
  final bool jsonRpc;
  late final StreamSubscription<dynamic> subscription;
  final pending = <int, Completer<Map<String, dynamic>>>{};
  final events = StreamController<Map<String, dynamic>>.broadcast();
  int sequence = 0;

  static Future<DebugProtocol> connect(
    String uri, {
    bool jsonRpc = false,
  }) async => DebugProtocol._(await WebSocket.connect(uri), jsonRpc);

  Future<Map<String, dynamic>> call(
    String method, [
    Map<String, Object?> params = const {},
  ]) {
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
    await subscription.cancel();
    await socket.close();
    await events.close();
  }
}
