import 'dart:convert';

import 'package:react_actions/react_actions.dart';
import 'package:react_server/react_server.dart';
import 'package:react_server_shelf/react_server_shelf.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

final class _IntCodec extends ServerFunctionJsonCodec<int> {
  @override
  int decode(dynamic json) => (json as num).toInt();

  @override
  int encode(int value) => value;
}

final class _ArgsCodec extends ServerFunctionJsonCodec<({int value})> {
  @override
  ({int value}) decode(dynamic json) =>
      (value: ((json as Map<String, dynamic>)['value'] as num).toInt());

  @override
  Map<String, dynamic> encode(({int value}) value) => {'value': value.value};
}

final _incrementRef = ServerFunctionRef<({int value}), int>(
  id: const ServerFunctionId('test.increment'),
  contractHash: 'sha256:test-increment',
  argumentsCodec: _ArgsCodec(),
  resultCodec: _IntCodec(),
);

void main() {
  test('dispatches a typed action through Shelf', () async {
    final registry = ServerFunctionRegistry()
      ..register(_incrementRef, (arguments, _) => arguments.value + 1);
    final handler = createServerActionHandler(registry);
    final request = Request(
      'POST',
      Uri.parse('http://localhost/__react/actions'),
      headers: {'content-type': 'application/json'},
      body: jsonEncode({
        'protocol': serverFunctionProtocolVersion,
        'id': _incrementRef.id.value,
        'contract': _incrementRef.contractHash,
        'arguments': {'value': 41},
      }),
    );

    final response = await handler(request);
    expect(response.statusCode, 200);
    expect(jsonDecode(await response.readAsString()), {
      'ok': true,
      'result': 42,
    });
  });
}
