/// Shared runtime-symbol metadata — the analyzer and generator must agree on this.
///
/// These types mirror the annotations that will be emitted on generated
/// Dart bindings (see docs/analyzer_plugin.md). Defining them here lets the
/// analyzer resolve them without a dependency cycle on `react_codegen`.
library;

/// The kind of runtime symbol a Dart declaration bridges to.
enum ReactRuntimeSymbolKind {
  component,
  hook,
  function,
  value,
}

/// Which render targets a symbol is valid for.
enum ReactRenderTarget {
  browser,
  server,
  test,
}

/// Machine-readable bridge metadata added to generated declarations.
///
/// Example:
/// ```dart
/// @ReactRuntimeSymbol(
///   kind: ReactRuntimeSymbolKind.hook,
///   runtimeKey: 'reactRouter.useLocation',
///   targets: {ReactRenderTarget.browser, ReactRenderTarget.server},
/// )
/// ReactRouterLocation useLocation() => ...
/// ```
final class ReactRuntimeSymbol {
  final ReactRuntimeSymbolKind kind;
  final String runtimeKey;
  final Set<ReactRenderTarget> targets;

  const ReactRuntimeSymbol({
    required this.kind,
    required this.runtimeKey,
    required this.targets,
  });
}

/// Marker for generated React hooks. The analyzer treats any declaration
/// annotated with this as a hook for rules-of-hooks validation.
final class ReactHook {
  const ReactHook();
}

/// Describes a Web API's realm exposure and SSR support.
enum WebRealm {
  window,
  document,
  worker,
  shared,
}

enum WebSsrSupport {
  available,
  unavailable,
  emulated,
}

final class WebApiRuntimeInfo {
  final String id;
  final Set<WebRealm> exposed;
  final WebSsrSupport ssr;

  const WebApiRuntimeInfo({
    required this.id,
    required this.exposed,
    required this.ssr,
  });
}

/// Diagnostic severity for react_analysis validators.
enum ReactDiagnosticSeverity {
  error,
  warning,
  info,
}

/// A single analyzer diagnostic produced by react_analysis.
final class ReactDiagnostic {
  final String code;
  final String message;
  final ReactDiagnosticSeverity severity;
  final String? correction;

  const ReactDiagnostic({
    required this.code,
    required this.message,
    required this.severity,
    this.correction,
  });

  @override
  String toString() => '[$code] $message';
}

/// Well-known diagnostic codes — keep stable for fixes/assists.
abstract final class ReactDiagnosticCode {
  // Component signature.
  static const invalidComponentReturn = 'react_invalid_component_return';
  static const componentCannotBeGeneric = 'react_component_cannot_be_generic';
  static const invalidComponentParamShape = 'react_invalid_component_param';
  static const duplicateComponentId = 'react_duplicate_component_id';
  static const unsupportedPropType = 'react_unsupported_prop_type';
  static const childrenParamInvalidType = 'react_children_param_invalid_type';
  static const callbackParamCannotBeBridged =
      'react_callback_param_cannot_be_bridged';

  // Hooks.
  static const hookOutsideComponent = 'react_hook_outside_component';
  static const hookInConditional = 'react_hook_in_conditional';
  static const hookInLoop = 'react_hook_in_loop';
  static const hookAfterEarlyReturn = 'react_hook_after_early_return';
  static const customHookInvalidName = 'react_custom_hook_invalid_name';
  static const componentCalledAsFunction =
      'react_component_called_as_function';

  // SSR.
  static const browserApiDuringSsr = 'react_browser_api_during_ssr';
  static const nativeSsrCompatibility = 'react_native_ssr_compatibility';

  // Codec / bridge.
  static const codecMissing = 'react_codec_missing';

  // Import boundaries (server/client).
  static const jsInteropInServer = 'js_interop_in_server';
  static const browserImportInServer = 'browser_import_in_server';
  static const generatedBridgeImport = 'generated_bridge_import';
}
