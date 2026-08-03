The agent is defining the wrong problem.

`dart compile js -O2` already compiles the complete Dart dependency graph into deployable JavaScript, performs tree shaking, and enables additional optimizations including minification. Your client release build and SSR build already use `-O2`. ([Dart][1]) The current foreign pipeline also already creates one browser aggregate and one SSR aggregate, with release minification.

The issue is **not**:

> The main Dart entrypoints are neither bundled nor minified.

The real issue is:

> The Dart and npm/JavaScript graphs are optimized independently, but the final application consists of several separately generated runtime units with no unified target-aware packaging stage and no cross-language dead-code elimination.

Here is the issue definition I would give the agent.

# Target-Aware JavaScript Packaging and Cross-Language Tree Shaking

## Current state

`react_tool` currently has two independent build pipelines.

### Dart pipeline

The browser and SSR Dart entrypoints are compiled using `dart compile js`:

* Browser development: `-O0`
* Browser release: `-O2`
* SSR: `-O2`

The Dart production compiler already performs Dart-aware optimization, tree shaking and minification.

Outputs:

```text
build/
├── client.js
└── ssr.js
```

### Foreign JavaScript pipeline

Generated wrapper shims and npm dependencies are bundled separately:

```text
build/foreign/
├── browser/bundle.mjs
└── ssr/bundle.mjs
```

The browser and SSR foreign graphs are resolved under different platform conditions, and React/ReactDOM stay external to preserve a single runtime instance. This target split is maintained deliberately in `_writeForeignComponents`: each wrapper package declares entries per target (`browser`/`ssr`/`shared`), and only the resolved entry files are aggregated. A wrapper entry that is marked `shared` — or that imports SSR-only code — will leak that code into the browser bundle (see the case study below). Per-target entry selection is a prerequisite for the packaging layer, not something it should invent.

Additional runtime files are generated separately:

```text
build/
├── callback_trampoline.mjs
├── ssr_worker.mjs
├── client.js
├── ssr.js
└── foreign/
    ├── browser/bundle.mjs
    └── ssr/bundle.mjs
```

## Problem

Although each graph is compiled or bundled individually, there is no final application-packaging stage that understands all runtime units for a target.

Consequently:

1. Runtime ordering is encoded manually in `index.html` and `ssr_worker.mjs`.
2. There is no unified output manifest describing entries, chunks, source maps and assets.
3. Source maps are produced independently and are not composed through a final packaging stage.
4. The generated JavaScript bridge is side-effect driven, so bundlers cannot remove registrations that the Dart application never uses.
5. Dart tree shaking and JavaScript tree shaking operate independently. An unused Dart helper may disappear from `client.js`, while its corresponding npm export remains registered in `foreign/browser/bundle.mjs`.
6. The project cannot currently choose a native Rust bundler without replacing code directly inside `ReactBuilder`.
7. Output size, chunk composition and retained foreign exports are not measured or reported.

### Case study: the UMD-inlining regression

Per-target entry selection is not academic. `react_router` originally wired one `shared` shim entry that imported both the browser bindings and `react-router-dom/server` (the SSR-only StaticRouter shim). `react-router-dom` has no `exports` map, so esbuild resolves a `require("react-router-dom")` from the CJS `server.js` subpath through the package `main` field — the **UMD dev build** — and the deduplicated package ends up inlined in the **browser** bundle too. The UMD wrapper calls `require("react")`, which esbuild must keep as a dynamic require:

```text
Uncaught Error: Dynamic require of "react" is not supported
Bad state: Foreign React component not registered: reactRouter.MemoryRouter
```

The fix was to split the wrapper into per-target entries (`browser: react_router_bindings_shim.mjs`, `ssr: react_router_shim.mjs`) so the browser graph resolves the ESM `dist/index.js` and never sees `react-router-dom/server`. The packaging layer must keep this property: browser bundles must not pull in SSR-only modules, and both must resolve React through a single external instance.

## Goal

Introduce a target-aware packaging layer that:

* Preserves `dart compile js` as the Dart compiler and optimizer.
* Bundles the npm and generated-shim module graph.
* Generates explicit browser and SSR bootstrap entries.
* Preserves one React and ReactDOM instance.
* Supports browser and Node conditional exports.
* Emits a deterministic output manifest.
* Supports development source maps and release minification.
* Allows esbuild and Rolldown to be interchangeable bundler backends.
* Eventually removes unused foreign components and hooks based on application usage.

