# Client + shadcn

A client-only React Dart application demonstrating the lowest-friction
shadcn integration:

- shadcn components remain local TypeScript/React source;
- `web/shadcn_bridge.ts` registers stable foreign-component names;
- `lib/shadcn.dart` provides small Dart-facing wrappers;
- Tailwind compiles the shadcn classes before the Dart build.

The Button click is handled by a Dart callback, demonstrating the browser
callback bridge as well.

## Setup

```sh
dart pub get
npm install
npm run build:css
```

## Build

```sh
npm run build
```

## Run

```sh
npm run serve
```

The server runs on `http://localhost:8080` and serves the client bundle statically.
