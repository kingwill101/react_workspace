/// Marks a function as a server function.
///
/// The implementation runs exclusively on the server. The generator
/// produces a client proxy, codecs, and a server registration.
///
/// The function's first parameter must be [ServerFunctionContext] (from
/// `package:react_server`). All remaining parameters must be required
/// and named.
///
/// ```dart
/// @serverFunction
/// Future<ToggleTodoResult> toggleTodo(
///   ServerFunctionContext context, {
///   required String todoId,
///   required bool completed,
/// }) async { ... }
/// ```
const serverFunction = _ServerFunction();

class _ServerFunction {
  const _ServerFunction();
}

/// Marks a class as a browser-safe data transfer type for server
/// function contracts.
///
/// The type must satisfy the Phase 1 contract requirements:
/// - `final class`
/// - No type parameters
/// - No superclass other than `Object`
/// - No mixins
/// - All instance fields are `final` and public
/// - Exactly one public generative constructor whose parameters match
///   the serialized fields
/// - No cyclic type references
/// - All field types are supported (primitives, records, other
///   [@serverData] types, [List], [Map], [DateTime], [Uri], enums)
///
/// ```dart
/// @serverData
/// final class ToggleTodoResult {
///   final String id;
///   final bool completed;
///
///   const ToggleTodoResult({
///     required this.id,
///     required this.completed,
///   });
/// }
/// ```
const serverData = _ServerData();

class _ServerData {
  const _ServerData();
}
