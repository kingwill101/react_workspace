/// Typed React Router bindings for [react-router-dom](https://reactrouter.com)
/// v6, generated from the package's TypeScript declarations.
///
/// ```sh
/// react ts bind react-router-dom BrowserRouter MemoryRouter Routes Route \
///   Link NavLink Outlet Navigate useHref useInRouterContext useLocation \
///   useNavigate useNavigationType useOutlet useParams useSearchParams \
///   useMatches useNavigation useRevalidator useResolvedPath useRouteError \
///   useRouteLoaderData useRoutes useBlocker useFetcher useFetchers \
///   useFormAction useLinkClickHandler useLoaderData useSubmit useActionData \
///   useOutletContext useAsyncValue useAsyncError --prefix reactRouter \
///   -o lib/react_router_bindings.g.dart \
///   --shim lib/react_router_bindings_shim.mjs \
///   --hooks lib/react_router_hooks.g.dart
/// react ts bind react-router-dom/server StaticRouter --prefix reactRouter \
///   --type-prefix Server \
///   -o lib/react_router_server_bindings.g.dart \
///   --shim lib/react_router_server_shim.mjs
/// ```
///
/// Components are rendered through the generic foreign-component bridge
/// (`foreignComponent`); the shims register the `reactRouter.*` names and are
/// bundled automatically via the react.js descriptor entry. Hooks are also
/// generated: they run through the shim's
/// `globalThis.__reactDartBindings.reactRouter` bridge during
/// render and decode into typed values (maps, records, value classes with
/// `fromParts`, enums with `fromValue`, captured closures for function
/// returns).
///
/// The second extraction uses `--type-prefix Server` because react-router and
/// @remix-run/router each declare their own `FutureConfig`; the server
/// bindings therefore expose `ServerFutureConfig`.
///
/// The typed `use*` hooks are **not** exported from this library: they import
/// `dart:js_interop` and only run in JavaScript targets (browser client and
/// Node SSR worker), so exporting them here would break VM (non-JS) consumers
/// and tests. Import `package:react_router/react_router_hooks.dart` explicitly
/// where you render with hooks (from JS-targeted Dart only).
library;

import 'react_router_bindings.g.dart' show Location;

/// Typed helpers for the `reactRouter.*` components.
export 'react_router_bindings.g.dart';

/// Typed helpers for the `react-router-dom/server` components
/// (`staticRouter` is the SSR counterpart of `browserRouter`).
export 'react_router_server_bindings.g.dart';

/// Convenience accessors for a React Router [Location].
extension ReactRouterLocation on Location {
  /// The URL path, query string, and fragment as one browser-relative value.
  String get fullPath => '$pathname$search$hash';
}
