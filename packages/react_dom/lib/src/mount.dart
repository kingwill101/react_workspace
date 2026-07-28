import 'dart:convert';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'package:react/react.dart';
import 'package:react_js/react_js.dart';

void initReact() => ReactInternal.init(binding: JsBinding(), renderer: JsRenderer());

JSObject getRoot(String id) => _getById(id)!;

bool hasSSRContent(JSObject root) =>
    (root.getProperty('innerHTML'.toJS) as JSString).toDart.trim().isNotEmpty;

Map<String, dynamic> getInitialProps() {
  final el = _getById('__props');
  if (el == null) return {};
  final txt = el.getProperty('textContent'.toJS) as JSString;
  if (txt.toDart.trim().isEmpty) return {};
  final parsed = jsonDecode(txt.toDart);
  return (parsed as Map<String, dynamic>?) ?? {};
}

void mount(JSObject root, ReactNode node) =>
    _createRoot(root).callMethod(
        'render'.toJS, ReactInternal.renderer.render(node) as JSAny);

void hydrate(JSObject root, ReactNode node) =>
    _hydrateRoot(root, ReactInternal.renderer.render(node) as JSAny);

@JS('document.getElementById')
external JSObject? _getById(String id);

@JS('ReactDOM.createRoot')
external JSObject _createRoot(JSObject e);

@JS('ReactDOM.hydrateRoot')
external void _hydrateRoot(JSObject e, JSAny n);
