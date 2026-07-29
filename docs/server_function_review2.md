This is now **architecturally sound and close to implementation-ready**. The major boundaries are correct:

```text
react_actions = shared protocol
react_server  = VM execution
react_web     = HTTP transport
react_codegen = shared/client/server generation
```

A few remaining issues should be resolved before implementation.

# 1. `ServerFunctionContext` import is currently inconsistent

The server implementation uses:

```dart
Future<ToggleTodoResult> toggleTodo(
  ServerFunctionContext context, {
  // ...
})
```

but only imports:

```dart
import 'package:react_actions/react_actions.dart';
```

Your architecture places `ServerFunctionContext` in `react_server`, so the implementation needs:

```dart
import 'package:react_actions/react_actions.dart';
import 'package:react_server/react_server.dart';
```

That is acceptable because `todos.server.dart` is server-only.

```dart
// lib/actions/todos.server.dart

import 'package:postgres/postgres.dart';
import 'package:react_actions/react_actions.dart';
import 'package:react_server/react_server.dart';

import 'todos_contract.dart';

@serverFunction
Future<ToggleTodoResult> toggleTodo(
  ServerFunctionContext context, {
  required String todoId,
  required bool completed,
}) async {
  final user = context.requireUser();

  // ...
}
```

Keep `ServerFunctionContext` out of `react_actions`. The client never needs it.

The generator should require the injected context to be:

* The first parameter.
* Positional.
* Non-nullable.
* Exactly `ServerFunctionContext`.
* Excluded from the generated argument record.

# 2. Split the generated shared artifact from the client proxy

Currently:

```text
todos.client.g.dart
├── ServerFunctionRef
├── codecs
└── client proxy
```

Then the server registry imports `todos.client.g.dart` for the ref and codecs.

That works technically, but the naming and dependency direction are misleading. The server should not import something labelled “client.”

Generate three files:

```text
todos.action.g.dart      shared ref + codecs
todos.client.g.dart      browser-callable proxy
todos.registry.g.dart    native server registration
```

## Shared generated artifact

```dart
// GENERATED CODE — DO NOT EDIT
// todos.action.g.dart

import 'package:react_actions/react_actions.dart';

import 'todos_contract.dart';

final toggleTodoRef = ServerFunctionRef<
  ({
    String todoId,
    bool completed,
  }),
  ToggleTodoResult
>(
  id: const ServerFunctionId(
    'package:app/actions/'
    'todos.server.dart#toggleTodo',
  ),
  contractHash: 'sha256:abc123...',
  argumentsCodec:
      const ToggleTodoArgumentsCodec(),
  resultCodec:
      const ToggleTodoResultCodec(),
);

final class ToggleTodoArgumentsCodec
    implements ServerFunctionJsonCodec<
      ({
        String todoId,
        bool completed,
      })
    > {
  const ToggleTodoArgumentsCodec();

  // ...
}

final class ToggleTodoResultCodec
    implements ServerFunctionJsonCodec<
      ToggleTodoResult
    > {
  const ToggleTodoResultCodec();

  // ...
}
```

## Client proxy

```dart
// todos.client.g.dart

import 'package:react_actions/react_actions.dart';

import 'todos.action.g.dart';

Future<ToggleTodoResult> toggleTodoAction({
  required String todoId,
  required bool completed,
}) {
  return currentServerFunctionRuntime
      .client
      .invoke(
        toggleTodoRef,
        (
          todoId: todoId,
          completed: completed,
        ),
      );
}
```

## Server registry

```dart
// todos.registry.g.dart

import 'package:react_server/react_server.dart';

import 'todos.action.g.dart';
import 'todos.server.dart'
    as implementation;

void registerTodosServerFunctions(
  ServerFunctionRegistry registry,
) {
  registry.register(
    toggleTodoRef,
    (arguments, context) {
      return implementation.toggleTodo(
        context,
        todoId: arguments.todoId,
        completed:
            arguments.completed,
      );
    },
  );
}
```

This makes the compilation boundary explicit:

```text
Browser:
contract + action.g + client.g

Server:
contract + action.g + registry.g + server.dart
```

