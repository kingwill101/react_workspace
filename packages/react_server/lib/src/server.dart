import 'dart:convert';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'package:react_js/react_js.dart';

final _memoizedComponents = <String, Map<Object?, JSFunction>>{};
final _forwardRefComponents = <Function, JSFunction>{};
final _lazyComponents = <Function, JSFunction>{};

///
/// The [factory] receives a component [id] and [props], and returns a
/// [ReactNode] tree.  The tree is expanded to JS React elements via
/// [React.createElement], producing a tree that
/// [ReactDOMServer.renderToString] can serialize.
///
/// Component nodes are emitted as [React.createElement(comp, toJSProps)]
/// so that React sets up the proper hooks context during rendering.
/// Intrinsic, Text, Fragment, and Empty nodes are expanded inline.
void registerGlobalRenderer(
  ReactNode Function(String id, Map<String, dynamic> props) factory,
) {
  JSAny? handler(JSObject req) {
    return runWithReactRuntime(
      ReactRuntime(
        target: ReactRenderTarget.server,
        capabilities: ReactRuntimeCapabilities.server,
        binding: JsBinding(),
        renderer: JsRenderer(),
      ),
      () {
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
      },
    );
  }

  _globalThis.setProperty('__REACT_RENDER__'.toJS, handler.toJS);
}

/// Recursively expands a [ReactNode] tree into JS React elements.
///
/// Component nodes are emitted as `React.createElement(registeredComp, …)`
/// so React handles component context, hooks, and lifecycle properly.
/// All other node types are flattened inline.
JSAny? _expandTree(ReactNode node) => switch (node) {
  HostNode(:var type, :var props, :var children, :var key) =>
    _createHostElement(type.name, props, children, key: key),
  Component(:var id, :var props, :var children, :var key) => _expandComponent(
    id,
    props,
    children,
    key: key,
  ),
  MemoizedNode(:final child, :final arePropsEqual) => _expandMemoized(
    child,
    arePropsEqual,
  ),
  ForwardRefNode() => _expandForwardRef(
    node as ForwardRefNode<Object?, Object?>,
  ),
  LazyNode() => _expandLazy(node as LazyNode<Object?>),
  ForeignComponent(:var name, :var props, :var children, :var key) =>
    _expandForeignComponent(name, props, children, key: key),
  Text(:var value) => value.toJS,
  Fragment(:var children, :var key) => _createFragment(children, key: key),
  StrictMode(:var children) => _createReactElement(_strictMode, children),
  Suspense(:var fallback, :var children) => _createReactElement(
    _suspense,
    children,
    props: _keyProps(null, props: _fallbackProps(fallback)),
  ),
  ContextProvider(:final context, :final value, :final children) => () {
    final binding = currentReactRuntime.binding;
    if (binding is! JsBinding) {
      throw UnsupportedError(
        'Context providers require the JavaScript React binding.',
      );
    }
    final props = JSObject();
    props.setProperty('value'.toJS, binding.encodeHookValue(value));
    return _createReactElement(
      binding.contextObject(context),
      children,
      props: props,
    );
  }(),
  Portal() => throw UnsupportedError(
    'Portals have no server container and are not supported during SSR.',
  ),
  ErrorBoundary(:final children, :final fallback, :final onError) =>
    _createReactElement(
      _getErrorBoundary(),
      children,
      props: _errorBoundaryProps(fallback, onError),
    ),
  Empty() => null,
  ReactNode() => throw UnsupportedError('Unknown ReactNode implementation.'),
};

JSAny _expandForeignComponent(
  String name,
  Map<String, Object?> props,
  List<ReactNode> children, {
  String? key,
}) {
  final component = _resolveForeignComponent(name.toJS);
  if (component == null) {
    throw ArgumentError('Foreign React component "$name" is not registered');
  }
  final jsProps = _intrinsicPropsToJS(props, key: key);
  final jsChildren = children.map(_expandTree).whereType<JSAny>().toList();
  return _react.callMethod(
        'createElement'.toJS,
        component,
        jsProps,
        jsChildren.toJS,
      )
      as JSAny;
}

