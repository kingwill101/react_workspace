# Changelog

## 0.2.4

- Fixes generated imports after authored React files moved under `lib/react/`.
- Uses hosted Routed packages in Routed scaffolds.
- Uses generated server-function references without duplicate handwritten refs.
- Makes both Routed templates generate runnable tests and fixes their README
  command fences.
- Resolves the npm command as `npm.cmd` on Windows so managed JavaScript
  environment installation works without a shell wrapper.

## 0.2.3

- Makes generated projects use the published React Dart packages by default.
- Adds `--packages` for local workspace overrides.
- Organizes authored starter files under `lib/react/`.
- Aligns generated README instructions and tests with the files the scaffold
  actually creates.

## 0.2.2

- Includes the gitignore and Docker ignore scaffold templates in the pub.dev
  archive so `react init` works from the hosted package.

## 0.2.1

- Ships verified native prebuilts for Linux, macOS, and Windows on x64 and
  ARM64 hosts.
- Widens the `artisanal` constraint so the published CLI resolves alongside
  the native prebuilt toolchain.

## 0.2.0

- Documents structured client, SSR, server, and stylesheet entrypoints.
- Documents Node and Fetch SSR runtimes, generated build artifacts, foreign
  module configuration, and selectable bundling backends.
- Updates the React Dart project skills with the current configuration and
  generated-output guidance.

## 0.1.1

- Declares native build-hook packages as runtime dependencies as required by
  `dart pub publish`.
- Documents the intentional hook-only imports for static analysis.

## 0.1.0

- Introduces project scaffolding, Dart code generation, browser and SSR builds, serving, and diagnostics.
- Adds managed JavaScript dependencies and TypeScript declaration binding generation.
