You have made a **major leap** since `6d9ce11`. The current head is `4006a7e`, and the new work covers three substantial areas:

1. Full Web IDL fidelity and verification.
2. A shared analyzer engine plus IDE plugin.
3. A much stronger testing and scaffold workflow.

## What is now genuinely strong

### Web IDL completeness is no longer self-reported

The generator now produces an actual `emitted_manifest.json` and compares source IDs against emitted definitions and members. The current report contains:

* 2,167 source definitions
* 2,166 emitted definitions
* One intentionally opaque `Function` callback
* 10,395 source and emitted members
* Zero dropped definitions or members

You also fixed several issues from my previous review:

* `package:web` is pinned to `1.1.1`.
* Host types are checked by library identity, reducing false matches with user-defined `Node`, `Event`, and `Element`.
* Namespace dispatch hooks were added to `WebRuntime`.
* The BCD event-name normalization issue was corrected.
* Constructors, constants, iterable, maplike and setlike members now participate in completeness verification.

This part is moving in the right direction.

### The analyzer architecture exists

You created the package structure we discussed:

```text
react_analysis
    shared semantic validators

react_analyzer
    IDE rules, fixes and assists

react_codegen
    generator consuming shared validation

react_tool
    build-time manifests and CLI

react_testing
    VM, SSR and integration harnesses
```

The plugin currently registers six rules, two fixes and one assist.

The code generator also runs `ReactComponentAnalyzer` before emitting code, so the plugin and generator at least begin from the same component validation implementation. Build-runner errors are now associated with the offending function element instead of only the library.

### Testing has become a first-class framework feature

The new scaffolds include VM-safe tests and `react_testing` dependencies. The CLI now includes:

```bash
react analyze
react test
react test --coverage
```

You also added component, in-memory SSR, server-function and generator-fidelity harnesses across the examples.

This is important product work. A generated application that starts with working tests feels substantially more mature than one that begins with only a build command.

---

# Critical problem: semantic DCE is currently unsafe

This is the most important finding.

The new `DartUsageCollector` claims to operate on resolved Dart ASTs, but it currently uses:

```dart
parseString(
  content: content,
  path: path,
).unit;
```

`parseString` only parses syntax. It does not resolve elements, annotations, imports or library metadata.

It also performs its own import traversal using a regular expression and explicitly skips all `package:` imports:

```dart
if (spec.startsWith('dart:') ||
    spec.startsWith('package:')) {
  continue;
}
```

That means the collector cannot reliably discover:

* `@ReactRuntimeSymbol`
* `@ReactHook`
* Hooks imported from `react_router_dom`
* Generated bindings imported through package URIs
* Re-exported declarations
* Parts
* Conditional imports
* Package-library reachability

But the builder considers any non-null Dart usage result authoritative:

```dart
final usedComponents =
    dartUsage != null
        ? Set<String>.from(
            dartUsage.components,
          )
        : /* JS fallback */;
```

The same happens for hooks.

Therefore, an incomplete or empty semantic manifest can cause valid wrapper registrations to be removed without falling back to the compiled-JS scan.

## Required correction

Use `AnalysisContextCollection` and resolved units:

```dart
final contexts =
    AnalysisContextCollection(
  includedPaths: [projectRoot],
);

final session =
    contexts.contextFor(entryPath)
        .currentSession;

final result =
    await session.getResolvedUnit(
  entryPath,
);
```

Traverse the resolved library graph using imported/exported libraries, parts and package configuration—not source-text import regexes.

Until that is complete, use a fail-safe union:

```dart
final retainedComponents = {
  ...semanticUsage.components,
  ...compiledJsUsage.components,
};

final retainedHooks = {
  ...semanticUsage.hooks,
  ...compiledJsUsage.hooks,
};
```

The semantic pass can become exclusive only when the result includes a completeness marker such as:

```json
{
  "complete": true,
  "resolvedLibraries": 47,
  "unresolvedLibraries": [],
  "components": [],
  "hooks": []
}
```

Right now, calling these manifests “authoritative” is premature.

# Generated bindings are not yet annotated

The metadata model exists:

```dart
@ReactRuntimeSymbol(...)
@ReactHook()
```

But the current generated React Router hook file still emits only `@JS` externals and ordinary Dart helper functions. It does not attach `@ReactHook` or `@ReactRuntimeSymbol` to public generated hooks.

So even after switching to resolved analysis, the collector will not have the metadata it expects.

The TS binding generator should emit annotations on every public generated declaration:

```dart
@ReactHook()
@ReactRuntimeSymbol(
  kind: ReactRuntimeSymbolKind.hook,
  runtimeKey:
      'reactRouter.useLocation',
  targets: {
    ReactRenderTarget.browser,
    ReactRenderTarget.server,
  },
)
ReactRouterLocation useLocation() {
  // ...
}
```

Components, ordinary functions and runtime values should receive their corresponding symbol kind as well.

# Runtime-symbol discovery still contains hard-coded namespaces

The collector currently falls back to:

```dart
if (uri.contains('react_router_dom')) {
  return 'reactRouter';
}
if (uri.contains('react_zustand')) {
  return 'reactZustand';
}
```

That recreates the exact maintenance problem you are trying to eliminate.

It also extracts annotation values by regexing:

```dart
ann.toSource()
```

rather than evaluating the annotation constant.

Use the resolved annotation value:

```dart
final value =
    annotation.computeConstantValue();

final runtimeKey =
    value?.getField('runtimeKey')
        ?.toStringValue();
```

The namespace must come exclusively from generated metadata. The analyzer should know nothing about specific packages such as React Router, Zustand, Bloc or Riverpod.