## Non-goals

The packaging layer must not:

* Replace Dart’s optimizer with a generic JavaScript minifier.
* parse Dart source as JavaScript before Dart compilation.
* assume that another JavaScript bundler can improve Dart-specific tree shaking.
* merge browser and SSR package-resolution conditions.
* bundle multiple React copies.
* require the application to maintain npm entry files manually.

## Recommended pipeline

```text
Dart source
    ↓
dart compile js
    ├── client.js  (-O0 dev / -O2 release)
    └── ssr.js     (-O2)

npm .d.ts
    ↓
Rust + oxc declaration extraction
    ↓
generated Dart bindings + generated JS bridges
    ↓
Rolldown or esbuild
    ├── foreign/browser/bundle.mjs
    └── foreign/ssr/bundle.mjs

Generated bootstraps
    ├── browser.entry.mjs   (sets globalThis.React, then imports trampoline/foreign/client)
    └── ssr.entry.mjs       (sets globalThis.React, imports trampoline/foreign/ssr.js)
        └── ssr_runtime.mjs (HTTP worker + error-boundary fallback)
```

Browser bootstrap:

```javascript
import './callback_trampoline.mjs';
import './foreign/browser/bundle.mjs';
import './client.js';
```

SSR bootstrap:

```javascript
import React from 'react';
import ReactDOMServer from 'react-dom/server';

globalThis.React = React;

await import('./callback_trampoline.mjs');
await import('./foreign/ssr/bundle.mjs');
await import('./ssr.js');

// Start the HTTP worker after all registrations exist.
await import('./ssr_runtime.mjs');
```

Initially, these bootstraps can remain small orchestration modules. You should not expect rebundling `client.js` to produce major size savings: Dart has already optimized it. Including it in a final bundle would mainly reduce artifact count, not perform meaningful additional Dart dead-code elimination.

## Use Rolldown—not raw Oxc—as the bundler

Oxc provides the parser, resolver, transformer and related compiler infrastructure. Rolldown is the actual module bundler built on Oxc and supports ESM/CJS resolution, platform handling, tree shaking, code splitting and plugin-style resolution. It also exposes a Rust crate, so it can fit your existing native code-asset architecture. ([GitHub][2])

I would introduce an abstraction first:

```dart
abstract interface class JavaScriptBundler {
  Future<BundleResult> bundle(BundleRequest request);
}

final class BundleRequest {
  final String target;
  final List<String> entries;
  final String outputDirectory;
  final List<String> externals;
  final List<String> conditions;
  final bool minify;
  final bool sourceMaps;
  final String npmRoot;
}
```

Then provide:

```text
EsbuildBundler
RolldownBundler
```

Do not wire Rolldown directly throughout `ReactBuilder`. Rolldown is evolving, and parts of its higher-level API remain marked experimental, so pin its version and contain it behind your own stable request/response contract. ([Rolldown][3])

The Rust FFI should remain coarse-grained:

```dart
final resultJson = nativeBundle(
  jsonEncode({
    'platform': 'browser',
    'entries': [...],
    'externals': ['react', 'react-dom'],
    'conditions': ['browser', 'production'],
    'minify': true,
    'sourceMaps': false,
  }),
);
```

Avoid passing resolver or plugin callbacks repeatedly across FFI.

## The real tree-shaking problem

The original generated shim registered everything through a namespace import:

```javascript
import * as Router from 'react-router-dom';

globalThis.__reactDartBindings.reactRouter = {
  BrowserRouter: Router.BrowserRouter,
  MemoryRouter: Router.MemoryRouter,
  Route: Router.Route,
  useLocation: Router.useLocation,
  useNavigate: Router.useNavigate,
  useParams: Router.useParams,
};
```

Every property assignment is observable. The bundler therefore considers every referenced export used.

Even if Dart removes the unused `useParams()` helper, JavaScript still registers `Router.useParams`.

That is the missing **cross-language reachability** step:

```text
Dart tree shaking knows which Dart helpers survive.
JS bundling knows which JS imports appear.
Neither side currently communicates that information.
```

`generateShim()` now emits individual named imports (aliased `__reactDart<Name>`) for only the referenced declarations:

