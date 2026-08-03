import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'package:react_js/react_js.dart';
import 'home_page.dart' as impl;
import 'home_page.react.dart' show idHomePage;

JSObject _HomePage_toJS(({String title}) props) {
  final o = JSObject();
  o.setProperty('title'.toJS, props.title.toJS);
  return o;
}

({String title}) _HomePage_fromJS(JSObject js) {
final title = requiredJSString(js, "title", component: "HomePage");
  return (title: title);
}

final JSFunction $HomePage = (() {
  JSAny? wrapper(JSObject props) {
    final dartProps = _HomePage_fromJS(props);
    return toReactJS(impl.HomePage(dartProps));
  }
  return wrapper.toJS;
})() as JSFunction;
void registerHomePage(){
  ReactRegistry.register(idHomePage.value, $HomePage,
      toJS: (p) => _HomePage_toJS(p as ({String title})),
      fromJS: (js) => _HomePage_fromJS(js));
}

