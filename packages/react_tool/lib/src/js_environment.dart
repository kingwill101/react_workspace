// Managed JavaScript environment for wrapper packages.
//
// A Dart wrapper package declares its JavaScript integration in pubspec.yaml
// under `react.js` (schema 1). This library parses those descriptors, merges
// the requirements of every wrapper in the dependency graph, validates that
// version ranges intersect, and provisions an isolated npm environment under
// `.dart_tool/react/js` — never the consumer's `package.json`.
//
// See docs/packaging_progress.md for the architecture notes.
library;

import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

/// The JavaScript contract of one wrapper package (`react.js` in pubspec).
///
/// ```yaml
/// react:
///   js:
///     schema: 1
///     entries:
///       shared: lib/src/js/register.ts   # or browser:/ssr: per target
///     dependencies:
///       react-router-dom: ^6.26.2
///     peers:
///       react: ">=18 <20"
///       react-dom: ">=18 <20"
///     externals:
///       - react
///       - react-dom
/// ```
final class JsWrapperDescriptor {
  final String packageName;

  /// Target key (`shared`, `browser`, `ssr`) → package-relative entry file.
  final Map<String, String> entries;

  /// npm specifier → version range, as declared by this wrapper.
  final Map<String, String> dependencies;

  /// Host-provided singletons (react, react-dom) and their required ranges.
  final Map<String, String> peers;

  /// Bare specifiers that must stay external in the bundles.
  final List<String> externals;

  /// Target key (`browser`, `ssr`) → already-bundled file shipped with the
  /// package. When present, [entries] is ignored for that target.
  final Map<String, String> prebuilt;

  const JsWrapperDescriptor({
    required this.packageName,
    this.entries = const {},
    this.dependencies = const {},
    this.peers = const {},
    this.externals = const ['react', 'react-dom'],
    this.prebuilt = const {},
  });

  bool get isEmpty =>
      entries.isEmpty && dependencies.isEmpty && peers.isEmpty &&
      prebuilt.isEmpty;

  /// Targets this wrapper contributes to.
  Set<String> get targets {
    final result = <String>{};
    for (final key in [...entries.keys, ...prebuilt.keys]) {
      if (key == 'shared' || key.startsWith('shared_')) {
        result.addAll({'browser', 'ssr'});
      } else {
        result.add(key);
      }
    }
    return result;
  }

  /// The entry file for [target] (a package-relative path), or null.
  String? entryFor(String target) {
    final explicit = entries[target] ?? prebuilt[target];
    if (explicit != null) return explicit;
    final shared = entries['shared'] ?? prebuilt['shared'];
    if (shared != null) return shared;
    // Legacy multiple shared entries (react.shims list): use the first.
    for (final key in [...entries.keys, ...prebuilt.keys]) {
      if (key.startsWith('shared_')) {
        return entries[key] ?? prebuilt[key];
      }
    }
    return null;
  }

  /// Parses `react.js` from a pubspec map. Accepts the legacy `react.shims` /
  /// `react.npm` fields when no `react.js` descriptor exists.
  static JsWrapperDescriptor? parse(
    String packageName,
    Map<String, dynamic> pubspec,
  ) {
    final react = _map(pubspec['react']);
    final js = _map(react['js']);
    final schema = js['schema'];
    if (schema != null && schema != 1) {
      throw StateError(
        'Unsupported react.js schema $schema in $packageName '
        '(expected schema: 1).',
      );
    }
    final entries = <String, String>{..._stringMap(js['entries'])};
    final dependencies = <String, String>{..._stringMap(js['dependencies'])};
    final peers = <String, String>{..._stringMap(js['peers'])};
    final externals = [..._stringList(js['externals'])];
    final prebuilt = <String, String>{..._stringMap(js['prebuilt'])};

    // Legacy fields, still accepted for compatibility.
    if (entries.isEmpty && prebuilt.isEmpty && externals.isEmpty) {
      final legacyShims = _stringList(react['shims']);
      final legacyNpm = _stringMap(react['npm']);
      for (final shim in legacyShims) {
        // Legacy `react.shims` entries are relative to the package lib/.
        entries['shared_${entries.length}'] =
            shim.startsWith('lib/') ? shim : 'lib/$shim';
      }
      dependencies.addAll(legacyNpm);
      externals.addAll(['react', 'react-dom']);
    }

    final descriptor = JsWrapperDescriptor(
      packageName: packageName,
      entries: entries,
      dependencies: dependencies,
      peers: peers,
      externals: externals,
      prebuilt: prebuilt,
    );
    return descriptor.isEmpty ? null : descriptor;
  }

