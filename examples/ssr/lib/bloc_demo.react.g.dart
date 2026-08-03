import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'package:react_js/react_js.dart';
import 'bloc_demo.dart' as impl;
import 'bloc_demo.react.dart' show idBlocDemo;

JSObject _BlocDemo_toJS(({bool hidden}) props) {
  final o = JSObject();
  o.setProperty('hidden'.toJS, props.hidden.toJS);
  return o;
}

({bool hidden}) _BlocDemo_fromJS(JSObject js) {
final hidden = requiredJSBool(js, "hidden", component: "BlocDemo");
  return (hidden: hidden);
}

final JSFunction $BlocDemo = (() {
  JSAny? wrapper(JSObject props) {
    final dartProps = _BlocDemo_fromJS(props);
    return toReactJS(impl.BlocDemo(dartProps));
  }
  return wrapper.toJS;
})() as JSFunction;
void registerBlocDemo(){
  ReactRegistry.register(idBlocDemo.value, $BlocDemo,
      toJS: (p) => _BlocDemo_toJS(p as ({bool hidden})),
      fromJS: (js) => _BlocDemo_fromJS(js));
}

