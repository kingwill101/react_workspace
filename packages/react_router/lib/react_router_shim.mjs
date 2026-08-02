// react_router shim — imports react-router-dom and self-registers.
//
// This file is imported by `react build` through the `foreign.modules` entry
// in react.yaml (resolved as `package:react_router/react_router_shim.mjs`).
// react_tool bundles it with esbuild, inlining react-router-dom; the bare
// `react`/`react-dom` imports stay external and resolve through the page
// import map (browser) or node_modules (SSR worker).
//
// Hook bridge: the Dart side declares @JS externals against these members and
// calls them during render, exactly like the core react_js hook binding. The
// wrappers decode results into primitives/arrays because dart2js cannot cast
// a raw `callAsFunction` return value to JSObject/JSArray.

import * as RRD from 'react-router-dom';

const components = {
  'reactRouter.BrowserRouter': RRD.BrowserRouter,
  'reactRouter.MemoryRouter': RRD.MemoryRouter,
  'reactRouter.StaticRouter': RRD.StaticRouter,
  'reactRouter.Routes': RRD.Routes,
  'reactRouter.Route': RRD.Route,
  'reactRouter.Link': RRD.Link,
  'reactRouter.NavLink': RRD.NavLink,
  'reactRouter.Outlet': RRD.Outlet,
  'reactRouter.Navigate': RRD.Navigate,
};

for (const [name, component] of Object.entries(components)) {
  globalThis.__reactDartRegisterComponent?.(name, component);
}

globalThis.__reactDartRouter = {
  navigate(to, options) {
    RRD.useNavigate()(to, options);
  },
  // [pathname, search, hash, key] — primitives only.
  locationParts() {
    const loc = RRD.useLocation();
    return [loc.pathname, loc.search, loc.hash, loc.key];
  },
  // [key, value] pairs for the matched route params.
  paramPairs() {
    return Object.entries(RRD.useParams() ?? {}).map(([k, v]) => [
      k,
      String(v ?? ''),
    ]);
  },
  // [[key, value] pairs, setter] for the current query string.
  searchParamPairs() {
    const [params, setter] = RRD.useSearchParams();
    return [[...params.entries()].map(([k, v]) => [k, v]), setter];
  },
};
