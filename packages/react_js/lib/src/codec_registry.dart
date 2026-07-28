import 'dart:js_interop';

/// Encodes a Dart value into a JS interop value for a custom codec.
typedef ReactValueEncoder = JSAny? Function(Object? value);

/// Decodes a JS interop value back into a Dart value for a custom codec.
typedef ReactValueDecoder = Object? Function(JSAny? value);

/// A custom codec for [ReactValueKind.object] callback values.
final class ReactCodec {
  /// Creates a codec with [encode] and [decode] functions.
  const ReactCodec({
    required this.encode,
    required this.decode,
  });

  /// Converts a Dart value to a JS interop value.
  final ReactValueEncoder encode;

  /// Converts a JS interop value back to a Dart value.
  final ReactValueDecoder decode;
}

/// Registry for custom callback object codecs.
///
/// Register codecs when generated component models need to pass complex
/// objects through callback props.
///
/// ```dart
/// ReactCodecRegistry.register(
///   'package:app/models.dart#User',
///   const ReactCodec(
///     encode: (user) => user.toJS,
///     decode: (js) => User.fromJS(js),
///   ),
/// );
/// ```
abstract final class ReactCodecRegistry {
  static final _codecs = <String, ReactCodec>{};

  /// Registers [codec] under [id].
  static void register(String id, ReactCodec codec) {
    _codecs[id] = codec;
  }

  /// Encodes [value] using the codec registered for [id].
  ///
  /// Throws a [StateError] if no codec is registered for [id].
  static JSAny? encode(String id, Object? value) {
    final codec = _codecs[id];

    if (codec == null) {
      throw StateError('No React codec registered for "$id".');
    }

    return codec.encode(value);
  }

  /// Decodes [value] using the codec registered for [id].
  ///
  /// Throws a [StateError] if no codec is registered for [id].
  static Object? decode(String id, JSAny? value) {
    final codec = _codecs[id];

    if (codec == null) {
      throw StateError('No React codec registered for "$id".');
    }

    return codec.decode(value);
  }
}
