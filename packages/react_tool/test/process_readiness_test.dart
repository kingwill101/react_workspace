import 'dart:async';
import 'dart:io';

import 'package:react_tool/src/process_readiness.dart';
import 'package:react_tool/src/project_config.dart';
import 'package:test/test.dart';

void main() {
  Future<int> unusedPort() async {
    final reservation = await ServerSocket.bind('127.0.0.1', 0);
    final port = reservation.port;
    await reservation.close();
    return port;
  }

  test('waits for delayed startup and destroys its probe socket', () async {
    final port = await unusedPort();
    final disconnected = Completer<void>();
    final exited = Completer<int>();
    final start = Future<void>(() async {
      await Future<void>.delayed(const Duration(milliseconds: 150));
      final server = await ServerSocket.bind('127.0.0.1', port);
      addTearDown(server.close);
      server.listen((socket) {
        addTearDown(socket.destroy);
        socket.listen((_) {}, onDone: disconnected.complete);
      });
    });
    await waitForLocalPort(port, exitCode: exited.future);
    await start;
    await disconnected.future.timeout(const Duration(seconds: 2));
    // A normal later exit must not become an unhandled asynchronous error.
    exited.complete(0);
    await Future<void>.delayed(Duration.zero);
  });

  test(
    'reports a child exit without waiting for the readiness deadline',
    () async {
      final port = await unusedPort();
      await expectLater(
        waitForLocalPort(
          port,
          exitCode: Future.value(9),
          service: 'Dart server',
        ).timeout(const Duration(seconds: 2)),
        throwsA(
          isA<ReactToolException>().having(
            (error) => error.toString(),
            'message',
            contains('Dart server exited with code 9'),
          ),
        ),
      );
    },
  );

  test('reports a bounded timeout with the service name and port', () async {
    final port = await unusedPort();
    await expectLater(
      waitForLocalPort(
        port,
        service: 'SSR worker',
        timeout: const Duration(milliseconds: 50),
      ),
      throwsA(
        isA<ReactToolException>().having(
          (error) => error.toString(),
          'message',
          contains('SSR worker timed out waiting for port $port'),
        ),
      ),
    );
  });
}
