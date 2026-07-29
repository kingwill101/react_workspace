import 'dart:js_interop';

class Entry {
  final JSFunction comp;
  final JSObject Function(Object?) toJS;
  final Object? Function(JSObject) fromJS;
  Entry(this.comp, this.toJS, this.fromJS);
}

class ReactRegistry {
  static final _m = <String, Entry>{};
  static void register(
    String id,
    JSFunction c, {
    required JSObject Function(Object?) toJS,
    required Object? Function(JSObject) fromJS,
  }) {
    _m[id] = Entry(c, toJS, fromJS);
  }

  static Entry? lookup(String id) => _m[id];
}
