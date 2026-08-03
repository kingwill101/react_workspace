import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'package:react_js/react_js.dart';
import 'zustand_demo.dart' as impl;
import 'zustand_demo.react.dart' show idZustandDemo;

JSObject _ZustandDemo_toJS(({bool hidden}) props) {
  final o = JSObject();
  o.setProperty('hidden'.toJS, props.hidden.toJS);
  return o;
}

({bool hidden}) _ZustandDemo_fromJS(JSObject js) {
final hidden = requiredJSBool(js, "hidden", component: "ZustandDemo");
  return (hidden: hidden);
}

final JSFunction $ZustandDemo = (() {
  JSAny? wrapper(JSObject props) {
    final dartProps = _ZustandDemo_fromJS(props);
    return toReactJS(impl.ZustandDemo(dartProps));
  }
  return wrapper.toJS;
})() as JSFunction;
void registerZustandDemo(){
  ReactRegistry.register(idZustandDemo.value, $ZustandDemo,
      toJS: (p) => _ZustandDemo_toJS(p as ({bool hidden})),
      fromJS: (js) => _ZustandDemo_fromJS(js));
}

