import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'package:react/react.dart';
const idApp = ComponentId('package:react_workspace/example/lib/app.dart#App');
JSObject _AppProps({required String title}) {
final o = JSObject();
  o.setProperty('title'.toJS, title.toJS);
  return o;
}
ReactNode App({required String title, String? key, List<ReactNode> children = const []}){
  return Component(idApp, _AppProps(title: title),
      key: key, children: children);
}