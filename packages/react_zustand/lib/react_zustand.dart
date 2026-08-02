// Typed Dart bindings for the zustand hook bridge.
//
// The underlying store is created inside the bundled shim
// (`react_zustand_shim.mjs`); this library only declares the `@JS` externals
// that read it. Everything here is JS-interop, so it runs in the browser and
// in the SSR worker, not on the native VM — mirroring `react_js`.
library;

import 'dart:js_interop';

/// Reads the current counter value from the zustand store as a React hook.
///
/// Safe to call from any component under the React tree: the shim wires it
/// through the store's `useSyncExternalStore` subscription.
@JS('globalThis.__reactDartZustand.useCount')
external int useCount();

/// Reads twice the counter value — demonstrates derived state.
@JS('globalThis.__reactDartZustand.useDoubled')
external int useDoubled();

/// Increments the counter outside the render cycle (`store.getState().inc()`).
@JS('globalThis.__reactDartZustand.inc')
external void inc();
