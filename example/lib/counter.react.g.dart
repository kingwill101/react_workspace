import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'package:react_js/react_js.dart';
import 'counter.dart' as impl;
import 'counter.react.dart' show idCounter;

JSObject _Counter_toJS(({int initialCount, void Function(int)? onChange, String? subtitle, String title}) props){
  final o = JSObject();
  o.setProperty('initialCount'.toJS, props.initialCount.toJS);
o.setProperty('onChange'.toJS, (props.onChange == null ? null : ((int a0) { (props.onChange!)(a0); }).toJS as JSAny));
if (props.subtitle != null) o.setProperty('subtitle'.toJS, props.subtitle!.toJS);
o.setProperty('title'.toJS, props.title.toJS);
  return o;
}
({int initialCount, void Function(int)? onChange, String? subtitle, String title}) _Counter_fromJS(JSObject js){
  final initialCount = requiredJSInt(js, "initialCount", component: "initialCount");
final onChange = (int a0) {
final _raw = js.getProperty('onChange'.toJS);
  if (_raw == null || _raw.isUndefined) return null;
  final _fn = _raw as JSFunction;
  _fn.callAsFunction(null, a0.toJS);
};
final subtitle = nullableJSString(js, "subtitle");
final title = requiredJSString(js, "title", component: "title");
  return (initialCount: initialCount, onChange: onChange, subtitle: subtitle, title: title);
}
final JSFunction $Counter = (() {
  JSAny? wrapper(JSObject props){
    final dartProps = _Counter_fromJS(props);
    return toReactJS(impl.Counter(dartProps));
  }
  return wrapper.toJS;
})() as JSFunction;
void registerCounter(){
  ReactRegistry.register(idCounter.value, $Counter,
      toJS: (p) => _Counter_toJS(p as ({int initialCount, void Function(int)? onChange, String? subtitle, String title})),
      fromJS: (js) => _Counter_fromJS(js));
}