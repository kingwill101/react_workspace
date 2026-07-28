import 'dart:js_interop';
import 'package:react/react.dart';
import 'badge.dart' as impl;
import 'badge.react.dart' show idBadge;
@JS()
extension type BadgePropsJS._(JSObject _) implements JSObject {
  external JSAny get label;
}
({String label}) _Badge_fromJS(BadgePropsJS js) => (
label: js.label as String
);
final JSFunction $Badge = (() {
  JSObject wrapper(JSObject p) {
    final props = _Badge_fromJS(p as BadgePropsJS);
    final tree = impl.Badge(props);
    return ReactInternal.renderer.render(tree) as JSObject;
  }
  return wrapper.toJS;
})() as JSFunction;
void registerBadge() => ReactRegistry.register(idBadge.value, $Badge);