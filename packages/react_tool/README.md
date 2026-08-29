# React Dart CLI (`react_tool`)

The official build tool and CLI for React Dart applications.

## Ecosystem Role

`react_tool` orchestrates Dart compilation, code generation, JavaScript bundling (using esbuild or rolldown), npm dependency management, and CSS/Sass compilation. It provides a standardized build pipeline out of the box, ensuring seamless integration between Dart, React, and native JS/TS modules.

## Installation

The React Dart packages are published on pub.dev. Activate the CLI from the
hosted package:

```console
dart pub global activate react_tool
```

For workspace development, use `react init --packages ../packages` to develop
against local package directories. Use an immutable package version for
reproducible applications.

Alternatively, run it directly from your project via `dart run`:

```console
dart run react_tool:react doctor
```

### Native extractor prebuilts

`react_tool` uses `native_prebuilt` for its Rust/Oxc TypeScript extractor. A
published package first resolves the verified native artifact from the
`react_tool-native-v*` GitHub release and falls back to compiling `native/`
when no matching artifact is available. Workspace checkouts always compile the
current Rust source so local changes are exercised.

The release metadata lives in `native_prebuilt.yaml` and the generated
manifest is `lib/src/hook/react_tool_prebuilts.g.dart`. Once the release exists,
verify its downloaded artifact metadata with:

```console
dart pub get
dart test
dart run native_prebuilt manifest verify \
  --config packages/react_tool/native_prebuilt.yaml \
  --output packages/react_tool/lib/src/hook/react_tool_prebuilts.g.dart
```

The repository workflow `.github/workflows/react_tool_prebuilt.yml` builds the
native host matrix (Linux x64/ARM64, macOS x64/ARM64, and Windows x64/ARM64),
verifies pull requests, and can publish a tagged GitHub release through
`workflow_dispatch`. The generated manifest must be committed after the release
so consumers can use the verified artifacts.

## CLI Commands

The CLI provides commands to manage the full lifecycle of a React Dart project:

- `react doctor` - Inspect the current React Dart project configuration and diagnostics.
- `react init <project_name> [--template <ssr|client|routed|routed-minimal>] [--packages <path>]` - Scaffold a new project. `ssr` includes Shelf-based SSR defaults, `client` omits server code, and `routed` uses Routed (`react_server_routed` + `routed_io`) with no Shelf dependency; `routed-minimal` uses the same stack with reduced starter files. Add `--packages ../packages` when developing against a local workspace checkout.
- `react generate` - Run Dart code generation and synchronize formatted sources into `lib/.generated/` without compiling bundles. Workspace orchestration may use `--sync-only` after one successful `build_runner build --workspace` invocation.
- `react build [--watch] [--release] [--server]` - Generate code, compile client and SSR Dart bundles, compile Sass, bundle JS dependencies, and copy static assets.
- `react prerender --routes /,/about [--output build/prerendered]` - Build the project, boot its real SSR server, and write selected routes as static HTML.
- `react serve [--watch] [--release] [--no-ssr]` - Build the project and run the Dart server (and SSR worker if configured) locally.
- `react clean` - Remove `build/react/`, `lib/.generated/`, and other React-owned generated outputs.
- `react component add <name> <module> [<prop:type> ...] [--infer] [--style <path>]` - Add a local or npm foreign React component, generate its wrapper, and validate the bundle. Bare npm modules may omit `<name>` and derive it from `--export`; use `--no-validate` for declaration-only workflows.
- `react shadcn add <component> [--infer] [--style <path>]` - Add a component from the conventional `web/components/ui` shadcn layout.
- `react js install` - Install exact wrapper versions into `.dart_tool/react/js`.
- `react js sync` - Validate that the host JS project satisfies every wrapper.
- `react ts bind <specifier> [<names...>]` - Generate typed Dart bindings from TypeScript declarations for seamless interop with NPM packages.
- `react analyze [--path <project>]` - Run Dart analysis and preview resolved React usage.
- `react test [--path <test-path>] [--coverage]` - Run the native Dart test stack.

### Scaffolding

```console
# Shelf-backed SSR project (default)
dart run react_tool:react init my_app

# Routed-hosted SSR project (no Shelf dependency)
dart run react_tool:react init --template routed my_routed_app

# Routed-hosted SSR project with reduced starter surface
dart run react_tool:react init --template routed-minimal my_routed_app_compact

# Client-only project (no server code)
dart run react_tool:react init --template client my_client_app
```

Scaffolded projects also include:

- `.gitignore` entries for generated artifacts (`.dart_tool`, `build`, `lib/.generated`).
- a VS Code `.vscode/settings.json` generated as:
  - `**/.dart_tool`
  - `**/.generated`
  - `**/build`

During iteration, you usually edit only:

- `lib/app.dart` for UI
- `lib/greeting.dart` for server functions

That makes it easier to work around generated SSR/build churn while still shipping a complete full-stack example.

### Prerendering

Use `prerender` for a declared set of public routes:

