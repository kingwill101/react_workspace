import 'ref.dart';

/// Transport abstraction for invoking server functions from the browser.
///
/// The concrete implementation depends on the environment:
/// - Browser: [HttpServerFunctionClient] via `package:http`
/// - Test: mock client
abstract class ServerFunctionClient {
  /// Invokes the function identified by [ref] with [arguments].
  ///
  /// Returns the typed result. Throws [RemoteServerFunctionException] on
  /// server-side errors or [ServerFunctionTransportException] on network
  /// failures.
  Future<TResult> invoke<TArgs, TResult>(
    ServerFunctionRef<TArgs, TResult> ref,
    TArgs arguments,
  );

  /// Releases any underlying resources (HTTP connections, etc.).
  void close() {}
}
