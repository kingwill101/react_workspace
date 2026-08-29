import 'package:react_web/src/http_server_function_client.dart';
import 'package:react_actions/react_actions.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:test/test.dart';

class _StringCodec extends ServerFunctionJsonCodec<String> {
  @override
  String decode(dynamic json) => json as String;
  @override
  String encode(String value) => value;
}

final _echoRef = ServerFunctionRef<String, String>(
  id: const ServerFunctionId('test.echo'),
  contractHash: 'sha256:echo-v1',
  argumentsCodec: _StringCodec(),
  resultCodec: _StringCodec(),
);

class _OkClient extends http.BaseClient {
  final dynamic result;
  _OkClient(this.result);
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final body = utf8.encode(jsonEncode({'ok': true, 'result': result}));
    return http.StreamedResponse(
      Stream.value(body),
      200,
      headers: {'content-type': 'application/json'},
      request: request,
    );
  }
}

class _ErrorClient extends http.BaseClient {
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final body = utf8.encode(
      jsonEncode({
        'ok': false,
        'error': {'code': 'bad', 'message': 'fail'},
      }),
    );
    return http.StreamedResponse(
      Stream.value(body),
      422,
      headers: {'content-type': 'application/json'},
      request: request,
    );
  }
}

class _CompactJsonErrorClient extends http.BaseClient {
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final body = utf8.encode(
      jsonEncode({
        'ok': false,
        'error': {'code': 'json_fallback', 'message': 'too large'},
      }),
    );
    return http.StreamedResponse(
      Stream.value(body),
      413,
      headers: {'content-type': serverFunctionContentType},
      request: request,
    );
  }
}

class _TransportFailClient extends http.BaseClient {
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async =>
      throw const SocketException('connection failed');
}

class _InvalidJsonClient extends http.BaseClient {
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    return http.StreamedResponse(
      Stream.value(utf8.encode('not json')),
      200,
      headers: {'content-type': 'application/json'},
      request: request,
    );
  }
}

class _MissingResultClient extends http.BaseClient {
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    return http.StreamedResponse(
      Stream.value(utf8.encode(jsonEncode({'ok': true}))),
      200,
      headers: {'content-type': 'application/json'},
      request: request,
    );
  }
}

