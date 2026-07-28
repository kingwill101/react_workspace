import 'package:react/react.dart';
const idCounter = ComponentId('package:react_workspace/example/lib/counter.dart#Counter');
ReactNode Counter({required int initialCount, required void Function(int)? onChange, required String? subtitle, required String title, String? key, List<ReactNode> children = const []}){
  final props = (initialCount: initialCount, onChange: onChange, subtitle: subtitle, title: title);
  return Component(idCounter, props, key: key, children: children);
}