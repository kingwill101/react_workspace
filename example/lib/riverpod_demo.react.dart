import 'package:react/react.dart';

const idRiverpodDemo = ComponentId('package:example/lib/riverpod_demo.dart#RiverpodDemo');

ReactNode RiverpodDemo({
  required bool hidden,
  String? key,
  List<ReactNode> children = const []
}) {
  final props = (hidden: hidden);
  return Component(idRiverpodDemo, props, key: key, children: children);
}

