# Client + shadcn

A client-only React Dart application demonstrating the lowest-friction
shadcn integration:

- shadcn components remain local TypeScript/React source;
- `react.yaml` declares the components and their Dart-facing props;
- `lib/.generated/foreign_components.g.dart` contains generated Dart wrappers,
  re-exported through `lib/shadcn.dart`;
- Tailwind compiles the shadcn classes before the Dart build.

The Button click is handled by a Dart callback, demonstrating the browser
callback bridge as well.

The `foreign.components` entries in `react.yaml` cause `react_tool` to import
the TypeScript components and register them in both the browser and SSR
foreign bundles. No hand-written JavaScript bridge is required.

## Setup

```sh
dart pub get
npm install
npm run build:css
```

## Add and enumerate a shadcn component

The source for the table is created by the normal shadcn CLI. `react_tool`
then discovers every public React component export in that local module:

```sh
npx --yes shadcn@latest add table --yes
dart run react_tool:react component list web/components/ui/table.tsx
```

The table module exposes `Table`, `TableHeader`, `TableBody`, `TableFooter`,
`TableHead`, `TableRow`, `TableCell`, and `TableCaption`. Each export can then
be added to `react.yaml` with `react component add`, using `--infer` to derive
its props from the TypeScript source.

## Build

```sh
npm run build
```

## Run

```sh
npm run serve
```

The server runs on `http://localhost:8080` and serves the client bundle statically.
