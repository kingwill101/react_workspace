# React Dart workspace

A typed React component and full-stack application ecosystem for Dart 3.12+.

React Dart keeps the UI contract portable while using React itself for browser
rendering and Node server-side rendering. Server functions, Web bindings,
JavaScript wrappers, and HTTP integrations live in separate packages.

## Architecture

```text
authored Dart component
        |
        v
react + react_dom portable node tree
        |
        +--> react_js --> browser ReactDOM
        |
        +--> react_server --> Node ReactDOMServer
        |
        +--> react_testing --> native in-memory harness

Dart HTTP server
        |
        +--> react_server_routed
        |
        +--> react_server_shelf
```

The main boundaries are intentional:

- `react` owns portable nodes, hooks, refs, contexts, and runtime contracts.
- `react_web` owns generated Web declarations and typed host factories.
- `react_dom` is the recommended component import and browser mount/hydrate
  entrypoint.
- `react_js` owns JavaScript conversion and React hook implementations.
- `react_server` owns transport-neutral SSR and server-function primitives.
- Shelf and Routed dependencies stay in their dedicated adapters.
- Generated application source stays under `lib/.generated/`.

## Packages

| Package | Role |
| --- | --- |
| [`react`](packages/react/README.md) | Portable React nodes, hooks, contexts, refs, and runtime features. |
| [`react_web`](packages/react_web/README.md) | Pinned Web API model, DOM/SVG factories, events, props, and adapters. |
| [`react_dom`](packages/react_dom/README.md) | Combined component entrypoint, browser mounting, and hydration. |
| [`react_js`](packages/react_js/README.md) | JavaScript renderer, hook binding, callbacks, and codecs. |
| [`react_actions`](packages/react_actions/README.md) | Browser-safe server-function protocol and annotations. |
| [`react_server`](packages/react_server/README.md) | Server-function registry, SSR worker client, and Node renderer. |
| [`react_server_routed`](packages/react_server_routed/README.md) | Routed SSR, asset, and action integration. |
| [`react_server_shelf`](packages/react_server_shelf/README.md) | Shelf SSR, asset, and action integration. |
| [`react_codegen`](packages/react_codegen/README.md) | Component, bridge, registry, and action source generators. |
| [`react_tool`](packages/react_tool/README.md) | Scaffold, generation, compilation, npm, TypeScript binding, and serving CLI. |
| [`react_testing`](packages/react_testing/README.md) | Native component, action, SSR, build, and fidelity harnesses. |
| [`react_analysis`](packages/react_analysis/README.md) | Shared component, hook, SSR, import, and usage semantics. |
| [`react_analyzer`](packages/react_analyzer/README.md) | Analysis-server diagnostics, fixes, and assists. |
| [`react_router`](packages/react_router/README.md) | Generated React Router components, functions, and hooks. |
| [`react_bloc`](packages/react_bloc/README.md) | Portable Bloc context and external-store hooks. |
| [`react_riverpod`](packages/react_riverpod/README.md) | Portable Riverpod scope and subscription hook. |
| [`react_zustand`](packages/react_zustand/README.md) | Focused npm-backed Zustand wrapper. |
| [`react_web_generator`](packages/react_web_generator/README.md) | Maintainable pinned Web IDL generation pipeline. |

## Requirements

- Dart SDK `>=3.12.0 <4.0.0`;
- Node.js and npm for React dependencies, bundling, and the SSR worker;
- the Rust toolchain required by `packages/react_tool/native/Cargo.toml` when
  building the native TypeScript declaration extractor.

The Web binding source is pinned to published `package:web 1.1.1`.

## Create an app

```console
dart pub get
dart run react_tool:react init my_app --template routed-minimal
cd my_app
dart pub get
dart run react_tool:react serve --watch
```

Available templates:

- `ssr`: Shelf-backed SSR;
- `routed`: expanded Shelf-free Routed SSR;
- `routed-minimal`: smaller Routed starter;
- `client`: static browser application.

Scaffolded projects hide and ignore `lib/.generated/`, `build/`, and
`.dart_tool/`. Day-to-day work is normally in `lib/app.dart`, feature files,
and tests.

## Author a component

```dart
import 'package:react_dom/react_dom.dart';

@reactComponent
ReactNode Counter(({int initial}) props) {
  final (count, setCount) = useState(props.initial);

  return button(
    type: 'button',
    className: classNames('counter'),
    style: css(padding: '8px 12px'),
    onClick: (_) => setCount(count + 1),
    children: ['Count: $count'],
  );
}
```

Run generation without compiling bundles:

```console
dart run react_tool:react generate
```

Workspace CI runs `build_runner build --workspace` once, then synchronizes
each application with `react generate --sync-only`. The latter is intended for
orchestration after a successful workspace build; normal application work
should use `react generate`.

Callers import the generated factory from
`package:my_app/.generated/counter.react.dart`. Authored component files do
not import their own generated output.

## Build and validate

```console
./tool/ci.sh all
```

The Dagger pipeline pins Dart, Node, Rust, Chromium, and ChromeDriver so this
same command runs locally and in GitHub Actions. Its stages can also be run
independently with `./tool/ci.sh quality`, `tests`, `docs`, or `browser`.
Initialize `third_party/web` once before local runs; the script archives the
pinned gitlink revision, so local modifications inside that submodule are
never sent to Dagger.
The browser stage uses `package:server_testing` in headless Chromium to prove
SSR hydration, client events, and typed server-function calls in the maintained
Shelf example. It does not use Playwright.

For a quick host-side development loop, run:

```console
dart analyze --fatal-infos
dart test <package-or-example>
dart run react_tool:react build --release
```

The build writes browser, SSR, CSS, static, foreign-module, manifest, and report
artifacts under `build/react/`.

Tests use `react_testing` on top of `server_testing`:

- `ReactComponentHarness` for nodes, hooks, refs, events, and capabilities;
- `ServerFunctionHarness` for dispatch, codecs, and HTTP envelopes;
- `SsrTestHarness` / `InMemorySsrHarness` for worker and document behavior;
- `ReactTestHarness` plus the application's actual server adapter for built
  assets, deep links, SSR, and actions;
- `GeneratorFidelityHarness` for Web surface completeness.

Browser automation is reserved for behavior the native harnesses cannot model.

## JavaScript wrappers

Reusable wrappers declare a `react.js` descriptor with npm dependencies,
React peer ranges, externals, and browser/SSR entries. Generate typed bindings
from published TypeScript declarations:

```console
dart run react_tool:react js install
dart run react_tool:react ts bind
```

[`react_router`](packages/react_router/README.md) is the generated reference;
[`react_zustand`](packages/react_zustand/README.md) demonstrates a deliberately
small handwritten bridge.

## Documentation

- [Documentation site source](.site/docs/intro.mdx)
- [CLI reference](.site/docs/reference/cli.mdx)
- [Wrapper package guide](.site/docs/guides/wrapper-packages.mdx)
- [Component ergonomics](.site/docs/guides/component-ergonomics.mdx)
- [Testing guide](.site/docs/guides/testing.mdx)
- [Maintainer guide](.site/docs/maintainers/maintenance.mdx)

## License

MIT. Each publishable package contains its own license and release metadata.
