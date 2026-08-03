import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'package:react_js/react_js.dart';
import 'riverpod_demo.dart' as impl;
import 'riverpod_demo.react.dart' show idRiverpodDemo;

JSObject _RiverpodDemo_toJS(({bool hidden}) props) {
  final o = JSObject();
  o.setProperty('hidden'.toJS, props.hidden.toJS);
  return o;
}

({bool hidden}) _RiverpodDemo_fromJS(JSObject js) {
final hidden = requiredJSBool(js, "hidden", component: "RiverpodDemo");
  return (hidden: hidden);
}

final JSFunction $RiverpodDemo = (() {
  JSAny? wrapper(JSObject props) {
    final dartProps = _RiverpodDemo_fromJS(props);
    return toReactJS(impl.RiverpodDemo(dartProps));
  }
  return wrapper.toJS;
})() as JSFunction;
void registerRiverpodDemo(){
  ReactRegistry.register(idRiverpodDemo.value, $RiverpodDemo,
      toJS: (p) => _RiverpodDemo_toJS(p as ({bool hidden})),
      fromJS: (js) => _RiverpodDemo_fromJS(js));
}

