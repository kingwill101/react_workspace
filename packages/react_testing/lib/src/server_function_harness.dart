import 'dart:convert';
import 'dart:io';

import 'package:react_actions/react_actions.dart';
import 'package:react_server/react_server.dart';
import 'package:server_testing/server_testing.dart';
import 'package:server_testing_shelf/server_testing_shelf.dart';
import 'package:shelf/shelf.dart';

/// Lightweight harness for testing server functions in isolation.
///
/// Wraps a [ServerFunctionRegistry] and exposes both direct dispatch
/// and HTTP-level helpers via `server_testing`. This is the recommended
/// entry point for unit and integration tests that exercise generated
/// server-function codecs and business logic without booting the full
/// React SSR stack.
///
/// Example:
/// ```dart
/// final harness = ServerFunctionHarness();
/// harness.registry.register(greetRef, (args, ctx) => 'Hello ${args.name}');
///
/// // Direct dispatch (no HTTP)
/// final result = await harness.dispatch(greetRef, (name: 'Ada'));
///
/// // HTTP-level (validates protocol, headers, envelope)
/// final client = harness.createClient();
/// final response = await client.postJson('/__react/actions', {
///   'protocol': 1,
///   'id': greetRef.id.value,
///   'contract': greetRef.contractHash,
///   'arguments': {'name': 'Ada'},
/// });
/// ```
final class ServerFunctionHarness {
  final ServerFunctionRegistry registry;
  final String actionPath;
  final Object? Function(Request request)? authenticate;

  ServerFunctionHarness({
    ServerFunctionRegistry? registry,
    this.actionPath = '/__react/actions',
    this.authenticate,
  }) : registry = registry ?? ServerFunctionRegistry();

  /// Creates a `server_testing` handler for this harness.
  ShelfRequestHandler createHandler() {
    final handler = createServerActionHandler(
      registry,
      authenticate: authenticate ?? (_) => 'test-user',
    );
    return ShelfRequestHandler(const Pipeline().addHandler(handler));
  }

  /// Creates an in-memory test client bound to this harness.
  TestClient createClient() => TestClient.inMemory(createHandler());

  /// Creates an ephemeral-server test client (real HTTP) bound to this harness.
  TestClient createEphemeralClient() =>
      TestClient.ephemeralServer(createHandler());

  /// Directly dispatches a typed server function without HTTP.
  Future<TResult> dispatch<TArgs, TResult>(
    ServerFunctionRef<TArgs, TResult> ref,
    TArgs arguments, {
    ServerFunctionContext? context,
  }) async {
    final ctx = context ??
        ServerFunctionContext(
          requestId: 'test-${DateTime.now().microsecondsSinceEpoch}',
          principal: 'test-user',
          headers: const {},
          requestUri: Uri.parse('/'),
          deadline: DateTime.now().add(const Duration(seconds: 30)),
          cancellation: CancellationToken(),
        );
    final encoded = ref.argumentsCodec.encode(arguments);
    final rawResult = await registry.dispatch(ref.id.value, encoded, ctx);
    return ref.resultCodec.decode(rawResult);
  }

  /// Asserts that dispatching [ref] with [arguments] throws a
  /// [ServerFunctionFailure] with the expected [code].
  Future<void> expectFailure<TArgs, TResult>(
    ServerFunctionRef<TArgs, TResult> ref,
    TArgs arguments, {
    required String code,
    ServerFunctionContext? context,
  }) async {
    try {
      await dispatch(ref, arguments, context: context);
      throw StateError(
        'Expected ServerFunctionFailure(code=$code) but dispatch succeeded',
      );
    } on ServerFunctionFailure catch (failure) {
      if (failure.code != code) {
        throw StateError(
          'Expected failure code "$code" but got "${failure.code}"',
        );
      }
    }
  }

  /// Helper to build a valid JSON envelope for [ref] and [arguments].
  Map<String, dynamic> envelope<TArgs, TResult>(
    ServerFunctionRef<TArgs, TResult> ref,
    TArgs arguments,
  ) => {
    'protocol': serverFunctionProtocolVersion,
    'id': ref.id.value,
    'contract': ref.contractHash,
    'arguments': ref.argumentsCodec.encode(arguments),
  };

  /// Helper to build an envelope with a stale contract (for testing mismatch).
  Map<String, dynamic> staleEnvelope<TArgs, TResult>(
    ServerFunctionRef<TArgs, TResult> ref,
    TArgs arguments,
  ) => {
    'protocol': serverFunctionProtocolVersion,
    'id': ref.id.value,
    'contract': 'sha256:stale-contract',
    'arguments': ref.argumentsCodec.encode(arguments),
  };
}

/// Utilities for asserting HTTP server-function responses.
extension ServerFunctionResponseAssertions on TestResponse {
  /// Asserts the response is a successful server-function envelope.
  TestResponse assertServerFunctionSuccess(dynamic expectedResult) {
    assertStatus(HttpStatus.ok);
    assertContentType(serverFunctionContentType);
    assertJsonContains({'ok': true, 'result': expectedResult});
    return this;
  }

  /// Asserts the response is a server-function error with [code].
  TestResponse assertServerFunctionError(
    String code, {
    int status = HttpStatus.badRequest,
  }) {
    assertStatus(status);
    assertJsonContains({
      'ok': false,
      'error': {'code': code},
    });
    return this;
  }

  /// Asserts the response indicates a contract mismatch.
  TestResponse assertContractMismatch() =>
      assertServerFunctionError('contract_mismatch');

  /// Asserts the response indicates an unauthenticated request.
  TestResponse assertUnauthenticated() =>
      assertServerFunctionError('unauthenticated', status: HttpStatus.unauthorized);
}

/// Creates a mock HTTP client that always returns a fixed JSON envelope.
class FixedResponseClient extends ShelfRequestHandler {
  final Map<String, dynamic> envelope;
  final int status;

  FixedResponseClient(this.envelope, {this.status = HttpStatus.ok})
      : super((Request request) async {
          return Response(
            status,
            body: jsonEncode(envelope),
            headers: {'content-type': 'application/json'},
          );
        });
}
