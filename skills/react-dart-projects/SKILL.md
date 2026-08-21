---
name: react-dart-projects
description: Build and maintain React Dart applications in the react_workspace ecosystem. Use for scaffolding projects, choosing client/Shelf/Routed templates, resolving unpublished packages from Git refs, respecting package boundaries, and handling generated sources.
---

# React Dart projects

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

## Resolve unpublished packages

The React Dart packages are currently hosted on GitHub and are not available
from pub.dev as released packages. Consumer applications must use the
workspace Git repository with an explicit ref until publication:

```yaml
dependencies:
  react:
    git:
      url: https://github.com/kingwill101/react_workspace.git
      ref: master
      path: packages/react
  react_dom:
    git:
      url: https://github.com/kingwill101/react_workspace.git
      ref: master
      path: packages/react_dom
```

Repeat the same Git dependency shape for every React Dart package the
application imports. Use the same ref for all packages. Prefer an immutable
commit ref for reproducible external applications; use `master` only for
workspace-edge development.

Routed applications also need the unpublished Routed packages from the same
Routed ref:

```yaml
dependencies:
  routed_core:
    git:
      url: https://github.com/kingwill101/routed.git
      ref: master
      path: packages/routed_core
  routed_io:
    git:
      url: https://github.com/kingwill101/routed.git
      ref: master
      path: packages/routed_io
```

Use `routed_testing` from that same repository/ref for Routed tests. Keep
`react_server_routed` separate from `react_server_shelf`; do not add Shelf to a
Routed application merely to obtain a test adapter.

## Preserve package boundaries

- Portable nodes, components, hooks, refs, and contexts belong in `react`.
- Host factories and mounting belong in `react_dom`.
- Browser bindings belong in `react_js` and `react_web`.
- Transport-neutral SSR and server-function contracts belong in `react_server`.
- Shelf and Routed HTTP integrations belong in `react_server_shelf` and
  `react_server_routed` respectively.
- Testing belongs in `react_testing` plus the selected `server_testing` adapter.

Do not introduce a server framework dependency into a transport-neutral package.

## Generated source rules

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

For full-stack behavior, compose `ReactTestHarness` with the application's
`RoutedRequestHandler` or `ShelfRequestHandler`. Use harness-allocated ports;
never assume an existing process on port 8080 belongs to the current project.