  Map<String, dynamic> toJson() => {
    'packageName': packageName,
    'entries': entries,
    'dependencies': dependencies,
    'peers': peers,
    'externals': externals,
    'prebuilt': prebuilt,
  };
}

/// A validated npm requirement with its provenance (which wrapper declared it).
final class NpmRequirement {
  final String name;
  final String range;
  final String declaredBy;

  const NpmRequirement(this.name, this.range, this.declaredBy);
}

/// Thrown when two wrappers require incompatible versions of one npm package.
final class JsDependencyConflict implements Exception {
  final String name;
  final List<NpmRequirement> requirements;

  const JsDependencyConflict(this.name, this.requirements);

  @override
  String toString() {
    final buffer = StringBuffer()
      ..writeln('Conflicting JavaScript requirements for "$name":')
      ..writeln();
    for (final requirement in requirements) {
      buffer.writeln('  ${requirement.declaredBy} requires '
          '${requirement.range}');
    }
    buffer
      ..writeln()
      ..writeln('No version satisfies all requirements.');
    return buffer.toString();
  }
}

/// The resolved, installed JavaScript environment for a build.
final class JsEnvironment {
  /// The environment root (`.dart_tool/react/js` for managed mode).
  final Directory root;

  /// npm package → exact installed version.
  final Map<String, String> installedVersions;

  /// Whether this environment validates a host project instead of managing
  /// its own installation.
  final bool host;

  /// The npm root used for resolution (managed env or the host project).
  final String npmRoot;

  /// The resolved, single React version used for both browser and SSR.
  final String reactVersion;

  const JsEnvironment({
    required this.root,
    required this.installedVersions,
    required this.host,
    required this.npmRoot,
    required this.reactVersion,
  });

  /// Entry file esbuild bundles for [target].
  ///
  /// In managed mode this is the pinned esbuild shipped in the environment;
  /// in host mode it comes from the host's installation or PATH.
  Future<File> esbuildEntry() async {
    final pinned = File(p.join(root.path, 'node_modules/esbuild/lib/main.js'));
    if (pinned.existsSync()) return pinned;
    final hostEntry = File(p.join(npmRoot, 'node_modules/esbuild/lib/main.js'));
    if (hostEntry.existsSync()) return hostEntry;
    final which = await Process.run('which', ['esbuild']);
    if (which.exitCode == 0) {
      final script = (which.stdout as String).trim();
      if (script.isNotEmpty) {
        // The PATH binary may be a shell script; resolve its JS entry.
        final dir = p.dirname(script);
        final candidates = [
          p.join(dir, 'esbuild', 'lib', 'main.js'),
          p.join(p.dirname(dir), 'lib', 'main.js'),
        ];
        for (final candidate in candidates) {
          if (File(candidate).existsSync()) return File(candidate);
        }
        throw const JsEnvironmentException(
          'esbuild binary found on PATH but its JS entry could not be '
          'located. Install esbuild in the host project or run `react js '
          'install`.',
        );
      }
    }
    throw const JsEnvironmentException(
      'esbuild is unavailable.\n\n'
      'Run: react js install',
    );
  }

