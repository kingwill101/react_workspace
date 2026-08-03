import 'package:react/react.dart';

const idHomePage = ComponentId('package:example/lib/home_page.dart#HomePage');

ReactNode HomePage({
  required String title,
  String? key,
  List<ReactNode> children = const []
}) {
  final props = (title: title);
  return Component(idHomePage, props, key: key, children: children);
}

