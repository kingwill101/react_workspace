import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'package:react/react.dart';
import 'callback_bridge.dart';

// ═══════════════════════════════════════════
// Core Dart → JS conversion
// ═══════════════════════════════════════════

JSAny? toReactJS(Object? v) => switch (v) {
      null => null,
      String string => string.toJS,
      bool boolean => boolean.toJS,
      int integer => integer.toJS,
      double number => number.toJS,
      ReactNode node => renderNode(node),
      ReactCallback callback => callbackToJS(callback),
      List values => <JSAny?>[
          for (final value in values)
            toReactJS(value),
        ].toJS,
      Map<String, Object?> map => _mapToJS(map),
      Function function =>
        throw UnsupportedError(
          'Raw Dart functions cannot be used as '
          'React properties. Use a typed '
          'ReactCallback descriptor. Received '
          '${function.runtimeType}.',
        ),
      JSAny jsValue => jsValue,
    };

JSAny renderNode(ReactNode n) =>
    ReactInternal.renderer.render(n) as JSAny;

// ═══════════════════════════════════════════
// Safe property access — prevents dart2js -O2 from
// inlining `getProperty` to `js.prop` which would
// return a Dart value instead of JSAny.
// ═══════════════════════════════════════════

// ignore: unused_element
JSAny? _prop(JSObject o, String key) =>
    o.getProperty(key.toJS);

// ═══════════════════════════════════════════
// Required-property accessors with diagnostics
// ═══════════════════════════════════════════

void _throwMissing(String key, String type, String? component) {
  final prefix = component != null ? '$component requires' : 'Required';
  throw ArgumentError('$prefix a $type property named "$key", '
      'but the property was missing.');
}

String requiredJSString(JSObject o, String key, {String? component}) {
  final raw = o.getProperty(key.toJS);
  if (raw == null || raw.isUndefined) _throwMissing(key, 'String', component);
  return (raw as JSString).toDart;
}

int requiredJSInt(JSObject o, String key, {String? component}) {
  final raw = o.getProperty(key.toJS);
  if (raw == null || raw.isUndefined) _throwMissing(key, 'int', component);
  return (raw as JSNumber).toDartInt;
}

double requiredJSDouble(JSObject o, String key, {String? component}) {
  final raw = o.getProperty(key.toJS);
  if (raw == null || raw.isUndefined) _throwMissing(key, 'double', component);
  return (raw as JSNumber).toDartDouble;
}

bool requiredJSBool(JSObject o, String key, {String? component}) {
  final raw = o.getProperty(key.toJS);
  if (raw == null || raw.isUndefined) _throwMissing(key, 'bool', component);
  return (raw as JSBoolean).toDart;
}

// ═══════════════════════════════════════════
// Nullable-property accessors
// ═══════════════════════════════════════════

String? nullableJSString(JSObject o, String key) {
  final raw = o.getProperty(key.toJS);
  return (raw == null || raw.isUndefined) ? null : (raw as JSString).toDart;
}

int? nullableJSInt(JSObject o, String key) {
  final raw = o.getProperty(key.toJS);
  return (raw == null || raw.isUndefined) ? null : (raw as JSNumber).toDartInt;
}

double? nullableJSDouble(JSObject o, String key) {
  final raw = o.getProperty(key.toJS);
  return (raw == null || raw.isUndefined)
      ? null
      : (raw as JSNumber).toDartDouble;
}

bool? nullableJSBool(JSObject o, String key) {
  final raw = o.getProperty(key.toJS);
  return (raw == null || raw.isUndefined) ? null : (raw as JSBoolean).toDart;
}

// ═══════════════════════════════════════════
// Unchecked accessors (fallback for complex types)
// ═══════════════════════════════════════════

JSAny jsAny(JSObject o, String key) =>
    o.getProperty(key.toJS) as JSAny;

JSAny? jsAnyOrNull(JSObject o, String key) {
  final v = o.getProperty(key.toJS);
  return v == null || v.isUndefined ? null : v;
}

// ═══════════════════════════════════════════
// Generic JS → Dart (type-dispatched)
// ═══════════════════════════════════════════

T fromJS<T>(JSAny? js) {
  if (T == String) return (js as JSString).toDart as T;
  if (T == int) return (js as JSNumber).toDartInt as T;
  if (T == double) return (js as JSNumber).toDartDouble as T;
  if (T == bool) return (js as JSBoolean).toDart as T;
  if (T == num) return (js as JSNumber).toDartDouble as T;
  return js as T;
}

// ═══════════════════════════════════════════
// Internal helpers
// ═══════════════════════════════════════════

JSAny _mapToJS(Map<String, Object?> m) {
  final o = JSObject();
  m.forEach((k, val) {
    final j = toReactJS(val);
    if (j != null) o.setProperty(k.toJS, j);
  });
  return o as JSAny;
}
