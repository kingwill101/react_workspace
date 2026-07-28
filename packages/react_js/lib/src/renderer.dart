import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'package:react/react.dart';
import 'conversion_core.dart';
import 'registry.dart';

class JsRenderer extends ReactRenderer {
  @override
  Object? render(ReactNode node) => _render(node) as Object?;

  JSAny? _render(ReactNode n) => switch (n) {
        Component(:var id, :var props, :var children) => () {
          final e = ReactRegistry.lookup(id.value)!;
          final jsProps = e.toJS(props);
          final jsChildren =
              children.map((c) => toReactJS(c)!).toList().toJS;
          return _react.callMethod('createElement'.toJS,
              e.comp as JSAny, jsProps as JSAny, jsChildren) as JSAny;
        }(),
        Intrinsic(:var tag, :var props, :var children) =>
          _react.callMethod('createElement'.toJS, tag.toJS,
              _propsToJS(props),
              children.map((c) => toReactJS(c)!).toList().toJS) as JSAny,
        Text(:var value) => value.toJS,
        Fragment(:var children) =>
          _react.callMethod('createElement'.toJS, _fragment, null,
              children.map((c) => toReactJS(c)!).toList().toJS) as JSAny,
        Empty() => null,
      };

  JSObject _propsToJS(Map<String, Object?> m) {
    final o = JSObject();
    m.forEach((k, v) {
      if (v != null) {
        o.setProperty(k.toJS, toReactJS(v)!);
      }
    });
    return o;
  }
}

@JS('React')
external JSObject get _react;

@JS('React.Fragment')
external JSAny get _fragment;