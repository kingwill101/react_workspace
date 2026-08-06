# React Dart Testing (`react_testing`)

Integration and HTTP testing harnesses for React Dart applications — full-stack, SSR, server-function, and component-unit levels.

## Ecosystem Role

`react_testing` provides layered test harnesses so you can choose the right fidelity for each test:

| Harness | Scope | Build Required | Use Case |
|---|---|---|---|
| `ReactTestHarness` | Full app (Dart backend + Node SSR worker + static assets) | Yes (`react build`) | End-to-end document + action tests |
| `ServerFunctionHarness` | `ServerFunctionRegistry` + Shelf handler + `server_testing` | No | Unit/integration tests for server functions and codecs |
| `SsrTestHarness` | Mock SSR worker + `ReactServerApp` | No | SSR template / document tests |
| `ReactComponentHarness` | In-memory `ReactBinding` + `ReactRenderer` | No | Pure component and hook tests |
| `GeneratorFidelityHarness` | File-system snapshots | No | Verifies generated Web surface completeness |

All harnesses expose `server_testing` (`TestClient`, `TestResponse` assertions) for fluent HTTP assertions.

## Installation

Add `react_testing` to your `dev_dependencies`:

```yaml
dev_dependencies:
  react_testing:
    path: packages/react_testing
```

Also add `server_testing` if you use HTTP assertions directly:

```yaml
dev_dependencies:
  server_testing: 0.4.0
  server_testing_shelf: 0.4.0
```

## Quick Start

### 1. Full-stack app test (existing)

```dart
import 'dart:io';
import 'package:test/test.dart';
import 'package:react_testing/react_testing.dart';
import 'package:app/actions.registry.g.dart';

void main() {
  late ReactTestHarness harness;

  setUpAll(() async {
    harness = await ReactTestHarness.start(
      projectRoot: Directory('.'),
      rootComponent: 'package:app/lib/app.dart#App',
      registerActions: registerActions,
    );
  });

  tearDownAll(() async => harness.close());

  test('home page', () async {
    final client = harness.createClient();
    final response = await client.get('/');
    expect(response.statusCode, 200);
    expect(await response.readAsString(), contains('<div id="app">'));
  });
}
```

### 2. Server-function unit test (new)

No build required — ideal for testing codec contracts and business logic.

```dart
import 'package:react_actions/react_actions.dart';
import 'package:react_testing/react_testing.dart';
import 'package:test/test.dart';

final greetRef = ServerFunctionRef<({String name}), String>(
  id: ServerFunctionId('app.greet'),
  contractHash: 'sha256:…',
  argumentsCodec: GreetArgsCodec(),
  resultCodec: StringCodec(),
);

void main() {
  test('direct dispatch', () async {
    final harness = ServerFunctionHarness();
    harness.registry.register(greetRef, (args, ctx) => 'Hello ${args.name}');

    final result = await harness.dispatch(greetRef, (name: 'Ada'));
    expect(result, 'Hello Ada');

    // HTTP-level (validates envelope, headers, contract)
    final client = harness.createClient();
    final response = await client.postJson('/__react/actions', harness.envelope(greetRef, (name: 'Ada')));
    response.assertServerFunctionSuccess('Hello Ada');
  });

  test('contract mismatch is rejected', () async {
    final harness = ServerFunctionHarness();
    harness.registry.register(greetRef, (args, ctx) => 'Hi');
    final client = harness.createClient();
    final response = await client.postJson('/__react/actions', harness.staleEnvelope(greetRef, (name: 'Ada')));
    response.assertContractMismatch();
  });
}
```

### 3. SSR document test (new)

```dart
import 'package:react_testing/react_testing.dart';
import 'package:test/test.dart';

void main() {
  test('SSR template', () async {
    final harness = SsrTestHarness(indexTemplate: '<html>{{SSR}} {{PROPS}}</html>');
    harness.mockRender('<div>SSR</div>', props: {'title': 'Test'});
    final app = await harness.start();
    final client = harness.createClient(); // uses SsrTestHarness.createClient() after start
    final response = await client.get('/');
    expect(await response.body, contains('<div>SSR</div>'));
    await harness.close();
  });

  test('in-memory template helper', () {
    final harness = InMemorySsrHarness(indexTemplate: 'A:{{SSR}}:B:{{PROPS}}');
    final doc = harness.render(renderedHtml: '<p>hi</p>', props: {'x': 1});
    harness.assertDocument(doc, containsHtml: '<p>hi</p>', containsProps: {'x': 1});
  });
}
```

