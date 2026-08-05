import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'package:react_js/react_js.dart';
import 'package:react_js/src/codec_registry.dart' show ReactCodecRegistry;
import 'analytics.dart' as impl;
import 'analytics.react.dart' show idAnalyticsPage;

JSObject _AnalyticsPage_toJS(({String? title}) props) {
  final o = JSObject();
  if (props.title != null) o.setProperty('title'.toJS, props.title!.toJS);
  return o;
}

({String? title}) _AnalyticsPage_fromJS(JSObject js) {
final title = nullableJSString(js, "title");
  return (title: title);
}

final JSFunction $AnalyticsPage = (() {
  JSAny? wrapper(JSObject props) {
    final dartProps = _AnalyticsPage_fromJS(props);
    return toReactJS(impl.AnalyticsPage(dartProps));
  }
  return wrapper.toJS;
})() as JSFunction;
void registerAnalyticsPage(){
  ReactRegistry.register(idAnalyticsPage.value, $AnalyticsPage,
      toJS: (p) => _AnalyticsPage_toJS(p as ({String? title})),
      fromJS: (js) => _AnalyticsPage_fromJS(js));
}

