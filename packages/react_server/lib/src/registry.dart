import 'dart:async';

import 'package:react_actions/react_actions.dart';

import 'context.dart';

/// Thrown when no handler is registered for a given function ID.
final class UnknownServerFunctionException implements Exception {
  final String id;
  const UnknownServerFunctionException(this.id);
}

/// Maps [ServerFunctionId]s to their actual implementations.
///
/// Populated by generated `register*` functions during server startup.
final class ServerFunctionRegistry {
  final _handlers =
      <String, Future<dynamic> Function(dynamic, ServerFunctionContext)>{};
  final _contractHashes = <String, String>{};

  /// Registers a handler for [ref].
  ///
  /// [handler] receives the decoded typed arguments and the request
  /// context, and returns the result.
  ///
  /// Throws [StateError] if [ref] is already registered.
  void register<TArgs, TResult>(
    ServerFunctionRef<TArgs, TResult> ref,
    FutureOr<TResult> Function(TArgs arguments, ServerFunctionContext context)
        handler,
  ) {
    if (_handlers.containsKey(ref.id.value)) {
      throw StateError('Duplicate server function: ${ref.id.value}');
    }
    _contractHashes[ref.id.value] = ref.contractHash;
    _handlers[ref.id.value] = (raw, context) async {
      final args = ref.argumentsCodec.decode(raw);
      final result = await handler(args, context);
      return ref.resultCodec.encode(result);
    };
  }

  /// Returns the contract hash for [id], or `null` if not registered.
  String? contractHashFor(String id) => _contractHashes[id];

  /// Dispatches a raw decoded-JSON request.
  ///
  /// Returns the encoded result (JSON-encodable object).
  /// Throws [UnknownServerFunctionException] if [id] is not registered.
  Future<dynamic> dispatch(
    String id,
    dynamic arguments,
    ServerFunctionContext context,
  ) async {
    final handler = _handlers[id];
    if (handler == null) {
      throw UnknownServerFunctionException(id);
    }
    return handler(arguments, context);
  }
}
