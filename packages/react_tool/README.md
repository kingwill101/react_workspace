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
- `react init <project_name> [--template <ssr|client|routed>]` - Scaffold a new project. `ssr` includes Shelf-based SSR defaults, `client` omits server code, and `routed` uses Routed (`react_server_routed` + `routed_io`) with no Shelf dependency.
- `react build [--watch] [--release] [--server]` - Generate code, compile client and SSR Dart bundles, compile Sass, bundle JS dependencies, and copy static assets.
- `react serve [--watch] [--release] [--no-ssr]` - Build the project and run the Dart server (and SSR worker if configured) locally.
- `react js install` - Install exact wrapper versions into `.dart_tool/react/js`.
- `react js sync` - Validate that the host JS project satisfies every wrapper.
- `react ts bind <specifier> [<names...>]` - Generate typed Dart bindings from TypeScript declarations for seamless interop with NPM packages.

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

## Architecture Notes

- **Bundling:** `react_tool` utilizes either `esbuild` or `rolldown` to bundle foreign JS dependencies. It aggregates project-level modules and wrapper package shims into per-target bundles (`browser` and `ssr`).
- **CSS Modules:** Any `*.module.scss` or `*.module.css` file is automatically processed, generating a Dart binding with stable scoped class names to prevent CSS collisions.
- **Manifest:** The build produces a `bundle_manifest.json` recording every artifact so `react serve` and `react_testing` can dynamically resolve targets and orchestrate processes without hardcoded paths.
