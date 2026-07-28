import 'dart:js_interop';
import 'package:react/react.dart';
import 'avatar.dart' as impl;
import 'avatar.react.dart' show idAvatar;
@JS()
extension type AvatarPropsJS._(JSObject _) implements JSObject {
  external JSAny get size;
  external JSAny get src;
}
({int size, String src}) _Avatar_fromJS(AvatarPropsJS js) => (
size: js.size as int,
src: js.src as String
);
final JSFunction $Avatar = (() {
  JSObject wrapper(JSObject p) {
    final props = _Avatar_fromJS(p as AvatarPropsJS);
    final tree = impl.Avatar(props);
    return ReactInternal.renderer.render(tree) as JSObject;
  }
  return wrapper.toJS;
})() as JSFunction;
void registerAvatar() => ReactRegistry.register(idAvatar.value, $Avatar);