// Self-registering shim for the zustand wrapper. Bundled by react_tool with
// esbuild: the `zustand` import is inlined, `react`/`react-dom` stay external.
import { create } from 'zustand';

// Shared counter store: also reachable outside React via getState().
const useCounterStore = create((set) => ({
  count: 0,
  inc: () => set((state) => ({ count: state.count + 1 })),
}));

// Hook bridge. Each hook returns JS primitives so dart2js can read them
// without casting raw function-call results to JSObject/JSArray.
globalThis.__reactDartZustand = {
  useCount: () => useCounterStore((state) => state.count),
  useDoubled: () => useCounterStore((state) => state.count * 2),
  inc: () => useCounterStore.getState().inc(),
};
