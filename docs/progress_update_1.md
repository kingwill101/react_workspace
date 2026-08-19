Checked the current head, **`968c5a0`**.

The latest work is moving well: the Web surface was regenerated, the commit reports **2,167 definitions with zero dropped**, generated Web files now avoid thousands of style diagnostics, provenance is serialized, and function/value symbol categories were added.

However, several important issues remain.

## 1. “Complete IDL” is still not literally complete

The generator still filters or collapses parts of the IDL:

* `flattenMembers()` explicitly skips every `staticMember`.
* Operation overloads are grouped by name, and only the overload with the greatest number of parameters is emitted.
* The emitted-manifest logic applies the same overload collapse, so the “zero dropped” result cannot detect lost overload signatures.

Therefore, the current invariant is effectively:

```text
Every normalized, deduplicated member identity was emitted.
```

It is not yet:

```text
Every IDL declaration and every overload signature was emitted.
```

For the contract you described, overload identity should include the complete signature:

```text
Interface.method(type1,type2):returnType
Interface.method(type1,type2,type3):returnType
```

Static interface members must also be dispatched through `WebRuntime`, rather than removed before emission.

## 2. P0: function/value DCE is still unsafe

`collectUnitWithPath()` currently returns only:

```dart
components
hooks
rawComponentKeys
rawHookKeys
```

It forgets:

```dart
functions
values
rawFunctionKeys
rawValueKeys
```

But resolved project analysis uses `collectUnitsWithPaths()`, which calls that incomplete method. Consequently, function/value usage disappears before `DartUsageCollector` checks:

```dart
final hasFunctionOrValue =
    collected.functions.isNotEmpty ||
    collected.values.isNotEmpty;
```

That check sees empty lists, so `complete` can still become `true` and the JS safety union can be disabled.

The immediate fix is:

```dart
ReactUsageResult collectUnitWithPath(
  CompilationUnit unit,
  String path,
) {
  final visitor =
      _UsageVisitor(currentPath: path);

  unit.visitChildren(visitor);

  return ReactUsageResult(
    components:
        visitor.components.toList()
          ..sort(),
    hooks:
        visitor.hooks.toList()
          ..sort(),
    functions:
        visitor.functions.toList()
          ..sort(),
    values:
        visitor.values.toList()
          ..sort(),
    rawComponentKeys:
        visitor.rawComponentKeys,
    rawHookKeys:
        visitor.rawHookKeys,
    rawFunctionKeys:
        visitor.rawFunctionKeys,
    rawValueKeys:
        visitor.rawValueKeys,
  );
}
```

There also needs to be a resolved integration test invoking an annotated `kind:function` declaration and asserting:

```dart
expect(
  result.functions,
  contains('reactRouter.generatePath'),
);

expect(result.complete, isFalse);
```

The existing eight tests cover hooks, components, hosted dependencies and provenance, but not resolved function/value usage.

Additionally, values cannot generally be discovered from `visitMethodInvocation()`. Reading:

```dart
final mode = someGeneratedValue;
```

requires `visitSimpleIdentifier`, `visitPrefixedIdentifier`, or equivalent resolved-reference handling.

## 3. P0: generated function shims discard arguments

Every ordinary function in the current Router shim forwards exactly one argument:

```javascript
matchRoutes: (a0) =>
  __reactDartMatchRoutes(a0),

generatePath: (a0) =>
  __reactDartGeneratePath(a0),

createRoutesFromChildren: (a0) =>
  __reactDartCreateRoutesFromChildren(a0),
```

That breaks required and optional parameters:

```dart
matchRoutes(routes, locationArg, basename)
generatePath(path, params)
createRoutesFromChildren(children, parentPath)
```

The shim generator itself still writes:

```dart
for (final fn in functions) {
  buffer.writeln(
    '  ${fn.name}: (a0) => '
    '${localFor[fn.name]}(a0),',
  );
}
```

Functions need the same parameter-aware forwarding used for hooks:

```javascript
matchRoutes: (a0, a1, a2) => {
  const args = [a0, a1, a2];
  while (
    args.length &&
    args[args.length - 1] == null
  ) {
    args.pop();
  }
  return __reactDartMatchRoutes(...args);
},
```

## 4. The new function codec has not reached React Router

