import 'package:react/react.dart';

const idAboutPage = ComponentId('package:example/lib/about_page.dart#AboutPage');

ReactNode AboutPage({
  required String title,
  String? key,
  List<ReactNode> children = const []
}) {
  final props = (title: title);
  return Component(idAboutPage, props, key: key, children: children);
}

