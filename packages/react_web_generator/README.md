# React Web Generator

Internal tooling for the React Dart ecosystem that generates the `react_web` package's DOM interfaces.

## Ecosystem Role

Parses Web IDL (Interface Definition Language) sources and Browser Compat Data (BCD) to automatically generate strongly-typed, exhaustive React DOM bindings (elements, attributes, events).

## Installation

This is an internal code generator for the workspace.

```yaml
dev_dependencies:
  react_web_generator: ^0.1.0
```

## Core Usage

The generator follows the exact `package:web 1.1.1` surface pinned in
`tool/web_idl/pin.json`. From the workspace root:

```bash
git submodule update --init third_party/web
dart run tool/web_idl/update.dart
dart run tool/web_idl/generate_factories.dart
dart run tool/web_idl/verify.dart --strict
dart test packages/react_web_generator
dart test packages/react_testing/test/generator_fidelity_test.dart
```

`update.dart` validates the submodule revision and exact Dart dependency pins,
then recreates the normalized snapshot from the WebRef versions locked by the
matching Dart web release. Generated Dart sources belong under
`packages/react_web/lib/src/generated/`; edit the generator, overlay, or pin
instead of editing those files directly.

## Generator architecture

`WebBindingsGenerator` is the single orchestration entrypoint. The script under
`tool/web_idl/` only locates the workspace and delegates to it. A generation run
has explicit phases:

1. `WebGenerationPaths` resolves and validates every input and output from one
   workspace root.
2. `CompleteWebModelBuilder` parses the normalized snapshot and `mergeRawModel`
   produces the complete IDL model.
3. `NeutralSurfaceEmitter` writes the complete and per-spec portable APIs.
4. `CompletenessVerifier` compares the emitted manifest to the source model.
5. Runtime emitters write SSR declarations, browser adapters, and React events.
6. `WebHostIrBuilder` creates the HTML/SVG host-element IR.
7. Factory and metadata emitters render the host-element outputs.
8. The pipeline formats every generated Dart file. Formatting is part of
   generation, not an undocumented follow-up command.

The main ownership boundaries are:

- `src/complete/`: snapshot parsing, normalized definitions, merging, type
  resolution, and completeness verification;
- `src/emit/browser_adapter_plan.dart`: browser proxy closure, conversion-kind
  classification, and compatible inheritance decisions;
- `src/emit/`: rendering only—emitters should consume a model or plan instead
  of rediscovering policy while writing strings;
- `src/generation/`: pipeline order, paths, reporting, output formatting;
- `src/ir_builder.dart`: React host-property and host-event IR;
- `config/`: authored React DOM overlays and strict starter roots.

When an emitter starts accumulating graph traversal, conflict resolution, or
classification logic, extract a typed planning phase and test that phase
directly. String-fragment tests should be reserved for rendering syntax.

## Changing the generator

From the workspace root:

```bash
dart analyze --fatal-infos packages/react_web_generator
dart test packages/react_web_generator
dart run tool/web_idl/generate_factories.dart
dart run tool/web_idl/verify.dart --strict
dart test packages/react_testing/test/generator_fidelity_test.dart
git diff --exit-code -- packages/react_web/lib/src/generated \
  packages/react_web/lib/apis \
  packages/react_codegen/lib/src/generated
```

The final diff command is expected to fail when an intentional API change has
been made; in that case review the generated diff and run generation a second
time. The second run must be clean.

## Architecture & Design Notes

- **Data Driven**: Relies on standardized Web IDL and BCD to ensure the React Dart DOM representations are accurate, up-to-date, and strictly typed.
- **Ecosystem Foundation**: The output of this package is fundamental to `packages/react_core` and `packages/react_dom`, providing the core HTML/SVG elements that developers use every day.
- **Separation of Concerns**: Maintains discrete emitters for different targets (browser adapters, SSR metadata, neutral surface) ensuring the generated interfaces are appropriately optimized for their runtime environments.
- **Output Parity**: Structural refactors must reproduce every owned generated
  file byte-for-byte. Capture hashes before a refactor and compare all outputs
  after regeneration.

The full maintainer workflow is documented in
[Maintaining the workspace](https://github.com/kingwill101/react_workspace/blob/master/.site/docs/maintainers/maintenance.mdx).
