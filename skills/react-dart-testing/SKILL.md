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
- `HookTestHarness`: persistent hook state, memo/ref/callback identity, effects,
  async replacement, stale completions, and disposal. It is not a concurrent or
  browser scheduler; use component harnesses for tree/event behavior.
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
  react_testing: ^0.1.0
  server_testing: ^0.4.0
```

For Shelf, add the hosted `server_testing_shelf` package. Routed also has a
hosted `routed_testing` adapter. If the application deliberately uses an
unreleased Routed Git revision, select its adapter from that same ref:

```yaml
dev_dependencies:
  routed_testing:
    git:
      url: https://github.com/kingwill101/routed.git
      ref: <immutable-routed-commit>
      path: packages/server_testing/routed_testing
```

Use one ref consistently across the application and its adapter packages.
Replace the placeholder with an immutable commit for reproducible builds.

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

For Future/Stream hooks, cover stale completions, source replacement, error and
stack propagation, cancellation/disposal, and deterministic SSR without live
subscriptions. Cubit coverage should distinguish provider ownership (close owned
instances) from hook subscriptions (unsubscribe without closing borrowed state).

## CLI and fresh-consumer validation

`react test --coverage -- <dart test arguments>` streams test output and writes
`coverage/lcov.info`. Check real source/hit records and failure exit codes, not
just file presence. Filter coverage using physical paths so symlinked checkouts
do not produce empty reports, and use only the current invocation's raw data.

Use disk-backed workspace `.tmp` for both `TMP` and `TMPDIR` when requested;
resolve it to an absolute path before subprocesses change working directories.
Fresh consumer tests must verify actual package roots, successful ordinary
analysis, rejected invalid hooks, native tests, and a production build without
repairing generated fixtures. Keep this evidence distinct from cached reruns.

## Real debugger lifecycle

The native harnesses do not attach a real DDC/DWDS browser Dart debugger. For
changes at that boundary, use the existing opt-in test from `packages/react_tool`:

```console
REACT_BROWSER_TESTS=1 dart test test/debug_session_integration_test.dart
```

This gate uses isolated Chromium/CDP and allocated ports; it is not a replacement
for native proxy, component, or server tests. Verify SSR, hydration, actions,
both Dart breakpoints, hydrated reload, authored-source refresh, restored
templates, and closed service ports. Allow bounded asynchronous daemon shutdown
and destroy successful probe sockets; fail if a port remains listening.

Separate incremental compilation from browser refresh by inspecting the emitted
module before debugger attachment. Match the changed string literal, not a
substring that could also occur in an identifier such as `setCount`.
The gate uses the native watcher. Earlier results obtained with the removed
polling implementation do not validate native source refresh. Report a native
watch failure separately from debugger attachment, and keep third-party
dependencies unmodified when recording final proof.

`REACT_KEEP_DEBUG_FIXTURE=1` retains a marked fixture; reuse it through
`REACT_DEBUG_FIXTURE=/absolute/path` only for diagnosis/cached validation. Report
timeouts, retries, and remaining expression-evaluation gaps separately from a
successful breakpoint or lifecycle test. See `docs/debugging.md` and
`docs/dart-developer-workflow.md` for current evidence and limitations.

For packages with native code assets, package tests should exercise the source
fallback in a workspace checkout. Native prebuilt release workflows are a
separate CI concern: verify the staged library and generated manifest there,
then test published-package resolution against immutable release metadata. Do
not make ordinary workspace tests download a release artifact.

If a behavior cannot be represented by the native harnesses, state the missing
capability first and prefer extending `react_testing` or `server_testing`
before introducing browser automation.
