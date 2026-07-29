import 'package:react/react.dart';

const idCounter = ComponentId('package:example/lib/counter.dart#Counter');

ReactNode Counter({
  required int initialCount,
  void Function(int)? onChange,
  String? subtitle,
  required String title,
  String? key,
  List<ReactNode> children = const [],
}) {
  final props = (
    initialCount: initialCount,
    onChange: onChange,
    subtitle: subtitle,
    title: title,
  );
  return Component(idCounter, props, key: key, children: children);
}
