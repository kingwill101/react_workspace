# react_web

Portable Web API declarations, generated HTML/SVG factories, typed React
events, SSR metadata, and browser adapters for React Dart.

Applications normally import `package:react_dom/react_dom.dart`, which
re-exports this package together with the core React APIs.

## Installation

```yaml
dependencies:
  react_web: ^0.1.0
```

## Typed host factories

```dart
import 'package:react_dom/react_dom.dart';
import 'package:react_web/web.dart' show HTMLInputElement;

@reactComponent
ReactNode SearchField(({
  required String value,
  required void Function(String) onChanged,
}) props) {
  return input(
    type: 'search',
    value: props.value,
    additionalProps: aria(label: 'Search'),
    style: css(minWidth: 240),
    onChange: (event) {
      final input = event.currentTarget as HTMLInputElement;
      props.onChanged(input.value);
    },
  );
}
```

Factories expose generated Web attributes, React event props, `key`,
`children`, `style`, and `additionalProps`. Each also has a `.props()`
builder for large or reusable prop sets.

Use `classNames`, `css`, `dataAttributes`, and `aria` instead of
manually assembling common prop maps.

## Server-action forms

`useServerAction` exposes typed pending, result, and error state. For a native
form, `serverActionSubmit` prevents navigation, converts the form to
`FormData`, and invokes the action once while it is pending:

```dart
final action = useServerAction(saveProfile);

form(
  onSubmit: serverActionFormSubmit(
    action,
    (data) => (name: data.text('name') ?? ''),
  ),
  children: [
    button(type: 'submit', disabled: action.pending, children: ['Save']),
  ],
);
```

For React 19 runtimes, `useOptimisticServerAction` applies an optimistic
state update inside a transition while retaining the typed action result and
error. Server functions may return field messages in
`ServerFunctionFailure.details['fieldErrors']`; read them with
`serverActionFieldErrors(action.error)`.

## Portable Web surface

`package:react_web/web.dart` exports the generated browser API model.
Application-facing types are ordinary Dart interfaces and value classes, so
they can appear in shared component signatures and native tests. Browser builds
install adapters backed by the pinned `package:web` implementation; unavailable
SSR operations expose explicit unsupported behavior rather than raw JS objects.

The current generator target is exactly `package:web 1.1.1`.

## Browser setup

`initReact()` from `react_dom` calls `registerBrowserAdapters()` and
`installBrowserWebRuntime()`, then installs the JavaScript renderer and hook
binding. Most applications should call only `initReact()`.

Generator bridge code uses `ReactCodecRegistry` to encode/decode synthetic
events and Web host values. Component code does not need `.toJS`, casts to
raw JS objects, or direct `package:web` imports.

## Generation

The surface is generated from pinned Web IDL snapshots, Browser Compat Data,
React overlays, and curated roots by `react_web_generator`. Do not hand-edit
`lib/src/generated/`. See the workspace maintainer guide for pin updates,
strict completeness verification, and determinism checks.
