/// A deliberate failure thrown by server business logic.
///
/// Maps to a structured error envelope over HTTP.
class ServerFunctionFailure implements Exception {
  final String code;
  final String message;
  final int statusCode;
  final Map<String, Object?>? details;

  const ServerFunctionFailure({
    required this.code,
    required this.message,
    required this.statusCode,
    this.details,
  });
}

/// A decoded server error received by the client.
///
/// Thrown by [ServerFunctionClient.invoke] when the server returns an
/// error envelope.
final class RemoteServerFunctionException implements Exception {
  final String code;
  final String message;
  final int statusCode;
  final Map<String, Object?>? details;
  final String? requestId;

  const RemoteServerFunctionException({
    required this.code,
    required this.message,
    required this.statusCode,
    this.details,
    this.requestId,
  });
}

/// A transport-level failure (network error, timeout, invalid response).
///
/// Thrown by [ServerFunctionClient.invoke] when the request could not
/// reach the server or the response was malformed.
final class ServerFunctionTransportException implements Exception {
  final String message;
  final Object? cause;

  const ServerFunctionTransportException(this.message, {this.cause});
}
