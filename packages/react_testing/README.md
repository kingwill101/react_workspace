# React Dart Testing (`react_testing`)

Integration and HTTP testing harnesses for React Dart applications — full-stack, SSR, server-function, and component-unit levels.

## Ecosystem Role

`react_testing` provides layered test harnesses so you can choose the right fidelity for each test:

| Harness | Scope | Build Required | Use Case |
|---|---|---|---|
| `ReactTestHarness` | React build output + Node SSR worker | Yes (`react build`) | Fixtures for full-stack tests with any server adapter |
| `ServerFunctionHarness` | Typed registry dispatch + protocol envelopes | No | Unit tests and adapter-composed HTTP tests |
| `SsrTestHarness` | Mock SSR worker + portable `ReactSsrClient` | No | SSR integration tests with any server package |
| `ReactComponentHarness` | In-memory `ReactBinding` + `ReactRenderer` | No | Pure component and hook tests |
| `GeneratorFidelityHarness` | File-system snapshots | No | Verifies generated Web surface completeness |

`react_testing` depends only on the transport-neutral `server_testing` base.
The application test chooses its real adapter:

| Server | Adapter |
|---|---|
| Shelf | `ShelfRequestHandler` from `server_testing_shelf` |
| Routed | `RoutedRequestHandler` from `routed_testing` |

## Installation

Add `react_testing` to your `dev_dependencies`:

```yaml
dev_dependencies:
  react_testing: ^0.1.0
```

Add the adapter for the server being tested alongside `server_testing`:

```yaml
dev_dependencies:
  server_testing: ^0.4.0
  # For Shelf:
  server_testing_shelf: ^0.4.0
  # For Routed, use the same source/ref as routed_core:
  routed_testing:
    git:
      url: https://github.com/kingwill101/routed.git
      ref: master
      path: packages/server_testing/routed_testing
```

## Quick Start

### 1. Full-stack app fixture

```dart
import 'dart:io';
import 'package:react_testing/react_testing.dart';
import 'package:server_testing/server_testing.dart';

void main() {
  late ReactTestHarness harness;
  late TestClient client;

  setUpAll(() async {
    harness = await ReactTestHarness.start(projectRoot: Directory('.'));

    // Build the actual Shelf/Routed application with:
    // - harness.ssrClient
    // - harness.indexTemplate
    // - harness.outputDirectory
    final appHandler = createApplicationUnderTest(harness);
    final requestHandler = adaptServer(appHandler);
    client = harness.createClient(requestHandler);
  });

  tearDownAll(() async {
    await client.close();
    await harness.close();
  });

  test('home page', () async {
    final response = await client.get('/');
    response.assertStatus(200);
    expect(response.body, contains('<div id="app">'));
  });
}
```

### 2. Server-function unit test

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

  });
}
```

For an HTTP contract test, compose `harness.registry` into the real Shelf,
Routed, or other server application. Then pass that server's
`RequestHandler` adapter to `harness.createClient(handler)`. This keeps the
test on the same server implementation used in production.

### 3. SSR worker and document tests

```dart
import 'package:react_testing/react_testing.dart';
import 'package:test/test.dart';

void main() {
  test('mock SSR worker', () async {
    final harness = SsrTestHarness();
    harness.mockRender('<div>SSR</div>', props: {'title': 'Test'});
    final ssr = await harness.start();
    final result = await ssr.render(component: 'app.Root', props: const {});
    expect(result.html, '<div>SSR</div>');
    expect(result.props, {'title': 'Test'});
    await harness.close();
  });

  test('in-memory template helper', () {
    final harness = InMemorySsrHarness(indexTemplate: 'A:{{SSR}}:B:{{PROPS}}');
    final doc = harness.render(renderedHtml: '<p>hi</p>', props: {'x': 1});
    harness.assertDocument(doc, containsHtml: '<p>hi</p>', containsProps: {'x': 1});
  });
}
```

### 4. Component / hook test

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
- `createClient(handler, mode: …)` — wraps the concrete server adapter selected by the test
- `dispatch<TArgs,TResult>(ref, args, context)` — typed direct dispatch without HTTP
- `expectFailure(ref, args, code)` — asserts `ServerFunctionFailure`
- `envelope(ref, args)` / `staleEnvelope(ref, args)` — envelope helpers
- Extensions `ServerFunctionResponseAssertions` on `TestResponse`: `assertServerFunctionSuccess`, `assertServerFunctionError`, `assertContractMismatch`, `assertUnauthenticated`

### `SsrTestHarness` / `InMemorySsrHarness`

- `SsrTestHarness()` — mock worker with `mockRender(html, props)`, `mockFailure()`, `start()`, `client`, and `close()`
- `createClient(handler, mode: …)` — optional convenience for a composed server application
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
- **Build timeout:** Full builds default to five minutes and can be bounded explicitly with `ReactTestHarness.start(buildTimeout: …)`.
- **Server-function harness:** No build — owns the action registry, direct dispatch, protocol-envelope helpers, and response assertions. The test owns its server application and adapter.
- **SSR harness:** Uses a mock `HttpServer` that serves `{'html','props'}` JSON through a portable `ReactSsrClient`. The test composes that client into its actual server package.
- **Component harness:** Pure-Dart runtime with no `dart:js_interop`, suitable for VM tests.
- **Transport boundary:** `react_testing` depends on `server_testing` only. Shelf tests add `server_testing_shelf`; Routed tests add `routed_testing`.
