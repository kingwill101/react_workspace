import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'package:react/react.dart';
import 'binding.dart';
import 'callback_bridge.dart';
import 'conversion_core.dart';
import 'registry.dart';

class JsRenderer extends ReactRenderer {
  final _memoizedComponents = <String, Map<Object?, JSFunction>>{};

  @override
  Object? render(ReactNode node) => _render(node) as Object?;

  JSAny? _render(ReactNode n) => switch (n) {
    Component(:var id, :var props, :var children, :var key) => () {
      final e = ReactRegistry.lookup(id.value)!;
      final jsProps = e.toJS(props);
      return _createElement(e.comp, jsProps, children, key: key);
    }(),
    MemoizedNode(:final child, :final arePropsEqual) => _renderMemoized(
      child,
      arePropsEqual,
    ),
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
    ErrorBoundary(:final children, :final fallback, :final onError) =>
      _createElement(
        _getErrorBoundary(),
        _errorBoundaryProps(fallback, onError),
        children,
      ),
    Empty() => null,
    ReactNode() => throw UnsupportedError('Unknown ReactNode implementation.'),
  };

  JSAny _renderMemoized(
    ReactNode child,
    bool Function(Object? previous, Object? next)? arePropsEqual,
  ) => switch (child) {
    Component(:var id, :var props, :var children, :var key) => () {
      final entry = ReactRegistry.lookup(id.value)!;
      final memoType = _memoizedComponent(id.value, entry, arePropsEqual);
      return _createElement(memoType, entry.toJS(props), children, key: key);
    }(),
    ForeignComponent(:var name, :var props, :var children, :var key) => () {
      final component = _resolveForeignComponent(name.toJS);
      if (component == null) {
        throw StateError('Foreign React component not registered: $name');
      }
      final memoType = _memoizedForeignComponent(name, component as JSFunction);
      return _createElement(memoType, _propsToJS(props), children, key: key);
    }(),
    _ => throw UnsupportedError(
      'memo currently supports registered component nodes only.',
    ),
  };

  JSFunction _memoizedComponent(
    String id,
    Entry entry,
    bool Function(Object? previous, Object? next)? arePropsEqual,
  ) {
    final byComparator = _memoizedComponents.putIfAbsent(id, () => {});
    final cached = byComparator[arePropsEqual];
    if (cached != null) return cached;

    final compareJS = arePropsEqual == null
        ? null
        : ((JSObject previous, JSObject next) {
            return arePropsEqual(
              entry.fromJS(previous),
              entry.fromJS(next),
            ).toJS;
          }).toJS;
    final memoType = compareJS == null
        ? _react.callMethod('memo'.toJS, entry.comp) as JSFunction
        : _react.callMethod('memo'.toJS, entry.comp, compareJS) as JSFunction;
    byComparator[arePropsEqual] = memoType;
    return memoType;
  }

  JSFunction _memoizedForeignComponent(String id, JSFunction component) {
    final byComparator = _memoizedComponents.putIfAbsent(id, () => {});
    final cached = byComparator[null];
    if (cached != null) return cached;
    final memoType = _react.callMethod('memo'.toJS, component) as JSFunction;
    byComparator[null] = memoType;
    return memoType;
  }

  JSObject _errorBoundaryProps(
    ReactNode fallback,
    void Function(Object error, StackTrace stack)? onError,
  ) {
    final props = JSObject();
    props.setProperty('fallback'.toJS, _render(fallback));
    if (onError != null) {
      final report = ((JSAny? error, JSAny? info) {
        onError(error ?? 'Unknown React error', StackTrace.current);
      }).toJS;
      props.setProperty('onError'.toJS, report);
    }
    return props;
  }

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

@JS('globalThis.__reactDartGetErrorBoundary')
external JSFunction _getErrorBoundary();