# 3. Prefer one framework runtime over two independent Zone runtimes

A standalone `ServerFunctionRuntime` is reasonable, but you are already introducing a scoped `ReactRuntime`.

Two independent Zone lookups create a subtle risk:

```text
ReactRuntime zone
ServerFunctionRuntime zone
JS callback re-entry
nested roots
tests
```

The cleaner final design is:

```dart
final class ReactRuntime {
  final ReactBinding binding;
  final ReactRenderer renderer;

  final ServerFunctionClient?
      serverFunctionClient;

  const ReactRuntime({
    required this.binding,
    required this.renderer,
    this.serverFunctionClient,
  });
}
```

Then:

```dart
ServerFunctionClient
    get currentServerFunctionClient {
  final client =
      currentReactRuntime
          .serverFunctionClient;

  if (client == null) {
    throw StateError(
      'No ServerFunctionClient is configured '
      'for the current React root.',
    );
  }

  return client;
}
```

Generated proxy:

```dart
Future<ToggleTodoResult> toggleTodoAction({
  required String todoId,
  required bool completed,
}) {
  return currentServerFunctionClient.invoke(
    toggleTodoRef,
    (
      todoId: todoId,
      completed: completed,
    ),
  );
}
```

Browser setup:

```dart
void main() {
  final runtime = ReactRuntime(
    binding: browserBinding,
    renderer: browserRenderer,
    serverFunctionClient:
        HttpServerFunctionClient(
      endpoint: Uri.parse(
        '/__react/actions',
      ),
    ),
  );

  runWithReactRuntime(
    runtime,
    () {
      hydrateRoot(
        '#app',
        App(),
      );
    },
  );
}
```

This ties the action transport to the React root that owns the event callback.

You can retain `ServerFunctionRuntime` internally, but there should be one public runtime installation mechanism.

# 4. Add a per-function contract hash

A whole-application `clientBuild` hash is useful, but it is too coarse to be the only compatibility check.

Add:

```dart
final class ServerFunctionRef<
  TArgs,
  TResult
> {
  final ServerFunctionId id;

  /// Hash of the normalized argument and result schema.
  final String contractHash;

  final ServerFunctionJsonCodec<TArgs>
      argumentsCodec;

  final ServerFunctionJsonCodec<TResult>
      resultCodec;

  const ServerFunctionRef({
    required this.id,
    required this.contractHash,
    required this.argumentsCodec,
    required this.resultCodec,
  });
}
```

Request:

```json
{
  "protocol": 1,
  "clientBuild": "f57cb9",
  "id": "package:app/actions/todos.server.dart#toggleTodo",
  "contract": "sha256:abc123",
  "arguments": {
    "todoId": "todo-42",
    "completed": true
  }
}
```

The contract hash should be generated from a canonical representation of:

```text
function ID
wire parameter names
parameter types
required/optional status
result type
nullable status
codec version
```

If the ID still exists but its signature changed, return:

```json
{
  "ok": false,
  "error": {
    "code": "contract_mismatch",
    "message": "The action contract has changed."
  }
}
```

That handles rolling deployments more precisely than a global build hash.

# 5. Define optional-parameter semantics now

The current argument record works perfectly for required parameters:

```dart
({
  String todoId,
  bool completed,
})
```

Optional parameters create a harder problem:

```dart
@serverFunction
Future<void> updateTodo(
  ServerFunctionContext context, {
  required String id,
  String? title,
  bool notify = true,
})
```

These are different:

```text
title omitted
title explicitly null
notify omitted, use default
notify explicitly false
```

A simple record cannot distinguish omission from explicit null unless the proxy always materializes every server-side default.

For Phase 1, use the simplest rule:

> Server functions may only have required named wire parameters.

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
String? title,
bool notify = true,
```

Later, add an explicit presence model:

```dart
sealed class ActionArgument<T> {
  const ActionArgument();
}

final class ArgumentAbsent<T>
    extends ActionArgument<T> {
  const ArgumentAbsent();
}

