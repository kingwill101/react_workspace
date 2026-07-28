import 'dart:convert';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'package:react/react.dart';
import 'package:react_js/react_js.dart';

void initReact() => ReactInternal.init(binding: JsBinding(), renderer: JsRenderer());

void registerGlobalRenderer(
    ReactNode Function(String id, Map<String, dynamic> props) factory) {
  JSAny? handler(JSObject req) {
    final id = (req.getProperty('id'.toJS) as JSString).toDart;
    final propsObj = req.getProperty('props'.toJS) as JSObject?;
    Map<String, dynamic> props = {};
    if (propsObj != null) {
      final jsonStr = _jsonStringify(propsObj);
      if (jsonStr.isNotEmpty) {
        props = (jsonDecode(jsonStr) as Map<String, dynamic>?) ?? {};
      }
    }
    return ReactInternal.renderer.render(factory(id, props)) as JSAny?;
  }
  globalThis.setProperty('__REACT_RENDER__'.toJS, handler.toJS);
}

/// JSON-stringify a JS object to convert it to a Dart Map via dart:convert.
String _jsonStringify(JSObject obj) =>
    (_json.callMethod('stringify'.toJS, obj) as JSString).toDart;

@JS('globalThis')
external JSObject get globalThis;

@JS('JSON')
external JSObject get _json;
