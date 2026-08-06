import 'dart:async';

import 'package:react_actions/react_actions.dart';
import 'package:react_server/react_server.dart';
import 'package:test/test.dart';

class _StringCodec extends ServerFunctionJsonCodec<String> {
  @override
  String decode(dynamic json) => json as String;
  @override
  String encode(String value) => value;
}

class _IntCodec extends ServerFunctionJsonCodec<int> {
  @override
  int decode(dynamic json) => (json as num).toInt();
  @override
  int encode(int value) => value;
}

class _ArgsCodec extends ServerFunctionJsonCodec<({String name})> {
  @override
  ({String name}) decode(dynamic json) => (name: (json as Map)['name'] as String);
  @override
  Map<String, dynamic> encode(({String name}) value) => {'name': value.name};
}

final _echoRef = ServerFunctionRef<String, String>(
  id: const ServerFunctionId('test.echo'),
  contractHash: 'sha256:echo',
  argumentsCodec: _StringCodec(),
  resultCodec: _StringCodec(),
);

final _greetRef = ServerFunctionRef<({String name}), String>(
  id: const ServerFunctionId('test.greet'),
  contractHash: 'sha256:greet',
  argumentsCodec: _ArgsCodec(),
  resultCodec: _StringCodec(),
);

final _incrementRef = ServerFunctionRef<int, int>(
  id: const ServerFunctionId('test.increment'),
  contractHash: 'sha256:increment',
  argumentsCodec: _IntCodec(),
  resultCodec: _IntCodec(),
);

ServerFunctionContext _ctx() => ServerFunctionContext(
      requestId: 'test-req',
      principal: 'tester',
      headers: const {},
      requestUri: Uri.parse('/'),
      deadline: DateTime.now().add(const Duration(seconds: 30)),
      cancellation: CancellationToken(),
    );

void main() {
  group('ServerFunctionRegistry', () {
    test('register and dispatch round-trip', () async {
      final registry = ServerFunctionRegistry();
      registry.register(_echoRef, (args, ctx) async => 'echo:$args');
      final result = await registry.dispatch('test.echo', 'hello', _ctx());
      expect(result, 'hello' == 'hello' ? 'echo:hello' : null);
      // Direct check via codec
      expect(_echoRef.resultCodec.decode(result), 'echo:hello');
    });

    test('dispatch throws UnknownServerFunctionException for unknown id', () async {
      final registry = ServerFunctionRegistry();
      expect(
        () => registry.dispatch('unknown', null, _ctx()),
        throwsA(isA<UnknownServerFunctionException>().having((e) => e.id, 'id', 'unknown')),
      );
    });

    test('register throws on duplicate id', () {
      final registry = ServerFunctionRegistry();
      registry.register(_echoRef, (args, ctx) => args);
      expect(
        () => registry.register(_echoRef, (args, ctx) => args),
        throwsStateError,
      );
    });

    test('contractHashFor returns hash for registered function', () {
      final registry = ServerFunctionRegistry();
      registry.register(_echoRef, (args, ctx) => args);
      expect(registry.contractHashFor('test.echo'), 'sha256:echo');
      expect(registry.contractHashFor('missing'), isNull);
    });

    test('dispatch decodes arguments and encodes result', () async {
      final registry = ServerFunctionRegistry();
      registry.register(_greetRef, (args, ctx) => 'Hello ${args.name}');
      final encodedArgs = _ArgsCodec().encode((name: 'Ada'));
      final result = await registry.dispatch('test.greet', encodedArgs, _ctx());
      expect(result, 'Hello Ada');
    });

    test('dispatch propagates handler exception', () async {
      final registry = ServerFunctionRegistry();
      registry.register(_echoRef, (args, ctx) => throw const ServerFunctionFailure(code: 'fail', message: 'oops', statusCode: 500));
      expect(() => registry.dispatch('test.echo', 'hi', _ctx()), throwsA(isA<ServerFunctionFailure>()));
    });

    test('dispatch supports async handler', () async {
      final registry = ServerFunctionRegistry();
      registry.register(_incrementRef, (args, ctx) async {
        await Future<void>.delayed(Duration.zero);
        return args + 1;
      });
      final result = await registry.dispatch('test.increment', 41, _ctx());
      expect(result, 42);
    });

    test('multiple functions can be registered', () async {
      final registry = ServerFunctionRegistry();
      registry.register(_echoRef, (args, ctx) => 'a:$args');
      registry.register(_greetRef, (args, ctx) => 'b:${args.name}');
      registry.register(_incrementRef, (args, ctx) => args * 2);
      expect(await registry.dispatch('test.echo', 'x', _ctx()), 'a:x');
      expect(await registry.dispatch('test.greet', {'name': 'y'}, _ctx()), 'b:y');
      expect(await registry.dispatch('test.increment', 5, _ctx()), 10);
    });

    test('handler receives correct context', () async {
      final registry = ServerFunctionRegistry();
      ServerFunctionContext? captured;
      registry.register(_echoRef, (args, ctx) {
        captured = ctx;
        return args;
      });
      final ctx = _ctx();
      await registry.dispatch('test.echo', 'hi', ctx);
      expect(captured, same(ctx));
      expect(captured!.principal, 'tester');
    });
  });

  group('UnknownServerFunctionException', () {
    test('stores id', () {
      const e = UnknownServerFunctionException('myId');
      expect(e.id, 'myId');
    });
  });
}
