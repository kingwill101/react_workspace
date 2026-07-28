import 'dart:js_interop';
import 'package:react/react.dart';
import 'conversion_core.dart';

class JsBinding extends ReactBinding {
  @override
  (T, void Function(T)) useState<T>(T initial) {
    final jsArray = _useState(toReactJS(initial)!);
    final value = fromJS<T>(jsArray[0]);
    final setter = jsArray[1] as JSFunction;
    return (
      value,
      (T v) => setter.callAsFunction(null, toReactJS(v)!),
    );
  }

  @override
  void useEffect(void Function() e, List<Object?>? deps) {
    final jsFn = e.toJS as JSFunction;
    if (deps == null) {
      _useEffect(jsFn, null);
    } else {
      _useEffect(jsFn, deps.map((d) => toReactJS(d)).toList().toJS);
    }
  }
}

@JS('React.useState')
external JSArray _useState(JSAny initial);

@JS('React.useEffect')
external void _useEffect(JSFunction effect, JSAny? deps);
