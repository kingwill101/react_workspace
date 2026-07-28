import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'package:react/react.dart';
const idBadge = ComponentId('package:react_workspace/example/lib/badge.dart#Badge');
JSObject _BadgeProps({required String label}) {
final o = JSObject();
  o.setProperty('label'.toJS, label.toJS);
  return o;
}
ReactNode Badge({required String label, String? key, List<ReactNode> children = const []}){
  return Component(idBadge, _BadgeProps(label: label),
      key: key, children: children);
}