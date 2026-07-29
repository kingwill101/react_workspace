This is a solid direction, but I would **not implement the document unchanged**. The transport separation is sound; the compilation boundary and SSR integration need correction.

The most important fixes are:

1. Do not duplicate result classes into the generated proxy.
2. Do not run server functions from `useEffect` during SSR—effects only run on the client. ([React][1])
3. Keep browser-safe protocol types out of a package whose public API may later become VM-only.
4. Always make generated client proxies asynchronous.
5. Use a request-scoped action context and structured errors.
6. Do not bake the three-process development topology into the framework API.

# 1. Correct package ownership

The browser currently needs:

```text id="64zjgx"
ServerFunctionId
ServerFunctionRef
ServerFunctionJsonCodec
ServerFunctionClient
generated proxies
```

Those are not server-runtime types. They are the shared action protocol.

I recommend:

```text id="jx2bqq"
react_actions
├── @serverFunction annotation
├── ServerFunctionId
├── ServerFunctionRef
├── ServerFunctionJsonCodec
├── ServerFunctionClient
├── ServerFunctionException
├── protocol request/response models
└── current runtime/client scope

react_server
├── ServerFunctionRegistry
├── ServerFunctionContext
├── Shelf handler
├── authentication integration
├── dispatch
└── native-only server concerns

react_web
└── HttpServerFunctionClient

react_codegen
├── client proxy generation
├── codec generation
├── contract validation
└── server registry generation
```

The dependency graph becomes:

```text id="mxltwk"
react_web ───────▶ react_actions

react_server ────▶ react_actions

application client
    └────────────▶ generated proxy
                       └──────▶ react_actions

application server
    └────────────▶ generated registry
                       ├──────▶ react_server
                       ├──────▶ react_actions
                       └──────▶ original implementation
```

An alternative is to keep everything in `react_server` but expose a browser-safe library:

```dart id="6n9ufk"
import 'package:react_server/protocol.dart';
```

and keep VM-only APIs in:

```dart id="onpbjc"
import 'package:react_server/server.dart';
```

However, `react_actions` communicates the boundary more clearly.

# 2. Do not inline-copy result classes

This proposed generated class is problematic:

```dart id="2z3h1x"
// Generated client copy.
final class ToggleTodoResult {
  final String id;
  final bool completed;
}
```

while the original server file also has:

```dart id="nyz2sv"
// Original server type.
final class ToggleTodoResult {
  final String id;
  final bool completed;
}
```

Those are two different nominal Dart types, even though they have the same name and fields.

The generated ref would use:

```dart id="6z7vqx"
ServerFunctionRef<
  ToggleTodoArguments,
  generated.ToggleTodoResult
>
```

but the implementation returns:

```dart id="t8j36u"
Future<server.ToggleTodoResult>
```

The server registration cannot safely return one where the other is expected without generating an explicit mapping.

It also creates long-term problems:

* Client and server DTO definitions can drift.
* Methods, validation and equality behavior differ.
* Nested DTOs require more copied declarations.
* Imports become difficult to reconstruct.
* Error messages show two classes with identical names.
* Type identity is lost.

## Recommended contract arrangement

Put transport types in a browser-safe contract file:

```dart id="lubgl4"
// lib/actions/todos_contract.dart

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
```

Put the implementation in a server-only file:

```dart id="3sfsbd"
// lib/actions/todos.server.dart

import 'package:postgres/postgres.dart';
import 'package:react_actions/react_actions.dart';

import 'todos_contract.dart';

@serverFunction
Future<ToggleTodoResult> toggleTodo({
  required String todoId,
  required bool completed,
}) async {
  final todo = await todoRepository.update(
    todoId,
    completed: completed,
  );

  return ToggleTodoResult(
    id: todo.id,
    completed: todo.completed,
  );
}
```

The generated proxy imports only the contract:

```dart id="pppgdn"
// GENERATED
// lib/actions/todos.client.g.dart

import 'package:react_actions/react_actions.dart';

import 'todos_contract.dart';

final toggleTodoRef = ServerFunctionRef<
  ({String todoId, bool completed}),
  ToggleTodoResult
>(
  // ...
);

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

The generated registry imports both:

```dart id="x0ccnk"
// GENERATED
// lib/actions/todos.registry.g.dart

