You are right. I was reviewing the packaging work at `0ea44a0`, while the important newer work is the sequence ending at **`09f8d891`**:

* `1fdc8d5`: Rust/oxc TypeScript declaration extraction and typed Dart generation.
* `e90a57f`: generated React Router components and `.mjs` registration shims.
* `63ebadf`: clean Dart names such as `route()`, `link()`, and `memoryRouter()`.
* `09f8d89`: generated hooks, hook return decoding, and generated hook shims.

## Updated view

The architecture is now:

```text
npm package .d.ts
        ↓
Rust + oxc parser/resolver
        ↓
neutral JSON declaration IR
        ↓
Dart emitters
  ├── typed component bindings
  ├── typed hook bindings
  └── generated .mjs shim
        ↓
esbuild browser/SSR aggregate bundles
```

This is the correct separation.

Rust should understand TypeScript semantics. Dart should control the public Dart API and code-emission policies. Esbuild should remain responsible for the runtime JavaScript module graph.

I would **keep this architecture**, not replace it.

## What is particularly good

The Rust extractor is no longer just looking for obvious interfaces. It is resolving package subpaths and declaration re-exports, recognizing `ForwardRefExoticComponent`, processing unions, intersections, aliases and React-specific wrapper types. That is the right foundation for producing bindings for packages beyond React Router.

Generating the shim from the same semantic model is also the correct move:

```text
TypeScript declaration says export exists
        ↓
Rust records its semantic shape
        ↓
Dart emits both sides of the bridge
```

This removes the most error-prone part of wrapper maintenance: manually keeping Dart declarations and JavaScript adapters synchronized.

The generated handling of hooks is a meaningful jump forward. In particular, capturing the function returned by `useNavigate()` during the actual hook call avoids the invalid pattern of invoking a hook later inside an event callback. The extractor now also understands tuple, callable, record, indexed-access and conditional return shapes.

## The most important remaining issue: hook namespacing

The latest design uses:

```javascript
globalThis.__reactDartHooks = {
  useLocation: ...,
  useNavigate: ...,
};
```

That works for one wrapper, but not for an ecosystem.

Another package can easily expose:

```text
useLocation
useNavigate
useParams
useForm
useSubmit
useBlocker
```

If every generated shim assigns `globalThis.__reactDartHooks`, the last loaded wrapper can overwrite the previous wrapper. Even merging into one object leaves hook-name collisions.

Namespace the hook bridge by wrapper:

```javascript
globalThis.__reactDartBindings ??= Object.create(null);

globalThis.__reactDartBindings.reactRouter = {
  useLocation: RRD.useLocation,
  useNavigate: RRD.useNavigate,
  useParams: RRD.useParams,
};
```

Generated Dart:

```dart
@JS('__reactDartBindings.reactRouter.useLocation')
external JSObject _useLocationJs();

@JS('__reactDartBindings.reactRouter.useNavigate')
external JSFunction _useNavigateJs();
```

Possible keys:

```text
reactRouter
reactHookForm
tanstackQuery
framerMotion
```

The prefix you already use for component registration is the natural hook namespace too.

## Avoid a universal recursive `toPairs`

The current `toPairs` mechanism is a useful bootstrap, but it should not become the universal hook transport.

A generic recursive converter has several risks:

* It loses JavaScript object identity.
* It creates new Dart lists, maps and value classes on every render.
* It can mishandle cyclic objects.
* It must special-case functions, `URLSearchParams`, arrays and class instances.
* It may treat tuple arrays and ordinary arrays identically.
* It prevents generated code from using the static return shape already discovered by Rust.

The extractor already knows the return type, so generate a lowering strategy per type:

```text
string                 → JSString
number                 → JSNumber
boolean                → JSBoolean
function               → JSFunction wrapper
known object           → generated JS extension type
tuple                   → JSArray with typed indexes
Array<T>                → JSArray conversion
Record<string, T>       → targeted entries conversion
URLSearchParams         → URLSearchParams adapter
unknown/any             → JSAny
```

For example:

```dart
@JS()
extension type _LocationJs(JSObject _) implements JSObject {
  external JSString get pathname;
  external JSString get search;
  external JSString get hash;
  external JSString get key;
}

final class ReactRouterLocation {
  final _LocationJs _value;

  const ReactRouterLocation._(this._value);

  String get pathname => _value.pathname.toDart;
  String get search => _value.search.toDart;
  String get hash => _value.hash.toDart;
  String get key => _value.key.toDart;

  String get fullPath => '$pathname$search$hash';
}
```

The shim can expose the actual imported hook:

```javascript
globalThis.__reactDartBindings.reactRouter.useLocation =
  RRD.useLocation;
```

Then Dart invokes it through a statically typed external. No object-to-pairs conversion is required.

Keep `toPairs` only for genuinely dynamic index-signature objects, such as a generic string-keyed parameter map.

## Preserve hook return identity

This is subtle but important.

Suppose `useNavigate()` returns a stable JavaScript function. If generated Dart does this:

```dart
final jsFunction = _useNavigateJs();

return (String path) {
  jsFunction.callAsFunction(null, path.toJS);
};
```

a **new Dart closure** is created on every render. That can break dependency-array and memoization behaviour even when the underlying JavaScript function is stable.

Prefer a callable wrapper:

```dart
extension type NavigateFunction._(JSFunction _function) {
  void call(
    String destination, {
    bool? replace,
  }) {
    final options = JSObject();

    if (replace != null) {
      options.setProperty(
        'replace'.toJS,
        replace.toJS,
      );
    }

    _function.callAsFunction(
      null,
      destination.toJS,
      options,
    );
  }
}
```

