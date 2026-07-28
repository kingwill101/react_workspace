import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:react/react.dart';
import 'package:react_js/src/codec_registry.dart' show ReactCodecRegistry;
import 'package:react_js/src/conversion_core.dart';

/// JS-backed implementation of [SyntheticEventHandle].
final class JsSyntheticEventHandle implements SyntheticEventHandle {
  /// The underlying JS event object.
  final JSObject value;

  /// Creates a handle for [value].
  JsSyntheticEventHandle(this.value);

  @override
  void preventDefault() {
    value.callMethod('preventDefault'.toJS);
  }

  @override
  void stopPropagation() {
    value.callMethod('stopPropagation'.toJS);
  }

  @override
  bool get defaultPrevented {
    return (value.getProperty('defaultPrevented'.toJS) as JSBoolean).toDart;
  }
}

/// Wraps a JS synthetic event object in a pure-Dart [SyntheticEvent].
SyntheticEvent decodeSyntheticEvent(JSObject value) {
  return SyntheticEvent(JsSyntheticEventHandle(value));
}

// ═══════════════════════════════════════════
// Built-in value decoding
// ═══════════════════════════════════════════

/// Decodes a JS interop value into a Dart value using [spec].
///
/// ```dart
/// final intValue = decodeReactValue(reactInt, jsNumber);
/// ```
///
/// Throws an [ArgumentError] if the value is `null` or `undefined` and
/// [ReactValueSpec.nullable] is `false`.
Object? decodeReactValue(
  ReactValueSpec spec,
  JSAny? value, [
  String? debugName,
  int? index,
]) {
  if (value == null || value.isUndefined) {
    if (spec.nullable) {
      return null;
    }

    throw ArgumentError(
      'Received null or undefined for '
      '${spec.kind.name}${debugName != null && index != null ? ' argument $index of $debugName' : ''}.',
    );
  }

  return switch (spec.kind) {
    ReactValueKind.void_ => null,

    ReactValueKind.any => value,

    ReactValueKind.string => (value as JSString).toDart,

    ReactValueKind.integer => (value as JSNumber).toDartInt,

    ReactValueKind.number => (value as JSNumber).toDartDouble,

    ReactValueKind.boolean => (value as JSBoolean).toDart,

    ReactValueKind.reactNode =>
      throw UnsupportedError(
        'Decoding ReactNode arguments is not implemented.',
      ),

    ReactValueKind.syntheticEvent =>
      decodeSyntheticEvent(value as JSObject),

    ReactValueKind.object => ReactCodecRegistry.decode(spec.codecId!, value),
  };
}

// ═══════════════════════════════════════════
// Built-in value encoding
// ═══════════════════════════════════════════

/// Encodes a Dart value into a JS interop value using [spec].
///
/// ```dart
/// final jsValue = encodeReactValue(reactString, 'hello');
/// ```
///
/// Throws an [ArgumentError] if [value] is `null` and the spec is not
/// nullable or [ReactValueKind.void_].
JSAny? encodeReactValue(ReactValueSpec spec, Object? value) {
  if (value == null) {
    if (spec.nullable || spec.kind == ReactValueKind.void_) {
      return null;
    }

    throw ArgumentError(
      'Callback returned null for non-nullable '
      '${spec.kind.name}.',
    );
  }

  return switch (spec.kind) {
    ReactValueKind.void_ => null,
    ReactValueKind.any => toReactJS(value),
    ReactValueKind.string => (value as String).toJS,
    ReactValueKind.integer => (value as int).toJS,
    ReactValueKind.number => (value as num).toDouble().toJS,
    ReactValueKind.boolean => (value as bool).toJS,
    ReactValueKind.reactNode => toReactJS(value as ReactNode),
    ReactValueKind.syntheticEvent =>
      throw UnsupportedError(
        'Synthetic events cannot be callback results.',
      ),
    ReactValueKind.object => ReactCodecRegistry.encode(spec.codecId!, value),
  };
}