```javascript
import {
  Route as __reactDartRoute,
  useLocation as __reactDartUseLocation,
  useNavigate as __reactDartUseNavigate,
} from 'react-router-dom';

registerComponent('reactRouter.Route', __reactDartRoute);
registerHook('reactRouter.useLocation', __reactDartUseLocation);
registerHook('reactRouter.useNavigate', __reactDartUseNavigate);
```

However, direct imports alone are insufficient if every registration is still emitted. To get application-level tree shaking, the builder eventually needs a usage manifest:

```json
{
  "browser": {
    "components": [
      "reactRouter.MemoryRouter",
      "reactRouter.Routes",
      "reactRouter.Route",
      "reactRouter.Link"
    ],
    "hooks": [
      "reactRouter.useLocation",
      "reactRouter.useNavigate"
    ]
  }
}
```

Then the aggregate entry only imports those exports.

**Status:** the builder now emits this data. Each target in `bundle_report.json` carries `usedComponents` (component keys whose quoted literal survives in the compiled `client.js`/`ssr.js` Dart output) and `usedHooks` (`<namespace>.<hook>` paths the compiled output actually calls). `dart compile js` keeps these string-literal component keys and JS-interop hook paths intact while tree-shaking unused helpers, so the scan reports what the application truly renders per target — without importing the whole namespace.

The usage manifest is **per target**. The `ssr` target is a superset of the browser target (e.g. it additionally needs `reactRouter.StaticRouter` from `react-router-dom/server`), so the manifest is keyed by target and the packaging layer consumes whichever the current build is producing:

```json
{
  "browser": {
    "components": ["reactRouter.MemoryRouter", "reactRouter.Routes"],
    "hooks": ["reactRouter.useLocation", "reactRouter.useNavigate"]
  },
  "ssr": {
    "components": ["reactRouter.StaticRouter", "reactRouter.MemoryRouter"],
    "hooks": []
  }
}
```

Do that in stages:

1. **Wrapper-level pruning:** only generate exports explicitly selected in `react_bindings.yaml`.
2. **Application-level pruning:** generate or infer a target-specific usage manifest (browser and SSR lists are generated separately, SSR as a superset).
3. **Bundle-level pruning:** Rolldown removes unused transitive npm code.

## Implementation order

1. Add bundle reporting before changing bundlers:

   * artifact count,
   * uncompressed size,
   * gzip/Brotli size,
   * retained wrapper exports,
   * external packages,
   * source-map size.

2. Introduce `JavaScriptBundler` with the current esbuild implementation behind it.

3. Add a Rolldown backend using the native Rust code asset.

4. Generate explicit browser and SSR bootstrap modules.

5. Emit a deterministic `bundle_manifest.json`:

```json
{
  "browser": {
    "entry": "browser.entry.mjs",
    "dart": "client.js",
    "foreign": "foreign/browser/bundle.mjs"
  },
  "ssr": {
    "entry": "ssr.entry.mjs",
    "dart": "ssr.js",
    "foreign": "foreign/ssr/bundle.mjs",
    "runtime": "ssr_runtime.mjs"
  }
}
```

6. Replace wildcard imports in generated shims with named imports. ✅ `generateShim()` now emits named imports.

7. Add target-specific foreign usage data. ✅ `bundle_report.json` per-target `usedComponents`/`usedHooks` from a scan of the compiled Dart output.

8. Apply that usage data to the aggregate entry: prune each generated wrapper shim to its used component/hook subset (and materialize pruned copies of aggregator wrappers), so Rolldown tree-shakes the unused rest of the npm package. ✅ `parseForeignShim`/`pruneShim` rewrite the generated shim template structurally; project-level `foreign.components` are dropped when the key never appears in the target's compiled output. Example release build: browser 32.8 → 22.7 KiB, SSR 156.3 → 149.6 KiB (server_boot_test green against the pruned bundles).

9. Only after measuring, decide whether physically inlining `client.js` and `ssr.js` into final bundles is worthwhile.

## Bottom line

Your current foreign bundling is already structurally sound. Your Dart output is already optimized in release mode. The next bundling work should focus on:

```text
target-aware final packaging
bundler backend abstraction
Rust/Rolldown integration
output manifests
source-map handling
cross-language usage tracking
foreign component and hook DCE
```

It should **not** begin by treating `client.js` and `ssr.js` as unoptimized JavaScript that Oxc needs to fix.

