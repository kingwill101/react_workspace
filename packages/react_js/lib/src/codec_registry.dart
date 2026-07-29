import 'dart:js_interop';

/// Encodes a Dart value into a JS interop value for a custom codec.
typedef ReactValueEncoder = JSAny? Function(Object? value);

/// Decodes a JS interop value back into a Dart value for a custom codec.
typedef ReactValueDecoder = Object? Function(JSAny? value);

/// A custom codec for [ReactValueKind.encodedObject] callback values.
final class ReactCodec {
  /// Creates a codec with [encode] and [decode] functions.
  const ReactCodec({required this.encode, required this.decode});

  /// Converts a Dart value to a JS interop value.
  final ReactValueEncoder encode;

  /// Converts a JS interop value back to a Dart value.
  final ReactValueDecoder decode;
}

/// Registry for custom callback object codecs and host-value decoders.
///
/// ## Object codecs
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
///
/// ## Host-value decoders
/// Register host-value decoders for renderer-specific types (browser DOM
/// elements, synthetic events).
///
/// ```dart
/// ReactCodecRegistry.registerHostValue(
///   'web', 'HTMLDivElement',
///   decoder: (value) => generateElement(value as JSObject as web.HTMLElement),
///   encoder: (value) => (value as GeneratedElement).js as JSAny?,
/// );
/// ```
abstract final class ReactCodecRegistry {
  static final _codecs = <String, ReactCodec>{};
  static final _hostDecoders = <(String, String), ReactValueDecoder>{};
  static final _hostEncoders = <(String, String), ReactValueEncoder>{};

  /// Registers [codec] under [id].
  static void register(String id, ReactCodec codec) {
    _codecs[id] = codec;
  }

  /// Registers a host-value decoder/encoder for [hostNamespace]/[typeId].
  static void registerHostValue(
    String hostNamespace,
    String typeId, {
    ReactValueDecoder? decoder,
    ReactValueEncoder? encoder,
  }) {
    final key = (hostNamespace, typeId);
    if (decoder != null) _hostDecoders[key] = decoder;
    if (encoder != null) _hostEncoders[key] = encoder;
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

  /// Decodes [value] using the host-value decoder registered for
  /// [hostNamespace]/[typeId].  Returns the raw [value] when no decoder
  /// is registered.
  static Object? decodeHostValue(
    String hostNamespace,
    String typeId,
    JSAny? value,
  ) {
    final decoder = _hostDecoders[(hostNamespace, typeId)];
    return decoder != null ? decoder(value) : value;
  }

  /// Encodes [value] using the host-value encoder registered for
  /// [hostNamespace]/[typeId].
  ///
  /// Throws a [StateError] if no encoder is registered.
  static JSAny? encodeHostValue(
    String hostNamespace,
    String typeId,
    Object? value,
  ) {
    final encoder = _hostEncoders[(hostNamespace, typeId)];
    if (encoder == null) {
      throw StateError(
        'No host-value encoder registered for ($hostNamespace, $typeId).',
      );
    }
    return encoder(value);
  }
}
