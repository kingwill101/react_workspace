import 'dart:js_interop';
import 'dart:js_interop_unsafe';

void main() {
  print('SSR simple: init');
  // Set a minimal function
  var fn = ((JSObject req) {
    print('Handler called!');
    return 'OK'.toJS;
  }).toJS;
  
  print('Setting __REACT_RENDER__');
  globalThis.setProperty('__REACT_RENDER__'.toJS, fn);
  print('Done.');
}

@JS('globalThis')
external JSObject get globalThis;
