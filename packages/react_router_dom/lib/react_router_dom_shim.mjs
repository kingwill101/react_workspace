// react_router_dom shim — component + hook bridge wiring.
//
// The generated shims (from `react ts bind --shim`) register the bound
// components and the `globalThis.__reactDartBindings.reactRouter` hook bridge
// the generated hooks file calls during render; this file just imports them. `react build` bundles
// this module through the `entries.shared` react.js descriptor entry; esbuild
// follows the relative imports and inlines the generated shims, keeping
// bare `react`/`react-dom` external.

import './react_router_dom_bindings_shim.mjs';
import './react_router_dom_server_shim.mjs';
