import 'package:react/react.dart';

const idItemDetail = ComponentId('package:example/lib/route_item.dart#ItemDetail');

ReactNode ItemDetail({
  required bool hidden,
  String? key,
  List<ReactNode> children = const []
}) {
  final props = (hidden: hidden);
  return Component(idItemDetail, props, key: key, children: children);
}

