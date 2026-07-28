import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'package:react/react.dart';

class JsRenderer extends ReactRenderer {
  @override
  JSAny? render(ReactNode node) => _render(node);

  JSAny? _render(ReactNode n) => switch (n) {
        Intrinsic(:var tag, :var props, :var children, :var key) =>
          _react.callMethod(
            'createElement'.toJS,
            tag.toJS,
            _withKey(_propsToJS(props), key),
            _childrenToJS(children),
          ),
        Component(:var id, :var props, :var key, :var children) =>
          _react.callMethod(
            'createElement'.toJS,
            ReactRegistry.lookup(id.value) as JSAny,
            _withKey(_toJSObject(props), key),
            _childrenToJS(children),
          ),
        Text(:var value) => value.toJS,
        Fragment(:var children) => _react.callMethod(
              'createElement'.toJS,
              _fragment,
              null,
              _childrenToJS(children),
            ),
        Empty() => null,
      };

  JSObject _propsToJS(Map<String, Object?> m) {
    final o = JSObject();
    m.forEach((k, v) {
      if (v != null) {
        o.setProperty(k.toJS, v as JSAny);
      }
    });
    return o;
  }

  JSObject _toJSObject(Object? p) {
    if (p == null) return JSObject();
    if (p is JSObject) return p;
    // For records, generator will produce JSObject via toJS helpers
    // fallback
    return JSObject();
  }

  JSObject _withKey(JSObject o, String? k) {
    if (k != null) {
      o.setProperty('key'.toJS, k.toJS);
    }
    return o;
  }

  JSAny _childrenToJS(List<ReactNode> children) {
    final list = children.map(_render).whereType<JSAny>().toList();
    return list.toJS;
  }
}

@JS('React')
external JSObject get _react;

@JS('React.Fragment')
external JSAny get _fragment;
