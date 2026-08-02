// react_router shim — component registration + the hook bridge.
//
// The generated shims (from `react ts bind --shim`) register the bound
// components; this file imports them and adds the hook bridge that
// react_router_hooks.dart calls during render. `react build` bundles this
// module through the `entries.shared` react.js descriptor entry; esbuild
// follows the relative imports and inlines the generated shims, keeping
// bare `react`/`react-dom` external.

import './react_router_bindings_shim.mjs';
import './react_router_server_shim.mjs';

import * as RRD from 'react-router-dom';

// Hook bridge: the Dart side declares @JS externals against these members and
// calls them during render, exactly like the core react_js hook binding. The
// wrappers decode results into primitives/arrays because dart2js cannot cast
// a raw `callAsFunction` return value to JSObject/JSArray.
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
