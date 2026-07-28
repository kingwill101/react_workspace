import 'dart:js_interop';

class ReactRegistry {
  static final _map = <String, JSFunction>{};
  static void register(String id, JSFunction fn) => _map[id] = fn;
  static JSFunction? lookup(String id) => _map[id];
  // instance operator for compatibility if needed
  JSFunction? operator [](String id) => _map[id];
}
