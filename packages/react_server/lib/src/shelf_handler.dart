import 'dart:async';

import 'package:shelf/shelf.dart';

import 'registry.dart';

/// Web placeholder for the native Shelf action handler.
///
/// A browser build should not execute a server action handler. The native
/// implementation is selected by the conditional export in
/// `react_server.dart`.
FutureOr<Response> Function(Request) createServerActionHandler(
  ServerFunctionRegistry registry, {
  Object? Function(Request req)? authenticate,
  Duration requestTimeout = const Duration(seconds: 30),
  int maxBodySize = 1024 * 1024,
}) {
  throw UnsupportedError(
    'createServerActionHandler is only available on a native Dart server.',
  );
}
