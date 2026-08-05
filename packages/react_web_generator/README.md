# React Web Generator

Internal tooling for the React Dart ecosystem that generates the `react_web` package's DOM interfaces.

## Ecosystem Role
Parses Web IDL (Interface Definition Language) sources and Browser Compat Data (BCD) to automatically generate strongly-typed, exhaustive React DOM bindings (elements, attributes, events).

## Installation
This is an internal code generator for the workspace.
```yaml
dev_dependencies:
  react_web_generator: path: ../react_web_generator
```

## Core Usage
Typically invoked as a script to regenerate DOM bindings in the `react_web` package.

Internally, it uses an IR (Intermediate Representation) builder to process Web IDLs:
- `src/ir_builder.dart`: Processes parsed IDLs.
- `src/emit/`: Contains emitters for factories, browser adapters, React events, and SSR metadata.
- `src/complete/`: Verifies completeness and handles surface emission (neutral vs. SSR).

## Architecture & Design Notes
- **Data Driven**: Relies on standardized Web IDL and BCD to ensure the React Dart DOM representations are accurate, up-to-date, and strictly typed.
- **Ecosystem Foundation**: The output of this package is fundamental to `packages/react` and `packages/react_dom`, providing the core HTML/SVG elements that developers use every day.
- **Separation of Concerns**: Maintains discrete emitters for different targets (browser adapters, SSR metadata, neutral surface) ensuring the generated interfaces are appropriately optimized for their runtime environments.
