import 'dart:async';
import 'dart:io';

import 'package:test/test.dart';

import 'support/port_lifecycle.dart';

void main() {
  test('waits for asynchronous closure and destroys probe sockets', () async {
    final server = await ServerSocket.bind('127.0.0.1', 0);
    addTearDown(server.close);
    final disconnected = Completer<void>();
    server.listen((socket) {
      addTearDown(socket.destroy);
      socket.listen(
        (_) {},
        onDone: () {
          if (!disconnected.isCompleted) disconnected.complete();
        },
      );
    });
    final closed = waitForPortClosed(server.port);
    await disconnected.future.timeout(const Duration(seconds: 2));
    await server.close();
    await closed;
  });

  test('fails within a deadline when a service remains listening', () async {
    final server = await ServerSocket.bind('127.0.0.1', 0);
    addTearDown(server.close);
    server.listen((socket) => socket.destroy());
    await expectLater(
      waitForPortClosed(
        server.port,
        timeout: const Duration(milliseconds: 100),
      ),
      throwsA(
        isA<TimeoutException>().having(
          (error) => error.message,
          'port',
          contains('${server.port}'),
        ),
      ),
    );
  });
}
