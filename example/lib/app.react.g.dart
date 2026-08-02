import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'package:react_js/react_js.dart';
import 'app.dart' as impl;
import 'app.react.dart' show idApp;

JSObject _App_toJS(({String path, String title}) props) {
  final o = JSObject();
  o.setProperty('path'.toJS, props.path.toJS);
  o.setProperty('title'.toJS, props.title.toJS);
  return o;
}

({String path, String title}) _App_fromJS(JSObject js) {
final path = requiredJSString(js, "path", component: "App");
final title = requiredJSString(js, "title", component: "App");
  return (path: path, title: title);
}

final JSFunction $App = (() {
  JSAny? wrapper(JSObject props) {
    final dartProps = _App_fromJS(props);
    return toReactJS(impl.App(dartProps));
  }
  return wrapper.toJS;
})() as JSFunction;
void registerApp(){
  ReactRegistry.register(idApp.value, $App,
      toJS: (p) => _App_toJS(p as ({String path, String title})),
      fromJS: (js) => _App_fromJS(js));
}

