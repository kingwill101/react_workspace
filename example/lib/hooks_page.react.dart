import 'package:react/react.dart';

const idHooksPage = ComponentId('package:example/lib/hooks_page.dart#HooksPage');

ReactNode HooksPage({
  required String title,
  String? key,
  List<ReactNode> children = const []
}) {
  final props = (title: title);
  return Component(idHooksPage, props, key: key, children: children);
}