```console
dart run react_tool:react prerender \
  --routes /,/about,/docs/getting-started \
  --output build/prerendered
```

For a checked-in route list, use a JSON manifest. It can be an array or an
object with a `routes` array:

```console
dart run react_tool:react prerender \
  --manifest config/prerender.json \
  --output build/prerendered
```

The command builds the configured client and SSR bundles, starts the project's
server with `REACT_SSR_URL`, requests each route, and writes `/` to
`index.html` and extensionless routes such as `/about` to
`about/index.html`. Routes must not contain query strings, fragments, or
parent-directory traversal. This is explicit route generation; it does not
turn request-time document caching into implicit ISR.

Project-level foreign-component helpers are also written under
`lib/.generated/`. Reusable wrapper packages are different: their generated
TypeScript bindings and shims are package implementation files and are normally
committed and reviewed.

## Configuration

Configuration is defined in a `react.yaml` file (or a `react:` section in
`pubspec.yaml`). A standalone `react.yaml` takes precedence when both files
contain configuration.

```yaml
# react.yaml
client:
  entrypoint: web/client.dart

ssr:
  entrypoint: lib/ssr.dart
  runtime: node

server:
  entrypoint: bin/server.dart

static: web
output: build/react

styles:
  entrypoints:
    - web/styles.scss
  output: styles.css

foreign:
  modules:
    - web/components/my_component.js
  components:
    - name: DatePicker
      module: web/components/date_picker.js
      export: default
      props:
        value: String
        disabled: bool?
```

### Entrypoints and runtimes

The tool has three Dart application entrypoints:

| Configuration | Purpose | Default |
| --- | --- | --- |
| `client.entrypoint` | Browser application compiled to JavaScript | `web/client.dart` |
| `ssr.entrypoint` | Server-rendered React document | `lib/ssr.dart` |
| `server.entrypoint` | Dart HTTP server and server-function host | `bin/server.dart` |

An entrypoint is optional in practice: if its conventional file does not
exist, the corresponding build step is skipped. The structured form is
recommended:

```yaml
client:
  entrypoint: web/client.dart
ssr:
  entrypoint: lib/ssr.dart
server:
  entrypoint: bin/server.dart
```

The older flat spelling remains supported for compatibility:

```yaml
clientEntrypoint: web/client.dart
ssrEntrypoint: lib/ssr.dart
serverEntrypoint: bin/server.dart
```

`ssr.runtime` selects the host contract for the generated SSR module:

- `node` (default) emits the Node SSR worker used by `react serve`.
- `fetch` emits a Web Fetch module using `renderToReadableStream`, suitable
  for Cloudflare Workers and other edge hosts. It is not started by the local
  Node SSR worker.

For example, a Cloudflare/Routed project uses:

```yaml
ssr:
  entrypoint: lib/ssr.dart
  runtime: fetch
```

### Styles, static files, and output

`styles.entrypoints` accepts one or more CSS, Sass, or SCSS files. The
stylesheet files are compiled into the configured output directory:

```yaml
styles:
  entrypoints:
    - web/styles.scss
    - web/components/ui.css
  output: styles.css
```

The singular `styles.entrypoint` spelling and the top-level `css` alias are
also accepted. If styles are not configured, the tool looks for
`web/styles.scss`, `web/styles.sass`, and CSS modules below `static`.

`static` defaults to `web` and identifies files copied into the build. `output`
defaults to `build/react`.

The authored Dart entrypoints produce these build artifacts:

| Artifact | Purpose |
| --- | --- |
| `browser.js` | Bundled browser application |
| `browser.entry.mjs` | Browser loader/intermediate entry |
| `ssr.entry.mjs` | SSR module entrypoint |
| `ssr_runtime.mjs` | Shared SSR runtime module |
| `bundle_manifest.json` | Machine-readable artifact manifest |
| `server` | Optional native server binary when `react build --server` is used |

The `browser.js`, SSR module, foreign bundles, and copied static assets are
the deployable output. `browser.entry.mjs` is retained as an inspectable build
intermediate; applications should reference the bundled `browser.js`.

### Foreign modules and JavaScript configuration

The foreign configuration controls local TSX/JavaScript components and their
runtime bundles:

```yaml
foreign:
  modules:
    - web/components/ui/utils.ts
  components:
    - name: Button
      module: web/components/ui/button.tsx
      export: Button
  dependencies:
    class-variance-authority: ^0.7.1
  externals:
    - some-large-package
  # Validate an existing npm project instead of the managed JS environment.
  host: true
```

`js.bind` declares repeatable TypeScript binding groups for `react ts bind`.
The default foreign bundler is `esbuild`; `rolldown` can be selected when the
project has been configured for it:

```yaml
bundling:
  backend: rolldown
```

All paths are relative to the package root. Run `react doctor` to see the
resolved entrypoints and output paths for the current project.

### TypeScript Bindings

You can automatically generate bindings for foreign npm components using `react ts bind`:

```console
react ts bind react-router-dom --hooks lib/hooks.dart
```