### 4. Component / hook test (new)

```dart
import 'package:react/react.dart';
import 'package:react_testing/react_testing.dart';
import 'package:test/test.dart';

void main() {
  test('host node', () {
    final harness = ReactComponentHarness();
    final node = harness.renderDiv(props: {'id': 'main'}, children: [Text('hi')]);
    harness.assertHostNode(node, namespace: 'web', name: 'div');
    harness.assertText(node.children.first, 'hi');
  });

  test('test runtime variants', () {
    final standard = TestRuntimes.standard;
    final browser = TestRuntimes.browser;
    final server = TestRuntimes.server;
    expect(standard.target, ReactRenderTarget.test);
    expect(browser.capabilities.supportsEffects, isTrue);
    expect(server.capabilities.supportsEvents, isFalse);
  });
}
```

### 5. Generator fidelity (existing)

```dart
import 'package:react_testing/react_testing.dart';
import 'package:test/test.dart';
import 'dart:io';

void main() {
  final harness = GeneratorFidelityHarness(workspaceRoot: Directory.current);
  test('manifest is complete', () => harness.assertManifestComplete());
  test('host types cover platform', () => harness.assertHostTypes());
}
```

## Available Harnesses

### `ServerFunctionHarness`

Wraps `ServerFunctionRegistry` and exposes:

- `registry` — the underlying registry
- `createHandler()` / `createClient()` / `createEphemeralClient()` — Shelf + `server_testing` integration
- `dispatch<TArgs,TResult>(ref, args, context)` — typed direct dispatch without HTTP
- `expectFailure(ref, args, code)` — asserts `ServerFunctionFailure`
- `envelope(ref, args)` / `staleEnvelope(ref, args)` — envelope helpers
- Extensions `ServerFunctionResponseAssertions` on `TestResponse`: `assertServerFunctionSuccess`, `assertServerFunctionError`, `assertContractMismatch`, `assertUnauthenticated`

### `SsrTestHarness` / `InMemorySsrHarness`

- `SsrTestHarness(indexTemplate: …)` — mock worker, `mockRender(html, props)`, `mockFailure()`, `start()`, `createClient()`, `handler`, `close()`
- `InMemorySsrHarness(indexTemplate: …)` — `render(html, props)`, `assertDocument(doc, containsHtml, containsProps)`
- Extensions `SsrResponseAssertions` on `TestResponse`: `assertSsrHtml`, `assertPropsContains`, `assertIsHtml`

### `ReactComponentHarness`

- `TestReactBinding` — in-memory state, context, memo, ref, `useId`, `useSyncExternalStore`
- `TestReactRenderer` — captures `lastNode` and `history`
- `ReactComponentHarness(binding, renderer)` — `run`, `renderNode`, `renderDiv`, `assertHostNode`, `assertText`
- Utilities in `assertions.dart`: `ReactNodeAssertions`, `HtmlAssertions`, `ReactCallbackAssertions`, `testComponent`, `testHostNode`

### `TestRuntimes`

Pre-built `ReactRuntime` instances: `standard` (test), `browser` (effects), `server` (SSR).

## Architecture Notes

- **Full-stack harness:** `ReactTestHarness` runs `react build`, parses `bundle_manifest.json`, allocates free ports, and spawns the Node SSR worker (`ssr.entry.mjs`).
- **Server-function harness:** No build — constructs a Shelf pipeline with `createServerActionHandler` and wraps it with `server_testing`.
- **SSR harness:** Uses a mock `HttpServer` that serves `{'html','props'}` JSON, and `ReactServerApp` for template rendering.
- **Component harness:** Pure-Dart runtime with no `dart:js_interop`, suitable for VM tests.
