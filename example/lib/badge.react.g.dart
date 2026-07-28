import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'package:react_js/react_js.dart';
import 'badge.dart' as impl;
import 'badge.react.dart' show idBadge;

JSObject _Badge_toJS(({String label}) props){
  final o = JSObject();
  o.setProperty('label'.toJS, props.label.toJS);
  return o;
}
({String label}) _Badge_fromJS(JSObject js){
  final label = requiredJSString(js, "label", component: "Badge");
  return (label: label);
}
final JSFunction $Badge = (() {
  JSAny? wrapper(JSObject props){
    final dartProps = _Badge_fromJS(props);
    return toReactJS(impl.Badge(dartProps));
  }
  return wrapper.toJS;
})() as JSFunction;
void registerBadge(){
  ReactRegistry.register(idBadge.value, $Badge,
      toJS: (p) => _Badge_toJS(p as ({String label})),
      fromJS: (js) => _Badge_fromJS(js));
}