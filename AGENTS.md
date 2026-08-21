# React workspace agent guidance

## Repository skills

Before working on a matching task, read the focused repository skill:

- `skills/react-dart-projects/SKILL.md` for scaffolding, unpublished Git refs,
  package boundaries, and generated sources;
- `skills/react-dart-testing/SKILL.md` for native harness selection and
  Routed/Shelf adapter tests;
- `skills/react-dart-wrappers/SKILL.md` for generated TypeScript bindings,
  npm descriptors, and handwritten-shim exceptions.
- `skills/react-dart-foreign-components/SKILL.md` for shadcn-style local TSX
  export discovery, prop inference, wrapper generation, and bundle retention.

React Dart packages are currently consumed from the GitHub repository with an
explicit ref. Routed dependencies and Routed testing adapters likewise use the
same ref from `https://github.com/kingwill101/routed.git` until publication.

## Use the native test stack first

- Use `package:react_testing` and `package:server_testing` for React workspace validation. Do not reach for Playwright or another browser automation tool for behavior that these harnesses cover.
- Use `ReactComponentHarness` for component trees, hooks, refs, events, and runtime-capability checks.
- Use `ServerFunctionHarness` for direct server-function dispatch and HTTP envelope, codec, authentication, and contract checks.
- Use `SsrTestHarness` or `InMemorySsrHarness` for SSR templates, response documents, props injection, and failure handling.
- Use `ReactTestHarness` for `react build`, generated assets, and the Node SSR worker. Compose those fixtures with the actual server application and its `server_testing` adapter.
- Use `GeneratorFidelityHarness` for generated Web API completeness and host-type coverage.
- Add durable Dart tests to the relevant package or example instead of creating ad hoc external test scripts.

Browser automation is reserved for genuinely browser-only behavior that cannot be represented by `react_testing`. If it is needed, first state the missing native capability and prefer adding that capability to `react_testing`.

## Example verification

For a generated or maintained example, verify the narrow layers first, then the full stack:

1. `dart analyze`
2. `dart test`
3. `ReactTestHarness` plus the server's adapter (`ShelfRequestHandler`, `RoutedRequestHandler`, or equivalent) for built SSR, assets, and server actions
4. `dart run react_tool:react build` when explicitly checking generated artifacts or production compilation

Do not infer that a process listening on a conventional port belongs to the current example. Use harness-allocated ports.

## Generated sources

- Treat `lib/.generated/` and `build/react/` as generated output.
- Change generators or scaffold templates at the source, then regenerate and verify outputs.
- Keep starter-facing authored code small; generated implementation details belong under `.generated/`.

## Package boundaries

- Portable component and host-node shapes belong in `react` and `react_dom`.
- Browser bindings belong in `react_js` and `react_web`.
- Server transport integrations stay in their dedicated packages (`react_server_routed`, `react_server_shelf`) rather than adding framework dependencies to `react_server`.
- `react_testing` depends on `server_testing`, never on a concrete server adapter. Tests select `server_testing_shelf`, `routed_testing`, or another adapter according to the application under test.
