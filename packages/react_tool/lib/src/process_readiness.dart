import 'dart:async';
import 'dart:io';

import 'project_config.dart';

/// Waits for a local service, allowing cold startup but detecting child exits.
Future<void> waitForLocalPort(
  int port, {
  Future<int>? exitCode,
  String service = 'Service',
  Duration timeout = const Duration(seconds: 60),
}) async {
  if (timeout <= Duration.zero) {
    throw ArgumentError.value(timeout, 'timeout', 'Must be positive.');
  }
  var cancelled = false;
  final elapsed = Stopwatch()..start();

  Future<void> poll() async {
    while (!cancelled && elapsed.elapsed < timeout) {
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
        return;
      } on SocketException {
        if (cancelled) return;
        final remaining = timeout - elapsed.elapsed;
        if (remaining <= Duration.zero) break;
        await Future<void>.delayed(
          remaining < const Duration(milliseconds: 100)
              ? remaining
              : const Duration(milliseconds: 100),
        );
      }
    }
    if (!cancelled) {
      throw ReactToolException('$service timed out waiting for port $port.');
    }
  }

  try {
    await Future.any<void>([
      poll(),
      if (exitCode != null)
        exitCode.then<void>((code) {
          throw ReactToolException(
            '$service exited with code $code before port $port was ready.',
          );
        }),
    ]);
  } finally {
    cancelled = true;
    elapsed.stop();
  }
}
