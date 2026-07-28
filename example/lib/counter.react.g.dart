import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'package:react_js/react_js.dart';
import 'counter.dart' as impl;
import 'counter.react.dart' show idCounter;

JSObject _Counter_toJS(({int initialCount, void Function(int)? onChange, String? subtitle, String title}) props) {
  final o = JSObject();
  o.setProperty('initialCount'.toJS, props.initialCount.toJS);
  o.setProperty('onChange'.toJS, props.onChange == null ? null : callbackToJS(ReactCallback(
  debugName: 'Counter.onChange',
  signature: const (
  positional: [
    reactInt,
  ],
  result: reactVoid,
  asynchronous: false,
),
  invoke: (arguments) {
    props.onChange!(arguments[0] as int);
return null;
  },
)));
  if (props.subtitle != null) o.setProperty('subtitle'.toJS, props.subtitle!.toJS);
  o.setProperty('title'.toJS, props.title.toJS);
  return o;
}

({int initialCount, void Function(int)? onChange, String? subtitle, String title}) _Counter_fromJS(JSObject js) {
final initialCount = requiredJSInt(js, "initialCount", component: "initialCount");
final _rawonChange = js.getProperty('onChange'.toJS);

final void Function(int)? onChange =
    _rawonChange == null || _rawonChange.isUndefined
        ? null
        : (int param0) {
            final _fn = _rawonChange as JSFunction;
            invokeJSCallback(
  _fn,
  <JSAny?>[
    encodeReactValue(reactInt, param0)
  ],
);
          };
final subtitle = nullableJSString(js, "subtitle");
final title = requiredJSString(js, "title", component: "title");
  return (initialCount: initialCount, onChange: onChange, subtitle: subtitle, title: title);
}

final JSFunction $Counter = (() {
  JSAny? wrapper(JSObject props) {
    final dartProps = _Counter_fromJS(props);
    return toReactJS(impl.Counter(dartProps));
  }
  return wrapper.toJS;
})() as JSFunction;
void registerCounter(){
  ReactRegistry.register(idCounter.value, $Counter,
      toJS: (p) => _Counter_toJS(p as ({int initialCount, void Function(int)? onChange, String? subtitle, String title})),
      fromJS: (js) => _Counter_fromJS(js));
}

