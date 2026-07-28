import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'package:react_js/react_js.dart';
import 'app.dart' as impl;
import 'app.react.dart' show idApp;

JSObject _App_toJS(({String title}) props){
  final o = JSObject();
  o.setProperty('title'.toJS, props.title.toJS);
  return o;
}
({String title}) _App_fromJS(JSObject js){
  final title = (js.getProperty('title'.toJS) as JSString).toDart;
  return (title: title);
}
final JSFunction $App = (() {
  JSObject wrapper(JSObject p){
    final dartProps = _App_fromJS(p);
    final tree = impl.App(dartProps);
    return toReactJS(tree) as JSObject;
  }
  return wrapper.toJS;
})() as JSFunction;
void registerApp(){
  ReactRegistry.register(idApp.value, $App,
      toJS: (p) => _App_toJS(p as ({String title})),
      fromJS: (js) => _App_fromJS(js));
}