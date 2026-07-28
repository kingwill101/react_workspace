import 'dart:js_interop';
import 'package:react/react.dart';
import 'app.dart' as impl;
import 'app.react.dart' show idApp;
@JS()
extension type AppPropsJS._(JSObject _) implements JSObject {
  external JSAny get title;
}
({String title}) _App_fromJS(AppPropsJS js) => (
title: js.title as String
);
final JSFunction $App = (() {
  JSObject wrapper(JSObject p) {
    final props = _App_fromJS(p as AppPropsJS);
    final tree = impl.App(props);
    return ReactInternal.renderer.render(tree) as JSObject;
  }
  return wrapper.toJS;
})() as JSFunction;
void registerApp() => ReactRegistry.register(idApp.value, $App);