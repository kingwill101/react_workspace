import 'package:react/react.dart';

const idRouterDemo = ComponentId('package:example/lib/router_demo.dart#RouterDemo');

ReactNode RouterDemo({
  required String path,
  String? key,
  List<ReactNode> children = const []
}) {
  final props = (path: path);
  return Component(idRouterDemo, props, key: key, children: children);
}

