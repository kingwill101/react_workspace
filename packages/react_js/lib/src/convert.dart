import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'package:react/react.dart';

// ═══════════════════════════════════════════
// Dart → JS conversion
// ═══════════════════════════════════════════

/// Converts any Dart value to its JS interop representation.
/// Used by [JsRenderer] and hand-written prop code.  Hides `.toJS` from
/// top-level Dart code — neither `example/` nor `react/` needs to know
/// about JS interop types.
JSAny? toReactJS(Object? v) => switch (v) {
      null => null,
      String s => s.toJS,
      bool b => b.toJS,
      int i => i.toJS,
      double d => d.toJS,
      ReactNode n => renderNode(n),
      List l => l.map(toReactJS).whereType<JSAny>().toList().toJS as JSAny,
      Map m => _mapToJS(m as Map<String, Object?>),
      Function f => _funcToJS(f),
      JSAny j => j,
    };

/// Converts a Dart function to a JS function.
/// The dummy `(() {}).toJS` call forces dart2js to retain `get$toJS()`
/// on all `void Function()` closures in the program — without it, the
/// tree-shaker removes the method from closures whose `.toJS` calls are
/// only reachable through `(f as dynamic).toJS` (which erases type info).
JSAny _funcToJS(Function f) {
  // `_functionToJS0` in the renderer may already wrap the closure.
  // A plain JS wrapper has no `get$toJS`, so return it as-is instead
  // of crashing with `f.get$toJS is not a function`.
  final asObj = f as JSObject;
  final maybeJS = asObj.getProperty('toJS'.toJS);
  if (maybeJS != null && !maybeJS.isUndefined) return maybeJS as JSAny;
  return f as JSAny;
}

/// Renders a [ReactNode] to a JS React element tree.
JSAny renderNode(ReactNode n) =>
    ReactInternal.renderer.render(n) as JSAny;

// ═══════════════════════════════════════════
// Safe property access — prevents dart2js -O2 from
// inlining `getProperty` to `js.prop` which would
// return a Dart value instead of JSAny.
// ═══════════════════════════════════════════

/// Reads a property from [o] returning the raw [JSAny?].
/// The noinline comment prevents dart2js from optimizing
/// the getProperty call to direct JS property access.
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

/// Converts a [JSAny?] back to Dart, using runtime type dispatch.
/// Falls through to `js as T` for types not in the known table.
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