Also, `rawComponentKeys` and `rawHookKeys` are declared but never populated, so the promised “where retained and why” information is currently empty.

# Plugin diagnostics are too coarse

The shared analyzers return detailed codes and messages, but `ReactDiagnostic` carries no source node, offset or length.

Consequently, the plugin throws away nearly all the detail.

The hook rule does this:

```dart
for (final _ in diagnostics) {
  rule.reportAtNode(node);
  break;
}
```

where `node` is the entire compilation unit.

The SSR rule behaves the same way.

This means the editor will generally highlight the whole file and show one generic message:

```text
Invalid React hook call.
```

rather than highlighting the actual `useState()` invocation and explaining that it is inside a conditional.

## Better diagnostic model

```dart
final class ReactDiagnostic {
  final String code;
  final String message;
  final ReactDiagnosticSeverity severity;
  final AstNode node;
  final String? correction;
}
```

Then:

```dart
for (final diagnostic
    in diagnostics) {
  rule.reportAtNode(
    diagnostic.node,
    arguments: [
      diagnostic.message,
    ],
  );
}
```

Ideally, register separate diagnostic codes:

```text
react_hook_in_conditional
react_hook_in_loop
react_hook_after_early_return
react_hook_outside_component
```

That also lets each issue have its own correct fix.

# Hook analysis is still mostly name-based

The comments say hook detection uses resolved metadata, but `_HookCallCollector` currently treats every method beginning with `use` as a hook:

```dart
if (_isHookName(
  node.methodName.name,
)) {
  hookCalls.add(...);
}
```

This can flag ordinary APIs such as:

```dart
useCache();
user.usePreference();
usefulMethod();
```

It also treats **any** `ReactRuntimeSymbol` annotation as a hook without checking whether its kind is actually `hook`.

Additional control-flow gaps remain:

* Conditional early returns such as `if (x) return ...; useState(...)` are not tracked.
* Hooks inside loops can receive both loop and conditional diagnostics.
* Nested-function hooks may be attributed to the outer component.
* `_validateNested` reports all nested hooks as being in a conditional, including loop-only cases.
* The analyzer does not yet build a proper control-flow model.

Use resolved elements as the primary classification:

```text
@ReactHook
or
@ReactRuntimeSymbol(kind: hook)
or
a custom hook declaration proven to call hooks
```

Name convention should only be a fallback for user-defined custom hooks.

# SSR analysis is not yet connected to generated Web metadata

`ReactSsrAnalyzer` is designed to read `@WebApiRuntimeInfo`, but the generated Web surface does not currently appear to emit those annotations. It therefore falls back to a small hard-coded list of browser methods and properties such as `getItem`, `querySelector`, `localStorage` and `history`.

The `native_ssr_compatibility.json` file confirms this is still a placeholder:

```json
{
  "summary":
    "native SSR compatibility — WebApiRuntimeInfo emission pending"
}
```

The next Web IDL emission step should attach runtime metadata to generated globals, members and constructors. Without it, “complete Web API surface” and “complete SSR diagnostics” remain disconnected systems.

# Tests do not cover the critical integration path

The validation tests mostly parse unresolved source strings.

Notable weaknesses:

* The “valid component produces no diagnostics” test only checks that one declaration was parsed.
* The `@ClientOnly` test only asserts that the analyzer returns a list.
* Usage tests cover literal `foreignComponent()` calls but not annotated generated hooks.
* Package-import reachability is not tested.
* Fix/assist testing only checks that diagnostic code strings are non-empty.
* No test starts the actual analyzer plugin and verifies reported location/message/fix.

Add end-to-end fixtures that use:

```text
AnalysisContextCollection
resolved package imports
generated @ReactRuntimeSymbol declarations
plugin diagnostic assertions
quick-fix application
browser/SSR manifest comparison
```

The highest-value regression test is:

> A client entry imports a component that imports `package:react_router_dom/react_router_dom.dart` and calls `useLocation()`. The browser usage manifest must contain `reactRouter.useLocation`, and the final browser shim must retain it.

# Smaller issues

### `react analyze` does not yet run a separate analysis pass

It delegates to `dart analyze`, then prints only the configured client and SSR entry paths under “Usage preview.” It does not actually display the collected usage.

### Doctor recommends a nonexistent command

It suggests:

```bash
dart run react_analysis
```

but `react_analysis` currently declares no executable.

### The scaffold duplicates server-function contracts

The greeting scaffold manually defines codecs and `greetRef` so tests work before codegen. That is understandable, but it creates two potential sources of truth once generated contracts exist.

A better solution is either:

* Run lightweight contract generation as part of `react init`, or
* Generate committed starter `.g.dart` files and verify their freshness.

## Updated verdict

This was the right set of changes. You implemented nearly the entire architecture we discussed:

```text
shared semantic engine       implemented
IDE plugin                   implemented
generator validation reuse   implemented
Web emitted manifest         implemented
testing harnesses            implemented
scaffold tests               implemented
usage manifests              prototype
native SSR report            stub
```

The Web IDL completeness work is now convincing.

The analyzer/plugin work is a strong **first implementation**, but the DCE integration must be treated as experimental until these are fixed:

1. Use resolved analysis contexts.
2. Traverse package imports and exports.
3. Emit runtime annotations from codegen.
4. Remove hard-coded namespace inference.
5. Keep the compiled-JS scan as a safety union.
6. Report diagnostics at exact AST nodes.
7. Add real plugin integration tests.

The architecture is right. The immediate priority is making sure the new semantic manifest cannot silently remove runtime bindings it failed to discover.

