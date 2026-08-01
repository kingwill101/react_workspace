import 'dart:io';

import 'package:react_actions/react_actions.dart';
import 'package:react_server/react_server.dart';
import 'package:server_testing/server_testing.dart';
import 'package:server_testing_shelf/server_testing_shelf.dart';
import 'package:shelf/shelf.dart';

final class _IntCodec extends ServerFunctionJsonCodec<int> {
  _IntCodec();

  @override
  int decode(dynamic json) => (json as num).toInt();

  @override
  int encode(int value) => value;
}

final class _ValueCodec extends ServerFunctionJsonCodec<({int value})> {
  _ValueCodec();

  @override
  ({int value}) decode(dynamic json) {
    final map = json as Map<String, dynamic>;
    return (value: (map['value'] as num).toInt());
  }

  @override
  Map<String, dynamic> encode(({int value}) value) => {'value': value.value};
}

final _incrementRef = ServerFunctionRef<({int value}), int>(
  id: const ServerFunctionId('test.increment'),
  contractHash: 'sha256:test-increment-v1',
  argumentsCodec: _ValueCodec(),
  resultCodec: _IntCodec(),
);

ShelfRequestHandler _handler() {
  final registry = ServerFunctionRegistry()
    ..register(_incrementRef, (arguments, _) => arguments.value + 1);
  final actionHandler = createServerActionHandler(registry);
  return ShelfRequestHandler(Pipeline().addHandler(actionHandler));
}

void main() {
  serverTest('Shelf action handler dispatches a typed result', (
    client,
    _,
  ) async {
    final response = await client.postJson('/__react/actions', {
      'protocol': 1,
      'id': _incrementRef.id.value,
      'contract': _incrementRef.contractHash,
      'arguments': {'value': 41},
    });

    response
        .assertStatus(HttpStatus.ok)
        .assertContentType(serverFunctionContentType)
        .assertJsonContains({'ok': true, 'result': 42});
  }, handler: _handler());

  serverTest(
    'Shelf action handler rejects requests without a contract',
    (client, _) async {
      final response = await client.postJson('/__react/actions', {
        'protocol': 1,
        'id': _incrementRef.id.value,
        'arguments': {'value': 41},
      });

      response.assertStatus(HttpStatus.badRequest).assertJsonContains({
        'ok': false,
        'error': {'code': 'contract_mismatch'},
      });
    },
    handler: _handler(),
  );
}
