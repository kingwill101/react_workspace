import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'package:react/react.dart';
const idAvatar = ComponentId('package:react_workspace/example/lib/avatar.dart#Avatar');
JSObject _AvatarProps({required int size, required String src}) {
final o = JSObject();
  o.setProperty('size'.toJS, size.toJS);
  o.setProperty('src'.toJS, src.toJS);
  return o;
}
ReactNode Avatar({required int size, required String src, String? key, List<ReactNode> children = const []}){
  return Component(idAvatar, _AvatarProps(size: size, src: src),
      key: key, children: children);
}