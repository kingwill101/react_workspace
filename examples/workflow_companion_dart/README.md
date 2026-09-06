# Workflow Companion Dart

A mostly 1:1 Dart port of StemCloud's Workflow Companion dashboard.

It is deliberately client-only: the reference route tree, state, forms,
Celery views, schedule builder, tenant settings, and shadcn-style UI are
translated into Dart-owned components. External browser-only behavior remains
behind the existing React Dart runtime boundary.

## Setup

```sh
dart pub get
npm install
npm run build:css
```

## Build

```sh
dart run react_tool:react build
```

## Run

```sh
dart run react_tool:react serve
```

For day-to-day iteration, focus on `lib/react/app.dart` and the files under
`lib/pages/`, `lib/components/`, and `lib/models/`. Generated output is in
`lib/.generated/` and `build/react/`; it is disposable and intentionally hidden
from the editor.

Refresh generated component wrappers with:

```sh
dart run react_tool:react generate
```

The app uses the same `react_dom` host shapes for browser and test rendering.
The primitives in `lib/components/ui/` are portable Dart functions; they do
not require Radix, `lucide-react`, or a JavaScript component import.

VS Code users get `.vscode/settings.json` preconfigured to hide generated and
build artifacts (`.generated`, `build`, `.dart_tool`) from the Explorer by
default.

## Test

```sh
dart test
dart run react_tool:react test --coverage
```

Tests use `react_testing` (`ReactComponentHarness`, `InMemorySsrHarness`)
— see `test/app_test.dart` and `test/parity_test.dart`. The client-only
scaffold does not include a server-function file or server-function tests.

## Analyze

```sh
dart run react_tool:react analyze
```

The server runs on `http://localhost:8080` and serves the client bundle
statically. If that port is occupied, use `--port`:

```sh
dart run react_tool:react serve --port 8090
```

## Translation coverage

The reference snapshot contains 13,268 authored TypeScript/TSX lines. The
current Dart source contains 10,704 authored lines (generated files excluded),
or 80.7% by the example's parity metric. The remaining differences are
tracked in [PORTING_PARITY.md](PORTING_PARITY.md); they are mostly third-party
Radix behavior and reference-only build metadata rather than unported routes.