import 'package:react_server/react_server.dart';

import 'todos.client.g.dart';
import 'todos.server.dart' as implementation;

void registerTodosServerFunctions(
  ServerFunctionRegistry registry,
) {
  registry.register(
    toggleTodoRef,
    (arguments, context) {
      return implementation.toggleTodo(
        todoId: arguments.todoId,
        completed: arguments.completed,
      );
    },
  );
}
```

## Generator validation

When a named parameter or result type is declared inside the server implementation library, generation should fail:

```text id="7iyqzm"
Server function contract type is not client-safe.

Function:
  toggleTodo

Type:
  ToggleTodoResult

Declared in:
  package:app/actions/todos.server.dart

Move the type to a browser-safe contract library or return a record.
```

Record returns remain a convenient alternative:

```dart id="dr5t6r"
@serverFunction
Future<({
  String id,
  bool completed,
})> toggleTodo({
  required String todoId,
  required bool completed,
}) async {
  // ...
}
```

# 3. Client proxies must always return `Future<TResult>`

The document says whether the original function returns `Future` influences whether the client proxy returns `Future<T>` or `T`.

That should be changed.

A network call is always asynchronous:

```dart id="x8w9mn"
Future<TResult> invoke<TArgs, TResult>(
  ServerFunctionRef<TArgs, TResult> ref,
  TArgs arguments,
);
```

Even when the server implementation is synchronous:

```dart id="fk19au"
@serverFunction
int add({
  required int a,
  required int b,
}) {
  return a + b;
}
```

the client proxy must be:

```dart id="po8xof"
Future<int> addAction({
  required int a,
  required int b,
}) {
  return currentServerFunctionClient.invoke(
    addRef,
    (a: a, b: b),
  );
}
```

The registry can accept `FutureOr<TResult>`:

```dart id="s7vzfm"
void register<TArgs, TResult>(
  ServerFunctionRef<TArgs, TResult> ref,
  FutureOr<TResult> Function(
    TArgs arguments,
    ServerFunctionContext context,
  ) handler,
)
```

But the remote caller always receives a `Future<TResult>`.

# 4. Correct the SSR section

This part of the document is incorrect:

```text id="4i9kh1"
React component tree builds
useEffect fires
useEffect calls toggleTodoAction()
SSR finishes rendering
```

React effects only run on the client; they do not run during server rendering. ([React][1])

Therefore:

```dart id="ft55p6"
useEffect(() {
  fetchTodosAction();
}, const []);
```

does not preload data into SSR HTML.

## Correct SSR data flow

Initial data should be resolved before rendering:

```text id="3tfruk"
Browser GET
    ↓
Shelf route handler
    ↓
load data in native Dart
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

Example:

```dart id="hzq5ae"
Future<Response> renderTodosPage(
  Request request,
) async {
  final todos =
      await todoRepository.listForUser(
    request.context['userId'] as String,
  );

  final props = {
    'initialTodos': todos
        .map((todo) => todo.toJson())
        .toList(),
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

The component receives the initial state:

```dart id="cjcqwr"
@reactComponent
ReactNode TodoList(
  ({
    List<TodoView> initialTodos,
  }) props,
) {
  final (todos, setTodos) =
      useState(props.initialTodos);

  // Interactive calls happen after hydration.
  // ...
}
```

A generated server-function proxy may be present inside an event-handler closure during SSR because the closure is never invoked. But the SSR renderer should not attempt to configure or execute it.

# 5. Do not require the SSR worker to call the function service

You could make the Node worker invoke the Dart action endpoint explicitly, but that should not be the default initial-data architecture.

The Shelf process is already native Dart and already has access to:

* Repositories
* Authentication
* Request headers
* Database pools
* Server-function registry
* Route context

It should prepare the initial props before asking the JS worker to render.

```text id="2nh5ba"
Recommended:

Shelf
  ├── authenticate
  ├── load data
  ├── send serializable props to SSR
  └── return HTML

Not recommended:

