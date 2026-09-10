# Dart developer workflow implementation

This checklist tracks the complete developer-experience scope. Fresh-consumer
and real-debugger validation are required; unit tests alone do not prove them.

- [x] Enable React analyzer diagnostics in scaffolds and provide setup for
  existing projects, respecting the package/workspace analysis root.
- [x] Resolve runtime, generator, analyzer, and CLI packages consistently in
  local development; support workspace membership and verify package locations.
- [x] Make doctor inspect resolved dependencies, tool availability, codegen
  readiness, and analyzer activation, with actionable fixes and optional targets.
- [x] Coordinate browser DDC/DWDS, Dart server debugging, SSR, and server actions
  in one development session. Verify real breakpoints, refresh, and cleanup.
- [x] Stream test output, forward standard Dart test arguments, preserve failure
  behavior, and generate real LCOV output when coverage is requested.
- [x] Support Cubit through BlocBase and portable Future/Stream hooks; verify
  disposal, replacement, stale completions, errors, and SSR snapshots.
- [x] Align documentation with react_core and hosted dependency distribution.
- [x] Verify a fresh scaffold resolves intended dependencies, reports invalid
  hooks through dart analyze, passes native tests, and builds without repairs.

## Implementation and evidence

### Analyzer, setup, and workspaces

`react setup` enables the analyzer without overwriting existing plugin choices,
comments, or rules. New configuration uses
`plugins.react_analyzer.diagnostics` to promote invalid hooks and component
signatures to errors. Putting those names under `analyzer.errors` caused
unknown-code warnings and is not used by the scaffold.
Local setup also adds `plugins.dependency_overrides.react_analysis`: plugins
resolve in a synthetic package, independently of application overrides.

Workspace members inherit root analysis options while retaining their existing
includes and rules. `react init --workspace` registers the app and relocates
shared overrides/plugin configuration. Local dependency paths become absolute;
Git repository-relative paths remain unchanged. Conflicts are checked before
registration writes.

Real standalone and workspace analyzer consumers both pass: valid code analyzes
cleanly with fatal infos; an invalid hook makes ordinary `dart analyze` fail.
The latest integration run passes both cases with the local analysis engine
and a portable DOM import. The import checker accepts
`react_dom/react_dom.dart` while still rejecting direct browser implementation
imports.

All four scaffold variants have local runtime/tooling dependency and valid
VS Code JSON coverage. The latest setup/scaffold/doctor/coverage suite passes
38 tests, including plugin-engine conflict preservation and symlinked coverage.
Analysis of `react_tool` and `react_analysis` is clean with fatal infos.

Standalone package lookup no longer borrows a parent configuration before
`pub get`; only packages declaring `resolution: workspace` walk to a shared
configuration. This also isolates managed JS artifacts when test fixtures live
under the repository's `.tmp`. The broader build/configuration/bindings/tooling
regression suite passes 95 tests, including three explicit resolution-boundary
tests. The workspace JS cache was reprovisioned after the original failing
fixtures reached it, and a real esbuild transform was verified afterward.

### Doctor

Doctor checks actual resolved package directories, mixed local sources, explicit
missing entrypoints, analyzer plugin paths and workspace inheritance, executable
availability, and generated-source existence/age. Six doctor tests pass,
including the plugin's independent local analysis-engine configuration.
An actual scaffold invocation of `react doctor --json` also produced parseable
JSON with the local analyzer engine marked ready and no error findings.
Generated-source freshness is a timestamp heuristic, not a complete build-input
hash; `react generate` remains authoritative.

### Tests, coverage, and portable state

The test runner streams child output and forwards standard arguments after `--`.
Four tests cover argument forwarding, real coverage conversion/source filtering,
symlinked project paths, and missing coverage. A real `react test --coverage -- test/cubit_test.dart
--reporter expanded --concurrency=1` run passed and produced LCOV hit/source
records for `lib/react_bloc.dart`; a missing-test invocation failed as expected.
Coverage filtering now uses physical project paths, matching the resolver's
source paths when the checkout or temporary directory is reached through a symlink.

BlocBase support includes Cubit, provider lookup, subscription updates/cleanup,
and server snapshots. Portable `useFuture` and `useStream` cover replacement,
stale completions, errors, cancellation, disposal, and deterministic SSR.
`HookTestHarness` preserves hook state, memoized values, callbacks, and refs and
rejects changes to hook count. It is not a concurrent/browser scheduler.
The combined core/Bloc/Cubit/async/harness regression run passes 97 tests.

### Full-stack debugging: validated with polling

The loopback gateway has five native HTTP/WebSocket tests covering SSR/props,
action requests/cookies, DDC modules and maps, shutdown, unavailable upstreams,
and delivery of small SSE frames before the upstream stream closes.
The CLI starts the Dart VM-enabled server, Node SSR worker, and webdev together.
Scaffolds provide VS Code task and browser/server attach configurations.

The complete Chromium gate passes SSR HTML, incremental DDC output, hydration,
browser events, a Dart server breakpoint and action response, a browser Dart
breakpoint, hydrated manual reload, source-triggered automatic refresh, template
restoration, and closure of every reported service port. The final run took
3 minutes 51 seconds using the retained fixture's build cache and unmodified
published build_runner. The JSON report records `success: true`.

Native source notifications failed on this host. Opt-in `--poll` uses the
generator's public watcher registration and builder options, with an early
resolved-generator capability check. Native watching remains the default;
polling increases filesystem activity. No diagnostic dependency override or
upstream source modification is shipped. The 30-test generator suite and eight
environment/compatibility tests pass.

Disabling proxy response buffering fixed the DWDS SSE handshake; a native test
covers it. SDK discovery uses the running CLI's SDK, resolving the FVM outline
warning. Browser attachment uses webdev's Alt+D/Option+D command, documented in
CLI guidance and IDE prompts. Webdev still logs some `.ddc.dill` connection
resets; expression evaluation is not validated. One run under heavy host load
timed out installing a browser breakpoint; the unchanged gate passed on retry.

Cold Dart server startup also exceeded the old ten-second readiness deadline
while running build hooks. Readiness now allows up to a minute, detects an
early child exit, and destroys the probe socket. Three focused tests pass for
delayed startup, early exit, and bounded timeout; tool analysis remains clean.

Two native tests verify the bounded asynchronous shutdown check, including
failure when a port remains open and destruction of successful probe sockets.
The gate waits for literal compiled labels, avoiding a `setCount` identifier
false match during its temporary source edit. Tool/generator static analysis is
clean. Server/SSR source changes require a session restart; client refresh resets
browser state.
See [debugging.md](debugging.md).

### Fresh scaffold: validated

The full fresh workspace test passes local package-root assertions, generation,
`dart analyze --fatal-infos`, native tests, production `browser.js`, and ordinary
analysis failure for an invalid hook. This run uses the corrected workspace
inheritance and the plugin's explicit local analysis-engine override. It
completed in 7 minutes 32 seconds with no fixture repairs.

## Running validation

Use the workspace's disk-backed `.tmp` for both `TMP` and `TMPDIR`. Keep
`third_party/web` an unmodified submodule; generator fixes belong in this repo.
Run the expensive fresh scaffold and browser gates separately on constrained
hosts. The browser gate is opt-in via `REACT_BROWSER_TESTS=1`; ordinary tests
retain native proxy coverage without requiring Chromium.