This extracts declarations and emits Dart helpers, allowing you to use TypeScript packages without writing manual interop.

For repeatable wrappers, declare `react.js.bind` groups in `pubspec.yaml` and
run `react ts bind` without positional arguments. The generator is split into
native extraction, serialized IR, type registration, component emission, hook
emission, and shim emission; structure and fidelity tests keep those phases
reviewable and deterministic.

### Foreign React Components

Use `foreign.components` for local TypeScript/React components or components
whose props are intentionally curated at the application boundary:

```yaml
foreign:
  components:
    - name: design.Button
      module: web/components/ui/button.tsx
      export: Button
      props:
        variant: String?
        disabled: bool?
        onClick: Function?
    - name: design.Card
      module: web/components/ui/card.tsx
      export: Card
      props:
        className: String?
```

The declaration can also be added interactively through the CLI. The command
edits only the structured `foreign.components` section, preserves the rest of
`react.yaml`, then generates the Dart wrapper and validates the normal
browser/SSR build pipeline:

```console
dart run react_tool:react component add design.Button \
  web/components/ui/button.tsx \
  variant:String? disabled:bool? onClick:Function?
```

For projects following the shadcn directory and naming conventions, the
optional adapter reduces this to:

```console
dart run react_tool:react shadcn add button
```

It declares `web/components/ui/button.tsx` as `shadcn.Button`. Use
`--directory`, `--namespace`, `--export`, and `--style` when the project uses
different conventions. `--infer` is available for typed local components.
The adapter writes the same `foreign.components` manifest consumed by the
generic command; it does not add a shadcn-specific runtime or generator. Pass
`--no-validate` when you only want to update the manifest and generate source
files.

Use `--style web/components/button.css` to add a local stylesheet to the
project's existing `styles.entrypoints` pipeline. Sass compilation, CSS
Modules, output naming, and document stylesheet links continue to use the
same build path as application styles.

Use `--export Button` for a named export; the default export is assumed when
the option is omitted. Add `--infer` to derive the prop surface from a local
TypeScript declaration or an npm package. Inference requires a named export.
For an npm package that is not already available in the project, `react_tool`
provisions it in the managed JS environment automatically. Use `--version` to
choose the npm range; it defaults to `*`:

```console
dart run react_tool:react component add design.Button \
  web/components/ui/button.tsx --export Button --infer
```

Explicit `prop:type` values may be supplied alongside `--infer`; they take
precedence over inferred values. Components need a declaration shape that the
TypeScript extractor can inspect, such as `React.FC<Props>` or a typed
component function.

The component name is also its runtime registration key. Dotted names are
useful for avoiding collisions between design systems, packages, and local
components. They are kept unchanged at runtime while `react_tool` sanitizes
the temporary JavaScript import names.

Bare npm modules are supported as well. The command records the package in
`foreign.dependencies`, so managed builds install it into the same JS
environment used by the foreign bundler:

```console
dart run react_tool:react component add dialog.Root \
  @radix-ui/react-dialog --export Dialog.Root --version '^1.0.0'
```

The same dependency and version are used during `--infer`, so a first run can
resolve, inspect, and declare a package in one command. Local TypeScript
modules still need to be reachable from the project or managed Node
environment.

For npm modules, the runtime name can be derived from the export and omitted:

```console
dart run react_tool:react component add \
  @radix-ui/react-dialog --export Dialog.Root
```

Nested export paths such as `Dialog.Root` are resolved in the generated
browser and SSR registration entries. If the package declares the namespace
as a typed object whose member is a React component, the member props are
inferred as well. Package-specific namespace or re-export shapes that do not
expose that object-member type still need explicit props. Simple named npm
exports can use the same inference path:

```console
dart run react_tool:react component add router.MemoryRouter \
  react-router-dom --export MemoryRouter --infer
```

Running either command generates the Dart wrappers in
`lib/.generated/foreign_components.g.dart`:

```console
dart run react_tool:react generate
dart run react_tool:react build
```

The generated wrappers use `foreignComponent`, and the build produces the
browser and SSR registration bundles automatically. Application code can
re-export the generated file through a small stable facade, for example:

```dart
export '.generated/foreign_components.g.dart';
```

This layer is deliberately not tied to shadcn. A shadcn component, a Radix
component, a local design-system component, or an npm package can use the same
manifest and bundling path. The source component remains ordinary React code;
the manifest describes only the Dart-facing boundary.

## Architecture Notes

- **Bundling:** `react_tool` utilizes either `esbuild` or `rolldown` to bundle foreign JS dependencies. It aggregates project-level modules and wrapper package shims into per-target bundles (`browser` and `ssr`).
- **CSS Modules:** Any `*.module.scss` or `*.module.css` file is automatically processed, generating a Dart binding with stable scoped class names to prevent CSS collisions.
- **Manifest:** The build produces a `bundle_manifest.json` recording every artifact so `react serve` and `react_testing` can dynamically resolve targets and orchestrate processes without hardcoded paths.
