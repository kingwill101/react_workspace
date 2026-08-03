import 'package:react/react.dart';

const idRouterSection = ComponentId('package:example/lib/router_pages.dart#RouterSection');

ReactNode RouterSection({
  required String title,
  String? key,
  List<ReactNode> children = const []
}) {
  final props = (title: title);
  return Component(idRouterSection, props, key: key, children: children);
}

const idRouterOverview = ComponentId('package:example/lib/router_pages.dart#RouterOverview');

ReactNode RouterOverview({
  required String title,
  String? key,
  List<ReactNode> children = const []
}) {
  final props = (title: title);
  return Component(idRouterOverview, props, key: key, children: children);
}

const idItemPage = ComponentId('package:example/lib/router_pages.dart#ItemPage');

ReactNode ItemPage({
  required String title,
  String? key,
  List<ReactNode> children = const []
}) {
  final props = (title: title);
  return Component(idItemPage, props, key: key, children: children);
}

const idSearchDemo = ComponentId('package:example/lib/router_pages.dart#SearchDemo');

ReactNode SearchDemo({
  required String title,
  String? key,
  List<ReactNode> children = const []
}) {
  final props = (title: title);
  return Component(idSearchDemo, props, key: key, children: children);
}

const idRedirectDemo = ComponentId('package:example/lib/router_pages.dart#RedirectDemo');

ReactNode RedirectDemo({
  required String title,
  String? key,
  List<ReactNode> children = const []
}) {
  final props = (title: title);
  return Component(idRedirectDemo, props, key: key, children: children);
}

