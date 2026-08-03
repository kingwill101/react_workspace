/// Per-target foreign usage detection against compiled Dart JS output.
///
/// `dart compile js` keeps string-literal component keys (`foreignComponent(
/// "reactRouter.Route", …)` → `"reactRouter.Route"`) and JS-interop hook paths
/// (`globalThis.__reactDartBindings.reactRouter.useLocation()`) intact, while
/// tree-shaking away helpers the application never calls. Scanning the
/// compiled output therefore reports which registered components and hooks the
/// app actually uses per target — the cross-language usage data that feeds
/// application-level pruning.
library;

/// Component registration keys from [retainedExports] whose quoted literal
/// appears in [dartJs], in [retainedExports] order.
List<String> usedComponentsIn(
  String dartJs,
  List<String> retainedExports,
) {
  if (retainedExports.isEmpty) return const [];
  return [
    for (final key in retainedExports)
      if (RegExp("[\"']${RegExp.escape(key)}[\"']").hasMatch(dartJs)) key,
  ];
}

/// `<namespace>.<hook>` keys whose hook-bridge path appears in [dartJs].
///
/// Matches the `@JS('globalThis.__reactDartBindings.<ns>.<hook>')` interop
/// form emitted by `react ts bind --hooks` in both its dot-access and
/// bracket-access compiled shapes, plus the legacy `__reactDartHooks` bridge.
List<String> usedHooksIn(
  String dartJs,
  List<String> namespaces,
) {
  final used = <String>{};
  for (final ns in namespaces) {
    final dot = RegExp(
      '__reactDartBindings\\.${RegExp.escape(ns)}\\.(use\\w+)',
    );
    final bracket = RegExp(
      "__reactDartBindings\\[[\"']${RegExp.escape(ns)}[\"']\\]"
      "\\s*\\[\\s*[\"'](use\\w+)[\"']\\s*\\]",
    );
    for (final match in dot.allMatches(dartJs)) {
      used.add('$ns.${match.group(1)}');
    }
    for (final match in bracket.allMatches(dartJs)) {
      used.add('$ns.${match.group(1)}');
    }
  }
  for (final match
      in RegExp('__reactDartHooks\\.(use\\w+)').allMatches(dartJs)) {
    used.add(match.group(1)!);
  }
  return used.toList()..sort();
}