Or a small generated class whose equality is based on the underlying `JSFunction`.

The same issue applies to decoded object results. Reconstructing a new Dart `Location` value every render could make:

```dart
useEffect(..., [location]);
```

behave differently from the original JavaScript library. Either preserve the JS object wrapper or give generated value classes meaningful structural equality.

## Keep hooks separate from portable component bindings

Your components remain portable `ReactNode` factories and can be loaded in VM tests. Generated hooks import `dart:js_interop`, so they are inherently JS-targeted.

The latest commit summary says `react_router_dom.dart` exports the generated hook file.  I would keep the public boundary as:

```dart
// Portable component API
import 'package:react_router_dom/react_router_dom.dart';

// JS-targeted hook API
import 'package:react_router_dom/react_router_dom_hooks.dart';
```

This lets:

* Component bindings remain VM-testable.
* Native tooling inspect the package.
* Future non-JS renderers use the component surface.
* Hooks remain explicitly tied to browser/Node-JS execution.

## Move from “one extraction command” to “one wrapper specification”

You have reduced manual shim writing, but `react_router_dom` still needs several coordinated extraction commands and a tiny handwritten aggregate shim.

The next major improvement should be a package-level binding specification:

```yaml
# react_bindings.yaml

package: react_router_dom
namespace: reactRouter

sources:
  - specifier: react-router-dom
    components:
      - BrowserRouter
      - MemoryRouter
      - Routes
      - Route
      - Link
      - NavLink
      - Outlet
      - Navigate
    hooks:
      - useLocation
      - useNavigate
      - useParams
      - useSearchParams
      - useNavigationType
      - useMatches

  - specifier: react-router-dom/server
    components:
      - StaticRouter
    typePrefix: Server

outputs:
  library: lib/react_router_dom.dart
  hooksLibrary: lib/react_router_dom_hooks.dart
  shim: lib/react_router_dom_shim.g.mjs
```

Then:

```bash
react ts generate react_bindings.yaml
```

would emit:

```text
react_router_dom_bindings.g.dart
react_router_dom_server_bindings.g.dart
react_router_dom_hooks.g.dart
react_router_dom.dart
react_router_dom_hooks.dart
react_router_dom_shim.g.mjs
```

The wrapper descriptor would point to the generated package-level shim:

```yaml
react:
  js:
    entries:
      shared: lib/react_router_dom_shim.g.mjs
```

That removes the remaining handcrafted aggregator and ensures all outputs are generated from one declarative source.

I would prefer this over automatically globbing for `*_shim.mjs` files. Globs can retain stale generated files after exports are removed.

## Rust IR direction

The Rust side should continue emitting semantics, not Dart or JavaScript source.

A hook declaration should eventually resemble:

```json
{
  "kind": "hook",
  "name": "useNavigate",
  "typeParameters": [],
  "overloads": [
    {
      "parameters": [],
      "returnType": {
        "kind": "function",
        "parameters": [
          {
            "name": "to",
            "type": {
              "kind": "named",
              "name": "To"
            }
          }
        ],
        "returnType": {
          "kind": "void"
        }
      }
    }
  ]
}
```

Important additions for broader package support:

* Preserve overloads instead of prematurely combining them.
* Preserve generic parameters and bounds.
* Record runtime export kind: named, default or namespace.
* Record source package and exact package version.
* Add an IR schema version.
* Maintain deterministic declaration and member ordering.

Generics will matter quickly for libraries such as form, query and state packages. Some hooks cannot be completely generated from package declarations alone because their generic type is supplied by the application. You will eventually need a small override/custom-codec layer rather than reducing everything to `Object?`.

## Bundling recommendation

Keep esbuild for now.

The Rust/oxc pipeline solves a **declaration-analysis** problem. The bundler must solve a different problem involving:

* Runtime conditional exports
* ESM and CommonJS interop
* Side-effect detection
* Dynamic imports
* CSS, WASM and other assets
* Browser versus Node resolution
* Minification and source maps

Your current build already collapses wrapper shims into one browser bundle and one SSR bundle. The generated source `.mjs` files are build inputs; they are not a runtime performance problem once esbuild has bundled them.

The current global side-effect registration model limits tree shaking because every selected export is registered. That is acceptable initially. The practical optimization is to keep each wrapper’s declared export list curated—not to replace esbuild immediately.

## Tests that now matter most

Add fixtures covering:

1. Two wrappers both exposing `useLocation`, proving namespaces do not collide.
2. A function-returning hook, checking stable wrapper identity.
3. An object-returning hook, checking dependency stability.
4. An overloaded hook.
5. A generic hook.
6. Nested callable members such as `blocker.reset`.
7. A `.d.ts` export with no corresponding runtime export, ensuring bundling fails clearly.
8. Regeneration twice producing byte-identical files.
9. A wrapper regenerated from only its specification, with no handwritten `.mjs`.
10. Browser and Node SSR execution of the same generated hooks.

The latest commit reports the React Router and `react_tool` tests passing, while two pre-existing callback-related failures remain. I have reviewed the commits and generated architecture, but I have not executed the repository locally.

## Bottom line

The new work changes the verdict significantly:

> **You are no longer building manually maintained Dart wrappers around handwritten shims. You are building a TypeScript-to-Dart React binding compiler.**

The right next step is not another packaging rewrite. It is hardening this compiler around:

```text
package-scoped hook namespaces
typed direct JS return lowering
identity preservation
overloads and generics
one declarative wrapper-generation command
deterministic output
```

That will make the automatic shim emission scalable beyond React Router without turning every hook return into a generic JSON-like structure.
