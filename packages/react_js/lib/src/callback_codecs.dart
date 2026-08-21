import 'dart:js_interop';

import 'package:react/react.dart';
import 'package:react_js/src/codec_registry.dart' show ReactCodecRegistry;
import 'package:react_js/src/conversion_core.dart';

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

    ReactValueKind.reactNode => throw UnsupportedError(
      'Decoding ReactNode arguments is not implemented.',
    ),

    ReactValueKind.hostValue => ReactCodecRegistry.decodeHostValue(
      spec.hostNamespace!,
      spec.typeId!,
      value,
    ),

    ReactValueKind.encodedObject => ReactCodecRegistry.decode(
      spec.codecId!,
      value,
    ),
  };
}

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
    ReactValueKind.hostValue => ReactCodecRegistry.encodeHostValue(
      spec.hostNamespace!,
      spec.typeId!,
      value,
    ),
    ReactValueKind.encodedObject => ReactCodecRegistry.encode(
      spec.codecId!,
      value,
    ),
  };
}
