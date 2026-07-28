import 'dart:js_interop';
import 'dart:js_interop_unsafe';

void main() {
  globalThis.setProperty(
    '__TEST_FN__'.toJS,
    ((JSObject req) {
      globalThis.setProperty(__resultVar, (req.getProperty('msg'.toJS) as JSString).toDart.toJS);
    }).toJS,
  );
}

@JS('globalThis')
external JSObject get globalThis;

@JS()
external JSString get __resultVar;
