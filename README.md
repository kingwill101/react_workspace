# React Dart Workspace - MVP

Dart >=3.12.0 <4.0.0 + pub workspace, no melos.

## Structure
- packages/react - pure sealed ReactNode, ComponentId, Component with key+children
- packages/react_js - JsBinding, JsRenderer exhaustive switch
- packages/react_dom - mount Attach/Hydrate
- packages/react_codegen - generates .react.dart (pure factory returning Component with key+children) + .react.g.dart (JS wrapper extension type PropsJS + fromJS/toJS + $Component + register)
- example - Avatar, App, client.dart, ssr.dart

## First run
```
dart pub get
dart run build_runner build --workspace --delete-conflicting-outputs
dart compile js -O2 -o build/ssr.js example/lib/ssr.dart
dart compile js -O0 -o example/web/client.js example/web/client.dart
node ssr_worker.mjs &
dart run bin/dev.dart
```

## Boundary preserving
Source:
  Avatar({required src}) in avatar.dart
Generated pure:
  Avatar({required src, key, children}) => Component(_idAvatar, (src: src), key: key, children: children)

Usage in client.dart after generation:
  import 'lib/avatar.react.dart';
  Avatar(src: url, key: 'a', children: [Text('badge')])

JS wrapper calls impl inside React render, hooks isolated.
