import 'package:react/react.dart';
const idAvatar = ComponentId('package:react_workspace/example/lib/avatar.dart#Avatar');
ReactNode Avatar({required int size, required String src, String? key, List<ReactNode> children = const []}){
  final props = (size: size, src: src);
  return Component(idAvatar, props, key: key, children: children);
}