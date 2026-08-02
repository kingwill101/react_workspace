import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'package:react_js/react_js.dart';
import 'router_demo.dart' as impl;
import 'router_demo.react.dart' show idRouterDemo;

JSObject _RouterDemo_toJS(({String path}) props) {
  final o = JSObject();
  o.setProperty('path'.toJS, props.path.toJS);
  return o;
}

({String path}) _RouterDemo_fromJS(JSObject js) {
final path = requiredJSString(js, "path", component: "RouterDemo");
  return (path: path);
}

final JSFunction $RouterDemo = (() {
  JSAny? wrapper(JSObject props) {
    final dartProps = _RouterDemo_fromJS(props);
    return toReactJS(impl.RouterDemo(dartProps));
  }
  return wrapper.toJS;
})() as JSFunction;
void registerRouterDemo(){
  ReactRegistry.register(idRouterDemo.value, $RouterDemo,
      toJS: (p) => _RouterDemo_toJS(p as ({String path})),
      fromJS: (js) => _RouterDemo_fromJS(js));
}