[1]: https://dart.dev/tools/dart-compile?utm_source=chatgpt.com "dart compile"
[2]: https://github.com/rolldown/rolldown?utm_source=chatgpt.com "GitHub - rolldown/rolldown: Fast Rust bundler for JavaScript/TypeScript with Rollup-compatible API. · GitHub"
[3]: https://rolldown.rs/apis/bundler-api?utm_source=chatgpt.com "Bundler API | Rolldown"










The best implementation beginning is **not Rolldown yet**. First refactor the existing esbuild path behind a stable bundler interface, without changing output behavior.

That gives you a safe baseline before adding Rust.

## First implementation milestone

```text
Current:
ReactBuilder
    └── _bundleTarget()
          └── launches esbuild directly

First refactor:
ReactBuilder
    └── JavaScriptBundler
          └── EsbuildBundler

Later:
ReactBuilder
    └── JavaScriptBundler
          ├── EsbuildBundler
          └── RolldownBundler
```

Your current `_compile()` should remain responsible for `dart compile js`, while `_bundleTarget()` becomes a call to the selected JavaScript bundler.

# 1. Introduce bundler models

Create:

```text
packages/react_tool/lib/src/bundler/
├── bundler.dart
├── bundle_request.dart
├── bundle_result.dart
└── esbuild_bundler.dart
```

```dart
// bundler/bundle_request.dart

enum JavaScriptTarget {
  browser,
  node,
}

final class BundleRequest {
  final String name;
  final JavaScriptTarget target;
  final List<String> entryPoints;
  final String outputFile;
  final String workingDirectory;
  final String npmRoot;
  final List<String> externals;
  final List<String> conditions;
  final bool minify;
  final bool sourceMaps;

  const BundleRequest({
    required this.name,
    required this.target,
    required this.entryPoints,
    required this.outputFile,
    required this.workingDirectory,
    required this.npmRoot,
    required this.externals,
    required this.conditions,
    required this.minify,
    required this.sourceMaps,
  });
}
```

```dart
// bundler/bundle_result.dart

final class BundleResult {
  final String outputFile;
  final int outputBytes;
  final Duration duration;
  final List<String> inputs;
  final List<String> warnings;

  const BundleResult({
    required this.outputFile,
    required this.outputBytes,
    required this.duration,
    required this.inputs,
    required this.warnings,
  });
}
```

```dart
// bundler/bundler.dart

abstract interface class JavaScriptBundler {
  String get name;

  Future<BundleResult> bundle(
    BundleRequest request,
  );
}
```

# 2. Move the existing esbuild logic

Your existing `_bundleTarget()` already prepares the correct high-level options:

* Browser versus Node platform.
* React externals.
* Development versus production conditions.
* Release minification.
* Development source maps.

Move that process-launching code into `EsbuildBundler`.

```dart
// bundler/esbuild_bundler.dart

import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

import '../errors.dart';
import '../js_environment.dart';
import 'bundle_request.dart';
import 'bundle_result.dart';
import 'bundler.dart';

final class EsbuildBundler
    implements JavaScriptBundler {
  final JsEnvironment environment;

  EsbuildBundler({
    required this.environment,
  });

  @override
  String get name => 'esbuild';

  @override
  Future<BundleResult> bundle(
    BundleRequest request,
  ) async {
    final stopwatch = Stopwatch()..start();

    final esbuildEntry =
        await environment.esbuildEntry();

    final driver = File(
      p.join(
        environment.root.path,
        'esbuild_driver.mjs',
      ),
    );

    await driver.parent.create(
      recursive: true,
    );

    await driver.writeAsString(
      _esbuildDriver,
    );

    final options = <String, Object?>{
      'entryPoints': request.entryPoints,
      'outfile': request.outputFile,
      'bundle': true,
      'format': 'esm',
      'platform':
          request.target ==
              JavaScriptTarget.node
          ? 'node'
          : 'browser',
      if (request.target ==
          JavaScriptTarget.node)
        'target': ['node20'],
      'external': request.externals,
      'conditions': request.conditions,
      'minify': request.minify,
      'sourcemap':
          request.sourceMaps
          ? 'linked'
          : false,
      'metafile': true,
      'logLevel': 'silent',
      'absWorkingDir':
          request.workingDirectory,
      'nodePaths': [request.npmRoot],
    };

    final result = await Process.run(
      'node',
      [
        driver.path,
        esbuildEntry.path,
        jsonEncode(options),
      ],
      workingDirectory:
          request.workingDirectory,
      environment: {
        ...Platform.environment,
        'REACT_NPM_ROOT':
            request.npmRoot,
      },
    );

    if (result.exitCode != 0) {
      throw ReactToolException(
        '${request.name} bundle failed '
        'with esbuild:\n${result.stderr}',
      );
    }

    final output = File(
      request.outputFile,
    );

    if (!await output.exists()) {
      throw ReactToolException(
        'esbuild completed but did not '
        'produce ${request.outputFile}.',
      );
    }

    stopwatch.stop();

    final response = jsonDecode(
      result.stdout as String,
    ) as Map<String, dynamic>;

    return BundleResult(
      outputFile: output.path,
      outputBytes:
          await output.length(),
      duration: stopwatch.elapsed,
      inputs: [
        for (final input
            in response['inputs']
                as List<dynamic>? ??
                const [])
          input as String,
      ],
      warnings: [
        for (final warning
            in response['warnings']
                as List<dynamic>? ??
                const [])
          warning as String,
      ],
    );
  }
}
```

