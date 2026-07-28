import 'dart:convert';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'package:react_js/react_js.dart';
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
    ReactNode Function(String id, Map<String, dynamic> props) factory) {
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
      HostNode(:var type, :var props, :var children) =>
        _react.callMethod('createElement'.toJS, type.name.toJS,
            _intrinsicPropsToJS(props as Map<String, Object?>),
            children.map(_expandTree).whereType<JSAny>().toList().toJS) as JSAny,
      Component(:var id, :var props, :var children) =>
        _expandComponent(id, props, children),
      Text(:var value) => value.toJS,
      Fragment(:var children) =>
        _react.callMethod('createElement'.toJS, _fragment, null,
            children.map(_expandTree).whereType<JSAny>().toList().toJS) as JSAny,
      Empty() => null,
    };

/// Expands a Component node by creating `React.createElement(registeredFn,
/// toJSProps)` so that React renders the component with proper hooks
/// context.  The component's generated wrapper calls
/// [currentReactRuntime.renderer.render] which invokes [_expandTree] for the
/// returned intrinsic tree — not for sub-components (the React runtime
/// handles those via createElement).
JSAny _expandComponent(ComponentId id, Object? props, List<ReactNode> children) {
  final e = ReactRegistry.lookup(id.value);
  if (e == null) {
    throw ArgumentError('Component "${id.value}" not registered for SSR');
  }
  // Create React.createElement(comp, toJSProps) so React sets up
  // hooks context and calls the wrapper internally.
  final jsProps = e.toJS(props);
  final childrenJS =
      children.map(_expandTree).whereType<JSAny>().toList().toJS;
  return _react.callMethod('createElement'.toJS, e.comp, jsProps,
      childrenJS) as JSAny;
}

JSObject _intrinsicPropsToJS(Map<String, Object?> m) {
  final o = JSObject();
  m.forEach((k, v) {
    if (v is ReactEventProp || v is ReactRefProp) return;
    if (v != null) o.setProperty(k.toJS, toReactJS(v)!);
  });
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
    ReactNode Function(Map<String, dynamic> request) handler) {
  registerGlobalRenderer((id, props) => handler({'id': id, 'props': props}));
}

/// JSON-stringifies a JSObject via `JSON.stringify`.
String _jsonStringify(JSObject obj) =>
    (_json.callMethod('stringify'.toJS, obj) as JSString).toDart;

@JS('React')
external JSObject get _react;

@JS('React.Fragment')
external JSAny get _fragment;

@JS('ReactDOMServer')
external JSObject get _reactDomServer;

@JS('globalThis')
external JSObject get _globalThis;

@JS('JSON')
external JSObject get _json;