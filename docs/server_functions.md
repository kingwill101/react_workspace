# Server Functions: Architecture & Design

## Overview

Server functions allow a browser-side React component to call a function that executes exclusively on the server — a typed RPC pattern analogous to tRPC, server actions, or LiveView event handlers.

The server function system is **separate from SSR rendering**:

| Concern | Process | Output |
|---------|---------|--------|
| SSR rendering | Node.js SSR worker (port 3001) | HTML |
| Server functions | Shelf/Dart (port 8080, route `/__react/actions`) | JSON |

Server functions run in the same Shelf process as page rendering. The SSR worker is a separate Node.js process because it needs `ReactDOMServer` (JavaScript APIs). Server functions have no such constraint — they run as native Dart, with full access to `package:postgres`, `dart:io`, and the rest of the Dart ecosystem.

The native host is standardized by `ReactServerApp` in `react_server`. It owns the
framework routes while applications provide the static handler, action registry,
and optional SSR worker configuration.

### Protocol direction

Next.js uses an action ID in the `Next-Action` header and uses the React Flight
stream when an action also causes a route render. We follow the useful part of
that design without coupling React Dart to Next's private Flight wire format:

- `X-React-Action` identifies the generated function.
- `X-React-Action-Contract` identifies the generated codec contract.
- `X-React-Protocol` identifies the protocol version.
- The versioned JSON envelope remains the canonical request and response body.
- HTML SSR and action responses remain separate until we have a Dart-native
  Flight/RSC implementation.

This gives proxies and observability tools routable metadata while preserving a
stable, typed protocol that can later support content negotiation for a combined
action-plus-render response.

---

## 1. Package Architecture

### New package: `react_actions`

The browser-safe protocol lives in a new `react_actions` package — not in `react_server`, because `react_server` may later become VM-only.

`react_actions` has **no dependency on `react`**, `react_web`, `react_server`, or `react_js`. It is a standalone protocol package.

```
react_actions                ← browser-safe protocol
├── @serverFunction          ← annotation
├── @serverData              ← annotation for contract types
├── ServerFunctionId
├── ServerFunctionRef<TArgs, TResult>
├── ServerFunctionJsonCodec<T>
├── ServerFunctionClient     ← abstract transport interface
├── ServerFunctionException  ← hierarchy (remote, transport, failure)
├── protocol request/response envelope types
└── currentServerFunctionClient accessor
         (reads from ReactRuntime)

react_server                 ← server-only concerns
├── ServerFunctionContext    ← request-scoped context
├── ServerFunctionRegistry
├── ServerFunctionFailure    ← deliberate server-side failure
├── same-origin Shelf handler
├── authentication integration
└── dispatch with cancellation/timeout

react_web                    ← browser-only
└── HttpServerFunctionClient  (via package:http)

react_codegen                ← generator
├── shared ref/codec generation (*.action.g.dart)
├── client proxy generation (*.client.g.dart)
├── server registry generation (*.registry.g.dart)
├── contract validation
└── contract hash generation
```

### Dependency graph

```
react_web ───────▶ react_actions

react_server ────▶ react_actions

application client
    └────────────▶ todos.client.g.dart
                       └──────▶ todos.action.g.dart
                                    └──────▶ react_actions
                                    └──────▶ todos_contract.dart

application server
    └────────────▶ todos.registry.g.dart
                       ├──────▶ todos.action.g.dart
                       ├──────▶ todos.server.dart
                       │           ├──────▶ react_actions
                       │           ├──────▶ react_server
                       │           └──────▶ todos_contract.dart
                       └──────▶ react_server
```

### Generated file layout

```
lib/actions/
├── todos_contract.dart        ← @serverData types (browser-safe)
├── todos.server.dart          ← @serverFunction implementation (server-only deps)
├── todos.action.g.dart        ← GENERATED shared ref + codecs (imported by both sides)
├── todos.client.g.dart        ← GENERATED browser proxy (imports .action.g.dart)
└── todos.registry.g.dart      ← GENERATED per-file server registration

server_actions.g.dart          ← GENERATED package-level registration entrypoint
```

The aggregate builder emits `server_actions.g.dart`, so a native server only
needs one generated import and one registration call:

```dart
import 'package:examples/ssr/server_actions.g.dart';

registerServerActions(registry: registry);
```

---

## 2. Contract Types: `@serverData`

**Do not inline-copy result classes into the generated proxy.** A generated copy is a different nominal Dart type — the registry cannot return `server.ToggleTodoResult` where `generated.ToggleTodoResult` is expected without an explicit mapping. This creates drift risk, breaks type identity, and fails for nested or complex types.

Instead, put transport types in a browser-safe contract file:

```dart
// lib/actions/todos_contract.dart

import 'package:react_actions/react_actions.dart';

/// Serializable result type shared between client and server.
@serverData
final class ToggleTodoResult {
  final String id;
  final bool completed;

  const ToggleTodoResult({
    required this.id,
    required this.completed,
  });
}
```

The `@serverData` annotation marks this type as part of the public contract. The generator validates the type against strict Phase 1 requirements.

### Phase 1 `@serverData` requirements

Only the following shape is accepted:

