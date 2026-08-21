import 'dart:async';

import 'client.dart';

final Object _serverFunctionClientKey = Object();
ServerFunctionClient? _globalServerFunctionClient;

/// The currently active [ServerFunctionClient].
///
/// JS callbacks and React effects can re-enter Dart outside the zone that
/// installed the React root, so the root client is also retained as a global
/// fallback. The zone value still takes precedence for isolated tests.
/// Throws [StateError] if no client has been configured.
ServerFunctionClient get currentServerFunctionClient {
  final client = Zone.current[_serverFunctionClientKey];
  if (client is ServerFunctionClient) return client;
  final globalClient = _globalServerFunctionClient;
  if (globalClient != null) return globalClient;
  throw StateError(
    'No ServerFunctionClient is configured for the current zone.',
  );
}

/// Runs [callback] with [client] as the current server function client.
///
/// Used by the browser entry point to configure how generated action
/// proxies reach the server:
///
/// ```dart
/// void main() {
///   runWithServerFunctionClient(
///     HttpServerFunctionClient(endpoint: Uri.parse('/__react/actions')),
///     startReactApplication,
///   );
/// }
/// ```
T runWithServerFunctionClient<T>(
  ServerFunctionClient client,
  T Function() callback,
) {
  // Keep the client available when React invokes an effect or event callback
  // after the installing zone has ended.
  _globalServerFunctionClient = client;
  return runZoned(callback, zoneValues: {_serverFunctionClientKey: client});
}
