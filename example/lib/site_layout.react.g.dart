import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'package:react_js/react_js.dart';
import 'site_layout.dart' as impl;
import 'site_layout.react.dart' show idSiteLayout;

JSObject _SiteLayout_toJS(({String title}) props) {
  final o = JSObject();
  o.setProperty('title'.toJS, props.title.toJS);
  return o;
}

({String title}) _SiteLayout_fromJS(JSObject js) {
final title = requiredJSString(js, "title", component: "SiteLayout");
  return (title: title);
}

final JSFunction $SiteLayout = (() {
  JSAny? wrapper(JSObject props) {
    final dartProps = _SiteLayout_fromJS(props);
    return toReactJS(impl.SiteLayout(dartProps));
  }
  return wrapper.toJS;
})() as JSFunction;
void registerSiteLayout(){
  ReactRegistry.register(idSiteLayout.value, $SiteLayout,
      toJS: (p) => _SiteLayout_toJS(p as ({String title})),
      fromJS: (js) => _SiteLayout_fromJS(js));
}

