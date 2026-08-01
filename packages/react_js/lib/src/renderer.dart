import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'package:react/react.dart';
import 'callback_bridge.dart';
import 'conversion_core.dart';
import 'registry.dart';

class JsRenderer extends ReactRenderer {
  @override
  Object? render(ReactNode node) => _render(node) as Object?;

  JSAny? _render(ReactNode n) => switch (n) {
    Component(:var id, :var props, :var children, :var key) => () {
      final e = ReactRegistry.lookup(id.value)!;
      final jsProps = e.toJS(props);
      return _createElement(e.comp, jsProps, children, key: key);
    }(),
    ForeignComponent(:var name, :var props, :var children, :var key) => () {
      final component = _resolveForeignComponent(name.toJS);
      if (component == null) {
        throw StateError('Foreign React component not registered: $name');
      }
      return _createElement(component, _propsToJS(props), children, key: key);
    }(),
    HostNode(:var type, :var props, :var children, :var key) => _createElement(
      type.name.toJS,
      _propsToJS(props as Map<String, Object?>),
      children,
      key: key,
    ),
    Text(:var value) => value.toJS,
    Fragment(:var children, :var key) => _createElement(
      _fragment,
      null,
      children,
      key: key,
    ),
    StrictMode(:var children) => _createElement(_strictMode, null, children),
    Suspense(:var fallback, :var children) => _createElement(
      _suspense,
      _propsToJS({'fallback': _render(fallback)}),
      children,
    ),
    ContextProvider() => throw UnsupportedError(
      'Context providers are not implemented by JsRenderer yet.',
    ),
    Portal() => throw UnsupportedError(
      'Portals are not implemented by JsRenderer yet.',
    ),
    ErrorBoundary() => throw UnsupportedError(
      'Error boundaries are not implemented by JsRenderer yet.',
    ),
    Empty() => null,
    ReactNode() => throw UnsupportedError('Unknown ReactNode implementation.'),
  };

  JSAny _createElement(
    JSAny type,
    JSAny? props,
    List<ReactNode> children, {
    String? key,
  }) {
    final keyedProps = _withKey(props, key);
    final jsChildren = children.map((c) => toReactJS(c)!).toList();
    if (jsChildren.isEmpty) {
      return _react.callMethod('createElement'.toJS, type, keyedProps) as JSAny;
    }
    return _react.callMethod(
          'createElement'.toJS,
          type,
          keyedProps,
          jsChildren.toJS,
        )
        as JSAny;
  }

  JSAny? _withKey(JSAny? props, String? key) {
    if (key == null) return props;
    final object = props != null && props.isA<JSObject>()
        ? props as JSObject
        : JSObject();
    object.setProperty('key'.toJS, key.toJS);
    return object;
  }

  JSObject _propsToJS(Map<String, Object?> m) {
    final o = JSObject();
    m.forEach((k, v) {
      if (v != null) {
        final jsValue = switch (v) {
          ReactEventProp(:final callback) => callbackToJS(callback),
          ReactRefProp(:final callback) => callbackToJS(callback),
          _ => toReactJS(v),
        };
        if (jsValue != null) o.setProperty(k.toJS, jsValue);
      }
    });
    return o;
  }
}

@JS('React')
external JSObject get _react;

@JS('React.Fragment')
external JSAny get _fragment;

@JS('React.StrictMode')
external JSAny get _strictMode;

@JS('React.Suspense')
external JSAny get _suspense;

@JS('globalThis.__reactDartResolveComponent')
external JSAny? _resolveForeignComponent(JSString name);
