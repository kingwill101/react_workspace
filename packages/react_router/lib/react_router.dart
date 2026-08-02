// Typed bindings for [react-router-dom](https://reactrouter.com) v6.
//
// Components are rendered through the generic foreign-component bridge
// (`foreignComponent`). Hooks live in `react_router_hooks.dart` and run
// through the shim's hook bridge.
//
// The shim is imported automatically when `react.yaml` declares:
//
// ```yaml
// foreign:
//   modules:
//     - package:react_router/react_router_shim.mjs
// ```
import 'package:react/react.dart';

/// A normalized React Router location.
///
/// See https://reactrouter.com/hooks/use-location.
final class ReactRouterLocation {
  final String pathname;
  final String search;
  final String hash;
  final String key;
  final Object? state;

  const ReactRouterLocation({
    required this.pathname,
    required this.search,
    required this.hash,
    required this.key,
    this.state,
  });

  /// The full path including the query string, for example `/items/7?a=1`.
  String get fullPath => '$pathname$search$hash';

  @override
  String toString() => fullPath;
}

/// A URL path pattern for [route].
typedef RoutePath = String;

// ═══════════════════════════════════════════
// Components
// ═══════════════════════════════════════════

/// A router that keeps history in the browser URL.
///
/// See https://reactrouter.com/router-components/browser-router.
ReactNode browserRouter(List<ReactNode> children, {String? basename}) =>
    foreignComponent(
      'reactRouter.BrowserRouter',
      props: {'basename': basename},
      children: children,
    );

/// A router that keeps history in memory — useful for SSR and tests.
///
/// See https://reactrouter.com/router-components/memory-router.
ReactNode memoryRouter(
  List<ReactNode> children, {
  List<String>? initialEntries,
  int? initialIndex,
}) => foreignComponent(
  'reactRouter.MemoryRouter',
  props: {
    'initialEntries': initialEntries,
    'initialIndex': initialIndex,
  },
  children: children,
);

/// A router that renders at a fixed [location] — the SSR counterpart of
/// [browserRouter].
///
/// See https://reactrouter.com/router-components/static-router.
ReactNode staticRouter(
  String location,
  List<ReactNode> children, {
  String? basename,
}) => foreignComponent(
  'reactRouter.StaticRouter',
  props: {'location': location, 'basename': basename},
  children: children,
);

/// A route-matching region. Render [route] children inside it.
///
/// See https://reactrouter.com/router-components/routes.
ReactNode routes(List<ReactNode> children, {String? key}) => foreignComponent(
  'reactRouter.Routes',
  children: children,
  key: key,
);

/// A single route definition.
///
/// See https://reactrouter.com/router-components/route.
ReactNode route({
  String? path,
  bool? index,
  ReactNode? element,
  List<ReactNode> children = const [],
  String? key,
}) => foreignComponent(
  'reactRouter.Route',
  props: {
    'path': path,
    'index': index,
    'element': element,
  },
  children: children,
  key: key,
);

/// An anchor that navigates with the router.
///
/// See https://reactrouter.com/components/link.
ReactNode link(
  String to, {
  List<ReactNode> children = const [],
  String? className,
  String? key,
}) => foreignComponent(
  'reactRouter.Link',
  props: {'to': to, 'className': className},
  children: children,
  key: key,
);

/// A link that tracks whether its destination is active.
///
/// Active links receive `aria-current="page"` so they can be styled with an
/// attribute selector.
///
/// See https://reactrouter.com/components/nav-link.
ReactNode navLink(
  String to, {
  List<ReactNode> children = const [],
  String? className,
  String? key,
  bool? end,
}) => foreignComponent(
  'reactRouter.NavLink',
  props: {'to': to, 'className': className, 'end': end},
  children: children,
  key: key,
);

/// Renders the matched child route — the layout counterpart of nested routes.
///
/// See https://reactrouter.com/components/outlet.
ReactNode outlet({String? key}) =>
    foreignComponent('reactRouter.Outlet', key: key);

/// Navigates to [to] during render.
///
/// See https://reactrouter.com/components/navigate.
ReactNode navigate(String to, {bool? replace, String? key}) => foreignComponent(
  'reactRouter.Navigate',
  props: {'to': to, 'replace': replace},
  key: key,
);
