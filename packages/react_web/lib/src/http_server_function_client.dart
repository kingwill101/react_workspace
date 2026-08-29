import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:react_actions/react_actions.dart';

/// Browser-side [ServerFunctionClient] for server-function HTTP requests.
///
/// Compact CBOR frames can be enabled with [useCompactProtocol]. JSON remains
/// the default for compatibility with existing deployments.
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
  final bool useCompactProtocol;

  HttpServerFunctionClient({
    Uri? endpoint,
    http.Client? client,
    this.requestTimeout = const Duration(seconds: 30),
    this.useCompactProtocol = false,
  }) : endpoint = endpoint ?? Uri.parse('/__react/actions'),
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
      final headers = {
        'content-type': useCompactProtocol
            ? compactProtocolContentType
            : serverFunctionContentType,
        'accept': useCompactProtocol
            ? compactProtocolContentType
            : serverFunctionContentType,
        serverFunctionProtocolHeader: useCompactProtocol
            ? '$compactProtocolVersion'
            : '$serverFunctionProtocolVersion',
        serverFunctionIdHeader: ref.id.value,
        serverFunctionContractHeader: ref.contractHash,
      };
      final body = ref.argumentsCodec.encode(arguments);
      response = await client
          .post(
            endpoint,
            headers: headers,
            body: useCompactProtocol
                ? ReactFrame(
                    kind: ReactMessageKind.invoke,
                    actionId: compactActionId(ref.id.value),
                    requestId: _nextRequestId(),
                    payload: {
                      'id': ref.id.value,
                      'contract': ref.contractHash,
                      'arguments': body,
                    },
                  ).encode()
                : jsonEncode({
                    'protocol': serverFunctionProtocolVersion,
                    'id': ref.id.value,
                    'contract': ref.contractHash,
                    'arguments': body,
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
      final envelope = useCompactProtocol
          ? _tryParseCompactErrorEnvelope(response.bodyBytes) ??
                _tryParseErrorEnvelope(response.body)
          : _tryParseErrorEnvelope(response.body);
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

    late ServerFunctionResponse envelope;
    try {
      envelope = useCompactProtocol
          ? _decodeCompactResponse(response.bodyBytes)
          : ServerFunctionResponse.fromJson(jsonDecode(response.body));
    } catch (error) {
      throw ServerFunctionTransportException(
        'The server returned an invalid response envelope.',
        cause: error,
      );
    }

    if (!envelope.ok) {
      throw RemoteServerFunctionException(
        code: envelope.error!.code,
        message: envelope.error!.message,
        statusCode: response.statusCode,
        details: envelope.error!.details,
        requestId: envelope.error!.requestId,
      );
    }

    try {
      return ref.resultCodec.decode(envelope.result);
    } catch (error) {
      throw ServerFunctionTransportException(
        'The server returned an invalid result.',
        cause: error,
      );
    }
  }
}

var _requestCounter = 0;
int _nextRequestId() => ++_requestCounter;

ServerFunctionResponse _decodeCompactResponse(List<int> bytes) {
  final frame = ReactFrame.decode(bytes);
  if (frame.kind != ReactMessageKind.result &&
      frame.kind != ReactMessageKind.error) {
    throw const FormatException('Unexpected compact response kind.');
  }
  return ServerFunctionResponse.fromJson(frame.payload);
}

ServerFunctionError? _tryParseCompactErrorEnvelope(List<int> bytes) {
  try {
    return ServerFunctionError.fromJson(
      Map<String, dynamic>.from(
        (ReactFrame.decode(bytes).payload as Map)['error'] as Map,
      ),
    );
  } catch (_) {
    return null;
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
