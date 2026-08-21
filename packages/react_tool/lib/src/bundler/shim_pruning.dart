/// Application-level pruning of generated foreign shims.
///
/// A wrapper ships a generated shim (`react ts bind --shim`) that imports
/// every bound declaration and registers all of them under `prefix.*` keys.
/// The per-target usage data ([usedComponents]/[usedHooks]) from the compiled
/// Dart output tells the build which subset the application actually renders
/// on each target. [parseForeignShim] extracts that shim's registration
/// surface, and [pruneShim] rewrites the source to import and register only
/// the used subset — so the bundler can tree-shake the rest of the npm
/// package instead of pulling the whole namespace in.
///
/// Pruning is a structural rewrite of the exact template `generateShim`
/// emits: a named-import line, a `components` object literal keyed by
/// registration key, a registration loop, and an optional `hooks` bridge
/// (a `hooks` object literal plus a namespace assignment). Files that do not
/// match this template are left untouched by the build.
library;

/// The registration surface of a generated foreign shim.
final class ForeignShim {
  /// npm specifier the shim imports from (`react-router-dom`).
  final String specifier;

  /// Export name → local alias (`MemoryRouter` → `__reactDartMemoryRouter`),
  /// in import order.
  final Map<String, String> aliasByExport;

  /// Full registration keys the shim can register, e.g. `reactRouter.Link`.
  final List<String> componentKeys;

  /// Hook bridge namespace (`__reactDartBindings.<namespace>`), or null for
  /// the legacy `__reactDartHooks` bridge.
  final String? namespace;

  /// Hook member names the shim exposes (`useLocation`).
  final List<String> hookNames;

  const ForeignShim({
    required this.specifier,
    required this.aliasByExport,
    required this.componentKeys,
    required this.namespace,
    required this.hookNames,
  });
}

final _importRe = RegExp(r"^import \{ ([^}]*) \} from '([^']+)';$");
final _aliasRe = RegExp(r'^(\w+)\s+as\s+(\w+)$');
final _componentsStartRe = RegExp(r'^const components = \{$');
final _componentMemberRe = RegExp(r"""^\s*'([^']+)':\s*(\w+),?\s*$""");
final _blockEndRe = RegExp(r'^\};$');
final _hooksStartRe = RegExp(r'^const hooks = \{$');
final _hookMemberRe = RegExp(r'^\s*(\w+):');
final _hookCommentRe = RegExp(r'^// Hook bridge:');
final _toPairsRe = RegExp(r'^const toPairs =');
final _bindingsAssignRe = RegExp(
  r'^globalThis\.__reactDartBindings\.([A-Za-z_$][\w$]*)\s*=\s*hooks',
);
final _legacyAssignRe = RegExp(r'^globalThis\.__reactDartHooks\s*=\s*hooks');

/// Parses [source] into its registration surface, or null when [source] is
/// not a generated shim (no `components` registration block).
ForeignShim? parseForeignShim(String source) {
  final lines = source.split('\n');
  String? specifier;
  final aliasByExport = <String, String>{};
  final componentKeys = <String>[];
  String? namespace;
  final hookNames = <String>[];

  var inComponents = false;
  var inHooks = false;
  for (final line in lines) {
    final importMatch = _importRe.firstMatch(line);
    if (importMatch != null && specifier == null) {
      specifier = importMatch.group(2);
      for (final pair in importMatch.group(1)!.split(',')) {
        final aliasMatch = _aliasRe.firstMatch(pair.trim());
        if (aliasMatch == null) continue;
        aliasByExport[aliasMatch.group(1)!] = aliasMatch.group(2)!;
      }
      continue;
    }
    if (_componentsStartRe.hasMatch(line)) {
      inComponents = true;
      continue;
    }
    if (_hooksStartRe.hasMatch(line)) {
      inHooks = true;
      continue;
    }
    if (inComponents) {
      if (_blockEndRe.hasMatch(line)) {
        inComponents = false;
      } else {
        final member = _componentMemberRe.firstMatch(line);
        if (member != null) componentKeys.add(member.group(1)!);
      }
      continue;
    }
    if (inHooks) {
      if (_blockEndRe.hasMatch(line)) {
        inHooks = false;
      } else {
        final member = _hookMemberRe.firstMatch(line);
        if (member != null) hookNames.add(member.group(1)!);
      }
      continue;
    }
    final bindings = _bindingsAssignRe.firstMatch(line);
    if (bindings != null) {
      namespace = bindings.group(1);
      continue;
    }
    if (_legacyAssignRe.hasMatch(line)) {
      namespace = null;
    }
  }

  if (specifier == null && componentKeys.isEmpty && hookNames.isEmpty) {
    return null;
  }
  if (componentKeys.isEmpty && hookNames.isEmpty) return null;
  return ForeignShim(
    specifier: specifier ?? '',
    aliasByExport: Map.unmodifiable(aliasByExport),
    componentKeys: List.unmodifiable(componentKeys),
    namespace: namespace,
    hookNames: List.unmodifiable(hookNames),
  );
}

