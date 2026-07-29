import 'package:react/react.dart';

const idApp = ComponentId('package:example/lib/app.dart#App');

ReactNode App({
  required String title,
  String? key,
  List<ReactNode> children = const [],
}) {
  final props = (title: title);
  return Component(idApp, props, key: key, children: children);
}