Update the Node driver to print structured JSON after building:

```javascript
const result = await build(opts);

console.log(JSON.stringify({
  inputs: Object.keys(
    result.metafile?.inputs ?? {}
  ),
  outputs: Object.keys(
    result.metafile?.outputs ?? {}
  ),
  warnings: result.warnings.map(
    warning => warning.text
  )
}));
```

Preserve the driver's target-specific external handling. Today the driver only installs its `react-node-externals` plugin for the node platform: it rewrites external bare specifiers (`react`, `react-dom`, and any wrapper-declared externals) to absolute paths through the npm root so the worker never depends on a `node_modules` walk-up. The browser target keeps those specifiers as bare externals, which the browser resolves via the `index.html` importmap. `EsbuildBundler` must keep this split — a browser build that rewrites `react` to an absolute path would break the single-instance guarantee.

# 3. Inject the bundler into `ReactBuilder`

```dart
final class ReactBuilder {
  final ReactProjectConfig config;
  final bool release;
  final void Function(String message) log;

  JavaScriptBundler? _bundler;

  // ...
}
```

After preparing the environment:

```dart
Future<void> build() async {
  final jsEnvironment =
      await _prepareJsEnvironment();

  if (jsEnvironment != null) {
    _bundler = EsbuildBundler(
      environment: jsEnvironment,
    );
  }

  // Existing build flow...
}
```

Then simplify `_bundleTarget()`:

```dart
Future<BundleResult> _bundleTarget({
  required JsEnvironment? environment,
  required String target,
  required String entry,
  required String outfile,
}) async {
  final bundler = _bundler;

  if (environment == null ||
      bundler == null) {
    throw const ReactToolException(
      'JavaScript bundling requires a '
      'configured JS environment.',
    );
  }

  final result = await bundler.bundle(
    BundleRequest(
      name: 'foreign-$target',
      target: target == 'ssr'
          ? JavaScriptTarget.node
          : JavaScriptTarget.browser,
      entryPoints: [entry],
      outputFile: outfile,
      workingDirectory:
          config.root.path,
      npmRoot: environment.npmRoot,
      externals:
          await _mergedExternals(),
      conditions: [
        release
            ? 'production'
            : 'development',
      ],
      minify: release,
      sourceMaps: !release,
    ),
  );

  log(
    'Bundled ${result.outputFile} '
    '(${_formatBytes(result.outputBytes)}, '
    '${result.duration.inMilliseconds} ms)',
  );

  return result;
}
```

```dart
String _formatBytes(int bytes) {
  if (bytes < 1024) return '$bytes B';

  final kib = bytes / 1024;

  if (kib < 1024) {
    return '${kib.toStringAsFixed(1)} KiB';
  }

  return '${(kib / 1024).toStringAsFixed(1)} MiB';
}
```

This first change should produce exactly the same bundles as today.

# 4. Generate explicit target bootstraps

Do this before attempting to bundle `client.js` itself.

## Browser bootstrap

The current `index.html` carries three runtime responsibilities that the entry must absorb without losing:

1. An **importmap** pinning the resolved React/ReactDOM versions (e.g. `https://esm.sh/react@18.3.1`) — this must stay in `index.html` because bare `react`/`react-dom` specifiers are resolved by the browser, not by esbuild.
2. An inline module that sets `globalThis.React` / `globalThis.ReactDOM` before any shim or Dart code runs.
3. Three module script tags (`callback_trampoline.mjs`, `foreign/browser/bundle.mjs`, `client.js`).