The generator now contains primitive, array and object decoding logic, but the checked-in Router bindings still use the previous raw casts:

```dart
return raw as List<AgnosticRouteMatch>?;
return raw as String?;
return raw as Path?;
```

and structured inputs still use plain `.jsify()`.

So the new codec implementation has not been validated through the main real-world binding package.

There is also a latent generator mismatch:

* Function object returns generate `SomeType.fromJs(...)`.
* Normal generated binding classes contain `toJson()`, but no `fromJs()` factory.
* Only hook-specific classes currently receive `fromJs()`.

Before regenerating Router, unify the function and hook value-class emitters. Then run a freshness gate that regenerates Router and fails on a diff.

## 5. The declarations are broad, but the browser backend is still filtered

The neutral Web surface may contain all definitions, but browser proxy generation still begins from:

```text
element-like interfaces
constructible interfaces
Window / Document / Navigator seeds
transitive referenced interfaces
```

It does not simply generate an adapter for every interface in the IDL model.

That leaves potential gaps for APIs exposed only in workers or other realms.

There are additional runtime-fidelity gaps in the generic adapter:

* `_toJs()` does not encode `Map` or generated dictionary value classes.
* Generic callbacks receive only the first JS argument.
* Promise results become `Future<JSAny?>`, without decoding `T`.
* Lists decode their members as generic wrapped objects.
* Unknown objects become `_UnknownObject`, which does not implement the expected neutral interface.

The neutral generator now creates dictionary value classes, but many of those values still cannot cross the browser bridge.

## 6. Web API SSR metadata is still host-element metadata

Moving `WebApiRuntimeInfo` into the public `package:react` surface was correct, and generated factories such as `div()` now carry the annotation.

But the complete Web IDL emitter still does not annotate actual APIs such as:

```dart
Window.localStorage
Storage.getItem
Navigator.clipboard
BroadcastChannel()
```

The metadata is currently emitted for HTML factories and SSR-definition constants, not every generated Web member and constructor.

Therefore, `localStorage` analysis still depends on hard-coded fallback logic.

There are also duplicate definitions of `WebApiRuntimeInfo`, `WebRealm`, and `WebSsrSupport` in `react` and `react_analysis`.

Those should have one canonical owner.

## 7. Exact IDL naming has been changed

`escapeIdentifier()` now transforms IDL spelling into lower camel case:

```text
VERTEX_ATTRIB_ARRAY_DIVISOR_ANGLE
    → vertexAttribArrayDivisorAngle

URL
    → url
```

The adapter maps renamed Dart members back to their original JavaScript names, so runtime lookup can still work.

But this no longer satisfies the stronger contract:

> The public surface remains named exactly like the pinned package:web/Web IDL surface.

Since generated files now use `type=lint`, there is no need to rename valid IDL constants merely to satisfy style lints. Preserve canonical names and optionally provide Dart-style aliases.

## Native SSR status

The report is now honestly labelled as a **browser/SSR symbol diff**, which is an improvement. It explicitly says it is not full native-SSR compatibility analysis.

However, the same heuristic payload is still written to `native_ssr_compatibility.json`, including a `compatible` Boolean based on symbol-set differences. That Boolean should be removed or changed to:

```json
{
  "compatible": null,
  "status": "unknown"
}
```

until the native renderer, adapter registry, browser-API diagnostics, hook matrix and client-only boundaries are actually evaluated.

No native Dart SSR renderer was added in these commits.

## Current scorecard

```text
Full neutral definition generation     strong
Generated manifest/provenance          improved
Hosted-dependency safety               fixed
HTML factory SSR metadata              fixed
Generated-code analyzer noise          fixed

Exact IDL signature preservation       not fixed
Function/value semantic DCE            still broken
Function shim argument forwarding      broken
Function codecs in real bindings       not applied
Complete browser runtime adapters      not complete
Web API member SSR metadata             not complete
Native Dart SSR renderer                still missing
```

The immediate priority remains:

1. Fix `collectUnitWithPath`.
2. Fix function shim arity.
3. Unify function/hook codecs and regenerate Router.
4. Stop collapsing overloads and static members.
5. Generate runtime metadata and browser adapters directly from the complete IDL graph.

I reviewed the committed source at `968c5a0`; I did not execute the workspace locally.