  /// Resolves a bare specifier to an absolute file through the environment's
  /// npm root (exports-aware), for imports that must stay external.
  String resolveForNode(String specifier) {
    final result = Process.runSync(
      Platform.resolvedExecutable == 'dart' ? 'node' : 'node',
      [
        '-e',
        'const r=require("node:module").createRequire(process.cwd()+"/x.js");'
            'try{console.log(r.resolve(process.argv[1],{paths:[process.argv[2]]}))}'
            'catch(e){console.error(e.message);process.exit(1)}',
        specifier,
        npmRoot,
      ],
      workingDirectory: root.path,
    );
    if (result.exitCode != 0) {
      throw JsEnvironmentException(
        'Could not resolve "$specifier" in the JS environment: '
        '${result.stderr}',
      );
    }
    return (result.stdout as String).trim();
  }
}

final class JsEnvironmentException implements Exception {
  final String message;
  const JsEnvironmentException(this.message);

  @override
  String toString() => message;
}

/// Provisions (or validates) the JS environment for a set of wrapper
/// descriptors.
class JsEnvironmentBuilder {
  final Directory projectRoot;
  final String packageName;
  final String? configEsbuildPath;
  final bool host;
  final void Function(String message) log;
  final String npmCommand;

  JsEnvironmentBuilder({
    required this.projectRoot,
    required this.packageName,
    this.configEsbuildPath,
    this.host = false,
    this.log = print,
    this.npmCommand = 'npm',
  });

  /// Creates the environment, resolving exact versions and installing when
  /// the managed manifest changes. Returns null when nothing requires a JS
  /// environment (no wrappers and [required] is false).
  Future<JsEnvironment?> ensure(
    List<JsWrapperDescriptor> wrappers, {
    bool required = false,
  }) async {
    final requirements = _collectRequirements(wrappers);
    if (!required && requirements.isEmpty && wrappers.isEmpty) return null;

    final toolRoot = _findToolRoot();
    final root = Directory(p.join(toolRoot.path, '.dart_tool/react/js'));

    if (host) {
      return _validateHost(root, requirements);
    }
    return _managed(root, requirements);
  }

  /// Merges every wrapper's requirements, failing on incompatible ranges.
  List<NpmRequirement> _collectRequirements(List<JsWrapperDescriptor> wrappers) {
    final merged = <String, List<NpmRequirement>>{};
    for (final wrapper in wrappers) {
      for (final entry in wrapper.dependencies.entries) {
        merged
            .putIfAbsent(entry.key, () => [])
            .add(NpmRequirement(entry.key, entry.value, wrapper.packageName));
      }
      for (final entry in wrapper.peers.entries) {
        merged
            .putIfAbsent(entry.key, () => [])
            .add(NpmRequirement(entry.key, entry.value, wrapper.packageName));
      }
    }
    return [
      for (final entry in merged.entries) ...entry.value,
    ];
  }

  Future<JsEnvironment> _managed(
    Directory root,
    List<NpmRequirement> requirements,
  ) async {
    // Host discovery: reuse an already-installed exact version when it
    // satisfies the requirement (no network round trip).
    final hostRoot = _findNpmRoot();
    final reused = <String, String>{};
    for (final requirement in requirements) {
      final installed = _hostVersion(hostRoot, requirement.name);
      if (installed != null && _rangeSatisfied(requirement.range, installed)) {
        reused[requirement.name] = installed;
      }
    }

    // Resolve exact versions for everything not covered by reuse. The
    // framework's React pin is the fallback for the react peer.
    final exact = <String, String>{};
    final toResolve = <String, List<NpmRequirement>>{};
    for (final requirement in requirements) {
      if (reused.containsKey(requirement.name)) continue;
      toResolve.putIfAbsent(requirement.name, () => []).add(requirement);
    }
    for (final entry in toResolve.entries) {
      exact[entry.key] = _resolveExact(entry.key, entry.value);
    }

    final manifest = _buildManifest({...reused, ...exact});
    final packageJson = File(p.join(root.path, 'package.json'));
    final unchanged =
        packageJson.existsSync() &&
        packageJson.readAsStringSync().trim() == manifest.trim();

    await root.create(recursive: true);
    if (!unchanged) {
      packageJson.writeAsStringSync(manifest);
      final installedMarker = File(p.join(root.path, '.installed'));
      if (installedMarker.existsSync()) installedMarker.deleteSync();
    }

    if (!File(p.join(root.path, '.installed')).existsSync()) {
      log('Installing JS environment into ${p.relative(root.path)}');
      final result = await Process.run(
        npmCommand,
        ['install', '--no-audit', '--no-fund'],
        workingDirectory: root.path,
      );
      if (result.exitCode != 0) {
        throw JsEnvironmentException(
          'npm install failed in ${root.path} '
          '(exit ${result.exitCode}): ${result.stderr}',
        );
      }
      File(p.join(root.path, '.installed')).writeAsStringSync('1\n');
    }

    final versions = {...reused, ...exact};
    return JsEnvironment(
      root: root,
      installedVersions: versions,
      host: false,
      npmRoot: root.path,
      reactVersion: versions['react'] ?? _frameworkReactFallback,
    );
  }