- `final class` (not `abstract`, `sealed`, `base`, `interface`, `mixin`)
- No type parameters
- No superclass other than `Object`
- No mixins
- No cyclic references (type A's fields do not reference type A, directly or transitively)
- All instance fields are `final` and public
- Exactly one public generative constructor
- Constructor parameter names and types match the serialized fields
- All field types are supported (primitives, records, other `@serverData` types, `List<T>`, `Map<String, V>`, `DateTime`, `Uri`, enums)

Valid:

```dart
@serverData
final class ToggleTodoResult {
  final String id;
  final bool completed;

  const ToggleTodoResult({
    required this.id,
    required this.completed,
  });
}
```

Rejected:

```dart
@serverData
class Result<T> extends BaseResult {
  // Generic and inherited — rejected.
}

@serverData
final class Result {
  final String id;
  // No matching constructor — rejected.
}
```

The generator validates the entire import closure — not just direct imports — for unsupported platform libraries (native-only dependencies).

### Record type alternative

Record types don't need a contract file — they are anonymous and self-describing:

```dart
@serverFunction
Future<({String id, bool completed})> toggleTodo(
  ServerFunctionContext context, {
  required String todoId,
  required bool completed,
}) async {
  final todo = await todoRepository.update(todoId, completed: completed);
  return (id: todo.id, completed: todo.completed);
}
```

The generator handles records natively — no `@serverData` file needed.

---

## 3. Server Implementation

```dart
// lib/actions/todos.server.dart

import 'package:postgres/postgres.dart';
import 'package:react_actions/react_actions.dart';
import 'package:react_server/react_server.dart';

import 'todos_contract.dart';

/// Server-only dependencies are allowed because this file is only
/// compiled into the native Dart server binary, not the browser JS bundle.
@serverFunction
Future<ToggleTodoResult> toggleTodo(
  ServerFunctionContext context, {
  required String todoId,
  required bool completed,
}) async {
  final user = context.requireUser();

  if (todoId.isEmpty) {
    throw ServerFunctionFailure(
      code: 'invalid_todo_id',
      message: 'The todo ID must not be empty.',
      statusCode: 422,
      details: {'todoId': todoId},
    );
  }

  final todo = await todoRepository.update(todoId, completed: completed);
  return ToggleTodoResult(id: todo.id, completed: todo.completed);
}
```

### Context parameter rules

The generator requires the injected context to be:

- The **first** parameter
- **Positional** (not named)
- **Non-nullable**
- Exactly `ServerFunctionContext` type
- **Excluded** from the generated argument record

The context is imported from `react_server`:

```dart
import 'package:react_server/react_server.dart';
```

This is acceptable because `todos.server.dart` is server-only.

---

## 4. Generated Shared Artifact

The shared ref and codecs live in a **separate** file — not in the client proxy — so the server registry does not import a file labelled "client."

### 4.1 Shared ref + codecs

```dart
// GENERATED CODE — DO NOT EDIT
// lib/actions/todos.action.g.dart

import 'package:react_actions/react_actions.dart';

import 'todos_contract.dart';

final toggleTodoRef = ServerFunctionRef<
  ({String todoId, bool completed}),
  ToggleTodoResult
>(
  id: const ServerFunctionId(
    'package:app/actions/todos.server.dart#toggleTodo',
  ),
  contractHash: 'sha256:abc123...',
  argumentsCodec: const ToggleTodoArgumentsCodec(),
  resultCodec: const ToggleTodoResultCodec(),
);

final class ToggleTodoArgumentsCodec
    implements ServerFunctionJsonCodec<({String todoId, bool completed})> {

  const ToggleTodoArgumentsCodec();

  @override
  Map<String, dynamic> encode(({String todoId, bool completed}) value) {
    return {
      'todoId': value.todoId,
      'completed': value.completed,
    };
  }

  @override
  ({String todoId, bool completed}) decode(dynamic json) {
    final m = json as Map<String, dynamic>;
    return (
      todoId: m['todoId'] as String,
      completed: m['completed'] as bool,
    );
  }
}

final class ToggleTodoResultCodec
    implements ServerFunctionJsonCodec<ToggleTodoResult> {

  const ToggleTodoResultCodec();

  @override
  Map<String, dynamic> encode(ToggleTodoResult value) {
    return {
      'id': value.id,
      'completed': value.completed,
    };
  }

  @override
  ToggleTodoResult decode(dynamic json) {
    final m = json as Map<String, dynamic>;
    return ToggleTodoResult(
      id: m['id'] as String,
      completed: m['completed'] as bool,
    );
  }
}
```

### 4.2 Contract hash

`ServerFunctionRef` includes a `contractHash`:

```dart
final class ServerFunctionRef<TArgs, TResult> {
  final ServerFunctionId id;

  /// Hash of the normalized parameter and result schema.
  ///
  /// Generated from a canonical representation of:
  ///   - function ID
  ///   - wire parameter names
  ///   - parameter types
  ///   - required/optional status (all required in Phase 1)
  ///   - result type
  ///   - nullable status
  ///   - codec version
  final String contractHash;

  final ServerFunctionJsonCodec<TArgs> argumentsCodec;
  final ServerFunctionJsonCodec<TResult> resultCodec;

  const ServerFunctionRef({
    required this.id,
    required this.contractHash,
    required this.argumentsCodec,
    required this.resultCodec,
  });
}
```

The request includes:

```json
{
  "protocol": 1,
  "clientBuild": "f57cb9",
  "id": "package:app/actions/todos.server.dart#toggleTodo",
  "contract": "sha256:abc123",
  "arguments": {"todoId": "todo-42", "completed": true}
}
```

If the ID exists but the contract hash differs, the server returns:

```json
{
  "ok": false,
  "error": {
    "code": "contract_mismatch",
    "message": "The action contract has changed. Please reload."
  }
}
```

This handles rolling deployments more precisely than a global build hash.

### 4.3 Compilation boundary

| Target | Files compiled |
|--------|---------------|
| Browser JS bundle | `todos_contract.dart` + `todos.action.g.dart` + `todos.client.g.dart` |
| Native Dart server | `todos_contract.dart` + `todos.action.g.dart` + `todos.registry.g.dart` + `todos.server.dart` |

---

## 5. Generated Client Proxy

```dart
// GENERATED CODE — DO NOT EDIT
// lib/actions/todos.client.g.dart

import 'package:react_actions/react_actions.dart';

import 'todos.action.g.dart';

/// Browser proxy for [toggleTodo].
///
/// Always returns [Future] — network calls are asynchronous even when
/// the server implementation is synchronous.
Future<ToggleTodoResult> toggleTodoAction({
  required String todoId,
  required bool completed,
}) {
  return currentServerFunctionClient.invoke(
    toggleTodoRef,
    (todoId: todoId, completed: completed),
  );
}
```

### Naming convention

`toggleTodo` → `toggleTodoAction`, `createUser` → `createUserAction`. The `Action` suffix disambiguates the generated proxy from the original function.

### Client proxies always return `Future<TResult>`

A network call is always asynchronous. Even when the server function is synchronous:

```dart
@serverFunction
int add(ServerFunctionContext context, {required int a, required int b}) {
  return a + b;
}
```

the client proxy returns `Future<int>`:

```dart
Future<int> addAction({required int a, required int b}) {
  return currentServerFunctionClient.invoke(addRef, (a: a, b: b));
}
```

---

## 6. Generated Server Registration

```dart
// GENERATED CODE — DO NOT EDIT
// lib/actions/todos.registry.g.dart

import 'package:react_server/react_server.dart';

import 'todos.action.g.dart';                    // for toggleTodoRef
import 'todos.server.dart' as implementation;    // for the real function

void registerTodosServerFunctions(
  ServerFunctionRegistry registry,
) {
  registry.register(
    toggleTodoRef,
    (arguments, context) {
      return implementation.toggleTodo(
        context,
        todoId: arguments.todoId,
        completed: arguments.completed,
      );
    },
  );
}
```

The registration file is the **only** bridge between the registry and the real implementation. It imports the original server file and wires it to the ref. The browser never imports this file.

---

## 7. Core Types

### 7.1 ServerFunctionId

```dart
// packages/react_actions/lib/src/function_id.dart

/// Opaque identifier for a registered server function.
final class ServerFunctionId {
  final String value;

  const ServerFunctionId(this.value);

  @override
  bool operator ==(Object other) =>
      other is ServerFunctionId && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'ServerFunctionId($value)';
}
```

Uses the same convention as `ComponentId`:

```
package:app/actions/todos.server.dart#toggleTodo
```

`react_actions` does **not** depend on `react`. The ID value class is self-contained.

### 7.2 ServerFunctionJsonCodec

```dart
/// Serializes and deserializes arguments/results between Dart values
/// and JSON-compatible objects.
///
/// Operates on `dynamic` (decoded JSON) because the transport layer
/// receives raw `dart:convert` output.
abstract class ServerFunctionJsonCodec<T> {
  dynamic encode(T value);
  T decode(dynamic json);
}
```

JSON-specific by design. The existing `ReactCodecRegistry` operates on `JSAny?` for in-process JS interop; server functions cross a network boundary and need format-agnostic transport encoding.

### 7.3 ServerFunctionRef

```dart
final class ServerFunctionRef<TArgs, TResult> {
  final ServerFunctionId id;
  final String contractHash;
  final ServerFunctionJsonCodec<TArgs> argumentsCodec;
  final ServerFunctionJsonCodec<TResult> resultCodec;

  const ServerFunctionRef({
    required this.id,
    required this.contractHash,
    required this.argumentsCodec,
    required this.resultCodec,
  });
}
```

The **shared artifact** — compiled into both the browser JS bundle and the native Dart server binary.

### 7.4 ServerFunctionClient

```dart
/// Transport abstraction for invoking server functions from the browser.
abstract class ServerFunctionClient {
  Future<TResult> invoke<TArgs, TResult>(
    ServerFunctionRef<TArgs, TResult> ref,
    TArgs arguments,
  );

  /// Releases any underlying resources (HTTP client, connections).
  void close();
}
```

### 7.5 How the client is accessed

Rather than a separate `ServerFunctionRuntime` zone, the action client lives inside the existing `ReactRuntime`:

```dart
// In package:react (or react_actions with a bridge)

final class ReactRuntime {
  final ReactBinding binding;
  final ReactRenderer renderer;
  final ServerFunctionClient? serverFunctionClient;

  const ReactRuntime({
    required this.binding,
    required this.renderer,
    this.serverFunctionClient,
  });
}
```

Then:

```dart
ServerFunctionClient get currentServerFunctionClient {
  final client = currentReactRuntime.serverFunctionClient;
  if (client == null) {
    throw StateError(
      'No ServerFunctionClient is configured for the current React root.',
    );
  }
  return client;
}
```

Browser setup:

```dart
void main() {
  final runtime = ReactRuntime(
    binding: browserBinding,
    renderer: browserRenderer,
    serverFunctionClient: HttpServerFunctionClient(
      endpoint: Uri.parse('/__react/actions'),
    ),
  );

  runWithReactRuntime(runtime, () {
    hydrateRoot('#app', App());
  });
}
```

This ties the action transport to the React root that owns the event callbacks. Generated proxies use `currentServerFunctionClient` directly.

### 7.6 HttpServerFunctionClient

Uses `package:http` with proper error handling:

```dart
// packages/react_web/lib/src/http_server_function_client.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:react_actions/react_actions.dart';

final class HttpServerFunctionClient implements ServerFunctionClient {
  final Uri endpoint;
  final http.Client client;
  final Duration requestTimeout;

  HttpServerFunctionClient({
    required this.endpoint,
    http.Client? client,
    this.requestTimeout = const Duration(seconds: 30),
  }) : client = client ?? http.Client();

  @override
  void close() {
    client.close();
  }

  @override
  Future<TResult> invoke<TArgs, TResult>(
    ServerFunctionRef<TArgs, TResult> ref,
    TArgs arguments,
  ) async {
    late http.Response response;

    try {
      response = await client
          .post(
            endpoint,
            headers: {
              'content-type': 'application/json',
              'accept': 'application/json',
            },
            body: jsonEncode({
              'protocol': 1,
              'id': ref.id.value,
              'contract': ref.contractHash,
              'arguments': ref.argumentsCodec.encode(arguments),
            }),
          )
          .timeout(requestTimeout);
    } catch (error) {
      throw ServerFunctionTransportException(
        'The server function request failed.',
        cause: error,
      );
    }

    final Object? decoded;

    try {
      decoded = jsonDecode(response.body);
    } catch (error) {
      throw ServerFunctionTransportException(
        'The server returned an invalid response.',
        cause: error,
      );
    }

    final envelope = ServerFunctionResponse.fromJson(decoded);

    if (!envelope.ok) {
      throw RemoteServerFunctionException(
        error: envelope.error!,
        statusCode: response.statusCode,
      );
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ServerFunctionTransportException(
        'Unexpected HTTP status ${response.statusCode}.',
      );
    }

    return ref.resultCodec.decode(envelope.result);
  }
}
```

### 7.7 ServerFunctionContext

```dart
/// Request-scoped context passed to every registered server function.
/// Lives in `react_server`.
final class ServerFunctionContext {
  final String requestId;
  final Object? principal;
  final Map<String, String> headers;
  final Uri requestUri;
  final DateTime deadline;
  final CancellationToken cancellation;

  const ServerFunctionContext({
    required this.requestId,
    required this.principal,
    required this.headers,
    required this.requestUri,
    required this.deadline,
    required this.cancellation,
  });

  Object requireUser() {
    if (principal == null) {
      throw ServerFunctionFailure(
        code: 'unauthenticated',
        message: 'Authentication is required.',
        statusCode: 401,
      );
    }
    return principal!;
  }
}
```

### 7.8 ServerFunctionRegistry

```dart
/// Maps [ServerFunctionId]s to their actual implementations.
final class ServerFunctionRegistry {
  final _handlers = <String, Future<dynamic> Function(dynamic, ServerFunctionContext)>{};

  void register<TArgs, TResult>(
    ServerFunctionRef<TArgs, TResult> ref,
    FutureOr<TResult> Function(TArgs arguments, ServerFunctionContext context) handler,
  ) {
    if (_handlers.containsKey(ref.id.value)) {
      throw StateError('Duplicate server function: ${ref.id.value}');
    }
    _handlers[ref.id.value] = (raw, context) async {
      final args = ref.argumentsCodec.decode(raw);
      final result = await handler(args, context);
      return ref.resultCodec.encode(result);
    };
  }

  Future<dynamic> dispatch(
    String id,
    dynamic arguments,
    ServerFunctionContext context,
  ) async {
    final handler = _handlers[id];
    if (handler == null) {
      throw UnknownServerFunctionException(id);
    }
    return handler(arguments, context);
  }
}
```

---

## 8. Exception Hierarchy

Separate distinct failure types so applications catch the right abstraction:

| Exception | Thrown by | Meaning |
|-----------|-----------|---------|
| `ServerFunctionFailure` | Server business logic | Deliberate domain error (validation, not-found, forbidden) |
| `RemoteServerFunctionException` | `HttpServerFunctionClient.invoke` | Decoded server error received by the client |
| `ServerFunctionTransportException` | `HttpServerFunctionClient.invoke` | Network failure, timeout, invalid response |

### 8.1 ServerFunctionFailure (server-side)

```dart
class ServerFunctionFailure implements Exception {
  final String code;
  final String message;
  final int statusCode;
  final Map<String, Object?>? details;

  const ServerFunctionFailure({
    required this.code,
    required this.message,
    required this.statusCode,
    this.details,
  });
}
```

Thrown inside the implementation:

```dart
throw ServerFunctionFailure(
  code: 'todo_not_found',
  message: 'The todo could not be found.',
  statusCode: 404,
  details: {'todoId': todoId},
);
```

### 8.2 RemoteServerFunctionException (client-side)

```dart
final class RemoteServerFunctionException implements Exception {
  final ServerFunctionError error;
  final int statusCode;

  const RemoteServerFunctionException({
    required this.error,
    required this.statusCode,
  });

  String get code => error.code;
  String get message => error.message;
}
```

### 8.3 ServerFunctionTransportException (client-side)

```dart
final class ServerFunctionTransportException implements Exception {
  final String message;
  final Object? cause;

  const ServerFunctionTransportException(this.message, {this.cause});
}
```

### 8.4 Component error handling

```dart
try {
  final result = await toggleTodoAction(
    todoId: props.id,
    completed: nextCompleted,
  );
  setCompleted(result.completed);
} on RemoteServerFunctionException catch (error) {
  setError(error.message);
} on ServerFunctionTransportException catch (error) {
  setError('Could not reach the server.');
}
```

The component catches framework abstractions, not `HttpException` or raw socket errors.

---

## 9. Transport Protocol

### Request

```
POST /__react/actions HTTP/1.1
Content-Type: application/json

{
  "protocol": 1,
  "clientBuild": "f57cb9...",
  "id": "package:app/actions/todos.server.dart#toggleTodo",
  "contract": "sha256:abc123",
  "arguments": {
    "todoId": "todo-42",
    "completed": true
  }
}
```

| Field | Required | Description |
|-------|----------|-------------|
| `protocol` | yes | Protocol version for schema detection |
| `clientBuild` | no | Build hash for stale-client detection |
| `id` | yes | Canonical `ServerFunctionId` value |
| `contract` | yes | Per-function contract hash for signature mismatch detection |
| `arguments` | yes | Encoded arguments (JSON object/array/primitive) |

### Success response

```
HTTP/1.1 200 OK
Content-Type: application/json

{
  "ok": true,
  "result": {
    "id": "todo-42",
    "completed": true
  }
}
```

### Error response

```
HTTP/1.1 422 Unprocessable Entity
Content-Type: application/json

{
  "ok": false,
  "error": {
    "code": "todo_not_found",
    "message": "The todo could not be found.",
    "details": {
      "todoId": "todo-42"
    },
    "requestId": "req_abc123"
  }
}
```

### HTTP status codes

| Situation | Status |
|-----------|--------|
| Success | `200` |
| Invalid JSON / protocol violation | `400` |
| Contract mismatch | `400` |
| Unauthenticated | `401` |
| Forbidden | `403` |
| Unknown function ID | `404` |
| Conflict (e.g. duplicate) | `409` |
| Validation failure | `422` |
| Function timeout | `504` |
| Internal failure | `500` |

---

## 10. Same-Origin Shelf Handler

```dart
// Inside the Shelf router

Router()
  ..post('/__react/actions', (Request req) async {
    // Security validations
    if (req.headers['content-type'] != 'application/json') {
      return Response(415);
    }

    // Body-size limit
    final body = await req.readAsString();
    if (body.length > 1024 * 1024) {
      return Response(413, body: 'Request too large.');
    }

    // Parse
    final payload = jsonDecode(body) as Map<String, dynamic>;

    if (payload['protocol'] != 1) {
      return Response(400, body: jsonEncode(
        ServerFunctionResponse.error(ServerFunctionError(
          code: 'unsupported_protocol',
          message: 'Unsupported protocol version.',
        )).toJson(),
      ));
    }

    final id = payload['id'] as String;
    final contract = payload['contract'] as String?;
    final arguments = payload['arguments'];

    // Contract hash validation
    final expectedHash = registry.contractHashFor(id);
    if (expectedHash != null && contract != null && contract != expectedHash) {
      return Response(400, body: jsonEncode(
        ServerFunctionResponse.error(ServerFunctionError(
          code: 'contract_mismatch',
          message: 'The action contract has changed. Please reload.',
        )).toJson(),
      ));
    }

    final context = ServerFunctionContext(
      requestId: generateId(),
      principal: authenticate(req),
      headers: req.headers,
      requestUri: req.url,
      deadline: DateTime.now().add(const Duration(seconds: 30)),
      cancellation: CancellationToken(),
    );

    try {
      final encoded = await registry
          .dispatch(id, arguments, context)
          .timeout(const Duration(seconds: 30));

      return Response.ok(
        jsonEncode(ServerFunctionResponse.ok(encoded).toJson()),
        headers: {'content-type': 'application/json'},
      );
    } on TimeoutException {
      return Response(504, body: jsonEncode(
        ServerFunctionResponse.error(ServerFunctionError(
          code: 'timeout',
          message: 'The action timed out.',
        )).toJson(),
      ));
    } on ServerFunctionFailure catch (e) {
      return Response(e.statusCode, body: jsonEncode(
        ServerFunctionResponse.error(ServerFunctionError(
          code: e.code,
          message: e.message,
          details: e.details,
          requestId: context.requestId,
        )).toJson(),
      ));
    } on UnknownServerFunctionException catch (e) {
      return Response(404, body: jsonEncode(
        ServerFunctionResponse.error(ServerFunctionError(
          code: 'unknown_function',
          message: 'Unknown function: ${e.id}',
        )).toJson(),
      ));
    } catch (e) {
      return Response.internalServerError(body: jsonEncode(
        ServerFunctionResponse.error(ServerFunctionError(
          code: 'internal_error',
          message: 'Internal server error.',
          requestId: context.requestId,
        )).toJson(),
      ));
    }
  });
```

---

## 11. Integration with SSR

The reusable `react_testing` package owns this integration for tests. It uses
`ReactBuilder`, boots the generated Node worker, starts the standardized native
`ReactServerApp`, and exposes both a browser `baseUrl` and a
`server_testing`/`server_testing_shelf` client:

```dart
final harness = await ReactTestHarness.start(
  projectRoot: Directory('example'),
  rootComponent: 'package:app/lib/app.dart#App',
  registerActions: registerActions,
);
addTearDown(harness.close);
```

This keeps browser tests focused on assertions rather than build output paths,
worker lifecycle, or Shelf adapter setup.


### Correct: initial data loads in Shelf before rendering

React's `useEffect` does **not** run during SSR. The following does NOT preload data:

```dart
// ❌ This effect never fires during SSR
useEffect(() {
  fetchTodosAction();
}, const []);
```

The correct SSR data flow loads data in the native Dart Shelf handler **before** sending the render request to the SSR worker:

```
Browser GET /todos
    ↓
Shelf route handler
    ↓
load data from database (native Dart)
    ↓
encode initial props
    ↓
send render request to SSR worker
    ↓
ReactDOMServer.renderToString(
  App(initialTodos: ...)
)
    ↓
return HTML + hydration props
```

Concrete example:

```dart
// Shelf route handler
Future<Response> renderTodosPage(Request request) async {
  final todos = await todoRepository.listForUser(
    request.context['userId'] as String,
  );

  final props = {
    'initialTodos': todos.map((t) => t.toJson()).toList(),
  };

  final rendered = await ssrWorker.render(
    componentId: appComponentId,
    props: props,
  );

  return Response.ok(
    composeHtml(
      renderedHtml: rendered.html,
      hydrationProps: props,
    ),
  );
}
```

The component receives the initial state and uses server functions only for post-hydration interactivity:

```dart
@reactComponent
ReactNode TodoList(({List<TodoView> initialTodos}) props) {
  final (todos, setTodos) = useState(props.initialTodos);

  Future<void> handleToggle(String id, bool completed) async {
    final result = await toggleTodoAction(todoId: id, completed: completed);
    // Update local state from authoritative server result
    setTodos(todos.map((t) => t.id == id ? /* updated */ : t).toList());
  }

  return div(/* ... */);
}
```

### Direct invocation during SSR

If a component attempts to call a server function directly during rendering (not inside an event handler or effect), the generated client proxy throws a clear runtime error:

```
Server functions cannot be invoked during
server rendering. Load initial data before
calling renderToString.
```

This is enforced by checking `currentReactRuntime.target` — if the target is `server` and a server function is invoked outside a user-initiated callback, the runtime rejects it.

### A component may contain server function calls in event handlers

```dart
onClick: (_) async {
  await toggleTodoAction(todoId: props.id, completed: nextCompleted);
}
```

during SSR the click handler is never invoked — it's registered as a `ReactEventProp` descriptor. The SSR encoder omits it from the rendered output. The action client does not need to be configured in the SSR worker.

---

## 12. Optional Parameters (Phase 1 Constraint)

For Phase 1, server functions may only have **required** named wire parameters. This avoids the ambiguity between "parameter omitted" and "parameter explicitly null."

Allowed:

```dart
@serverFunction
Future<void> updateTodo(
  ServerFunctionContext context, {
  required String id,
  required String? title,
  required bool notify,
})
```

Rejected initially:

```dart
@serverFunction
Future<void> updateTodo(
  ServerFunctionContext context, {
  required String id,
  String? title,          // ❌ optional
  bool notify = true,     // ❌ optional with default
})
```

Later, an explicit presence model can be added:

```dart
sealed class ActionArgument<T> {
  const ActionArgument();
}

final class ArgumentAbsent<T> extends ActionArgument<T> {
  const ArgumentAbsent();
}

final class ArgumentValue<T> extends ActionArgument<T> {
  final T value;
  const ArgumentValue(this.value);
}
```

But do not silently treat missing and null as equivalent.

---

## 13. Codec Generation

### 13.1 Supported types

| Dart type | JSON representation | Codec behavior |
|-----------|-------------------|----------------|
| `String` | JSON string | Direct assignment |
| `int` | JSON number | `(json as num).toInt()` |
| `double` | JSON number | `(json as num).toDouble()` |
| `bool` | JSON boolean | Direct assignment |
| `Null` / `void` | JSON null | Return null |
| `T?` | JSON null or T | Null check |
| `List<T>` | JSON array | Map each element |
| `Map<String, V>` | JSON object | Map each value |
| Record type `({K1 v1, K2 v2})` | JSON object | Field-by-field (all fields are positional at the wire level) |
| `@serverData` class | JSON object | Field-by-field |
| `DateTime` | ISO 8601 string | `DateTime.parse` / `.toIso8601String()` |
| `Uri` | URI string | `Uri.parse` / `.toString()` |
| Enum | Enum name string | `.name` / `EnumType.values.byName` |

### 13.2 Codec generation strategy

The generator walks the Dart type tree for the function's parameter record and return type. For each leaf type, it emits the corresponding encode/decode expression.

**Record types** produce `Map<String, dynamic>` codecs:

```dart
@override
Map<String, dynamic> encode(({String todoId, bool completed}) value) {
  return {
    'todoId': value.todoId,
    'completed': value.completed,
  };
}

@override
({String todoId, bool completed}) decode(dynamic json) {
  final m = json as Map<String, dynamic>;
  return (
    todoId: m['todoId'] as String,
    completed: m['completed'] as bool,
  );
}
```

**`@serverData` classes** produce field-by-field codecs without `dart:mirrors`:

```dart
@override
Map<String, dynamic> encode(ToggleTodoResult value) {
  return {
    'id': value.id,
    'completed': value.completed,
  };
}

@override
ToggleTodoResult decode(dynamic json) {
  final m = json as Map<String, dynamic>;
  return ToggleTodoResult(
    id: m['id'] as String,
    completed: m['completed'] as bool,
  );
}
```

### 13.3 Null handling

```dart
@override
Map<String, dynamic> encode(({String? optional, String name}) value) {
  return {
    'name': value.name,
    if (value.optional != null) 'optional': value.optional,
  };
}

@override
({String? optional, String name}) decode(dynamic json) {
  final m = json as Map<String, dynamic>;
  return (
    name: m['name'] as String,
    optional: m['optional'] as String?,
  );
}
```

### 13.4 Generator validation

The generator **must** confirm that every type referenced by the function signature is client-safe. A type is client-safe if it is:

- A primitive (`String`, `int`, `double`, `bool`, `Null`)
- A record type composed of client-safe types
- A `List<T>` or `Map<String, V>` where `T`/`V` is client-safe
- A `@serverData` class meeting the Phase 1 requirements
- A `DateTime`, `Uri`, or enum

If a type is declared in a library with native-only imports (e.g., `package:postgres`), generation fails with a clear error:

```
Server function contract type is not client-safe.

Function:
  toggleTodo

Type:
  ToggleTodoResult

Declared in:
  package:app/actions/todos.server.dart

Move the type to a browser-safe contract library or return a record.
```

---

## 14. Runtime Topology

### Initial implementation (single Shelf process)

```
Browser
├── GET /todos           ──▶ Shelf/Dart VM :8080
│                               ├── load initial data
│                               ├── SSR worker proxy
│                               └── return HTML+props
│
└── POST /__react/actions ──▶ Shelf/Dart VM :8080
                                    ├── validate content-type, body size
                                    ├── authenticate
                                    ├── check contract hash
                                    ├── ServerFunctionRegistry
                                    │     └── dispatch with timeout
                                    └── database / business logic

Node SSR worker :3001
└── ReactDOMServer.renderToString
```

Shelf handles both page routes and action dispatch. The SSR worker is the only separate process.

### Optional isolated action service (production scaling)

```
Browser
├── GET /todos           ──▶ Shelf :8080
│                               └── proxy to SSR worker :3001
│
└── POST /__react/actions ──▶ Shelf :8080
                                    └── proxy ──▶ Dart action service :3002
```

Shelf proxies `/__react/actions` to a dedicated action service when process isolation is needed. The browser protocol, generated code, and client proxy remain unchanged.

### Future embedded runtime

```
Dart process
├── Shelf
├── ServerFunctionRegistry
├── database
└── embedded JavaScript runtime
      └── ReactDOMServer
```

When an embedded JS engine supports `ReactDOMServer`, the SSR worker merges into the same process. The action endpoint and generated proxies remain identical.

---

## 15. Security Considerations

### 15.1 Endpoint validation

The Shelf handler validates:

- `POST` only
- `Content-Type: application/json`
- Body-size limit (1 MB)
- Protocol version
- Contract hash
- Authentication
- Rate limiting

### 15.2 Authentication and authorization

Authentication is handled by Shelf middleware and exposed through `ServerFunctionContext.principal`:

```dart
final context = ServerFunctionContext(
  principal: authenticateRequest(req),
  // ...
);
```

Cookies used for authentication must have `SameSite` appropriately configured. Mutating functions must never rely only on hidden IDs or function IDs for authorization — each function must validate the principal's permissions.

### 15.3 Input validation

Generated codecs cast to expected types but do not validate semantic constraints. Each server function validates its own inputs:

```dart
if (todoId.isEmpty) {
  throw ServerFunctionFailure(
    code: 'invalid_todo_id',
    message: 'The todo ID must not be empty.',
    statusCode: 422,
  );
}
```

### 15.4 Error disclosure

A timeout should not expose the raw function name, stack trace, database error, or secrets. The Shelf handler catches unhandled exceptions and returns a generic `internal_error` envelope.

### 15.5 CORS

Not needed for same-origin `/__react/actions`. If a remote action service is used in production, CORS is configured at the reverse proxy level, not in application code.

---

## 16. Comparison with Existing Codec System

The existing `ReactCodecRegistry` in `react_js` is for in-process JS interop:

```dart
ReactCodecRegistry.register('package:app/models.dart#User', ReactCodec(
  encode: (user) => (user as User).toJS(),    // → JSAny
  decode: (js) => User.fromJS(js as JSObject), // ← JSAny
));
```

This is **not** suitable for server functions:

| Aspect | ReactCodecRegistry | ServerFunctionJsonCodec |
|--------|-------------------|------------------------|
| Domain | Callback arguments through React props | Server function arguments over HTTP |
| Format | `JSAny?` (in-process JS objects) | `dynamic` (decoded JSON) |
| Runtime | Browser only (needs `dart:js_interop`) | Both browser and native Dart |
| Scope | Per-type codec lookup by string ID | Per-function argument/result pair |
| Registration | Global mutable singleton | Scoped to `ServerFunctionRegistry` |
| Error handling | `StateError` on missing codec | Structured error envelopes |

They coexist. Component callbacks use `ReactCodecRegistry`; server functions use `ServerFunctionJsonCodec`.

---

## 17. Future Directions

### 17.1 Streaming responses

Extend the protocol for streaming:

```json
// Request
{"id": "...", "arguments": {...}, "stream": true}

// Response (Server-Sent Events)
event: chunk
data: {"progress": 0.5}

event: result
data: {"value": 42}
```

### 17.2 File uploads

File uploads need multipart form data or binary framing. A companion endpoint handles uploads separately, passing file references to server functions.

### 17.3 Optional parameters with explicit presence

Add `ActionArgument<T>` sealed class to distinguish omission from explicit null.

### 17.4 Batch dispatch

Multiple calls in one request:

```json
{
  "calls": [
    {"id": "...", "arguments": {...}},
    {"id": "...", "arguments": {...}}
  ]
}
```

### 17.5 Form actions

For progressive enhancement without JavaScript, generate `<form action="/__react/actions/..." method="POST">` bindings. Before hydration, form submission triggers a full-page postback. After hydration, the same form uses `fetch`.

---

## 18. Implementation Plan

### Phase 1: `react_actions` package and core types

1. Create `packages/react_actions/` with **no dependency on `react`** or any other framework package
2. Add `ServerFunctionId`, `ServerFunctionJsonCodec<T>`, `ServerFunctionRef<TArgs, TResult>`
3. Add `ServerFunctionClient` (abstract), exception hierarchy, and envelope types
4. Add `currentServerFunctionClient` accessor (reads from `ReactRuntime`)
5. Add `@serverFunction` and `@serverData` annotations
6. Write unit tests for codec encode/decode, envelope serialization, exception types

### Phase 2: `react_server` registry and Shelf handler

7. Add `ServerFunctionContext` (with `deadline` and `CancellationToken`)
8. Add `ServerFunctionRegistry` (`register`, `dispatch`, `contractHashFor`)
9. Add the same-origin Shelf route handler for `/__react/actions` with security validations
10. Write integration tests: Shelf → registry → function → structured response

### Phase 3: `react_web` HTTP client

11. Implement `HttpServerFunctionClient` using `package:http` with timeout, response validation, and `close()`
12. Write client-side unit tests with mock HTTP

### Phase 4: Code generator

13. Add annotation processing to `react_codegen`:
    - Parse `@serverFunction` → parameter record + return type
    - Resolve contract types: `@serverData` in browser-safe files, records, primitives
    - Validate: reject types in native-only libraries, enforce Phase 1 `@serverData` shape
    - Generate `*.action.g.dart`: ref + contract hash + codecs
    - Generate `*.client.g.dart`: client proxy importing `.action.g.dart`
    - Generate `*.registry.g.dart`: server registration importing `.action.g.dart` + server impl
14. Write golden tests for all three generated output files
15. Write generation-failure tests for non-client-safe types

### Phase 5: Integration ✅

16. Add server function example to the example app (todo CRUD) — ✅ complete
    - `@serverData` contract class (`TodoItem`, `TodoListResult`)
    - `@serverFunction` implementation (`listTodos`, `toggleTodo`, `addTodo`)
    - `@reactComponent TodoApp` UI with useState/useEffect
    - Generated `.action.g.dart`, `.client.g.dart`, `.registry.g.dart`
    - Client compilation succeeds (`dart compile js -O0 examples/ssr/web/client.dart`)
    - SSR compilation succeeds (`dart compile js -O2 examples/ssr/lib/ssr.dart`)
17. Test end-to-end (runtime) — ✅ complete
    - `server_testing: 0.4.0` and `server_testing_shelf: 0.4.0`
    - ephemeral HTTP server verification in `packages/react_web/test/server_function_integration_test.dart`
    - client → Shelf → registry → typed result/error coverage
18. Add SSR + hydration + action integration test — ✅ complete
    - opt-in browser test: `RUN_BROWSER_E2E=1 dart test examples/ssr/test/server_function_browser_test.dart`
    - verifies SSR output, hydration, action loading, and checkbox mutation
19. Document the pattern with optimistic updates, error handling, and auth — pending

**Key fixes discovered during Phase 5 integration:**
- `TypeChecker.fromUrl` must point to the **definition** file (e.g. `src/annotations.dart#ServerFunctionAnnotation`), not the barrel export
- Annotation class names must match the TypeChecker fragment fragment — use a public class name, not `_Private` pattern
- dart2js parser does not handle `>(` across line breaks when generic type arguments contain record types
- analyzer 14.x uses `firstFragment.source.uri` instead of `element.source?.uri` for source URIs
- Generated files with `build_to: source` are placed alongside source files; `build_to: cache` files are in `.dart_tool/build/generated/` and must be tracked in VCS for `dart compile js` to resolve them

### Phase 6 (future)

20. Streaming responses
21. Batch dispatch
22. Optional parameters with `ActionArgument<T>`
23. Stale-client and contract-mismatch detection
24. Form actions for progressive enhancement
25. Process isolation when operationally justified
