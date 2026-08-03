import 'package:react/react.dart';

const idNotFoundPage = ComponentId('package:example/lib/not_found_page.dart#NotFoundPage');

ReactNode NotFoundPage({
  required String title,
  String? key,
  List<ReactNode> children = const []
}) {
  final props = (title: title);
  return Component(idNotFoundPage, props, key: key, children: children);
}

