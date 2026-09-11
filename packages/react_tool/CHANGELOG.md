# Changelog

## 0.2.8

- Coordinate DDC/DWDS, VM-enabled Dart servers, and Node SSR through a loopback
  debug gateway, with scaffolded VS Code tasks and attach configurations.
- Forward existing Chrome debug ports and reject invalid headless attachment
  options before building. Use resolved React versions for debug import maps.
- Align webdev's PATH-based SDK discovery with the Dart executable running the
  CLI, including when PATH contains SDK-manager wrappers.
- Allow cold service startup for up to a minute while failing immediately if
  the server or SSR worker exits, and close readiness probe connections fully.
- Registers scaffolded applications with existing Dart workspaces and relocates
  shared overrides and analyzer plugin declarations with conflict checks.
- Keep unresolved standalone projects from borrowing an enclosing workspace's
  package configuration or writing managed npm artifacts into its cache.
- Replaces doctor file-presence hints with actionable resolved-package/tool
  checks, explicit-entrypoint errors, generated-source age warnings, and JSON.

- Enable React analyzer diagnostics in new scaffolds and add `react setup`
  for existing projects, configuring workspace members at their analysis root.

- Keep local CLI, code generation, and analysis dependencies alongside local
  runtime packages when scaffolding with `--packages`, including the analyzer
  plugin's separate analysis-engine dependency context.
- Stream native test output and accept Dart test arguments after `--`.
- Generate an actual LCOV report for `react test --coverage`, including
  checkouts reached through symlinks.

## 0.2.7

- Scaffolds a code-generation-only `build.react.yaml` so `react generate` does
  not compile the web entrypoint before generated imports exist.
- Makes `generateSources` use `--config react` for new projects and build
  output filters as a fallback for existing projects without that config.
- Seeds the workspace build cache before synchronizing generated sources so
  clean checkouts can compile web entrypoints reliably.
- Preserves current build-cache output when stale legacy generated files use
  the same path.

## 0.2.6

- Adds DDC/DWDS client debugging with cached, accurately staged CSS, foreign
  bundles, callback trampolines, and source maps.
- Keeps debug and production browser entrypoints separate so production HTML
  loads only the bundled `browser.js` entrypoint.
- Makes generated client, Shelf, and Routed templates compatible with the
  DDC toolchain by requiring Dart 3.13 or newer.

## 0.2.5

- Propagates the Windows `npm.cmd` default through `ReactBuilder`, fixing the
  managed JavaScript environment in `react build` on Windows.

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
