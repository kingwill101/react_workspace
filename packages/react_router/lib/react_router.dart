/// Typed React Router bindings for [react-router-dom](https://reactrouter.com)
/// v6, generated from the package's TypeScript declarations.
///
/// ```sh
/// react ts bind react-router-dom BrowserRouter MemoryRouter Routes Route \
///   Link NavLink Outlet Navigate --prefix reactRouter \
///   -o lib/react_router_bindings.g.dart \
///   --shim lib/react_router_bindings_shim.mjs
/// react ts bind react-router-dom/server StaticRouter --prefix reactRouter \
///   --type-prefix Server \
///   -o lib/react_router_server_bindings.g.dart \
///   --shim lib/react_router_server_shim.mjs
/// ```
///
/// Components are rendered through the generic foreign-component bridge
/// (`foreignComponent`); the shims register the `reactRouter.*` names and are
/// bundled automatically via the react.js descriptor entry. Hooks live in
/// `react_router_hooks.dart` and run through the shim's hook bridge.
///
/// The second extraction uses `--type-prefix Server` because react-router and
/// @remix-run/router each declare their own `FutureConfig`; the server
/// bindings therefore expose `ServerFutureConfig`.
library;

/// Typed helpers for the `reactRouter.*` components.
export 'react_router_bindings.g.dart';

/// Typed helpers for the `react-router-dom/server` components
/// (`reactRouterStaticRouter` is the SSR counterpart of the browser router).
export 'react_router_server_bindings.g.dart';

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
