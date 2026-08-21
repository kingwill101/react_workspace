# react_dom

The recommended entrypoint for React Dart web components, browser mounting, and
SSR hydration.

`react_dom` re-exports the portable `react` contracts and typed
`react_web` host factories. Component source can therefore use one import for
hooks, nodes, DOM elements, events, styles, and prop helpers.

## Installation

```yaml
dependencies:
  react_dom: ^0.1.0
```

## Author a component

```dart
import 'package:react_dom/react_dom.dart';

@reactComponent
ReactNode Counter(({int initial}) props) {
  final (count, setCount) = useState(props.initial);

  return button(
    type: 'button',
    style: css(padding: '8px 12px'),
    onClick: (_) => setCount(count + 1),
    children: ['Count: $count'],
  );
}
```

The generated `Counter` factory is imported by its caller from
`package:my_app/.generated/counter.react.dart`.

## Browser entrypoint

Initialize the browser adapters, register generated component bridges, then
mount or hydrate:

```dart
import 'package:my_app/.generated/app.react.dart';
import 'package:my_app/.generated/react_components.g.dart';
import 'package:react_dom/react_dom.dart';

void main() {
  initReact();
  registerReactComponents();

  final root = getRoot('app');
  final props = getInitialProps();
  final app = App(title: props['title'] as String? ?? 'React Dart');

  if (hasSSRContent(root)) {
    hydrate(root, app);
  } else {
    mount(root, app);
  }
}
```

- `initReact()` installs the browser Web adapters and active React runtime.
- `getRoot(id)` resolves a root element without requiring application-level
  `dart:js_interop`.
- `getInitialProps()` reads the JSON payload from `#__props`.
- `mount(root, node)` creates a fresh React root.
- `hydrate(root, node)` attaches to server-rendered markup.
- `hasSSRContent(root)` distinguishes hydration from a client-only mount.

The browser and SSR entrypoints must construct the same root component and
props to avoid hydration mismatches.

## Package boundary

Portable node and hook contracts originate in `react`; typed Web declarations
and host factories originate in `react_web`; JavaScript rendering lives in
`react_js`. Application code should use this combined entrypoint unless it is
implementing one of those lower layers.
