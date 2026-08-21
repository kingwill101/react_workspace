# react_analysis

Shared semantic analysis for React Dart components, hooks, SSR code, import
boundaries, codecs, and runtime usage. This package is the source of truth used
by `react_analyzer`, `react_codegen`, and `react_tool`; it does not register an
IDE plugin itself.

## Installation

```yaml
dependencies:
  react_analysis: ^0.1.0
```

Choose an analyzer based on the source information you already have:

| API | Input | Use it for |
| --- | --- | --- |
| `ReactComponentAnalyzer` | resolved `LibraryElement` or function element | component signatures and prop bridgeability |
| `ReactHookAnalyzer` | `CompilationUnit` | Rules of Hooks and custom-hook naming |
| `ReactSsrAnalyzer` | `CompilationUnit` | browser-only access during SSR |
| `ServerClientImportAnalyzer` | path and `CompilationUnit` | server/client import boundaries |
| `ReactRuntimeUsageCollector` | resolved libraries | component and hook usage manifests |

For syntax-level rules, parse source and inspect stable diagnostic codes:

```dart
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:react_analysis/react_analysis.dart';

void main() {
  final unit = parseString(
    content: '''
void helper() {
  useState(0);
}
''',
  ).unit;

  final diagnostics = const ReactHookAnalyzer().analyzeUnit(unit);
  for (final diagnostic in diagnostics) {
    print('${diagnostic.code}: ${diagnostic.message}');
  }
}
```

Use `ReactDiagnostic.code` for assertions and integrations. Messages and
corrections are for people and may become more specific over time.

Component analysis requires resolved analyzer elements because it validates
actual Dart types and annotations. Reuse an existing analysis context instead
of reparsing files independently when integrating it into a build tool.

## Package boundary

Keep semantic rules in this package so CLI, code generation, tests, and the IDE
cannot drift. Plugin registration, quick fixes, and assists belong in
`react_analyzer`; generated output belongs in `react_codegen`.

## Validation

```bash
dart analyze --fatal-infos
dart test
```
