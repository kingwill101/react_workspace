/// Shared analyzer engine for React Dart.
///
/// This package is the single source of truth for component, hook, SSR,
/// and runtime-usage semantics. It is consumed by:
/// - `react_analyzer` (live IDE diagnostics via `analysis_server_plugin`)
/// - `react_tool` (authoritative `browser_usage.json` / `ssr_usage.json`)
/// - `react_codegen` (deterministic file generation — same validators)
///
/// See docs/analyzer_plugin.md for the architecture.
library;

export 'src/codec_analyzer.dart';
export 'src/component_analyzer.dart';
export 'src/hook_analyzer.dart';
export 'src/import_analyzer.dart';
export 'src/model/runtime_symbol.dart';
export 'src/runtime_usage.dart';
export 'src/ssr_analyzer.dart';
