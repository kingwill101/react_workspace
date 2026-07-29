/// Serializes and deserializes function arguments or results between
/// Dart values and JSON-compatible maps/lists/primitives.
///
/// Each generated server function gets a pair of codecs — one for its
/// arguments (a record type) and one for its result type.
///
/// Operates on [dynamic] (decoded JSON) because the transport layer
/// receives raw [dart:convert] output. The codec casts to the expected
/// structure internally.
abstract class ServerFunctionJsonCodec<T> {
  /// Converts [value] to a JSON-encodable object.
  ///
  /// The returned object must be accepted by [jsonEncode]:
  /// [Map], [List], [num], [String], [bool], or [Null].
  dynamic encode(T value);

  /// Converts a JSON-decoded [json] back to the typed Dart value.
  ///
  /// [json] is the raw output of [jsonDecode]: [Map], [List], [num],
  /// [String], [bool], or [Null].
  T decode(dynamic json);
}
