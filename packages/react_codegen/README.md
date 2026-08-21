# react_codegen

Build-runner generators for React Dart component factories, JavaScript bridges,
SSR registries, and server-function contracts.

## Installation

```yaml
dev_dependencies:
  build_runner: ^2.4.0
  react_codegen: ^0.1.0
```

Application builds normally invoke codegen through `react_tool`.

## Components

A component must return `ReactNode` and accept exactly one named record:

```dart
import 'package:react_dom/react_dom.dart';

@reactComponent
ReactNode Avatar(({
  required String src,
  String? label,
}) props) {
  return img(src: props.src, alt: props.label ?? '');
}
```

Generation emits two cache outputs for the source library:

- `avatar.react.dart`: component identity, callable `Avatar` factory, and
  `Avatar.props()` builder;
- `avatar.react.g.dart`: browser registration and prop codecs.

Aggregate outputs register components for browser and SSR rendering. The CLI
synchronizes all application-facing files into `lib/.generated/`.

```console
dart run react_tool:react generate
```

Callers import the factory through a package URI:

```dart
import 'package:my_app/.generated/avatar.react.dart';

final node = Avatar(src: '/avatar.png', label: 'Ada', key: 'ada');
```

## Server functions

`@serverFunction` and `@serverData` generation produces:

- stable function and contract identifiers;
- typed argument and result codecs;
- a browser proxy using `ServerFunctionClient`;
- server dispatch registration for `ServerFunctionRegistry`.

The wire protocol belongs to `react_actions`; HTTP transport integration
belongs to `react_server_routed` or `react_server_shelf`.

## Architecture

Generation is split into analyzer readers, typed models, and focused emitters.
Readers own Dart semantic interpretation. Emitters consume models and never
re-resolve source. Browser and server outputs derive from the same component or
action contract.

Generated sources are implementation details:

- do not edit them;
- change a reader, model, emitter, or annotated source;
- regenerate and format;
- analyze and run package tests;
- run generation twice when checking deterministic output.

Use direct `build_runner` commands only when debugging builders. Cache outputs
are not synchronized into `lib/.generated/` until `react_tool` runs.
