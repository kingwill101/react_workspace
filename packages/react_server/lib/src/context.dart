import 'package:react_actions/react_actions.dart';

/// Request-scoped context passed to every registered server function.
///
/// Carries authentication, request metadata, cancellation, and a
/// deadline.  The [ServerFunctionRegistry] injects this; the server
/// function implementation reads from it.
final class ServerFunctionContext {
  final String requestId;
  final Object? principal;
  final Map<String, String> headers;
  final Uri requestUri;
  final DateTime deadline;
  final CancellationToken cancellation;

  const ServerFunctionContext({
    required this.requestId,
    required this.principal,
    required this.headers,
    required this.requestUri,
    required this.deadline,
    required this.cancellation,
  });

  /// Returns [principal] or throws a [ServerFunctionFailure] with
  /// status 401.
  Object requireUser() {
    if (principal == null) {
      throw const ServerFunctionFailure(
        code: 'unauthenticated',
        message: 'Authentication is required.',
        statusCode: 401,
      );
    }
    return principal!;
  }
}

/// Mutable cancellation token for cooperative cancellation.
final class CancellationToken {
  bool _cancelled = false;

  bool get isCancelled => _cancelled;

  void cancel() {
    _cancelled = true;
  }
}
