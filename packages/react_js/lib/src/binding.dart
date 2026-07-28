import 'dart:js_interop';
import 'package:react/react.dart';

class JsBinding extends ReactBinding {
  @override
  (T, void Function(T)) useState<T>(T initial) {
    final jsArray = _useState(initial as JSAny);
    final dartList = jsArray.toDart;
    final value = dartList[0] as T;
    final setter = dartList[1] as JSFunction;
    return (
      value,
      (T v) => setter.callAsFunction(null, v as JSAny),
    );
  }

  @override
  void useEffect(void Function() e, List<Object?>? deps) {
    final jsFn = e.toJS as JSFunction;
    if (deps == null) {
      _useEffect(jsFn, null);
    } else {
      final jsDeps = deps.map((d) => d as JSAny?).toList().toJS;
      _useEffect(jsFn, jsDeps);
    }
  }
}

@JS('React.useState')
external JSArray _useState(JSAny initial);

@JS('React.useEffect')
external void _useEffect(JSFunction effect, JSAny? deps);
