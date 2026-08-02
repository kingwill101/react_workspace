import 'package:react/react.dart';

const idZustandDemo = ComponentId('package:example/lib/zustand_demo.dart#ZustandDemo');

ReactNode ZustandDemo({
  required bool hidden,
  String? key,
  List<ReactNode> children = const []
}) {
  final props = (hidden: hidden);
  return Component(idZustandDemo, props, key: key, children: children);
}

