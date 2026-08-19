# React Dart Shelf integration (`react_server_shelf`)

`react_server_shelf` is the optional Shelf adapter for `react_server`.
It provides `ReactServerApp` and `createServerActionHandler` while keeping
the portable `react_server` package free of Shelf dependencies.

```yaml
dependencies:
  react_server:
    path: ../react_server
  react_server_shelf:
    path: ../react_server_shelf
```

```dart
import 'package:react_server/react_server.dart';
import 'package:react_server_shelf/react_server_shelf.dart';
```
