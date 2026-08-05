# React Dart Code Generation (`react_codegen`)

The `build_runner` code generator for React Dart. It generates pure functional components from `@ReactComponent` annotations and client/server bridges for `@serverFunction` and `@serverData`.

## Ecosystem Role

`react_codegen` is the engine that converts idiomatic Dart types and functions into React-compatible JavaScript interop calls without requiring users to write `dart:js_interop` manually. It ensures strong typing across the boundary and produces the necessary factory methods to instantiate React components efficiently.

## Installation

Add `react_codegen` and `build_runner` to your `dev_dependencies` in `pubspec.yaml`:

```yaml
dev_dependencies:
  build_runner: ^2.4.0
  react_codegen:
    path: packages/react_codegen # Or use a version constraint if published
```

## How to Use

### Components

Annotate your component functions with `@ReactComponent`. The function must take exactly one record parameter with named fields.

```dart
import 'package:react/react.dart';

@ReactComponent
ReactNode Avatar({required String src, bool? round}) {
  return img(src: src, className: round == true ? 'round' : 'square');
}
```

Run `build_runner`:

```bash
dart run build_runner build
```

This generates `avatar.react.dart` containing an `Avatar` factory that adds `key` and `children` props automatically, allowing you to use it in your application safely.

### Server Functions (RPC)

Annotate server-side business logic with `@serverFunction` and data transfer objects with `@serverData`.

```dart
import 'package:react_actions/react_actions.dart';

@serverData
final class ToggleResult {
  final String id;
  final bool completed;

  const ToggleResult({required this.id, required this.completed});
}

@serverFunction
Future<ToggleResult> toggleTodo(
  ServerFunctionContext context, {
  required String todoId,
}) async {
  // Database logic here...
  return ToggleResult(id: todoId, completed: true);
}
```

The generator produces:
- A client-side proxy to invoke the function over HTTP.
- Specialized codecs for serialization of `@serverData`, `List`, `Map`, `DateTime`, etc.
- A registry to safely route requests on the server backend.

## Architecture & Generated Code

- **Pure Functions:** For `@ReactComponent`, the original function remains untouched. The generated file provides a boundary-preserving factory function that returns a `Component` node, which delegates to your Dart implementation when React renders it.
- **Server Actions:** For `@serverFunction`, the generator parses the arguments and return types. It generates typed arguments records, a serialization codec that conforms to the wire protocol defined in `react_actions`, and a client stub that uses `ServerFunctionClient`.
