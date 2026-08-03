import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'package:react_js/react_js.dart';
import 'about_page.dart' as impl;
import 'about_page.react.dart' show idAboutPage;

JSObject _AboutPage_toJS(({String title}) props) {
  final o = JSObject();
  o.setProperty('title'.toJS, props.title.toJS);
  return o;
}

({String title}) _AboutPage_fromJS(JSObject js) {
final title = requiredJSString(js, "title", component: "AboutPage");
  return (title: title);
}

final JSFunction $AboutPage = (() {
  JSAny? wrapper(JSObject props) {
    final dartProps = _AboutPage_fromJS(props);
    return toReactJS(impl.AboutPage(dartProps));
  }
  return wrapper.toJS;
})() as JSFunction;
void registerAboutPage(){
  ReactRegistry.register(idAboutPage.value, $AboutPage,
      toJS: (p) => _AboutPage_toJS(p as ({String title})),
      fromJS: (js) => _AboutPage_fromJS(js));
}

