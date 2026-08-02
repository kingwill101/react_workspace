import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'package:react_js/react_js.dart';
import 'route_content.dart' as impl;
import 'route_content.react.dart' show idRouteContent;

JSObject _RouteContent_toJS(({bool hidden}) props) {
  final o = JSObject();
  o.setProperty('hidden'.toJS, props.hidden.toJS);
  return o;
}

({bool hidden}) _RouteContent_fromJS(JSObject js) {
final hidden = requiredJSBool(js, "hidden", component: "RouteContent");
  return (hidden: hidden);
}

final JSFunction $RouteContent = (() {
  JSAny? wrapper(JSObject props) {
    final dartProps = _RouteContent_fromJS(props);
    return toReactJS(impl.RouteContent(dartProps));
  }
  return wrapper.toJS;
})() as JSFunction;
void registerRouteContent(){
  ReactRegistry.register(idRouteContent.value, $RouteContent,
      toJS: (p) => _RouteContent_toJS(p as ({bool hidden})),
      fromJS: (js) => _RouteContent_fromJS(js));
}