JSAny _expandLazy(LazyNode<Object?> node) {
  final component = _lazyComponents.putIfAbsent(node.load, () {
    final loadJS = (() {
      return node.load().then((builder) {
        JSAny? loaded(JSObject props) {
          final raw = props.getProperty('__dartLazy'.toJS);
          if (raw == null || !raw.isA<JSBoxedDartObject>()) {
            throw StateError('Missing lazy component payload.');
          }
          final payload = (raw as JSBoxedDartObject).toDart;
          if (payload is! LazyNode<Object?>) {
            throw StateError('Invalid lazy component payload.');
          }
          return toReactJS(payload.buildWith(builder));
        }

        final module = JSObject();
        module.setProperty('default'.toJS, loaded.toJS);
        return module;
      }).toJS;
    }).toJS;
    return _react.callMethod('lazy'.toJS, loadJS) as JSFunction;
  });
  final props = JSObject();
  props.setProperty('__dartLazy'.toJS, node.toJSBox);
  return _react.callMethod('createElement'.toJS, component, props) as JSAny;
}

JSAny _expandForwardRef(ForwardRefNode<Object?, Object?> node) {
  final component = _forwardRefComponents.putIfAbsent(node.render, () {
    JSAny? wrapper(JSObject props, JSAny? jsRef) {
      final raw = props.getProperty('__dartForwardRef'.toJS);
      if (raw == null || !raw.isA<JSBoxedDartObject>()) {
        throw StateError('Missing forwarded-ref payload.');
      }
      final payload = (raw as JSBoxedDartObject).toDart;
      if (payload is! ForwardRefNode<Object?, Object?>) {
        throw StateError('Invalid forwarded-ref payload.');
      }
      final ref = payload.ref ?? ReactRef<Object?>();
      return toReactJS(payload.buildWithRef(ref));
    }

    final renderJS = wrapper.toJS;
    return _react.callMethod('forwardRef'.toJS, renderJS) as JSFunction;
  });
  final props = JSObject();
  props.setProperty('__dartForwardRef'.toJS, node.toJSBox);
  return _react.callMethod('createElement'.toJS, component, props) as JSAny;
}

JSObject _errorBoundaryProps(
  ReactNode fallback,
  void Function(Object error, StackTrace stack)? onError,
) {
  final props = JSObject();
  final expanded = _expandTree(fallback);
  if (expanded != null) props.setProperty('fallback'.toJS, expanded);
  if (onError != null) {
    final report = ((JSAny? error, JSAny? info) {
      onError(error ?? 'Unknown React error', StackTrace.current);
    }).toJS;
    props.setProperty('onError'.toJS, report);
  }
  return props;
}

