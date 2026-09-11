import 'dart:async';
import 'dart:io';

/// Allows detached build-daemon cleanup to finish, but never accepts a leak.
Future<void> waitForPortClosed(
  int port, {
  Duration timeout = const Duration(seconds: 10),
}) async {
  final elapsed = Stopwatch()..start();
  while (elapsed.elapsed < timeout) {
    final remaining = timeout - elapsed.elapsed;
    if (remaining <= Duration.zero) break;
    try {
      final socket = await Socket.connect(
        '127.0.0.1',
        port,
        timeout: remaining < const Duration(seconds: 1)
            ? remaining
            : const Duration(seconds: 1),
      );
      socket.destroy();
    } on SocketException {
      return;
    }
    await Future<void>.delayed(const Duration(milliseconds: 50));
  }
  throw TimeoutException('Debug session left port $port listening.', timeout);
}
