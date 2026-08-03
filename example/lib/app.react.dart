import 'package:react/react.dart';

const idApp = ComponentId('package:example/lib/app.dart#App');

ReactNode App({
  String? path,
  required String title,
  String? key,
  List<ReactNode> children = const []
}) {
  final props = (path: path, title: title);
  return Component(idApp, props, key: key, children: children);
}