final class ArgumentValue<T>
    extends ActionArgument<T> {
  final T value;

  const ArgumentValue(this.value);
}
```

Do not silently treat missing and null as equivalent.

Also correct record type examples such as:

```dart
({String? optional, required String name})
```

The `required` keyword belongs to function named parameters, not named record field type declarations. The record type is:

```dart
({
  String? optional,
  String name,
})
```

# 6. Separate server failures from client exceptions

`ServerFunctionException` currently appears to serve multiple roles:

* An exception thrown by server business logic.
* A decoded remote error thrown by the client.
* Possibly a transport failure.

Split these concepts.

## Server-side deliberate failure

```dart
class ServerFunctionFailure
    implements Exception {
  final String code;
  final String message;
  final int statusCode;
  final Map<String, Object?>?
      details;

  const ServerFunctionFailure({
    required this.code,
    required this.message,
    required this.statusCode,
    this.details,
  });
}
```

Example:

```dart
throw ServerFunctionFailure(
  code: 'todo_not_found',
  message:
      'The todo could not be found.',
  statusCode: 404,
  details: {
    'todoId': todoId,
  },
);
```

## Client-side remote failure

```dart
final class RemoteServerFunctionException
    implements Exception {
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

## Transport failure

```dart
final class ServerFunctionTransportException
    implements Exception {
  final String message;
  final Object? cause;

  const ServerFunctionTransportException(
    this.message, {
    this.cause,
  });
}
```

The component catches framework abstractions:

```dart
try {
  final result =
      await toggleTodoAction(
    todoId: props.id,
    completed: nextCompleted,
  );

  setCompleted(result.completed);
} on RemoteServerFunctionException catch (
  error
) {
  setError(error.message);
} on ServerFunctionTransportException catch (
  error
) {
  setError(
    'Could not reach the server.',
  );
}
```

It should not catch `HttpException`, because browser HTTP clients may surface a different transport exception type.

# 7. Improve HTTP response handling

This client code:

```dart
final decoded =
    jsonDecode(response.body);

final envelope =
    ServerFunctionResponse.fromJson(
  decoded,
);
```

must account for:

* Empty responses.
* Invalid JSON.
* Reverse-proxy HTML error pages.
* Network exceptions.
* Timeouts.
* Unexpected protocol versions.

A stronger implementation:

```dart
@override
Future<TResult> invoke<
  TArgs,
  TResult
>(
  ServerFunctionRef<
    TArgs,
    TResult
  > ref,
  TArgs arguments,
) async {
  late http.Response response;

  try {
    response = await client
        .post(
          endpoint,
          headers: const {
            'content-type':
                'application/json',
            'accept':
                'application/json',
          },
          body: jsonEncode({
            'protocol': 1,
            'id': ref.id.value,
            'contract':
                ref.contractHash,
            'arguments':
                ref.argumentsCodec
                    .encode(arguments),
          }),
        )
        .timeout(
          requestTimeout,
        );
  } catch (error) {
    throw ServerFunctionTransportException(
      'The server function request failed.',
      cause: error,
    );
  }

  final Object? decoded;

  try {
    decoded = jsonDecode(
      response.body,
    );
  } catch (error) {
    throw ServerFunctionTransportException(
      'The server returned an invalid '
      'response.',
      cause: error,
    );
  }

  final envelope =
      ServerFunctionResponse.fromJson(
    decoded,
  );

  if (!envelope.ok) {
    throw RemoteServerFunctionException(
      error: envelope.error!,
      statusCode:
          response.statusCode,
    );
  }

  if (response.statusCode < 200 ||
      response.statusCode >= 300) {
    throw ServerFunctionTransportException(
      'Unexpected HTTP status '
      '${response.statusCode}.',
    );
  }

  return ref.resultCodec.decode(
    envelope.result,
  );
}
```

Also add lifecycle management:

```dart
abstract class ServerFunctionClient {
  Future<TResult> invoke<
    TArgs,
    TResult
  >(
    ServerFunctionRef<
      TArgs,
      TResult
    > ref,
    TArgs arguments,
  );

  void close();
}
```

# 8. Tighten `@serverData`

“Public fields and no native imports” is not enough for deterministic codec generation.

For Phase 1, require:

```text
final class
no type parameters
no superclass other than Object
no mixins
no cyclic references
final public instance fields
one public generative constructor
constructor parameters match serialized fields
only supported field types
```

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

Reject:

```dart
@serverData
class Result<T> extends BaseResult {
  // Generic and inherited.
}
```

Reject:

```dart
@serverData
final class Result {
  final String id;

  Result.fromDatabase(Row row)
      : id = row[0] as String;
}
```

The generator diagnostic should explain exactly which contract rule was violated.

Also validate the entire import closure—not just direct imports—for unsupported platform libraries such as native-only dependencies.

# 9. `react_actions` should not depend on `react`

This line in the plan is unnecessary:

```text
react_actions depends on react
for ComponentId convention reuse
```

A canonical ID is just a build-time convention. Do not create a runtime package dependency for it.

Either duplicate the tiny immutable ID value class:

```dart
final class ServerFunctionId {
  final String value;
  const ServerFunctionId(this.value);
}
```

or place shared symbol-ID construction in a code-generation utility package:

```text
react_codegen_common
└── canonicalLibrarySymbolId(...)
```

The runtime packages only receive the generated string.

Keep:

```text
react_actions
```

independent of:

```text
react
react_web
react_server
react_js
```

# 10. Registry dispatch should support cancellation and timeout

Add cancellation/deadline information to the context:

```dart
final class ServerFunctionContext {
  final String requestId;
  final Object? principal;
  final Map<String, String> headers;
  final Uri requestUri;
  final DateTime deadline;
  final CancellationToken cancellation;

  // ...
}
```

The Shelf handler sets a timeout:

```dart
final encoded =
    await registry
        .dispatch(
          id,
          arguments,
          context,
        )
        .timeout(
          const Duration(
            seconds: 30,
          ),
        );
```

A timeout should not expose the raw function name, stack trace, database error or secrets.

# 11. Security additions for the same-origin endpoint

Same-origin removes CORS complexity but does not remove all request-forgery concerns.

At minimum, the action handler should validate:

```text
POST only
Content-Type: application/json
Origin or Sec-Fetch-Site where available
authentication
authorization inside each action
body-size limit
request timeout
rate limit
protocol version
contract hash
```

Cookies should be configured with appropriate `SameSite` behavior. Mutating functions must never rely only on hidden IDs or action IDs for authorization.

# 12. The SSR section is now correct

This part is now properly framed:

```text
Shelf loads initial data
    ↓
passes initial props to SSR worker
    ↓
ReactDOMServer renders
    ↓
browser hydrates
    ↓
server functions handle later interaction
```

That cleanly separates:

```text
query/data loading for initial render
from
commands/actions after interaction
```

A component may contain:

```dart
onClick: (_) async {
  await toggleTodoAction(...);
}
```

during SSR because the callback is represented but not invoked. No action client needs to be configured in the SSR worker.

Calling an action directly during component rendering should produce a clear runtime error:

```text
Server functions cannot be invoked during
server rendering. Load initial data before
calling renderToString.
```

# Recommended generated flow

```text
todos_contract.dart
    shared DTOs
          │
          ▼
todos.action.g.dart
    IDs + hashes + codecs + refs
       │                  │
       ▼                  ▼
todos.client.g.dart    todos.registry.g.dart
client proxy           server wiring
       │                  │
browser bundle         native Dart binary
```

# Final implementation readiness

The design is ready once these are made explicit:

1. Shared refs/codecs live in `*.action.g.dart`.
2. Context is imported from `react_server`.
3. Required named wire parameters only in Phase 1.
4. One root-scoped runtime owns the action client.
5. Per-function contract hashes are generated.
6. Remote, server-domain and transport exceptions are distinct.
7. `@serverData` has a strict supported shape.
8. `react_actions` does not depend on `react`.
9. HTTP parsing, timeouts and client disposal are defined.
10. The Shelf endpoint validates protocol, content type, body size and request origin.

With those changes, the architecture remains compatible with all three future topologies:

```text
Shelf + Node SSR worker

Shelf + isolated Dart action service
      + Node SSR worker

Shelf + action registry
      + embedded JavaScript SSR runtime
```

None of those deployment changes require regenerating application components or changing the server-function calling API.
