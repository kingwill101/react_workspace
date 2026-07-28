import 'dart:convert';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'package:react_js/react_js.dart';

void initReact() => ReactInternal.init(binding: JsBinding(), renderer: JsRenderer());

JSObject getRoot(String id) => _getById(id)!;

bool hasSSRContent(JSObject root) =>
    (root.getProperty('innerHTML'.toJS) as JSString).toDart.trim().isNotEmpty;

/// Reads initial props from the [#__props] script tag placed by the SSR
/// worker. Returns the parsed JSON Map, or an empty Map if absent/empty.
Map<String, dynamic> getInitialProps() {
  final el = _getById('__props');
  if (el == null) return {};
  final txt = el.getProperty('textContent'.toJS) as JSString;
  final content = txt.toDart.trim();
  if (content.isEmpty) return {};
  if (content == '{{PROPS}}') return {};
  try {
    final parsed = jsonDecode(content);
    return (parsed as Map<String, dynamic>?) ?? {};
  } on Exception {
    return {};
  }
}

/// Mounts a React component into a fresh root (client-only rendering).
void mount(JSObject root, ReactNode node) =>
    _createRoot(root).callMethod(
        'render'.toJS, ReactInternal.renderer.render(node) as JSAny);

/// Hydrates SSR-rendered HTML, attaching event handlers.
/// Uses [hydrateRoot] which expects the SSR HTML to already be in [root].
void hydrate(JSObject root, ReactNode node) =>
    _hydrateRoot(root, ReactInternal.renderer.render(node) as JSAny);

@JS('document.getElementById')
external JSObject? _getById(String id);

@JS('ReactDOM.createRoot')
external JSObject _createRoot(JSObject e);

@JS('ReactDOM.hydrateRoot')
external void _hydrateRoot(JSObject e, JSAny n);