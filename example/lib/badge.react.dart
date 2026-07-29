import 'package:react/react.dart';

const idBadge = ComponentId('package:example/lib/badge.dart#Badge');

ReactNode Badge({
  required String label,
  String? key,
  List<ReactNode> children = const [],
}) {
  final props = (label: label);
  return Component(idBadge, props, key: key, children: children);
}
