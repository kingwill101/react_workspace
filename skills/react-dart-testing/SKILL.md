---
name: react-dart-testing
description: Test React Dart components, hooks, SSR, server functions, generated builds, and HTTP adapters with the native react_testing/server_testing stack. Use when adding tests or diagnosing behavior in client, Shelf, Routed, or full-stack examples.
---

# React Dart testing

Use the smallest native harness that represents the behavior. Do not use
Playwright or another browser automation tool when a React Dart or
server_testing harness can cover the case.

## Select the harness

- `ReactComponentHarness`: portable trees, hooks, refs, contexts, events, and
  runtime-capability checks.
- `ServerFunctionHarness`: direct server-function dispatch, codecs,
  authentication context, and protocol failures.
- `InMemorySsrHarness` or `SsrTestHarness`: templates, props, SSR envelopes,
  and worker failure handling without a full build.
- `ReactTestHarness`: real `react build` output, browser/SSR artifacts, and
  the generated Node SSR worker.
- `GeneratorFidelityHarness`: generated Web API completeness and host-type
  coverage.

## Select the server adapter

`react_testing` depends on transport-neutral `server_testing`. Add the adapter
that matches the application:

```yaml
dev_dependencies:
  react_testing:
    git:
      url: https://github.com/kingwill101/react_workspace.git
      ref: master
      path: packages/react_testing
  server_testing: ^0.4.0
```

For Shelf, add the hosted `server_testing_shelf` package. For Routed,
add `routed_testing` from the same `routed` repository/ref as `routed_core`:

```yaml
dev_dependencies:
  routed_testing:
    git:
      url: https://github.com/kingwill101/routed.git
      ref: master
      path: packages/server_testing/routed_testing
```

Use one ref consistently across the application and its adapter packages.
Replace `master` with an immutable commit for reproducible external builds.

## Verify examples in layers

Run this order for a generated or maintained example:

```console
dart analyze
dart test
dart run react_tool:react build
```

When checking the full stack, start `ReactTestHarness` with the project root,
compose its `ssrClient`, `indexTemplate`, and output directory into the real
server application, then adapt that application with `RoutedRequestHandler`,
`ShelfRequestHandler`, or the selected server-testing adapter. Let the harness
allocate ports.

## Test behavior at the right boundary

- Test hook state and event callbacks with `ReactComponentHarness`.
- Test action codecs and business behavior with `ServerFunctionHarness`.
- Test HTTP envelopes, body limits, authentication, and status codes through
  the real server adapter.
- Test SSR output and failure handling with `SsrTestHarness` before invoking a
  full build.
- Test generated assets and Node SSR only with `ReactTestHarness`.

Add durable tests to the relevant package or example. Do not create temporary
external scripts or fixed-port smoke tests.

For packages with native code assets, package tests should exercise the source
fallback in a workspace checkout. Native prebuilt release workflows are a
separate CI concern: verify the staged library and generated manifest there,
then test published-package resolution against immutable release metadata. Do
not make ordinary workspace tests download a release artifact.

If a behavior cannot be represented by the native harnesses, state the missing
capability first and prefer extending `react_testing` or `server_testing`
before introducing browser automation.
