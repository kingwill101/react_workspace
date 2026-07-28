import 'dart:convert';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'package:react/react.dart';
import 'package:react_js/react_js.dart';

void initReact() => ReactInternal.init(binding: JsBinding(), renderer: JsRenderer());

/// Registers an SSR render handler.
///
/// The [factory] receives a component [id] and [props], and returns a
/// [ReactNode] tree.  The tree is expanded to JS React elements via the
/// [JsRenderer], producing a flat intrinsic tree that
/// [ReactDOMServer.renderToString] can serialize without re-entering
/// component wrappers.
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
    return _expandTree(factory(id, props));
  }
  _globalThis.setProperty('__REACT_RENDER__'.toJS, handler.toJS);
}

/// Recursively expands a [ReactNode] tree into JS React elements
/// (intrinsics, not component wrappers) so SSR can serialize them
/// without re-entering generated component functions.
JSAny? _expandTree(ReactNode node) => switch (node) {
      Intrinsic(:var tag, :var props, :var children) =>
        _react.callMethod('createElement'.toJS, tag.toJS,
            _intrinsicPropsToJS(props),
            children.map(_expandTree).whereType<JSAny>().toList().toJS) as JSAny,
      Component(:var id, :var props, :var children) =>
        _expandComponent(id, props, children),
      Text(:var value) => value.toJS,
      Fragment(:var children) =>
        _react.callMethod('createElement'.toJS, _fragment, null,
            children.map(_expandTree).whereType<JSAny>().toList().toJS) as JSAny,
      Empty() => null,
    };

/// Renders a Component node by calling its generated JS wrapper
/// (which produces a flat intrinsic React element via toReactJS).
JSAny _expandComponent(ComponentId id, Object? props, List<ReactNode> children) {
  final e = ReactRegistry.lookup(id.value);
  if (e == null) {
    throw ArgumentError('Component "${id.value}" not registered for SSR');
  }
  final jsProps = e.toJS(props);
  final rendered = e.comp.callAsFunction(null, jsProps) as JSAny?;
  if (rendered == null) {
    if (children.isEmpty) return _react.callMethod('createElement'.toJS, _fragment, null) as JSAny;
    return _react.callMethod('createElement'.toJS, _fragment, null,
        children.map(_expandTree).whereType<JSAny>().toList().toJS) as JSAny;
  }
  return rendered as JSAny;
}

JSObject _intrinsicPropsToJS(Map<String, Object?> m) {
  final o = JSObject();
  m.forEach((k, v) {
    if (v != null) o.setProperty(k.toJS, toReactJS(v)!);
  });
  return o;
}

/// JSON-stringifies a JSObject via `JSON.stringify`.
String _jsonStringify(JSObject obj) =>
    (_json.callMethod('stringify'.toJS, obj) as JSString).toDart;

@JS('React')
external JSObject get _react;

@JS('React.Fragment')
external JSAny get _fragment;

@JS('globalThis')
external JSObject get _globalThis;

@JS('JSON')
external JSObject get _json;