Generate one entry that preserves order 2 before 3:

```javascript
// build/browser.entry.mjs

import React from 'react';
import ReactDOM from 'react-dom/client';

globalThis.React = React;
globalThis.ReactDOM = ReactDOM;

await import('./callback_trampoline.mjs');
await import('./foreign/browser/bundle.mjs');
await import('./client.js');
```

The trampoline/foreign/client must be **dynamic** imports: ES module semantics hoist static imports and evaluate them before the importing module's body runs, which would evaluate the foreign graph and `client.js` with `globalThis.React` still unset. Dynamic imports preserve the old inline-bootstrap ordering (globals first, then registrations, then the Dart app). This was the regression that produced a broken hydration pass with static imports.

Then `index.html` only needs the importmap plus one script tag:

```html
<script type="importmap">{"imports":{"react":"https://esm.sh/react@18.3.1","react-dom":"https://esm.sh/react-dom@18.3.1","react-dom/":"https://esm.sh/react-dom@18.3.1/"}}</script>
<script type="module" src="browser.entry.mjs"></script>
```

The importmap must precede the entry because module scripts resolve bare specifiers at fetch time. `_writeBrowserRuntime` (which currently injects the three tags into the static `index.html` and pins the importmap to the resolved React version) is replaced by `_writeBrowserEntry`, which writes the entry and keeps the importmap pinning logic:

```dart
Future<void> _writeBrowserEntry({
  required bool hasForeignBundle,
  required String? reactVersion,
}) async {
  final output = config.directory(
    config.outputDirectory,
  );

  final buffer = StringBuffer()
    ..writeln(
      '// Generated by react_tool.',
    )
    ..writeln(
      "import React from 'react';",
    )
    ..writeln(
      "import ReactDOM from 'react-dom/client';",
    )
    ..writeln()
    ..writeln('globalThis.React = React;')
    ..writeln('globalThis.ReactDOM = ReactDOM;')
    ..writeln()
    ..writeln(
      "await import('./callback_trampoline.mjs');",
    );

  if (hasForeignBundle) {
    buffer.writeln(
      "await import('./foreign/browser/bundle.mjs');",
    );
  }

  buffer.writeln(
    "await import('./client.js');",
  );

  await File(
    p.join(
      output.path,
      'browser.entry.mjs',
    ),
  ).writeAsString(
    buffer.toString(),
  );

  // Then update index.html: rewrite the importmap versions to
  // [reactVersion] and replace the inline React bootstrap + the three
  // module tags with a single browser.entry.mjs tag.
}
```

The foreign shims and `client.js` both read `globalThis.React`, so the entry must set it before importing them; the `await import(...)` ordering above guarantees that.

## SSR bootstrap

Today `ssr_worker.mjs` is a single module: it imports React, the trampoline, the foreign bundle, and `ssr.js`, then starts the HTTP server that receives `{component, props}` and calls `__REACT_RENDER__` (with a fallback pass that swaps the first Dart `ErrorBoundary` for its fallback). Split the HTTP implementation from the bootstrap, preserving both the server and the fallback boundary logic in the runtime module:

```text
ssr.entry.mjs
ssr_runtime.mjs
```

```javascript
// ssr.entry.mjs

import React from 'react';
import ReactDOMServer from 'react-dom/server';

globalThis.React = React;
globalThis.ReactDOMServer =
  ReactDOMServer;

await import(
  './callback_trampoline.mjs'
);

await import(
  './foreign/ssr/bundle.mjs'
);

await import('./ssr.js');
await import('./ssr_runtime.mjs');
```

This gives you one explicit entry module per target without forcing the Dart compiler output through another minifier.

# 5. Emit a bundle manifest

After building:

```json
{
  "schema": 1,
  "bundler": "esbuild",
  "mode": "release",
  "browser": {
    "entry": "browser.entry.mjs",
    "dart": "client.js",
    "foreign": "foreign/browser/bundle.mjs",
    "bytes": {
      "dart": 174382,
      "foreign": 42116
    }
  },
  "ssr": {
    "entry": "ssr.entry.mjs",
    "dart": "ssr.js",
    "foreign": "foreign/ssr/bundle.mjs",
    "runtime": "ssr_runtime.mjs",
    "bytes": {
      "dart": 203817,
      "foreign": 48822
    }
  }
}
```

