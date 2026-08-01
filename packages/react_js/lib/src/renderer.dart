import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'package:react/react.dart';
import 'binding.dart';
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
    ContextProvider(:final context, :final value, :final children) => () {
      final binding = currentReactRuntime.binding;
      if (binding is! JsBinding) {
        throw UnsupportedError(
          'Context providers require the JavaScript React binding.',
        );
      }
      return _createElement(
        binding.contextObject(context),
        _propsToJS({'value': binding.encodeHookValue(value)}),
        children,
      );
    }(),
    Portal(:final children, :final container, :final key) => _createPortal(
      children,
      container,
      key: key,
    ),
    ErrorBoundary() => throw UnsupportedError(
      'Error boundaries are not implemented by JsRenderer yet.',
    ),
    Empty() => null,
    ReactNode() => throw UnsupportedError('Unknown ReactNode implementation.'),
  };

  JSAny _createPortal(
    List<ReactNode> children,
    Object container, {
    String? key,
  }) {
    final jsContainer = container as JSObject;
    final jsChildren = children.map((child) => toReactJS(child)!).toList();
    if (key == null) {
      return _reactDom.callMethod(
            'createPortal'.toJS,
            jsChildren.toJS,
            jsContainer,
          )
          as JSAny;
    }
    return _reactDom.callMethod(
          'createPortal'.toJS,
          jsChildren.toJS,
          jsContainer,
          key.toJS,
        )
        as JSAny;
  }

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

@JS('ReactDOM')
external JSObject get _reactDom;

@JS('React.Fragment')
external JSAny get _fragment;

@JS('React.StrictMode')
external JSAny get _strictMode;

@JS('React.Suspense')
external JSAny get _suspense;

@JS('globalThis.__reactDartResolveComponent')
external JSAny? _resolveForeignComponent(JSString name);