JSAny? _expandMemoized(
  ReactNode child,
  bool Function(Object? previous, Object? next)? arePropsEqual,
) => switch (child) {
  Component(:var id, :var props, :var children, :var key) => () {
    final entry = ReactRegistry.lookup(id.value)!;
    final memoType = _memoizedComponent(id.value, entry, arePropsEqual);
    return _createReactElement(
      memoType,
      children,
      props: _keyProps(key, props: entry.toJS(props)),
    );
  }(),
  ForeignComponent(:var name, :var props, :var children, :var key) => () {
    final component = _resolveForeignComponent(name.toJS);
    if (component == null) {
      throw ArgumentError('Foreign React component "$name" is not registered');
    }
    final memoType = _memoizedForeignComponent(name, component as JSFunction);
    return _createReactElement(
      memoType,
      children,
      props: _intrinsicPropsToJS(props, key: key),
    );
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
          return arePropsEqual(entry.fromJS(previous), entry.fromJS(next)).toJS;
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

JSAny _createReactElement(
  JSAny type,
  List<ReactNode> children, {
  JSObject? props,
}) {
  final jsChildren = children.map(_expandTree).whereType<JSAny>().toList();
  if (jsChildren.isEmpty) {
    return _react.callMethod('createElement'.toJS, type, props ?? JSObject())
        as JSAny;
  }
  return _react.callMethod(
        'createElement'.toJS,
        type,
        props ?? JSObject(),
        jsChildren.toJS,
      )
      as JSAny;
}

JSObject _fallbackProps(ReactNode fallback) {
  final props = JSObject();
  final expanded = _expandTree(fallback);
  if (expanded != null) props.setProperty('fallback'.toJS, expanded);
  return props;
}

JSAny _createHostElement(
  String type,
  Object? props,
  List<ReactNode> children, {
  String? key,
}) {
  final jsProps = _intrinsicPropsToJS(props as Map<String, Object?>, key: key);
  final jsChildren = children.map(_expandTree).whereType<JSAny>().toList();
  if (jsChildren.isEmpty) {
    return _react.callMethod('createElement'.toJS, type.toJS, jsProps) as JSAny;
  }
  return _react.callMethod(
        'createElement'.toJS,
        type.toJS,
        jsProps,
        jsChildren.toJS,
      )
      as JSAny;
}

JSAny _createFragment(List<ReactNode> children, {String? key}) {
  final jsChildren = children.map(_expandTree).whereType<JSAny>().toList();
  if (jsChildren.isEmpty) {
    return _react.callMethod('createElement'.toJS, _fragment, _keyProps(key))
        as JSAny;
  }
  return _react.callMethod(
        'createElement'.toJS,
        _fragment,
        _keyProps(key),
        jsChildren.toJS,
      )
      as JSAny;
}

/// Expands a Component node by creating `React.createElement(registeredFn,
/// toJSProps)` so that React renders the component with proper hooks
/// context.  The component's generated wrapper calls
/// [currentReactRuntime.renderer.render] which invokes [_expandTree] for the
/// returned intrinsic tree — not for sub-components (the React runtime
/// handles those via createElement).
JSAny _expandComponent(
  ComponentId id,
  Object? props,
  List<ReactNode> children, {
  String? key,
}) {
  final e = ReactRegistry.lookup(id.value);
  if (e == null) {
    throw ArgumentError('Component "${id.value}" not registered for SSR');
  }
  // Create React.createElement(comp, toJSProps) so React sets up
  // hooks context and calls the wrapper internally.
  final jsProps = _keyProps(key, props: e.toJS(props));
  final childrenJS = children.map(_expandTree).whereType<JSAny>().toList().toJS;
  return _react.callMethod('createElement'.toJS, e.comp, jsProps, childrenJS)
      as JSAny;
}

JSObject _keyProps(String? key, {JSAny? props}) {
  final object = props != null && props.isA<JSObject>()
      ? props as JSObject
      : JSObject();
  if (key != null) object.setProperty('key'.toJS, key.toJS);
  return object;
}

JSObject _intrinsicPropsToJS(Map<String, Object?> m, {String? key}) {
  final o = JSObject();
  m.forEach((k, v) {
    if (v is ReactEventProp || v is ReactRefProp) return;
    if (v != null) o.setProperty(k.toJS, toReactJS(v)!);
  });
  if (key != null) o.setProperty('key'.toJS, key.toJS);
  return o;
}

/// Renders [node] to an HTML string using `ReactDOMServer.renderToString`.
///
/// Sets up a server runtime and expands the [ReactNode] tree into JS React
/// elements before serialization.
String renderToString(ReactNode node) {
  final result = runWithReactRuntime(
    ReactRuntime(
      target: ReactRenderTarget.server,
      capabilities: ReactRuntimeCapabilities.server,
      binding: JsBinding(),
      renderer: JsRenderer(),
    ),
    () {
      final expanded = _expandTree(node)!;
      return _reactDomServer.callMethod('renderToString'.toJS, expanded);
    },
  );
  return (result as JSString?)?.toDart ?? '';
}

/// Registers a handler that receives a request map and returns a [ReactNode]
/// to render.
///
/// The handler is invoked within a scoped server runtime so that hooks and
/// other renderer-specific APIs are available.
void registerServerHandler(
  ReactNode Function(Map<String, dynamic> request) handler,
) {
  registerGlobalRenderer((id, props) => handler({'id': id, 'props': props}));
}

/// JSON-stringifies a JSObject via `JSON.stringify`.
String _jsonStringify(JSObject obj) =>
    (_json.callMethod('stringify'.toJS, obj) as JSString).toDart;

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

@JS('globalThis.__reactDartGetErrorBoundary')
external JSFunction _getErrorBoundary();

@JS('ReactDOMServer')
external JSObject get _reactDomServer;

@JS('globalThis')
external JSObject get _globalThis;

@JS('JSON')
external JSObject get _json;