  JsEnvironment _validateHost(
    Directory root,
    List<NpmRequirement> requirements,
  ) {
    final hostRoot = _findNpmRoot();
    if (hostRoot == null) {
      throw const JsEnvironmentException(
        'Host JS mode requires a package.json or node_modules in the project '
        'or a workspace ancestor.',
      );
    }
    final missing = <String>[];
    final versions = <String, String>{};
    for (final requirement in requirements) {
      final installed = _hostVersion(hostRoot, requirement.name);
      if (installed == null || !_rangeSatisfied(requirement.range, installed)) {
        missing.add(
          '${requirement.name}@${requirement.range} '
          '(declared by ${requirement.declaredBy})',
        );
        continue;
      }
      versions[requirement.name] = installed;
    }
    if (missing.isNotEmpty) {
      throw JsEnvironmentException(
        'The host JS environment is missing required packages:\n'
        '${missing.join('\n')}\n\n'
        'Install them with e.g.:\n'
        '  npm add ${missing.map((m) => m.split(' ').first).join(' ')}\n'
        'or run: react js sync',
      );
    }
    return JsEnvironment(
      root: root,
      installedVersions: versions,
      host: true,
      npmRoot: hostRoot,
      reactVersion: versions['react'] ?? _frameworkReactFallback,
    );
  }

  /// The exact version the framework pins for react when nothing resolves it.
  static const _frameworkReactFallback = '18.3.1';

  String _buildManifest(Map<String, String> exact) {
    final dependencies = {...exact};
    if (!dependencies.containsKey('react')) {
      dependencies['react'] = _frameworkReactFallback;
    }
    if (!dependencies.containsKey('react-dom')) {
      dependencies['react-dom'] = _frameworkReactFallback;
    }
    final esbuild = _resolveExact('esbuild', [
      const NpmRequirement('esbuild', '>=0.20 <1', 'react_tool'),
    ]);
    return const JsonEncoder.withIndent('  ').convert({
      'name': '@react-dart/generated-js-environment',
      'private': true,
      'type': 'module',
      'dependencies': dependencies,
      'devDependencies': {'esbuild': esbuild},
    });
  }

  /// Queries the package manager for the highest version satisfying all given
  /// ranges. An empty result means the ranges do not intersect.
  String _resolveExact(String name, List<NpmRequirement> requirements) {
    // `npm view pkg@range` rejects ranges containing spaces in newer npm;
    // fetch the full version list and filter locally instead.
    final constraints = <String>[
      for (final requirement in requirements)
        ...requirement.range
            .split(RegExp(r'\s+'))
            .where((c) => c.trim().isNotEmpty),
    ];
    final result = Process.runSync(
      npmCommand,
      ['view', name, 'versions', '--json'],
    );
    if (result.exitCode != 0) {
      throw JsEnvironmentException(
        'Could not query versions for "$name" '
        '(${(result.stderr as String).trim()}).',
      );
    }
    final decoded = jsonDecode(result.stdout as String);
    final versions = decoded is List
        ? decoded.whereType<String>().toList()
        : <String>[];
    final satisfying = versions
        .where((version) => _satisfiesAll(version, constraints))
        .toList()
      ..sort((a, b) => _compareVersions(a, b));
    if (satisfying.isEmpty) {
      throw JsDependencyConflict(name, requirements);
    }
    return satisfying.last;
  }