/// Rewrites [source] (a generated shim matching [shim]) to import and register
/// only the [usedComponents] keys and [usedHooks] keys (full
/// `<namespace>.<hook>` keys, or bare `useX` for the legacy bridge).
///
/// The resulting file keeps the original header, registration loop, hook
/// bridge, and `toPairs` helper intact; only the import list and the
/// `components`/`hooks` object members are filtered. If no hook is used, the
/// entire hook bridge section is dropped so `toPairs` and the namespace
/// assignment do not reach the bundle.
String pruneShim(
  String source, {
  required ForeignShim shim,
  required Set<String> usedComponents,
  required Set<String> usedHooks,
}) {
  final lines = source.split('\n');
  var importLine = -1;
  final importAliases = <String, String>{};
  var componentsStart = -1;
  var componentsEnd = -1;
  final componentMembers = <({String key, String line})>[];
  var hooksStart = -1;
  var hooksEnd = -1;
  final hookMembers = <({String name, String line})>[];
  var hooksSectionStart = -1;

  for (var i = 0; i < lines.length; i++) {
    final line = lines[i];
    final importMatch = _importRe.firstMatch(line);
    if (importMatch != null && importLine < 0) {
      importLine = i;
      for (final pair in importMatch.group(1)!.split(',')) {
        final aliasMatch = _aliasRe.firstMatch(pair.trim());
        if (aliasMatch != null) {
          importAliases[aliasMatch.group(1)!] = aliasMatch.group(2)!;
        }
      }
      continue;
    }
    if (_componentsStartRe.hasMatch(line)) {
      componentsStart = i;
      for (var j = i + 1; j < lines.length; j++) {
        if (_blockEndRe.hasMatch(lines[j])) {
          componentsEnd = j;
          break;
        }
        final member = _componentMemberRe.firstMatch(lines[j]);
        if (member != null) {
          componentMembers.add((key: member.group(1)!, line: lines[j]));
        }
      }
      continue;
    }
    if (_hookCommentRe.hasMatch(line)) {
      if (hooksSectionStart < 0) hooksSectionStart = i;
      continue;
    }
    if (_toPairsRe.hasMatch(line)) {
      if (hooksSectionStart < 0) hooksSectionStart = i;
      continue;
    }
    if (_hooksStartRe.hasMatch(line)) {
      hooksStart = i;
      if (hooksSectionStart < 0) hooksSectionStart = i;
      for (var j = i + 1; j < lines.length; j++) {
        if (_blockEndRe.hasMatch(lines[j])) {
          hooksEnd = j;
          break;
        }
        final member = _hookMemberRe.firstMatch(lines[j]);
        if (member != null) {
          hookMembers.add((name: member.group(1)!, line: lines[j]));
        }
      }
      continue;
    }
    if (_bindingsAssignRe.hasMatch(line)) continue;
    if (_legacyAssignRe.hasMatch(line)) continue;
  }

  final usedComponentKeys = usedComponents
      .where(shim.componentKeys.contains)
      .toSet();
  final usedHookNames = <String>{
    for (final name in shim.hookNames)
      if (usedHooks.contains(
        shim.namespace == null ? name : '${shim.namespace}.$name',
      ))
        name,
  };

  // Imports to keep: every used component's export plus every used hook.
  final keptExports = <String>[
    for (final export in importAliases.keys)
      if (usedComponentKeys
              .map((key) => key.split('.').last)
              .contains(export) ||
          usedHookNames.contains(export))
        export,
  ];

  final buffer = <String>[];
  final headerEnd = importLine < 0 ? componentsStart : importLine;
  buffer.addAll(lines.sublist(0, headerEnd < 0 ? 0 : headerEnd));
  if (keptExports.isNotEmpty && shim.specifier.isNotEmpty) {
    buffer.add(
      "import { ${keptExports.map((e) => '$e as ${importAliases[e]}').join(', ')} } "
      "from '${shim.specifier}';",
    );
    buffer.add('');
  }
  if (componentsStart >= 0) {
    buffer.add(lines[componentsStart]);
    buffer.addAll(
      componentMembers
          .where((m) => usedComponentKeys.contains(m.key))
          .map((m) => m.line),
    );
    buffer.add(lines[componentsEnd]);
  }
  // Everything after the components block and before the hook bridge (the
  // blank line, registration loop, trailing blank) — verbatim. When no hook
  // is used the cut is the start of the hook bridge itself, so the comment,
  // `toPairs`, and the namespace assignment never reach the bundle.
  final hooksCut = usedHookNames.isEmpty && hooksSectionStart >= 0
      ? hooksSectionStart
      : null;
  final tailStart =
      hooksCut ?? (hooksSectionStart >= 0 ? hooksSectionStart : lines.length);
  if (componentsEnd >= 0 && componentsEnd + 1 < tailStart) {
    buffer.addAll(lines.sublist(componentsEnd + 1, tailStart));
  }
  if (usedHookNames.isNotEmpty && hooksStart >= 0) {
    buffer.addAll(lines.sublist(hooksSectionStart, hooksStart));
    buffer.add(lines[hooksStart]);
    buffer.addAll(
      hookMembers
          .where((m) => usedHookNames.contains(m.name))
          .map((m) => m.line),
    );
    buffer.add(lines[hooksEnd]);
    buffer.addAll(lines.sublist(hooksEnd + 1));
  }

  final text = buffer.join('\n');
  return source.endsWith('\n') && !text.endsWith('\n') ? '$text\n' : text;
}
