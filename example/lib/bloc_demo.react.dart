import 'package:react/react.dart';

const idBlocDemo = ComponentId('package:example/lib/bloc_demo.dart#BlocDemo');

ReactNode BlocDemo({
  required bool hidden,
  String? key,
  List<ReactNode> children = const []
}) {
  final props = (hidden: hidden);
  return Component(idBlocDemo, props, key: key, children: children);
}

