## 0.1.1

- Fixes hook dependency encoding to use stable snapshot identity instead of
  React-prop encoding, so raw Dart callbacks and model objects work as
  `useMemo`/`useEffect` dependencies.
- Fixes `createElement` to pass children as variadic arguments instead of a
  single array, avoiding spurious React key warnings for static siblings.

## 0.1.0

- Introduces the JavaScript renderer, hook bindings, callback bridge, and component registry.
- Adds public codec registration for custom Dart-wrapped JavaScript value types.
