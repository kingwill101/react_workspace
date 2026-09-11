import 'dart:async';
import 'dart:io';

import 'package:test/test.dart';
import 'support/debug_protocol.dart';

void main() {
  for (final local in [false, true]) {
    test(
      'pending calls fail promptly on ${local ? 'local' : 'remote'} close',
      () async {
        final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
        addTearDown(() => server.close(force: true));
        final connected = Completer<WebSocket>();
        server.listen((request) async {
          connected.complete(await WebSocketTransformer.upgrade(request));
        });
        final protocol = await DebugProtocol.connect(
          'ws://127.0.0.1:${server.port}',
        );
        addTearDown(protocol.close);
        final peer = await connected.future;
        addTearDown(peer.close);
        final received = peer.first;
        final eventsDone = expectLater(protocol.events.stream, emitsDone);
        final result = expectLater(
          protocol.call('pending'),
          throwsA(isA<StateError>()),
        );
        await received;
        if (local) {
          await protocol.close();
        } else {
          await peer.close();
        }
        await result.timeout(const Duration(seconds: 2));
        await eventsDone.timeout(const Duration(seconds: 2));
        expect(protocol.pending, isEmpty);
        await expectLater(
          protocol.call('afterClose'),
          throwsA(isA<StateError>()),
        );
      },
    );
  }
}
