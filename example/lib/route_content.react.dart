import 'package:react/react.dart';

const idRouteContent = ComponentId('package:example/lib/route_content.dart#RouteContent');

ReactNode RouteContent({
  required bool hidden,
  String? key,
  List<ReactNode> children = const []
}) {
  final props = (hidden: hidden);
  return Component(idRouteContent, props, key: key, children: children);
}

