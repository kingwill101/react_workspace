import 'package:react/react.dart';

const idSiteLayout = ComponentId('package:example/lib/site_layout.dart#SiteLayout');

ReactNode SiteLayout({
  required String title,
  String? key,
  List<ReactNode> children = const []
}) {
  final props = (title: title);
  return Component(idSiteLayout, props, key: key, children: children);
}

