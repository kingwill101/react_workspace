import 'package:react_actions/react_actions.dart';
import 'package:test/test.dart';

class _EchoCodec extends ServerFunctionJsonCodec<String> {
  @override
  String decode(dynamic json) => json as String;
  @override
  String encode(String value) => value;
}

class _RecordCodec extends ServerFunctionJsonCodec<({String name, int count})> {
  @override
  ({String name, int count}) decode(dynamic json) {
    final m = json as Map<String, dynamic>;
    return (name: m['name'] as String, count: m['count'] as int);
  }

  @override
  Map<String, dynamic> encode(({String name, int count}) value) => {
    'name': value.name,
    'count': value.count,
  };
}

void main() {
  group('ServerFunctionJsonCodec', () {
    test('encode/decode string round-trip', () {
      final codec = _EchoCodec();
      expect(codec.decode(codec.encode('hello')), 'hello');
    });

    test('encode/decode record round-trip', () {
      final codec = _RecordCodec();
      const value = (name: 'Ada', count: 42);
      expect(codec.decode(codec.encode(value)), value);
    });
  });

  group('ServerFunctionRef', () {
    test('holds id, contract and codecs', () {
      final ref = ServerFunctionRef<String, String>(
        id: const ServerFunctionId('test.echo'),
        contractHash: 'sha256:abc',
        argumentsCodec: _EchoCodec(),
        resultCodec: _EchoCodec(),
      );
      expect(ref.id.value, 'test.echo');
      expect(ref.contractHash, 'sha256:abc');
      expect(ref.argumentsCodec.encode('x'), 'x');
      expect(ref.resultCodec.decode('y'), 'y');
    });
  });

  group('ServerFunctionFailure', () {
    test('stores fields', () {
      const f = ServerFunctionFailure(
        code: 'not_found',
        message: 'missing',
        statusCode: 404,
        details: {'id': 1},
      );
      expect(f.code, 'not_found');
      expect(f.message, 'missing');
      expect(f.statusCode, 404);
      expect(f.details, {'id': 1});
    });

    test('details can be null', () {
      const f = ServerFunctionFailure(code: 'x', message: 'y', statusCode: 500);
      expect(f.details, isNull);
    });
  });

  group('RemoteServerFunctionException', () {
    test('stores fields', () {
      const e = RemoteServerFunctionException(
        code: 'invalid',
        message: 'bad input',
        statusCode: 422,
        details: {'field': 'name'},
        requestId: 'req-1',
      );
      expect(e.code, 'invalid');
      expect(e.message, 'bad input');
      expect(e.statusCode, 422);
      expect(e.details, {'field': 'name'});
      expect(e.requestId, 'req-1');
    });
  });

  group('ServerFunctionTransportException', () {
    test('stores message and cause', () {
      const cause = FormatException('bad json');
      const e = ServerFunctionTransportException(
        'transport failed',
        cause: cause,
      );
      expect(e.message, 'transport failed');
      expect(e.cause, cause);
    });

    test('cause can be null', () {
      const e = ServerFunctionTransportException('oops');
      expect(e.cause, isNull);
    });
  });

  group('ServerFunctionClient zone', () {
    test('currentServerFunctionClient throws without zone', () {
      expect(() => currentServerFunctionClient, throwsStateError);
    });

    test('runWithServerFunctionClient installs client', () async {
      final client = _FakeClient();
      await runWithServerFunctionClient(client, () async {
        expect(currentServerFunctionClient, same(client));
      });
    });

    test('zone value takes precedence over global fallback', () async {
      final global = _FakeClient();
      final zoned = _FakeClient();
      // Install global
      runWithServerFunctionClient(global, () {});
      // Now run with zoned client
      await runWithServerFunctionClient(zoned, () async {
        expect(currentServerFunctionClient, same(zoned));
      });
      // Global fallback is now the last installed client (zoned)
      expect(currentServerFunctionClient, same(zoned));
    });
  });
}

class _FakeClient implements ServerFunctionClient {
  @override
  Future<TResult> invoke<TArgs, TResult>(
    ServerFunctionRef<TArgs, TResult> ref,
    TArgs arguments,
  ) async => throw UnimplementedError();

  @override
  void close() {}
}
