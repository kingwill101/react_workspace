# React Dart CLI (`react_tool`)

The official build tool and CLI for React Dart applications.

## Ecosystem Role

`react_tool` orchestrates Dart compilation, code generation, JavaScript bundling (using esbuild or rolldown), npm dependency management, and CSS/Sass compilation. It provides a standardized build pipeline out of the box, ensuring seamless integration between Dart, React, and native JS/TS modules.

## Installation

Activate globally using pub:

```console
dart pub global activate react_tool
```

Alternatively, run it directly from your project via `dart run`:

```console
dart run react_tool:react doctor
```

## CLI Commands

The CLI provides commands to manage the full lifecycle of a React Dart project:

- `react doctor` - Inspect the current React Dart project configuration and diagnostics.
- `react init <project_name> [--template <ssr|client|routed|routed-minimal>]` - Scaffold a new project. `ssr` includes Shelf-based SSR defaults, `client` omits server code, and `routed` uses Routed (`react_server_routed` + `routed_io`) with no Shelf dependency; `routed-minimal` uses the same stack with reduced starter files.
- `react generate` - Run Dart code generation and synchronize formatted sources into `lib/.generated/` without compiling bundles. Workspace orchestration may use `--sync-only` after one successful `build_runner build --workspace` invocation.
- `react build [--watch] [--release] [--server]` - Generate code, compile client and SSR Dart bundles, compile Sass, bundle JS dependencies, and copy static assets.
- `react prerender --routes /,/about [--output build/prerendered]` - Build the project, boot its real SSR server, and write selected routes as static HTML.
- `react serve [--watch] [--release] [--no-ssr]` - Build the project and run the Dart server (and SSR worker if configured) locally.
- `react clean` - Remove `build/react/`, `lib/.generated/`, and other React-owned generated outputs.
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

Configuration is defined in a `react.yaml` file (or a `react:` section in `pubspec.yaml`).

```yaml
# react.yaml
client: web/client.dart
ssr: lib/ssr.dart
server: bin/server.dart

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

The component name is also its runtime registration key. Dotted names are
useful for avoiding collisions between design systems, packages, and local
components. They are kept unchanged at runtime while `react_tool` sanitizes
the temporary JavaScript import names.

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