void main() {
  group('HttpServerFunctionClient', () {
    test('sends and decodes compact protocol frames', () async {
      http.BaseRequest? captured;
      final client = HttpServerFunctionClient(
        endpoint: Uri.parse('https://example.test/__react/actions'),
        useCompactProtocol: true,
        client: _CapturingClient((req) async {
          captured = req;
          final body = ReactFrame(
            kind: ReactMessageKind.result,
            actionId: compactActionId('test.echo'),
            requestId: 1,
            payload: {'ok': true, 'result': 'compact'},
          ).encode();
          return http.StreamedResponse(
            Stream.value(body),
            200,
            headers: {'content-type': compactProtocolContentType},
            request: req,
          );
        }),
      );

      expect(await client.invoke(_echoRef, 'hi'), 'compact');
      expect(captured!.headers[serverFunctionProtocolHeader], '2');
      expect(captured!.headers['content-type'], compactProtocolContentType);
      final request = ReactFrame.decode(await captured!.finalize().toBytes());
      expect(request.kind, ReactMessageKind.invoke);
      expect(request.actionId, compactActionId('test.echo'));
      expect(request.payload, {
        'id': 'test.echo',
        'contract': 'sha256:echo-v1',
        'arguments': 'hi',
      });
      client.close();
    });

    test('sends correct headers and body for successful invoke', () async {
      http.BaseRequest? captured;
      final client = HttpServerFunctionClient(
        endpoint: Uri.parse('https://example.test/__react/actions'),
        client: _CapturingClient((req) async {
          captured = req;
          final body = utf8.encode(jsonEncode({'ok': true, 'result': 'hello'}));
          return http.StreamedResponse(
            Stream.value(body),
            200,
            headers: {'content-type': 'application/json'},
            request: req,
          );
        }),
      );
      final result = await client.invoke(_echoRef, 'world');
      expect(result, 'hello');
      expect(captured, isNotNull);
      expect(captured!.headers[serverFunctionIdHeader], 'test.echo');
      expect(captured!.headers[serverFunctionContractHeader], 'sha256:echo-v1');
      expect(captured!.headers[serverFunctionProtocolHeader], '1');
      client.close();
    });

    test('decodes successful result', () async {
      final client = HttpServerFunctionClient(
        client: _OkClient('success'),
        endpoint: Uri.parse('https://example.test/__react/actions'),
      );
      expect(await client.invoke(_echoRef, 'hi'), 'success');
      client.close();
    });

    test('throws RemoteServerFunctionException on structured error', () async {
      final client = HttpServerFunctionClient(
        client: _ErrorClient(),
        endpoint: Uri.parse('https://example.test/__react/actions'),
      );
      expect(
        () => client.invoke(_echoRef, 'hi'),
        throwsA(
          isA<RemoteServerFunctionException>().having(
            (e) => e.code,
            'code',
            'bad',
          ),
        ),
      );
      client.close();
    });

    test('throws RemoteServerFunctionException on compact error', () async {
      final client = HttpServerFunctionClient(
        client: _CapturingClient((request) async {
          final body = ReactFrame(
            kind: ReactMessageKind.error,
            actionId: compactActionId(_echoRef.id.value),
            requestId: 1,
            payload: {
              'ok': false,
              'error': {'code': 'compact_bad', 'message': 'fail'},
            },
          ).encode();
          return http.StreamedResponse(
            Stream.value(body),
            422,
            headers: {'content-type': compactProtocolContentType},
            request: request,
          );
        }),
        endpoint: Uri.parse('https://example.test/__react/actions'),
        useCompactProtocol: true,
      );
      expect(
        () => client.invoke(_echoRef, 'hi'),
        throwsA(
          isA<RemoteServerFunctionException>().having(
            (e) => e.code,
            'code',
            'compact_bad',
          ),
        ),
      );
      client.close();
    });

    test('accepts JSON fallback errors for compact requests', () async {
      final client = HttpServerFunctionClient(
        client: _CompactJsonErrorClient(),
        endpoint: Uri.parse('https://example.test/__react/actions'),
        useCompactProtocol: true,
      );
      expect(
        () => client.invoke(_echoRef, 'hi'),
        throwsA(
          isA<RemoteServerFunctionException>().having(
            (e) => e.code,
            'code',
            'json_fallback',
          ),
        ),
      );
      client.close();
    });

    test(
      'throws ServerFunctionTransportException on transport failure',
      () async {
        final client = HttpServerFunctionClient(
          client: _TransportFailClient(),
          endpoint: Uri.parse('https://example.test/__react/actions'),
        );
        expect(
          () => client.invoke(_echoRef, 'hi'),
          throwsA(isA<ServerFunctionTransportException>()),
        );
        client.close();
      },
    );

    test('throws transport on invalid JSON', () async {
      final client = HttpServerFunctionClient(
        client: _InvalidJsonClient(),
        endpoint: Uri.parse('https://example.test/__react/actions'),
      );
      expect(
        () => client.invoke(_echoRef, 'hi'),
        throwsA(isA<ServerFunctionTransportException>()),
      );
      client.close();
    });

    test('throws transport on missing result field', () async {
      final client = HttpServerFunctionClient(
        client: _MissingResultClient(),
        endpoint: Uri.parse('https://example.test/__react/actions'),
      );
      // Missing result is parsed as invalid envelope -> transport
      expect(
        () => client.invoke(_echoRef, 'hi'),
        throwsA(isA<ServerFunctionTransportException>()),
      );
      client.close();
    });

    test('default endpoint is /__react/actions', () {
      final client = HttpServerFunctionClient();
      expect(client.endpoint.path, '/__react/actions');
      client.close();
    });

    test('_tryParseErrorEnvelope returns null for non-envelope', () {
      expect(_tryParse('not json'), isNull);
      expect(_tryParse(jsonEncode({'ok': true, 'result': 1})), isNull);
    });

    test('_tryParseErrorEnvelope parses error envelope', () {
      final err = _tryParse(
        jsonEncode({
          'ok': false,
          'error': {'code': 'x', 'message': 'y'},
        }),
      );
      expect(err, isNotNull);
      expect(err!.code, 'x');
    });
  });
}

ServerFunctionError? _tryParse(String body) {
  try {
    final decoded = jsonDecode(body);
    if (decoded is! Map) return null;
    if (decoded['ok'] == false && decoded['error'] != null) {
      return ServerFunctionError.fromJson(
        decoded['error'] as Map<String, dynamic>,
      );
    }
    return null;
  } catch (_) {
    return null;
  }
}

class _CapturingClient extends http.BaseClient {
  final Future<http.StreamedResponse> Function(http.BaseRequest) handler;
  _CapturingClient(this.handler);
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) =>
      handler(request);
}
