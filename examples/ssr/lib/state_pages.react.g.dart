import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'package:react_js/react_js.dart';
import 'state_pages.dart' as impl;
import 'state_pages.react.dart' show idStateSection;
import 'state_pages.react.dart' show idStateOverview;
import 'state_pages.react.dart' show idZustandPage;
import 'state_pages.react.dart' show idRiverpodPage;
import 'state_pages.react.dart' show idBlocPage;
import 'state_pages.react.dart' show idTodosPage;

JSObject _StateSection_toJS(({String title}) props) {
  final o = JSObject();
  o.setProperty('title'.toJS, props.title.toJS);
  return o;
}

({String title}) _StateSection_fromJS(JSObject js) {
final title = requiredJSString(js, "title", component: "StateSection");
  return (title: title);
}

final JSFunction $StateSection = (() {
  JSAny? wrapper(JSObject props) {
    final dartProps = _StateSection_fromJS(props);
    return toReactJS(impl.StateSection(dartProps));
  }
  return wrapper.toJS;
})() as JSFunction;
void registerStateSection(){
  ReactRegistry.register(idStateSection.value, $StateSection,
      toJS: (p) => _StateSection_toJS(p as ({String title})),
      fromJS: (js) => _StateSection_fromJS(js));
}

JSObject _StateOverview_toJS(({String title}) props) {
  final o = JSObject();
  o.setProperty('title'.toJS, props.title.toJS);
  return o;
}

({String title}) _StateOverview_fromJS(JSObject js) {
final title = requiredJSString(js, "title", component: "StateOverview");
  return (title: title);
}

final JSFunction $StateOverview = (() {
  JSAny? wrapper(JSObject props) {
    final dartProps = _StateOverview_fromJS(props);
    return toReactJS(impl.StateOverview(dartProps));
  }
  return wrapper.toJS;
})() as JSFunction;
void registerStateOverview(){
  ReactRegistry.register(idStateOverview.value, $StateOverview,
      toJS: (p) => _StateOverview_toJS(p as ({String title})),
      fromJS: (js) => _StateOverview_fromJS(js));
}

JSObject _ZustandPage_toJS(({String title}) props) {
  final o = JSObject();
  o.setProperty('title'.toJS, props.title.toJS);
  return o;
}

({String title}) _ZustandPage_fromJS(JSObject js) {
final title = requiredJSString(js, "title", component: "ZustandPage");
  return (title: title);
}

final JSFunction $ZustandPage = (() {
  JSAny? wrapper(JSObject props) {
    final dartProps = _ZustandPage_fromJS(props);
    return toReactJS(impl.ZustandPage(dartProps));
  }
  return wrapper.toJS;
})() as JSFunction;
void registerZustandPage(){
  ReactRegistry.register(idZustandPage.value, $ZustandPage,
      toJS: (p) => _ZustandPage_toJS(p as ({String title})),
      fromJS: (js) => _ZustandPage_fromJS(js));
}

JSObject _RiverpodPage_toJS(({String title}) props) {
  final o = JSObject();
  o.setProperty('title'.toJS, props.title.toJS);
  return o;
}

({String title}) _RiverpodPage_fromJS(JSObject js) {
final title = requiredJSString(js, "title", component: "RiverpodPage");
  return (title: title);
}

final JSFunction $RiverpodPage = (() {
  JSAny? wrapper(JSObject props) {
    final dartProps = _RiverpodPage_fromJS(props);
    return toReactJS(impl.RiverpodPage(dartProps));
  }
  return wrapper.toJS;
})() as JSFunction;
void registerRiverpodPage(){
  ReactRegistry.register(idRiverpodPage.value, $RiverpodPage,
      toJS: (p) => _RiverpodPage_toJS(p as ({String title})),
      fromJS: (js) => _RiverpodPage_fromJS(js));
}

JSObject _BlocPage_toJS(({String title}) props) {
  final o = JSObject();
  o.setProperty('title'.toJS, props.title.toJS);
  return o;
}

({String title}) _BlocPage_fromJS(JSObject js) {
final title = requiredJSString(js, "title", component: "BlocPage");
  return (title: title);
}

final JSFunction $BlocPage = (() {
  JSAny? wrapper(JSObject props) {
    final dartProps = _BlocPage_fromJS(props);
    return toReactJS(impl.BlocPage(dartProps));
  }
  return wrapper.toJS;
})() as JSFunction;
void registerBlocPage(){
  ReactRegistry.register(idBlocPage.value, $BlocPage,
      toJS: (p) => _BlocPage_toJS(p as ({String title})),
      fromJS: (js) => _BlocPage_fromJS(js));
}

JSObject _TodosPage_toJS(({String title}) props) {
  final o = JSObject();
  o.setProperty('title'.toJS, props.title.toJS);
  return o;
}

({String title}) _TodosPage_fromJS(JSObject js) {
final title = requiredJSString(js, "title", component: "TodosPage");
  return (title: title);
}

final JSFunction $TodosPage = (() {
  JSAny? wrapper(JSObject props) {
    final dartProps = _TodosPage_fromJS(props);
    return toReactJS(impl.TodosPage(dartProps));
  }
  return wrapper.toJS;
})() as JSFunction;
void registerTodosPage(){
  ReactRegistry.register(idTodosPage.value, $TodosPage,
      toJS: (p) => _TodosPage_toJS(p as ({String title})),
      fromJS: (js) => _TodosPage_fromJS(js));
}

