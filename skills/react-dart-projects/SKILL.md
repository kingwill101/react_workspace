---
name: react-dart-projects
description: Build and maintain React Dart applications in react_workspace. Use for scaffolding, package and analyzer setup, workspace integration, full-stack debugging, generated sources, and native code-asset delivery.
---

# React Dart projects

Scaffolded applications currently require Dart `>=3.13.0 <4.0.0`, because the
DDC toolchain uses `build_web_compilers: ^4.8.10`.

Use this skill when creating or modifying a React Dart application or scaffold.

## Start from the CLI

Run commands from the directory containing the application's `pubspec.yaml`:

```console
dart run react_tool:react init my_app --template client
dart run react_tool:react init my_app --template ssr
dart run react_tool:react init my_app --template routed
dart run react_tool:react init my_app --template routed-minimal
```

Use `client` for browser-only applications, `ssr` for Shelf-backed full-stack
applications, and `routed` or `routed-minimal` for Shelf-free Routed hosts.
Prefer `routed-minimal` when the authored starter surface should stay small.

## Configure application entrypoints

The tool reads `react.yaml`, or a `react:` section in `pubspec.yaml` when
`react.yaml` is absent. Prefer the structured configuration:

```yaml
client:
  entrypoint: web/client.dart
ssr:
  entrypoint: lib/ssr.dart
  runtime: node
server:
  entrypoint: bin/server.dart
styles:
  entrypoints:
    - web/styles.scss
  output: styles.css

static: web
output: build/react
```

The conventional entrypoints are `web/client.dart`, `lib/ssr.dart`, and
`bin/server.dart`. Missing conventional files are skipped. The compatible
flat aliases are `clientEntrypoint`, `ssrEntrypoint`, and
`serverEntrypoint`; use the structured form in new projects.
`styles.entrypoints` accepts multiple CSS/Sass/SCSS files, while
`styles.entrypoint` and the top-level `css` spelling are legacy aliases.

`react doctor` reports the resolved entrypoints and output paths. The final
deployable browser artifact is `build/react/browser.js`; the generated
`browser.entry.mjs`, `ssr.entry.mjs`, `ssr_runtime.mjs`, and
`bundle_manifest.json` are build/runtime artifacts and should not be authored
by application code.

For edge deployments, configure the SSR build explicitly:

```yaml
ssr:
  entrypoint: lib/ssr.dart
  runtime: fetch
```

The default `node` runtime emits the development/production SSR listener used
by `react serve`. The experimental `fetch` runtime emits a module-style SSR
endpoint using Web Fetch and `renderToReadableStream`; it is intended for a
separately deployed Worker or another Fetch host. The application host can
call that endpoint through the JavaScript `ReactSsrClient`.

## Resolve package sources consistently

React Dart and Routed packages are published on pub.dev. New scaffolds use
hosted dependencies by default. For local React development, pass
`--packages /absolute/path/to/react_workspace/packages` to `react init` so the
runtime, CLI, generator, analysis library, and analyzer plugin use this checkout.
Use `--workspace /absolute/path/to/workspace` to register the generated app in
an existing Dart workspace and relocate shared overrides/plugins to its root.

For an existing app, `react setup` enables analyzer diagnostics; add `--packages`
to select a local analyzer plugin. Run `react doctor --json` to inspect resolved
packages, analyzer activation, entrypoints, tools, and generated-source freshness.
Freshness is a timestamp heuristic, not proof that all generator inputs match.

Analyzer configuration belongs at the package/workspace analysis root. React
diagnostics use top-level `plugins.react_analyzer.diagnostics`, not
`analyzer.errors`. Local analyzer plugins resolve in a separate package context:
keep `plugins.dependency_overrides.react_analysis` aligned with the local engine.
Preserve existing includes, rules, comments, and deliberate plugin choices.

Resolve a standalone consumer's own `.dart_tool/package_config.json`; only an
explicit `resolution: workspace` member may share its ancestor's configuration.
This also applies to npm cache ownership: an unresolved nested fixture must not
borrow or rewrite the enclosing checkout's managed JavaScript environment.

When a consumer explicitly needs an unreleased Git revision, use this shape:

```yaml
dependencies:
  react_core:
    git:
      url: https://github.com/kingwill101/react_workspace.git
      ref: <immutable-react-commit>
      path: packages/react_core
  react_dom:
    git:
      url: https://github.com/kingwill101/react_workspace.git
      ref: <immutable-react-commit>
      path: packages/react_dom
```

Repeat the same Git dependency shape for every React Dart package the
application imports. Replace the placeholder with the same immutable commit
for runtime, tooling, and testing packages from that repository. Use
`--packages` for local workspace development instead of mutable Git refs.

When choosing Git for Routed, use one Routed ref for its packages and adapter:

```yaml
dependencies:
  routed_core:
    git:
      url: https://github.com/kingwill101/routed.git
      ref: <immutable-routed-commit>
      path: packages/routed_core
  routed_io:
    git:
      url: https://github.com/kingwill101/routed.git
      ref: <immutable-routed-commit>
      path: packages/routed_io
```

