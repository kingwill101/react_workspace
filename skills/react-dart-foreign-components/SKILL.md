---
name: react-dart-foreign-components
description: Add local TypeScript/React components such as shadcn, Radix, or design-system components to a React Dart application. Use when enumerating TSX exports, generating typed wrappers, inferring props, or validating browser and SSR foreign bundles.
---

# React Dart foreign components

Use this skill for project-local React/TypeScript components. The component
remains authored TSX; React Dart generates the Dart-facing wrapper and runtime
registration.

## 0. Scaffold the complete client setup

Start with a client-only React Dart project:

```console
dart run react_tool:react init client --template client
cd client
dart pub get
```

Because the React Dart packages are currently unpublished, make sure the
project's `pubspec.yaml` uses Git dependencies from the React workspace with a
consistent ref. The scaffolded workspace example uses path dependencies; an
external application should use:

```yaml
dependencies:
  react_core:
    git:
      url: https://github.com/kingwill101/react_workspace.git
      ref: master
      path: packages/react_core
  react_dom:
    git:
      url: https://github.com/kingwill101/react_workspace.git
      ref: master
      path: packages/react_dom
```

Install the JavaScript toolchain in the project root:

```console
npm install
```

The scaffold uses `react.yaml` for build inputs. The browser entrypoint is
`client.entrypoint`; client-only projects normally leave SSR and server
entrypoint files absent so those build steps are skipped. Styles are configured
as a list so generated Tailwind output can be included alongside library CSS:

```yaml
client:
  entrypoint: web/client.dart
styles:
  entrypoints:
    - web/styles.generated.css
  output: styles.css
```

The tool writes the final browser bundle to `build/react/browser.js`. Keep
`lib/.generated/` and `build/react/` out of authored code and source control;
the generated wrapper and bundle manifest are reproducible build output.

## Configure Tailwind

Use Tailwind 3 with a project-local CSS source. The shadcn CLI expects
`components.json` and `tsconfig.json`:

```json
// components.json
{
  "$schema": "https://ui.shadcn.com/schema.json",
  "style": "new-york",
  "rsc": false,
  "tsx": true,
  "tailwind": {
    "config": "tailwind.config.js",
    "css": "web/styles.css",
    "baseColor": "slate",
    "cssVariables": true
  },
  "aliases": {
    "components": "@/web/components",
    "utils": "@/web/components/ui/utils"
  }
}
```

```json
// tsconfig.json
{
  "compilerOptions": {
    "baseUrl": ".",
    "paths": { "@/*": ["./*"] }
  }
}
```

Create `tailwind.config.js` with both TSX and Dart sources in its content
globs:

```js
export default {
  content: ['./web/**/*.{ts,tsx}', './lib/**/*.dart'],
  theme: {
    extend: {
      colors: {
        border: 'hsl(var(--border))',
        input: 'hsl(var(--input))',
        ring: 'hsl(var(--ring))',
        background: 'hsl(var(--background))',
        foreground: 'hsl(var(--foreground))',
      },
    },
  },
  plugins: [],
};
```

Use `web/styles.css` as the authored source:

```css
@tailwind base;
@tailwind components;
@tailwind utilities;

@layer base {
  :root {
    --background: 210 40% 98%;
    --foreground: 222 47% 11%;
  }

  body {
    @apply m-0 bg-background text-foreground antialiased;
  }
}
```

Compile it to the file consumed by `react.yaml`:

```yaml
styles:
  entrypoints:
    - web/styles.generated.css
  output: styles.css
```

Add scripts so CSS always runs before Dart compilation:

```json
{
  "scripts": {
    "build:css": "tailwindcss -i ./web/styles.css -o ./web/styles.generated.css --minify",
    "build": "npm run build:css && dart run react_tool:react build",
    "serve": "npm run build:css && dart run react_tool:react serve"
  }
}
```

## 1. Install the JavaScript component

Use the component's normal JavaScript tool first. For shadcn:

```console
npx --yes shadcn@latest add textarea --yes
```

This should create a local module such as
`web/components/ui/textarea.tsx`. The same workflow applies to Radix wrappers,
local design systems, and hand-authored TSX modules.

## 2. Enumerate public exports

Before declaring wrappers, inspect every public component export:

```console
dart run react_tool:react component list \
  web/components/ui/textarea.tsx
```

The command handles both direct exports and the common pattern where a local
component is declared first and exported later:

```tsx
const Textarea = React.forwardRef(...)
export { Textarea }
```

For compound components, add each exported component that Dart code will use.

## 3. Generate the wrapper

Declare the selected export and infer its TypeScript props:

```console
dart run react_tool:react component add shadcn.Textarea \
  web/components/ui/textarea.tsx \
  --export Textarea \
  --infer
```

This updates `react.yaml`, generates
`lib/.generated/foreign_components.g.dart`, and validates the foreign bundle.
Do not hand-edit the generated Dart file.

If inference cannot expand a broad utility type such as
`React.ComponentProps<"textarea">`, add the narrow explicit contract in
`react.yaml`:

```yaml
foreign:
  components:
    - name: shadcn.Textarea
      module: web/components/ui/textarea.tsx
      export: Textarea
      props:
        className: String?
        placeholder: String?
        disabled: bool?
        rows: num?
```

Explicit props take precedence over inferred props. Keep the contract limited
to props the Dart application actually needs.

## 4. Use the generated wrapper from Dart

Re-export the generated facade from an authored entrypoint:

```dart
// lib/shadcn.dart
export '.generated/foreign_components.g.dart';
```

Use it from `app.dart` or another authored component:

```dart
import 'package:react_dom/react_dom.dart';
import 'shadcn.dart';

@reactComponent
ReactNode FeedbackForm(Object props) {
  return shadcnTextarea(
    id: 'feedback',
    placeholder: 'Your feedback helps us improve...',
    rows: 4,
  );
}
```

The generated helper is a normal Dart component function. Do not manually
construct host nodes or duplicate element definitions in `react_dom`.

## 5. Handle styling and compound components

Keep Tailwind, CSS, or Sass processing in the JavaScript project as authored by
the component library. Run the project's style command before `react build`:

```console
npm run build:css
dart run react_tool:react build
```

For a shadcn field composed of `Field`, `FieldLabel`, `Textarea`, and
`FieldDescription`, enumerate and declare each export. Shared TSX modules are
deduplicated in the foreign bundle.

## 6. Verify retention and SSR

Foreign declarations that are never rendered are intentionally pruned. Use a
generated helper from authored Dart, then inspect the build report:

```console
dart analyze
dart test
dart run react_tool:react build
```

Confirm the component appears in `build/react/bundle_report.json` for the
browser and SSR targets. For full-stack behavior, use `ReactTestHarness` with
the actual Routed or Shelf server adapter. Check that props use React DOM
shapes: for example, `style` is a map such as
`{'marginRight': '1em'}`, not a CSS string.

## General rule

Use `component list` and `component add --infer` for local TSX components. Use
`react ts bind` for reusable npm wrapper packages with TypeScript declarations.
Use a handwritten JavaScript shim only when the wrapper intentionally exposes a
custom facade, as documented by the `react_zustand` example.
