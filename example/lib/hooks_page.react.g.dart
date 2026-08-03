import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'package:react_js/react_js.dart';
import 'hooks_page.dart' as impl;
import 'hooks_page.react.dart' show idHooksPage;

JSObject _HooksPage_toJS(({String title}) props) {
  final o = JSObject();
  o.setProperty('title'.toJS, props.title.toJS);
  return o;
}

({String title}) _HooksPage_fromJS(JSObject js) {
final title = requiredJSString(js, "title", component: "HooksPage");
  return (title: title);
}

final JSFunction $HooksPage = (() {
  JSAny? wrapper(JSObject props) {
    final dartProps = _HooksPage_fromJS(props);
    return toReactJS(impl.HooksPage(dartProps));
  }
  return wrapper.toJS;
})() as JSFunction;
void registerHooksPage(){
  ReactRegistry.register(idHooksPage.value, $HooksPage,
      toJS: (p) => _HooksPage_toJS(p as ({String title})),
      fromJS: (js) => _HooksPage_fromJS(js));
}