Use `routed_testing` from that same repository/ref for Routed tests. Keep
`react_server_routed` separate from `react_server_shelf`; do not add Shelf to a
Routed application merely to obtain a test adapter.

## Preserve package boundaries

- Portable nodes, components, hooks, refs, and contexts belong in `react_core`.
- Host factories and mounting belong in `react_dom`.
- Browser bindings belong in `react_js` and `react_web`.
- Transport-neutral SSR and server-function contracts belong in `react_server`.
- Shelf and Routed HTTP integrations belong in `react_server_shelf` and
  `react_server_routed` respectively.
- Testing belongs in `react_testing` plus the selected `server_testing` adapter.

Do not introduce a server framework dependency into a transport-neutral package.

## Native Rust code assets

`react_tool` contains a Rust/Oxc native extractor. Its hook uses
`native_prebuilt` to resolve verified release artifacts for published-package
consumers and falls back to the local Rust crate for workspace checkouts.
Keep this distinction when testing: do not make a workspace build depend on a
GitHub release that may not exist yet.

When changing the native library or hook:

1. Update `packages/react_tool/native/` and the hook source.
2. Run `dart test` from `packages/react_tool` to exercise the source fallback.
3. Stage the built library and verify the manifest with
   `dart run native_prebuilt manifest verify` as described in
   `packages/react_tool/README.md`.
4. Use `.github/workflows/react_tool_prebuilt.yml` to build release assets;
   commit the generated manifest only after the matching release asset exists.

Do not hand-edit `lib/src/hook/react_tool_prebuilts.g.dart`; it is generated by
`native_prebuilt manifest update`. Keep the release tag and artifact hashes in
sync with the GitHub release.

## Generated source rules

Keep `third_party/web` an unmodified, pinned submodule used for Web API stub
generation. Change generators in this repository, never the upstream sources.

Treat `lib/.generated/` and `build/react/` as disposable output. Change the
generator, scaffold template, descriptor, or authored source, then regenerate:

```console
dart run react_tool:react generate
dart analyze
dart test
```

Do not hand-edit generated wrappers, SSR registries, browser entries, or build
manifests. Keep authored application code in `lib/app.dart`, feature files,
server-action files, and tests.

## Verify a project

For a maintained example, run the narrow checks first:

```console
dart analyze
dart test
dart run react_tool:react build
```

When validating an edge SSR project, inspect both generated modules:
`build/react/ssr.entry.mjs` and `build/react/ssr_runtime.mjs`. Confirm the
entry uses `renderToReadableStream` and neither file has a `node:http` listener.
Do not run a Fetch entrypoint with `react serve`; that command starts the Node
SSR worker only for projects using `ssr.runtime: node`.

For IDE debugging, use `react serve --debug`. It serves DDC's
`/client.dart.js` and stages the generated callback trampoline, foreign browser
bundle, source maps, and compiled CSS under `web/react-debug/`. The staged
assets are cached in `.dart_tool/react/`; adding a foreign component must
invalidate a cache created by a previously foreign-free run. Production builds
must reference only `/browser.js`, which contains the bundled browser runtime.

Full-stack Node SSR projects also start a VM-enabled Dart server and a loopback
gateway for pages, server actions, DDC assets, and debugger connections. New
scaffolds provide VS Code task/attach configurations. Browser source edits
rebuild and refresh the page; server and SSR edits require restarting the CLI.
After the page loads, press Alt+D (Option+D on macOS) to start webdev's browser
VM service, then use the printed URI for browser attachment. Server attachment
uses `.dart_tool/react/server_vm_service.json`. Do not mistake a listening HTTP
port for a ready browser debugger. Keep webdev's PATH-based SDK discovery aligned
with `Platform.resolvedExecutable`, including when PATH contains SDK wrappers.

For unreliable native filesystem notifications, use `react serve --debug --poll`.
Polling is opt-in, increases filesystem activity, and requires a resolved
`react_codegen` advertising `polling_watcher` in `react_tooling.json`. Use matching
local packages for unreleased capabilities; do not change hosted scaffold defaults
to an unavailable version. Encode watcher selection in builder options so a
daemon with different options cannot silently reuse the wrong watcher mode.

Stop the session to restore its temporary HTML templates; do not edit those
templates while debugging. Refresh reruns SSR and resets browser-local state.
For an existing Chrome instance, use
`--no-launch-browser --chrome-debug-port <port>`; DWDS requires that port when
the CLI does not launch Chrome itself. See `docs/debugging.md` for limitations
and the current validation status. A passing breakpoint test does not establish
expression-evaluation support.

For full-stack behavior, compose `ReactTestHarness` with the application's
`RoutedRequestHandler` or `ShelfRequestHandler`. Use harness-allocated ports;
never assume an existing process on port 8080 belongs to the current project.
