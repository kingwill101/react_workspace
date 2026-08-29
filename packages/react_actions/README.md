# React Dart Server Actions (`react_actions`)

Shared annotations and client transport for React Dart server functions.

## Ecosystem Role

Provides the foundational `@serverFunction` and `@serverData` annotations for declaring RPC contracts between your browser client and Dart server. It also provides `ServerFunctionClient`, the transport abstraction used to execute those contracts seamlessly across the network.

## Installation

Add `react_actions` to your `dependencies`:

```yaml
dependencies:
  react_actions: ^0.1.0
```

## How to Use

### Annotating Data and Functions

Mark your data classes with `@serverData` to make them transmittable across the wire. Ensure they contain only final fields and supported types (primitives, Lists, Maps, DateTimes, Uris, and other `@serverData` classes).

```dart
import 'package:react_actions/react_actions.dart';

@serverData
final class ToggleTodoResult {
  final String id;
  final bool completed;

  const ToggleTodoResult({
    required this.id,
    required this.completed,
  });
}

@serverFunction
Future<ToggleTodoResult> toggleTodo(
  ServerFunctionContext context, {
  required String todoId,
  required bool completed,
}) async {
  // Perform server-only logic, database updates, etc.
  return ToggleTodoResult(id: todoId, completed: completed);
}
```

The first argument to a `@serverFunction` must always be `ServerFunctionContext`. Subsequent parameters must be named and required. 

Run `react build` (via `react_tool`) to generate the networking stubs.

### Invoking Functions

On the client side, you don't invoke the HTTP endpoint manually. The generated client proxy handles invoking the `ServerFunctionClient` (e.g. `HttpServerFunctionClient` in the browser) automatically using the generated strong-typed reference.

## Architecture & Protocol

The package currently supports two wire representations. JSON (`application/vnd.react.dart.action+json`, protocol version 1) remains the compatibility representation used by the existing HTTP client. New transports can use the compact version 2 frame format from `ReactFrame`.
Requests encapsulate protocol versioning, generated action IDs, and argument payloads:

```json
{
  "protocol": 1,
  "id": "myPackage:lib/actions.dart#toggleTodo",
  "arguments": { "todoId": "123", "completed": true }
}
```

Responses similarly follow an envelope pattern to handle standard results and structured errors (`ServerFunctionResponse` / `ServerFunctionError`).

Codec generation (`react_codegen`) uses these abstractions to ensure types like `DateTime` and `@serverData` instances remain perfectly symmetric across the browser and server boundaries.

### Compact frames

Version 2 uses a small binary header and a CBOR payload:

```dart
import 'package:react_actions/react_actions.dart';

final request = ReactFrame(
  kind: ReactMessageKind.invoke,
  actionId: 42, // numeric ID from the generated build manifest
  requestId: 1001,
  payload: {'todoId': '123', 'completed': true},
);

final bytes = request.encode();
final decoded = ReactFrame.decode(bytes);
```

Only numeric, build-scoped IDs are sent in the frame. Do not derive IDs from
untrusted user input or use them as an authorization decision: the transport
must still authenticate the request, enforce origin policy, check the build
manifest, and authorize the action on the server. The frame codec enforces a
one-megabyte payload limit, rejects malformed varints and trailing bytes, and
accepts only JavaScript-safe numeric identifiers.

`ReactFrame` is the framing layer, not an HTTP client. Routed and Shelf
adapters should select the content type and add their own authentication,
CSRF/origin, replay, and authorization checks before exposing a compact action
endpoint. The existing JSON protocol remains the migration and fallback path.