Shelf
  └── SSR worker
        └── component effect
              └── HTTP back to Dart server
```

The second approach adds an unnecessary network round-trip and cannot work through `useEffect` during SSR anyway.

# 6. The function service does not have to be a third process

Your diagram has:

```text id="awbh1y"
Shelf gateway        8080
Node SSR worker      3001
Dart function server 3002
```

That is a valid deployment option, but it should not be part of the framework contract.

Shelf is already running on the Dart VM. The simplest initial setup is:

```text id="d9s1jm"
Shelf/Dart server    8080
├── page routes
├── /__react/actions
├── static files
├── ServerFunctionRegistry
└── proxy to SSR worker

Node SSR worker      3001
└── rendering only
```

Browser flow:

```text id="5e23qj"
POST /__react/actions
    ↓
Shelf handler
    ↓
local ServerFunctionRegistry
    ↓
business logic
```

This removes:

* One process.
* One internal port.
* Function-service CORS.
* An extra proxy hop.
* Another restart/watch lifecycle.
* Another health check.

If action execution later needs process isolation, Shelf can proxy the same endpoint to port 3002 without changing the browser protocol:

```text id="opmrbx"
Browser always calls:
  /__react/actions

Deployment chooses:
  local registry
  or remote action service
```

This also fits the future embedded-JavaScript plan:

```text id="fgfepf"
Single Dart process
├── Shelf
├── ServerFunctionRegistry
└── embedded JS SSR engine
```

# 7. Use same-origin routing

The browser should not normally call:

```text id="9bhgqw"
http://localhost:3002
```

It should call:

```text id="nfh85j"
/__react/actions
```

Shelf can dispatch locally or proxy internally.

That avoids browser CORS complexity and makes authentication cookies straightforward.

Initialize the client with:

```dart id="8weukm"
final actionClient =
    HttpServerFunctionClient(
  endpoint: Uri.parse(
    '/__react/actions',
  ),
);
```

# 8. Prefer `package:http` over handwritten fetch interop

The proposed `HttpServerFunctionClient` manually defines:

```dart id="w1xzk5"
@JS('fetch')
external JSObject _fetchJs(...);
```

and manually converts promises using `then` and `catch`.

That is unnecessary and introduces several places where JS interop typing can go wrong.

`package:web` is the generated low-level browser binding package. Its own helper documentation recommends using cross-platform `package:http` rather than depending on its deprecated convenience HTTP API. ([Dart packages][2])

Use:

```dart id="ipw706"
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:react_actions/react_actions.dart';

final class HttpServerFunctionClient
    implements ServerFunctionClient {
  final Uri endpoint;
  final http.Client client;

  HttpServerFunctionClient({
    required this.endpoint,
    http.Client? client,
  }) : client = client ?? http.Client();

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
    final request = ServerFunctionRequest(
      protocolVersion: 1,
      id: ref.id.value,
      arguments:
          ref.argumentsCodec.encode(
        arguments,
      ),
    );

    final response = await client.post(
      endpoint,
      headers: const {
        'content-type':
            'application/json',
        'accept':
            'application/json',
      },
      body: jsonEncode(
        request.toJson(),
      ),
    );

    final decoded = jsonDecode(
      response.body,
    );

    final envelope =
        ServerFunctionResponse.fromJson(
      decoded,
    );

    if (!envelope.ok) {
      throw ServerFunctionException(
        envelope.error!,
        statusCode: response.statusCode,
      );
    }

    return ref.resultCodec.decode(
      envelope.result,
    );
  }
}
```

`package:http` also encourages accepting an explicit client so applications can choose and test the transport implementation. ([Dart packages][3])

# 9. Replace the global mutable client

This:

```dart id="t0rccd"
currentServerFunctionClient =
    HttpServerFunctionClient(...);
```

works for a basic browser application, but it makes:

* Tests order-dependent.
* Multiple application roots difficult.
* Nested runtimes difficult.
* Request-scoped configuration difficult.
* SSR runtime isolation harder.

Use a scoped runtime similar to the planned React runtime:

```dart id="nt7o27"
final class ServerFunctionRuntime {
  final ServerFunctionClient client;

