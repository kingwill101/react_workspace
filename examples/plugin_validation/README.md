# plugin_validation — Analyzer Plugin Example

Validates the **interactive intelligence layer** from `docs/analyzer_plugin.md` before it is rolled out to all packages.

## What it demonstrates

| File | Rule | Expected diagnostic |
|------|------|---------------------|
| `lib/invalid_component.dart` | `invalid_react_component` (shared `ReactComponentAnalyzer`) | `BadReturn` must return `ReactNode`; `BadGeneric` cannot be generic; `BadArity` arity; `BadPositional` positional record |
| `lib/hook_errors.dart` | `invalid_hook_call` | `HookInConditional` / `HookInLoop` / `HookAfterReturn` / `notAComponent` + `badHookName` |
| `lib/ssr_errors.dart` | `browser_api_during_ssr` | `SsrBadRead` `window.localStorage` during render; `SsrGoodRead` ok in `useEffect`; `SsrClientOnly` ok via `@ClientOnly` |
| `lib/usage_demo.dart` | `ReactRuntimeUsageCollector` | `App` → `reactRouter.Route/Link`; `HookUsageDemo` → `reactRouter.useLocation` |
| `lib/valid_component.dart` | — | No diagnostics (control) |

Plugin also offers:
* **Fix** `browser_api_during_ssr` → `AddClientOnlyFix` (“Add @ClientOnly”)
* **Assist** `ConvertToReactComponentAssist` (“Convert to React component”) on any plain function

## Run live `dart analyze` (plugin)

From workspace root:

```bash
dart pub get
dart analyze examples/plugin_validation --fatal-infos
```

With `analysis_options.yaml` → `analyzer: plugins: - react_analyzer`, diagnostics appear in IDE and `dart analyze` (warning rules are enabled by default; no lint toggle needed). The same diagnostics are reproduced by unit tests below.

## Run semantic usage manifests (tool)

`packages/react_tool` now prefers Dart manifests over JS scanning:

```bash
dart run react_tool:react build  # writes .dart_tool/react/browser_usage.json etc.
cat .dart_tool/react/browser_usage.json
```

## Run unit tests (shared engine)

Pure-Dart engine tests — no `build_runner`, no file watcher, no JS compile:

```bash
dart test examples/plugin_validation --reporter=compact
# or from package:
dart test packages/react_analysis packages/react_analyzer
```

See `test/plugin_validation_test.dart` — groups mirror `lib/` structure, use `package:analyzer` `parseString` + `react_analysis` analyzers, assert `ReactDiagnostic.code` values per skill `dart-add-unit-test`.