Model:

```dart
final class ReactBundleManifest {
  final int schema;
  final String bundler;
  final String mode;
  final TargetBundleManifest?
      browser;
  final TargetBundleManifest? ssr;

  const ReactBundleManifest({
    this.schema = 1,
    required this.bundler,
    required this.mode,
    this.browser,
    this.ssr,
  });

  Map<String, Object?> toJson() => {
    'schema': schema,
    'bundler': bundler,
    'mode': mode,
    if (browser != null)
      'browser': browser!.toJson(),
    if (ssr != null)
      'ssr': ssr!.toJson(),
  };
}
```

This is the foundation for:

* Build reporting.
* Cache invalidation.
* Dev server loading.
* Deployment tooling.
* A future Rolldown backend.
* Source-map discovery.

# 6. Do not bundle `client.js` in the first phase

For the first implementation, retain:

```text
browser.entry.mjs
├── callback_trampoline.mjs
├── foreign/browser/bundle.mjs
└── client.js
```

The browser still downloads modules separately, but you now have a coherent target entry.

Later, test bundling that bootstrap through esbuild:

```dart
BundleRequest(
  name: 'browser-application',
  target: JavaScriptTarget.browser,
  entryPoints: [
    'build/browser.entry.mjs',
  ],
  outputFile:
      'build/app.browser.mjs',
  // ...
)
```

But measure it first.

Potential problems include:

* Dart compiler output format.
* Generated source maps.
* Deferred imports.
* Global initialization order.
* Code that assumes it executes as a classic script rather than ESM.
* Re-minification of already optimized Dart output.

Treat a final combined bundle as an optional packaging mode:

```yaml
react:
  bundling:
    combineDartOutput: false
```

# 7. Add Rolldown only after the abstraction is green

The second implementation becomes straightforward:

```dart
final class RolldownBundler
    implements JavaScriptBundler {
  final ReactNativeBindings native;

  RolldownBundler({
    required this.native,
  });

  @override
  String get name => 'rolldown';

  @override
  Future<BundleResult> bundle(
    BundleRequest request,
  ) async {
    final requestJson =
        jsonEncode({
      'entryPoints':
          request.entryPoints,
      'outputFile':
          request.outputFile,
      'platform':
          request.target.name,
      'externals':
          request.externals,
      'conditions':
          request.conditions,
      'minify':
          request.minify,
      'sourceMaps':
          request.sourceMaps,
      'npmRoot':
          request.npmRoot,
    });

    final responseJson =
        native.bundle(requestJson);

    final response =
        jsonDecode(responseJson)
            as Map<String, dynamic>;

    if (response['ok'] != true) {
      throw ReactToolException(
        response['error'] as String,
      );
    }

    return BundleResult(
      outputFile:
          response['outputFile']
              as String,
      outputBytes:
          response['outputBytes']
              as int,
      duration: Duration(
        milliseconds:
            response['durationMs']
                as int,
      ),
      inputs: List<String>.from(
        response['inputs']
            as List<dynamic>,
      ),
      warnings: List<String>.from(
        response['warnings']
            as List<dynamic>,
      ),
    );
  }
}
```

Configuration:

```yaml
react:
  bundling:
    backend: esbuild
```

Later:

```yaml
react:
  bundling:
    backend: rolldown
```

# First PR scope

Keep the first implementation narrow:

1. Add `JavaScriptBundler`.
2. Move existing esbuild logic into `EsbuildBundler`.
3. Preserve current output byte-for-byte where possible.
4. Enable esbuild metafiles.
5. Log output size and duration.
6. Add `browser.entry.mjs` (absorbs the inline `globalThis.React` bootstrap; the importmap stays in `index.html`) and split `ssr_worker.mjs` into `ssr.entry.mjs` + `ssr_runtime.mjs`.
7. Emit `bundle_manifest.json`.
8. Add snapshot tests for browser and SSR requests.

Do **not** include in that PR:

* Rolldown.
* Cross-language usage manifests.
* Combining Dart and foreign bundles.
* Hook bridge redesign.
* Code splitting.
* Automatic chunk loading.

That first step gives you a stable seam. Everything more ambitious becomes an implementation of `JavaScriptBundler` or a consumer of `BundleResult`, rather than another large rewrite inside `ReactBuilder`.
