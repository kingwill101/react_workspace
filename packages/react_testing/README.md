# React Dart Testing (`react_testing`)

Integration and HTTP testing harness for React Dart applications.

## Ecosystem Role

`react_testing` boots a full React Dart application—including the Dart backend, Node SSR worker, and static file server—in an isolated test harness. It allows you to run robust integration assertions against real HTTP output, or to connect an in-memory `shelf` test client to simulate user requests efficiently.

## Installation

Add `react_testing` to your `dev_dependencies`:

```yaml
dev_dependencies:
  react_testing:
    path: packages/react_testing
```

## How to Use

Use `ReactTestHarness` to start your application inside a test group.

```dart
import 'dart:io';
import 'package:test/test.dart';
import 'package:react_testing/react_testing.dart';

// Import generated server actions registry
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

  tearDownAll(() async {
    await harness.close();
  });

  test('application renders home page', () async {
    // Create an in-memory test client to avoid network overhead
    final client = harness.createClient();
    final response = await client.get('/');
    
    expect(response.statusCode, 200);
    expect(await response.readAsString(), contains('<div id="app">'));
  });
}
```

## Architecture Notes

- **Harness Orchestration:** The `ReactTestHarness` automatically runs `react build` behind the scenes, parses the `bundle_manifest.json` from the output directory, allocates free networking ports, and spawns the node-based SSR worker process (`ssr.entry.mjs`). 
- **Server Application:** It constructs a complete `ReactServerApp` combining the static handler, SSR client, and `ServerFunctionRegistry`. 
- **Test Client:** You can extract `harness.baseUrl` to test with Selenium/Puppeteer, or use `harness.createClient()` which yields a `TestClient` (from `server_testing`) bound directly to the application's shelf pipeline for rapid, network-free endpoint testing.
