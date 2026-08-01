import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:react_actions/react_actions.dart';
import 'package:react_server/react_server.dart';
import 'package:server_testing/server_testing.dart';
import 'package:server_testing_shelf/server_testing_shelf.dart';
import 'package:react_web/src/http_server_function_client.dart';
import 'package:shelf/shelf.dart';

final class _StringCodec extends ServerFunctionJsonCodec<String> {
  _StringCodec();

  @override
  String decode(dynamic json) => json as String;

  @override
  String encode(String value) => value;
}

final class _GreetingCodec extends ServerFunctionJsonCodec<({String name})> {
  _GreetingCodec();

  @override
  ({String name}) decode(dynamic json) {
    final map = json as Map<String, dynamic>;
    return (name: map['name'] as String);
  }

  @override
  Map<String, dynamic> encode(({String name}) value) => {'name': value.name};
}

final _greetRef = ServerFunctionRef<({String name}), String>(
  id: const ServerFunctionId('test.greet'),
  contractHash: 'sha256:test-greet-v1',
  argumentsCodec: _GreetingCodec(),
  resultCodec: _StringCodec(),
);

final _privateRef = ServerFunctionRef<({bool proceed}), String>(
  id: const ServerFunctionId('test.private'),
  contractHash: 'sha256:test-private-v1',
  argumentsCodec: _PrivateArgumentsCodec(),
  resultCodec: _StringCodec(),
);

final class _PrivateArgumentsCodec
    extends ServerFunctionJsonCodec<({bool proceed})> {
  _PrivateArgumentsCodec();

  @override
  ({bool proceed}) decode(dynamic json) {
    final map = json as Map<String, dynamic>;
    return (proceed: map['proceed'] as bool);
  }

  @override
  Map<String, dynamic> encode(({bool proceed}) value) => {
    'proceed': value.proceed,
  };
}

ShelfRequestHandler _handler({Object? Function(Request)? authenticate}) {
  final registry = ServerFunctionRegistry()
    ..register(_greetRef, (arguments, context) {
      return 'Hello, ${arguments.name}!';
    })
    ..register(_privateRef, (_, context) {
      context.requireUser();
      return 'authorized';
    });

  final actionHandler = createServerActionHandler(
    registry,
    authenticate: authenticate ?? (_) => 'Ada',
  );
  return ShelfRequestHandler(
    Pipeline().addHandler((request) {
      if (request.url.path == '__react/actions') {
        return actionHandler(request);
      }
      return Response.notFound('Not found');
    }),
  );
}

void main() {
  serverTest(
    'server and client complete a real action request',
    (client, _) async {
      final baseUrl = await client.baseUrlFuture;
      final actionClient = HttpServerFunctionClient(
        endpoint: Uri.parse('$baseUrl/__react/actions'),
      );

      try {
        final result = await actionClient.invoke(_greetRef, (name: 'Ada'));
        expect(result, 'Hello, Ada!');

        final raw = await client.postJson('/__react/actions', {
          'protocol': 1,
          'id': _greetRef.id.value,
          'contract': _greetRef.contractHash,
          'arguments': {'name': 'Grace'},
        });
        raw
            .assertStatus(HttpStatus.ok)
            .assertContentType(serverFunctionContentType)
            .assertJsonContains({'ok': true, 'result': 'Hello, Grace!'});
      } finally {
        actionClient.close();
      }
    },
    handler: _handler(),
    transportMode: TransportMode.ephemeralServer,
  );

  serverTest('action endpoint rejects a stale contract', (client, _) async {
    final response = await client.postJson('/__react/actions', {
      'protocol': 1,
      'id': _greetRef.id.value,
      'contract': 'sha256:old-contract',
      'arguments': {'name': 'Ada'},
    });

    response.assertStatus(HttpStatus.badRequest).assertJsonContains({
      'ok': false,
      'error': {'code': 'contract_mismatch'},
    });
  }, handler: _handler());

  serverTest(
    'requireUser produces an authentication response',
    (client, _) async {
      final response = await client.postJson('/__react/actions', {
        'protocol': 1,
        'id': _privateRef.id.value,
        'contract': _privateRef.contractHash,
        'arguments': {'proceed': true},
      });

      response.assertStatus(HttpStatus.unauthorized).assertJsonContains({
        'ok': false,
        'error': {'code': 'unauthenticated'},
      });
    },
    handler: _handler(authenticate: (_) => null),
  );

  test(
    'client turns a structured server error into a remote exception',
    () async {
      final client = HttpServerFunctionClient(
        client: _ErrorClient(),
        endpoint: Uri.parse('https://example.test/__react/actions'),
      );
      try {
        await expectLater(
          client.invoke(_greetRef, (name: 'Ada')),
          throwsA(
            isA<RemoteServerFunctionException>().having(
              (error) => error.code,
              'code',
              'invalid_name',
            ),
          ),
        );
      } finally {
        client.close();
      }
    },
  );

  test(
    'client rejects a malformed successful envelope as transport failure',
    () async {
      final client = HttpServerFunctionClient(
        client: _InvalidResponseClient(),
        endpoint: Uri.parse('https://example.test/__react/actions'),
      );
      try {
        await expectLater(
          client.invoke(_greetRef, (name: 'Ada')),
          throwsA(isA<ServerFunctionTransportException>()),
        );
      } finally {
        client.close();
      }
    },
  );
}

final class _InvalidResponseClient extends http.BaseClient {
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    return http.StreamedResponse(
      Stream.value(utf8.encode('{"ok":true}')),
      HttpStatus.ok,
      headers: const {'content-type': 'application/json'},
      request: request,
    );
  }
}

final class _ErrorClient extends http.BaseClient {
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final body = utf8.encode(
      jsonEncode({
        'ok': false,
        'error': {'code': 'invalid_name', 'message': 'The name is invalid.'},
      }),
    );
    return http.StreamedResponse(
      Stream.value(body),
      HttpStatus.unprocessableEntity,
      headers: const {'content-type': 'application/json'},
      request: request,
    );
  }
}
