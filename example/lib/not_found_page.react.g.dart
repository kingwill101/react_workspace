import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'package:react_js/react_js.dart';
import 'not_found_page.dart' as impl;
import 'not_found_page.react.dart' show idNotFoundPage;

JSObject _NotFoundPage_toJS(({String title}) props) {
  final o = JSObject();
  o.setProperty('title'.toJS, props.title.toJS);
  return o;
}

({String title}) _NotFoundPage_fromJS(JSObject js) {
final title = requiredJSString(js, "title", component: "NotFoundPage");
  return (title: title);
}

final JSFunction $NotFoundPage = (() {
  JSAny? wrapper(JSObject props) {
    final dartProps = _NotFoundPage_fromJS(props);
    return toReactJS(impl.NotFoundPage(dartProps));
  }
  return wrapper.toJS;
})() as JSFunction;
void registerNotFoundPage(){
  ReactRegistry.register(idNotFoundPage.value, $NotFoundPage,
      toJS: (p) => _NotFoundPage_toJS(p as ({String title})),
      fromJS: (js) => _NotFoundPage_fromJS(js));
}

