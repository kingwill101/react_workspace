import 'dart:async';

import 'client.dart';

final Object _serverFunctionClientKey = Object();

/// The currently active [ServerFunctionClient] for this zone.
///
/// Throws [StateError] if no client has been configured.
ServerFunctionClient get currentServerFunctionClient {
  final client = Zone.current[_serverFunctionClientKey];
  if (client is ServerFunctionClient) return client;
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
///     () {
///       hydrateRoot('#app', App());
///     },
///   );
/// }
/// ```
T runWithServerFunctionClient<T>(
  ServerFunctionClient client,
  T Function() callback,
) {
  return runZoned(
    callback,
    zoneValues: {_serverFunctionClientKey: client},
  );
}