  const ServerFunctionRuntime({
    required this.client,
  });
}

final Object _serverFunctionRuntimeKey =
    Object();

ServerFunctionRuntime
    get currentServerFunctionRuntime {
  final runtime =
      Zone.current[
        _serverFunctionRuntimeKey
      ];

  if (runtime
      is! ServerFunctionRuntime) {
    throw StateError(
      'No ServerFunctionRuntime is active.',
    );
  }

  return runtime;
}

T runWithServerFunctionRuntime<T>(
  ServerFunctionRuntime runtime,
  T Function() callback,
) {
  return runZoned(
    callback,
    zoneValues: {
      _serverFunctionRuntimeKey:
          runtime,
    },
  );
}
```

Generated proxy:

```dart id="586wdn"
Future<ToggleTodoResult>
    toggleTodoAction({
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

The browser root activates it:

```dart id="ujw11u"
void main() {
  final actionRuntime =
      ServerFunctionRuntime(
    client:
        HttpServerFunctionClient(
      endpoint: Uri.parse(
        '/__react/actions',
      ),
    ),
  );

  runWithServerFunctionRuntime(
    actionRuntime,
    () {
      hydrateRoot(
        '#app',
        App(),
      );
    },
  );
}
```

If the asynchronous zone does not reliably cover callbacks registered with React JS, attach the client to the root’s `ReactRuntime` instead:

```dart id="2f9fll"
final class ReactRuntime {
  final ReactBinding binding;
  final ReactRenderer renderer;
  final ServerFunctionClient?
      serverFunctionClient;

  // ...
}
```

That may be the better integration for this framework.

# 10. Add `ServerFunctionContext`

The registry handler needs request context from the start:

```dart id="1ujr3e"
final class ServerFunctionContext {
  final String requestId;
  final Object? principal;
  final Map<String, String> headers;
  final Uri requestUri;

  const ServerFunctionContext({
    required this.requestId,
    required this.principal,
    required this.headers,
    required this.requestUri,
  });
}
```

Registry:

```dart id="0q6yvt"
final class ServerFunctionRegistry {
  final _handlers = <
    String,
    Future<dynamic> Function(
      dynamic arguments,
      ServerFunctionContext context,
    )
  >{};

  void register<TArgs, TResult>(
    ServerFunctionRef<
      TArgs,
      TResult
    > ref,
    FutureOr<TResult> Function(
      TArgs arguments,
      ServerFunctionContext context,
    ) function,
  ) {
    if (_handlers.containsKey(
      ref.id.value,
    )) {
      throw StateError(
        'Duplicate server function: '
        '${ref.id.value}',
      );
    }

    _handlers[ref.id.value] =
        (raw, context) async {
      final arguments =
          ref.argumentsCodec.decode(raw);

      final result = await function(
        arguments,
        context,
      );

      return ref.resultCodec.encode(
        result,
      );
    };
  }

  Future<dynamic> dispatch(
    String id,
    dynamic arguments,
    ServerFunctionContext context,
  ) async {
    final handler = _handlers[id];

    if (handler == null) {
      throw UnknownServerFunctionException(
        id,
      );
    }

    return handler(
      arguments,
      context,
    );
  }
}
```

Server function:

```dart id="jgyg0n"
@serverFunction
Future<ToggleTodoResult> toggleTodo(
  ServerFunctionContext context, {
  required String todoId,
  required bool completed,
}) async {
  final user = context.requireUser();

  final todo =
      await todoRepository.find(todoId);

  if (todo.ownerId != user.id) {
    throw const ForbiddenActionException();
  }

  // ...
}
```

The context parameter is server-injected and not serialized by the generated client proxy.

# 11. Use structured error envelopes

Avoid:

```json id="8aynx0"
{
  "error": "Todo not found: todo-42"
}
```

Use:

```json id="5dmzcf"
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

And success:

```json id="ejku09"
{
  "ok": true,
  "result": {
    "id": "todo-42",
    "completed": true
  }
}
```

I would also use meaningful HTTP statuses:

| Situation             | Status |
| --------------------- | -----: |
| Success               |  `200` |
| Invalid JSON/protocol |  `400` |
| Unauthenticated       |  `401` |
| Forbidden             |  `403` |
| Unknown function      |  `404` |
| Conflict              |  `409` |
| Validation failure    |  `422` |
| Timeout               |  `504` |
| Internal failure      |  `500` |

The typed envelope still distinguishes domain errors from network failures. Returning HTTP 200 for every application error reduces observability and makes proxies, logs and monitoring less useful.

# 12. Add protocol and build versions

The request should include:

```json id="it6qdo"
{
  "protocol": 1,
  "clientBuild": "f57cb9...",
  "id": "package:app/actions/todos.server.dart#toggleTodo",
  "arguments": {
    "todoId": "todo-42",
    "completed": true
  }
}
```

This allows the server to detect:

* Stale browser bundle calling a removed function.
* Codec schema mismatch.
* Unsupported protocol versions.
* Rolling-deployment incompatibility.

A stale client can receive:

```json id="vzhn3v"
{
  "ok": false,
  "error": {
    "code": "stale_client",
    "message": "The application has been updated."
  }
}
```

The browser can then reload.

# 13. Revised source and generated files

```text id="rr8z1g"
lib/actions/
├── todos_contract.dart
├── todos.server.dart
├── todos.client.g.dart
└── todos.registry.g.dart
```

## Contract

```dart id="jb0nbz"
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

## Server implementation

```dart id="0gr16b"
@serverFunction
Future<ToggleTodoResult> toggleTodo(
  ServerFunctionContext context, {
  required String todoId,
  required bool completed,
}) async {
  // Native-only dependencies allowed.
}
```

## Generated client proxy

```dart id="tntmz8"
import 'package:react_actions/react_actions.dart';

import 'todos_contract.dart';

final toggleTodoRef =
    ServerFunctionRef<
      ({
        String todoId,
        bool completed,
      }),
      ToggleTodoResult
    >(
  // ...
);

Future<ToggleTodoResult>
    toggleTodoAction({
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

## Generated registry

```dart id="6ggcjd"
import 'package:react_server/react_server.dart';

import 'todos.client.g.dart';
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

# 14. Revised runtime topology

## Initial implementation

```text id="9ve0lf"
Browser
├── GET /todos
└── POST /__react/actions
          │
          ▼
Shelf/Dart VM :8080
├── page routes
├── action registry
├── database access
├── static assets
└── SSR worker client
          │
          ▼
Node SSR worker :3001
└── ReactDOMServer
```

## Optional isolated action service

```text id="0pkycv"
Shelf :8080
└── /__react/actions
        ↓ internal proxy
Dart action service :3002
```

## Future embedded runtime

```text id="7rhz37"
Dart process
├── Shelf
├── action registry
├── database
└── embedded JavaScript runtime
      └── ReactDOMServer
```

The browser endpoint and generated proxy remain unchanged across all three.

# Revised implementation order

```text id="9mtgja"
1. Create browser-safe react_actions package.

2. Add ServerFunctionId, ref, codec,
   protocol envelope and client interface.

3. Add ServerFunctionContext and registry
   to react_server.

4. Add same-origin Shelf action handler.

5. Generate proxies using only
   client-safe contract imports.

6. Reject named DTO types declared in
   native-only implementation libraries.

7. Generate server registrations.

8. Implement HttpServerFunctionClient
   with package:http.

9. Integrate the action client into
   the scoped React runtime.

10. Add full client → Shelf → registry
    integration tests.

11. Add SSR + hydration + click/action
    integration tests.

12. Add process isolation only when
    operationally justified.
```

The strongest parts of the existing proposal are the typed reference, per-function codecs, generated registry and separation from the React JS callback codec. The parts to change now are the copied DTO classes, the `useEffect` SSR model, the global client and the assumption that server functions necessarily require a third process.

[1]: https://react.dev/reference/react/useEffect?utm_source=chatgpt.com "useEffect – React"
[2]: https://pub.dev/documentation/web/latest/?utm_source=chatgpt.com "web - Dart API docs"
[3]: https://pub.dev/documentation/http/latest/?utm_source=chatgpt.com "http - Dart API docs"
