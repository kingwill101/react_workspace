import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:react_actions/react_actions.dart';

/// Browser-side [ServerFunctionClient] that uses `package:http` to POST
/// JSON-encoded action requests to a same-origin endpoint.
///
/// The default [endpoint] is `/__react/actions`.
///
/// ```dart
/// void main() {
///   runWithServerFunctionClient(
///     HttpServerFunctionClient(),
///     () => hydrateRoot('#app', App()),
///   );
/// }
/// ```
final class HttpServerFunctionClient implements ServerFunctionClient {
  final Uri endpoint;
  final http.Client client;
  final Duration requestTimeout;

  HttpServerFunctionClient({
    Uri? endpoint,
    http.Client? client,
    this.requestTimeout = const Duration(seconds: 30),
  })  : endpoint = endpoint ?? Uri.parse('/__react/actions'),
        client = client ?? http.Client();

  @override
  void close() {
    client.close();
  }

  @override
  Future<TResult> invoke<TArgs, TResult>(
    ServerFunctionRef<TArgs, TResult> ref,
    TArgs arguments,
  ) async {
    late http.Response response;

    try {
      response = await client
          .post(
            endpoint,
            headers: const {
              'content-type': 'application/json',
              'accept': 'application/json',
            },
            body: jsonEncode({
              'protocol': 1,
              'id': ref.id.value,
              'contract': ref.contractHash,
              'arguments': ref.argumentsCodec.encode(arguments),
            }),
          )
          .timeout(requestTimeout);
    } catch (error) {
      throw ServerFunctionTransportException(
        'The server function request failed.',
        cause: error,
      );
    }

    // Validate HTTP status
    if (response.statusCode < 200 || response.statusCode >= 300) {
      // Try to parse structured error
      final envelope = _tryParseErrorEnvelope(response.body);
      if (envelope != null) {
        throw RemoteServerFunctionException(
          code: envelope.code,
          message: envelope.message,
          statusCode: response.statusCode,
          details: envelope.details,
          requestId: envelope.requestId,
        );
      }
      throw ServerFunctionTransportException(
        'Unexpected HTTP status ${response.statusCode}.',
      );
    }

    // Parse response body
    final Object? decoded;
    try {
      decoded = jsonDecode(response.body);
    } catch (error) {
      throw ServerFunctionTransportException(
        'The server returned an invalid response.',
        cause: error,
      );
    }

    // Decode envelope
    final envelope = ServerFunctionResponse.fromJson(decoded);

    if (!envelope.ok) {
      throw RemoteServerFunctionException(
        code: envelope.error!.code,
        message: envelope.error!.message,
        statusCode: response.statusCode,
        details: envelope.error!.details,
        requestId: envelope.error!.requestId,
      );
    }

    return ref.resultCodec.decode(envelope.result);
  }
}

/// Attempts to parse a structured error envelope from a non-2xx response
/// body. Returns `null` if the body is not valid JSON or not an envelope.
ServerFunctionError? _tryParseErrorEnvelope(String body) {
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
