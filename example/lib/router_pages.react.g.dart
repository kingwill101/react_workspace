import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'package:react_js/react_js.dart';
import 'router_pages.dart' as impl;
import 'router_pages.react.dart' show idRouterSection;
import 'router_pages.react.dart' show idRouterOverview;
import 'router_pages.react.dart' show idItemPage;
import 'router_pages.react.dart' show idSearchDemo;
import 'router_pages.react.dart' show idRedirectDemo;

JSObject _RouterSection_toJS(({String title}) props) {
  final o = JSObject();
  o.setProperty('title'.toJS, props.title.toJS);
  return o;
}

({String title}) _RouterSection_fromJS(JSObject js) {
final title = requiredJSString(js, "title", component: "RouterSection");
  return (title: title);
}

final JSFunction $RouterSection = (() {
  JSAny? wrapper(JSObject props) {
    final dartProps = _RouterSection_fromJS(props);
    return toReactJS(impl.RouterSection(dartProps));
  }
  return wrapper.toJS;
})() as JSFunction;
void registerRouterSection(){
  ReactRegistry.register(idRouterSection.value, $RouterSection,
      toJS: (p) => _RouterSection_toJS(p as ({String title})),
      fromJS: (js) => _RouterSection_fromJS(js));
}

JSObject _RouterOverview_toJS(({String title}) props) {
  final o = JSObject();
  o.setProperty('title'.toJS, props.title.toJS);
  return o;
}

({String title}) _RouterOverview_fromJS(JSObject js) {
final title = requiredJSString(js, "title", component: "RouterOverview");
  return (title: title);
}

final JSFunction $RouterOverview = (() {
  JSAny? wrapper(JSObject props) {
    final dartProps = _RouterOverview_fromJS(props);
    return toReactJS(impl.RouterOverview(dartProps));
  }
  return wrapper.toJS;
})() as JSFunction;
void registerRouterOverview(){
  ReactRegistry.register(idRouterOverview.value, $RouterOverview,
      toJS: (p) => _RouterOverview_toJS(p as ({String title})),
      fromJS: (js) => _RouterOverview_fromJS(js));
}

JSObject _ItemPage_toJS(({String title}) props) {
  final o = JSObject();
  o.setProperty('title'.toJS, props.title.toJS);
  return o;
}

({String title}) _ItemPage_fromJS(JSObject js) {
final title = requiredJSString(js, "title", component: "ItemPage");
  return (title: title);
}

final JSFunction $ItemPage = (() {
  JSAny? wrapper(JSObject props) {
    final dartProps = _ItemPage_fromJS(props);
    return toReactJS(impl.ItemPage(dartProps));
  }
  return wrapper.toJS;
})() as JSFunction;
void registerItemPage(){
  ReactRegistry.register(idItemPage.value, $ItemPage,
      toJS: (p) => _ItemPage_toJS(p as ({String title})),
      fromJS: (js) => _ItemPage_fromJS(js));
}

JSObject _SearchDemo_toJS(({String title}) props) {
  final o = JSObject();
  o.setProperty('title'.toJS, props.title.toJS);
  return o;
}

({String title}) _SearchDemo_fromJS(JSObject js) {
final title = requiredJSString(js, "title", component: "SearchDemo");
  return (title: title);
}

final JSFunction $SearchDemo = (() {
  JSAny? wrapper(JSObject props) {
    final dartProps = _SearchDemo_fromJS(props);
    return toReactJS(impl.SearchDemo(dartProps));
  }
  return wrapper.toJS;
})() as JSFunction;
void registerSearchDemo(){
  ReactRegistry.register(idSearchDemo.value, $SearchDemo,
      toJS: (p) => _SearchDemo_toJS(p as ({String title})),
      fromJS: (js) => _SearchDemo_fromJS(js));
}

JSObject _RedirectDemo_toJS(({String title}) props) {
  final o = JSObject();
  o.setProperty('title'.toJS, props.title.toJS);
  return o;
}

({String title}) _RedirectDemo_fromJS(JSObject js) {
final title = requiredJSString(js, "title", component: "RedirectDemo");
  return (title: title);
}

final JSFunction $RedirectDemo = (() {
  JSAny? wrapper(JSObject props) {
    final dartProps = _RedirectDemo_fromJS(props);
    return toReactJS(impl.RedirectDemo(dartProps));
  }
  return wrapper.toJS;
})() as JSFunction;
void registerRedirectDemo(){
  ReactRegistry.register(idRedirectDemo.value, $RedirectDemo,
      toJS: (p) => _RedirectDemo_toJS(p as ({String title})),
      fromJS: (js) => _RedirectDemo_fromJS(js));
}

