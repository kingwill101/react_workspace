import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'package:react_js/react_js.dart';
import 'route_item.dart' as impl;
import 'route_item.react.dart' show idItemDetail;

JSObject _ItemDetail_toJS(({bool hidden}) props) {
  final o = JSObject();
  o.setProperty('hidden'.toJS, props.hidden.toJS);
  return o;
}

({bool hidden}) _ItemDetail_fromJS(JSObject js) {
final hidden = requiredJSBool(js, "hidden", component: "ItemDetail");
  return (hidden: hidden);
}

final JSFunction $ItemDetail = (() {
  JSAny? wrapper(JSObject props) {
    final dartProps = _ItemDetail_fromJS(props);
    return toReactJS(impl.ItemDetail(dartProps));
  }
  return wrapper.toJS;
})() as JSFunction;
void registerItemDetail(){
  ReactRegistry.register(idItemDetail.value, $ItemDetail,
      toJS: (p) => _ItemDetail_toJS(p as ({bool hidden})),
      fromJS: (js) => _ItemDetail_fromJS(js));
}

