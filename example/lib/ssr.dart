import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'package:react/react.dart';
import 'package:react_js/react_js.dart';
import 'app.dart';
import 'avatar.dart';
import 'app.react.g.dart' as app;
import 'avatar.react.g.dart' as av;
import 'badge.react.g.dart' as badge;

void main() {
  ReactInternal.init(binding: JsBinding(), renderer: JsRenderer());
  app.registerApp();
  av.registerAvatar();
  badge.registerBadge();

  globalThis.setProperty(
    '__REACT_RENDER__'.toJS,
    _renderHandler.toJS,
  );
}

@JS('globalThis')
external JSObject get globalThis;

JSAny? _renderHandler(JSObject req) {
  final id = (req.getProperty('id'.toJS) as JSString).toDart;
  final propsObj = req.getProperty('props'.toJS) as JSObject;
  final node = switch (id) {
    'package:react_workspace/example/lib/app.dart#App' => App(
        (title: (propsObj.getProperty('title'.toJS) as JSString).toDart)),
    'package:react_workspace/example/lib/avatar.dart#Avatar' => Avatar((
      src: (propsObj.getProperty('src'.toJS) as JSString).toDart,
      size: (propsObj.getProperty('size'.toJS) as JSNumber).toDartInt
    )),
    _ => const Empty(),
  };
  return ReactInternal.renderer.render(node);
}