  bool _satisfiesAll(String version, List<String> constraints) {
    for (final constraint in constraints) {
      if (!_rangeSatisfied(constraint, version)) return false;
    }
    return true;
  }

  String? _hostVersion(String? npmRoot, String name) {
    if (npmRoot == null) return null;
    final manifest = File(
      p.join(npmRoot, 'node_modules', name, 'package.json'),
    );
    if (!manifest.existsSync()) return null;
    final decoded = jsonDecode(manifest.readAsStringSync()) as Map;
    final version = decoded['version'];
    return version is String ? version : null;
  }

  /// Minimal caret/tilde/exact/gt-lt range check used only to decide whether
  /// an already-installed version can be reused; the package manager is the
  /// authority for final resolution.
  bool _rangeSatisfied(String range, String version) {
    final normalized = range.trim();
    if (normalized == '*') return true;
    final match = RegExp(r'^([\^~=<>]|>=|<=)?\s*([0-9]+(?:\.[0-9]+){0,2})')
        .firstMatch(normalized);
    if (match == null) return false;
    final op = match.group(1) ?? '';
    final required = match.group(2)!;
    final major = int.parse(required.split('.')[0]);
    final versionMajor = int.parse(version.split('.')[0]);
    switch (op) {
      case '>=':
        return _compareVersions(version, required) >= 0;
      case '<':
        return _compareVersions(version, required) < 0;
      case '>':
        return _compareVersions(version, required) > 0;
      case '<=':
        return _compareVersions(version, required) <= 0;
      case '^':
        return versionMajor == major && _compareVersions(version, required) >= 0;
      case '~':
        return _sameMinor(version, required) &&
            _compareVersions(version, required) >= 0;
      default:
        return version == required;
    }
  }

  int _compareVersions(String a, String b) {
    int part(String version, int index) {
      final pieces = version.split('.');
      if (pieces.length <= index) return 0;
      final match = RegExp(r'^[0-9]+').firstMatch(pieces[index]);
      return match == null ? 0 : int.parse(match.group(0)!);
    }

    for (var i = 0; i < 3; i++) {
      final diff = part(a, i) - part(b, i);
      if (diff != 0) return diff;
    }
    return 0;
  }

  bool _sameMinor(String a, String b) {
    final pa = a.split('.');
    final pb = b.split('.');
    return pa[0] == pb[0] && (pa.length < 2 || pb.length < 2 || pa[1] == pb[1]);
  }

  /// The workspace root holding `.dart_tool` (found via package_config).
  Directory _findToolRoot() {
    var current = projectRoot;
    while (true) {
      if (File(
        p.join(current.path, '.dart_tool/package_config.json'),
      ).existsSync()) {
        return current;
      }
      final parent = current.parent;
      if (parent.path == current.path) break;
      current = parent;
    }
    // Fall back to the project root.
    return projectRoot;
  }

  String? _findNpmRoot() {
    var current = projectRoot;
    while (true) {
      if (File(p.join(current.path, 'package.json')).existsSync() ||
          Directory(p.join(current.path, 'node_modules')).existsSync()) {
        return current.path;
      }
      final parent = current.parent;
      if (parent.path == current.path) return null;
      current = parent;
    }
  }
}

// ---------------------------------------------------------------------------
// YAML helpers (kept local so this file is self-contained).
// ---------------------------------------------------------------------------

Map<String, dynamic> _map(Object? value) {
  if (value is! Map) return <String, dynamic>{};
  return {for (final entry in value.entries) '${entry.key}': entry.value};
}

Map<String, String> _stringMap(Object? value) {
  final map = _map(value);
  return {
    for (final entry in map.entries)
      if (entry.value is String && entry.value.trim().isNotEmpty)
        entry.key: entry.value.trim(),
  };
}

List<String> _stringList(Object? value) {
  if (value is String) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? const [] : [trimmed];
  }
  if (value is! List) return const [];
  return [
    for (final item in value)
      if (item is String && item.trim().isNotEmpty) item.trim(),
  ];
}
