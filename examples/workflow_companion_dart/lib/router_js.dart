import 'package:react_router_dom/react_router_dom.dart' as router;
import 'package:react_router_dom/react_router_dom_hooks.dart' as router_hooks;
import 'package:react_core/react.dart';

ReactNode browserRouter({ReactChildren children = const []}) =>
    router.browserRouter(children: children);

ReactNode routes({ReactChildren children = const []}) =>
    router.routes(children: children);

ReactNode route({
  String? key,
  Object? path,
  ReactNode? element,
  ReactChildren children = const [],
}) => router.route(key: key, path: path, element: element, children: children);

ReactNode navLink({
  String? key,
  required Object? to,
  String? className,
  bool? end,
  ReactChildren children = const [],
}) => router.navLink(
  key: key,
  to: to,
  className: className,
  end: end,
  children: children,
);

Map<String, String> useParams() => router_hooks.useParams();

void Function(Object? to, {bool? replace}) useNavigate() {
  final navigate = router_hooks.useNavigate();
  return (to, {replace}) => navigate(to, replace: replace);
}
