import 'codec.dart';
import 'function_id.dart';

/// A typed reference to a registered server function.
///
/// Binds together the function's canonical identifier with the codecs
/// needed to serialize its arguments and deserialize its result, plus
/// a contract hash for schema-change detection.
///
/// This is the **shared artifact** — compiled into both the browser JS
/// bundle (for the client proxy) and the native Dart server binary (for
/// the registry). Both sides agree on the ID and the codec behavior.
final class ServerFunctionRef<TArgs, TResult> {
  final ServerFunctionId id;

  /// Hash of the normalized parameter and result schema.
  ///
  /// Generated from a canonical representation of the function's
  /// wire-level contract: ID, parameter names, types, nullability,
  /// result type, and codec version.
  final String contractHash;

  final ServerFunctionJsonCodec<TArgs> argumentsCodec;
  final ServerFunctionJsonCodec<TResult> resultCodec;

  const ServerFunctionRef({
    required this.id,
    required this.contractHash,
    required this.argumentsCodec,
    required this.resultCodec,
  });
}
