# react

Portable React node, component, hook, context, ref, and runtime contracts for
Dart.

`react` contains no `dart:js_interop` or server-framework dependency. The same
component model can therefore be consumed by browser rendering, Node SSR,
native tests, code generation, and tooling.

## Installation

```yaml
dependencies:
  react: ^0.1.0
```

Web applications normally depend on `react_dom` instead. Its entrypoint
re-exports this package together with the typed host-element API.

## Components

Author components as functions with one named record parameter:

```dart
import 'package:react_dom/react_dom.dart';

@reactComponent
ReactNode UserCard(({
  required String name,
  String? role,
  ReactChildren children,
}) props) {
  final (expanded, setExpanded) = useState(false);

  return article(
    className: classNames('user-card', {'expanded': expanded}),
    children: [
      h2(key: 'name', children: [props.name]),
      if (props.role case final role?) p(key: 'role', children: [role]),
      button(
        key: 'toggle',
        type: 'button',
        onClick: (_) => setExpanded(!expanded),
        children: [expanded ? 'Collapse' : 'Expand'],
      ),
      ...props.children,
    ],
  );
}
```

Run `react generate`, `react build`, or `react serve`. The generated callable
factory is synchronized to
`package:my_app/.generated/user_card.react.dart` and is imported by callers,
not by the authored component itself.

Component factories accept a stable `key`, normalize `ReactChildren`, and
provide a `.props()` builder for composition-heavy call sites.

## Node model

Every render result is a `ReactNode`. The portable hierarchy includes:

| Type | Purpose |
| --- | --- |
| `Component<P>` | Invocation of a generated Dart component with typed record props. |
| `HostNode<P>` | Portable host element emitted by typed `react_web` factories. |
| `ForeignComponent` | Registered JavaScript or TypeScript React component. |
| `Text` | Explicit text node. Strings and numbers are also normalized as children. |
| `Fragment` | Keyable child group without a host wrapper. |
| `Empty` | Deliberately absent output. |
| `LazyNode`, `MemoizedNode`, `ForwardRefNode` | React lazy, memo, and ref-forwarding contracts. |

Application code should use the typed factories re-exported by `react_dom`
rather than constructing `HostNode` records manually.

## Children and props helpers

`ReactChildren` is `Iterable<Object?>`. `normalizeChildren` converts nested
iterables, strings, numbers, booleans, nulls, and existing nodes into the
portable tree.

Web-facing helpers available through `react_dom` include:

- `css(...)` for typed style maps;
- `classNames(...)` for conditional class composition;
- `dataAttributes(...)` and `aria(...)` for additional props;
- generated `<Element>.props()` builders for large prop sets.

## Hooks

The public hook surface delegates to the active `ReactBinding`:

- `useState`, `useReducer`, `useEffect`, and `useLayoutEffect`;
- `useMemo`, `useCallback`, `useRef`, and `useImperativeHandle`;
- `useContext`, `useSyncExternalStore`, `useTransition`, and
  `useDeferredValue`;
- React 18/19 APIs including `useId`, `useOptimistic`, and
  `useActionState`.

The workspace supports React 18 and 19. A hook missing from the active runtime
throws a descriptive `UnsupportedError`; do not infer API support only from a
successful npm installation.

Hooks must run while a component is rendered and at the top level of a
component or custom `use*` function. `react_analysis` and `react_analyzer`
provide matching diagnostics.

## Runtime features

The package also defines portable contracts for contexts, providers, refs,
error boundaries, suspense, strict mode, portals, memoization, lazy components,
and runtime capability checks. Renderers implement those contracts in
`react_js`, `react_server`, and `react_testing`.

## Package boundaries

- `react_dom`: recommended web component entrypoint and mount/hydrate APIs;
- `react_web`: generated DOM/Web surface and SSR-compatible host shapes;
- `react_js`: JavaScript renderer and hook binding;
- `react_server`: transport-neutral SSR and server-function primitives;
- `react_codegen`: component and server-function generation;
- `react_testing`: native component/runtime harnesses.
