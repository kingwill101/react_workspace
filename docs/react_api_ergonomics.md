# React Dart API ergonomics

This document records the portable API direction for the React Dart packages.
It is inspired by OverReact's fluent builders, but does not depend on the
legacy `react` runtime used by OverReact.

## Design constraints

The public API must:

- produce the workspace's portable `ReactNode` tree;
- work with browser rendering, Node SSR, and `react_testing`;
- keep Web and JavaScript types out of `package:react`;
- allow generated DOM and foreign-component wrappers to share conventions;
- preserve typed Dart props without requiring callers to read string-key maps;
- remain compatible with generated sources and server actions.

## Component authoring

The normal component API is a function with a named record parameter:

```dart
@reactComponent
ReactNode Feedback(({String value, void Function(String) onChanged}) props) {
  return textarea(
    value: props.value,
    onChange: (event) => props.onChanged(event.target.value),
  );
}
```

`react_codegen` generates the callable public wrapper and its typed props
builder. The builder is useful when a component has many optional properties:

```dart
final feedback = Feedback.props()
  ..value = 'Initial value'
  ..onChanged = saveValue;

return feedback();
```

The generated wrapper remains the source of truth. Generated files under
`.generated/` must not be edited by hand.

## Portable composition helpers

Use `when`, `unless`, and `each` for common collection composition:

```dart
div(children: [
  when(isAdmin, AdminBadge()),
  unless(isLoading, Results(items)),
  ...each(rows, (row, index) => ResultRow(row, key: '$index')),
]);
```

These helpers return portable nodes or iterables. They do not inspect the
active renderer and are safe during SSR.

## State

The tuple API remains available for direct React parity:

```dart
final (count, setCount) = useState(0);
```

When a named value is clearer, use:

```dart
final count = useStateController(0);
count.set(count.value + 1);
```

Both forms call the same renderer binding and obey the normal Rules of Hooks.

## Styling

`react_web` owns the Web-specific `classNames` and typed inline `css` style
map. Portable libraries can use `joinClassNames` from `react` when they must
remain independent of Web bindings.

```dart
button(
  className: classNames(
    'button',
    {'button-primary': isPrimary, 'button-disabled': disabled},
  ),
  style: css(padding: '0.5rem 1rem'),
  children: ['Save'],
);
```

This works for Tailwind utilities, shadcn components, and ordinary CSS. The
runtime does not bundle or interpret a CSS framework.

## Registered component factories

Generated or registered components can expose a
`ReactComponentFactory<P>` when a stable component ID is useful:

```dart
final Greeting = component<GreetingProps>(
  const ComponentId('package:app/greeting.dart#Greeting'),
  metadata: const ReactComponentMetadata(name: 'Greeting'),
);

final node = Greeting(const GreetingProps(name: 'Ada'));
```

The factory creates a `Component<P>` node. It does not perform registration;
registration remains the responsibility of the generated browser and SSR
bridges.

## Naming and package split

Before publication, the current package name `react` should be evaluated
against a publishable family name. `react_core` is the leading candidate:

```text
react_core, react_dom, react_js, react_web, react_server, react_testing
```

That rename should be done as one deliberate migration after the API is stable,
because generated imports, Git dependencies, descriptors, examples, and
documentation all need to move together. Until then, the workspace package
name remains `react` and consumers use the explicit Git reference documented in
the repository.

## What is intentionally not copied from OverReact

The workspace does not plan to make `UiProps` a mutable `Map` subclass or make
the legacy `ReactElement` runtime part of the portable contract. Those choices
would reintroduce browser-only assumptions and make SSR/test parity harder.
