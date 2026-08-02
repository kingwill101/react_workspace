import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

/// Errors raised while loading or validating a React Dart project.
class ReactToolException implements Exception {
  final String message;

  const ReactToolException(this.message);

  @override
  String toString() => message;
}

/// A JavaScript/TypeScript React component exposed to Dart by name.
final class ReactForeignComponentConfig {
  final String name;
  final String module;
  final String? exportName;
  final Map<String, String> props;

  const ReactForeignComponentConfig({
    required this.name,
    required this.module,
    required this.exportName,
    this.props = const {},
  });

  Map<String, Object?> toJson() => {
    'name': name,
    'module': module,
    'export': exportName ?? 'default',
    'props': props,
  };
}

/// Resolved project configuration used by the React Dart CLI.
///
/// Explicit values come from `react.yaml`. If that file is absent, the CLI
/// also accepts a `react:` map in `pubspec.yaml`. Conventional entrypoints are
/// used when neither file supplies a value.
final class ReactProjectConfig {
  final Directory root;
  final String packageName;
  final String? clientEntrypoint;
  final String? ssrEntrypoint;
  final String? serverEntrypoint;
  final String staticDirectory;
  final String outputDirectory;
  final List<String> styleEntrypoints;
  final String? styleOutput;
  final List<ReactForeignComponentConfig> foreignComponents;

  /// Side-effect module imports resolved into the foreign bundle.
  ///
  /// Each entry may be a relative path or a `package:` URI. Wrapper packages
  /// (for example `react_router`) ship a self-registering `.mjs` shim here so
  /// projects never need to copy package-internal JavaScript by hand.
  final List<String> foreignModules;

  /// Optional esbuild binary used to bundle foreign shims (defaults to
  /// `ESBUILD` env var, then `esbuild` on PATH).
  final String? esbuildPath;

  /// Bare npm specifiers that stay external in foreign bundles, in addition
  /// to the always-external `react` / `react-dom`.
  final List<String> foreignExternals;

  /// Whether to validate an existing host JS project instead of provisioning
  /// the managed environment at `.dart_tool/react/js` (`react.yaml
  /// `foreign.host`).
  final bool jsHostMode;

  const ReactProjectConfig({
    required this.root,
    required this.packageName,
    required this.clientEntrypoint,
    required this.ssrEntrypoint,
    required this.serverEntrypoint,
    required this.staticDirectory,
    required this.outputDirectory,
    required this.styleEntrypoints,
    required this.styleOutput,
    required this.foreignComponents,
    this.foreignModules = const [],
    this.esbuildPath,
    this.foreignExternals = const [],
    this.jsHostMode = false,
  });

  factory ReactProjectConfig.load([Directory? directory]) {
    final root = (directory ?? Directory.current).absolute;
    final pubspecFile = File(p.join(root.path, 'pubspec.yaml'));
    if (!pubspecFile.existsSync()) {
      throw ReactToolException(
        'No pubspec.yaml found in ${root.path}. Run the command from a Dart package root.',
      );
    }

    final pubspec = _loadMap(pubspecFile);
    final packageName = _string(pubspec['name']) ?? p.basename(root.path);
    final reactFile = File(p.join(root.path, 'react.yaml'));
    final explicit = reactFile.existsSync()
        ? _loadMap(reactFile)
        : _map(pubspec['react']);

    final client =
        _pathValue(explicit, 'client', 'entrypoint') ??
        _pathValue(explicit, 'clientEntrypoint') ??
        'web/client.dart';
    final ssr =
        _pathValue(explicit, 'ssr', 'entrypoint') ??
        _pathValue(explicit, 'ssrEntrypoint') ??
        'lib/ssr.dart';
    final server =
        _pathValue(explicit, 'server', 'entrypoint') ??
        _pathValue(explicit, 'serverEntrypoint') ??
        'bin/server.dart';

    final staticDirectory = _string(explicit['static']) ?? 'web';
    final stylesValue = explicit.containsKey('styles')
        ? explicit['styles']
        : explicit['css'];
    final stylesMap = _map(stylesValue);
    final configuredStyles = _stringList(
      stylesValue is String || stylesValue is List
          ? stylesValue
          : stylesMap['entrypoints'] ?? stylesMap['entrypoint'],
    );
    final styleEntrypoints = configuredStyles.isNotEmpty
        ? configuredStyles
        : [
            for (final convention in ['web/styles.scss', 'web/styles.sass'])
              if (File(p.join(root.path, convention)).existsSync()) convention,
            ..._discoverCssModules(root, staticDirectory),
          ];
    final styleOutput = _string(stylesMap['output']);
    final foreignValue = explicit['foreign'] ?? explicit['components'];
    final foreignMap = _map(foreignValue);
    // A structured `foreign:` block (with `components:`/`modules:`/`host:`
    // keys) keeps its components nested; a bare list/map of name→module pairs
    // is the legacy inline form.
    final isStructured = foreignValue is Map &&
        (foreignMap.containsKey('components') ||
            foreignMap.containsKey('host') ||
            foreignMap.containsKey('modules') ||
            foreignMap.containsKey('externals'));
    final foreignComponents = isStructured
        ? _foreignComponents(foreignMap['components'])
        : _foreignComponents(foreignValue);
    final foreignModules = _stringList(
      foreignMap['modules'] ??
          explicit['foreignModules'] ??
          explicit['modules'],
    );
    final esbuildPath = _string(
      foreignMap['esbuild'] ?? explicit['esbuild'],
    );
    final foreignExternals = _stringList(
      foreignMap['externals'],
    );
    final jsHostMode =
        _boolNullable(foreignMap['host']) ??
        _boolNullable(explicit['hostJs']) ??
        false;

    return ReactProjectConfig(
      root: root,
      packageName: packageName,
      clientEntrypoint: client,
      ssrEntrypoint: ssr,
      serverEntrypoint: server,
      staticDirectory: staticDirectory,
      outputDirectory: _string(explicit['output']) ?? 'build/react',
      styleEntrypoints: styleEntrypoints,
      styleOutput: styleOutput,
      foreignComponents: foreignComponents,
      foreignModules: foreignModules,
      esbuildPath: esbuildPath,
      foreignExternals: foreignExternals,
      jsHostMode: jsHostMode,
    );
  }

  File file(String relativePath) => File(p.join(root.path, relativePath));

  Directory directory(String relativePath) =>
      Directory(p.join(root.path, relativePath));

  String pathFor(String relativePath) =>
      p.normalize(p.join(root.path, relativePath));

  bool get hasReactYaml => file('react.yaml').existsSync();

  /// Whether Node dependencies are available in this package or a workspace
  /// parent. Workspace projects commonly keep `node_modules` at the root.
  bool get hasNodePackageManifest {
    var current = root;
    while (true) {
      if (File(p.join(current.path, 'package.json')).existsSync()) return true;
      final parent = current.parent;
      if (parent.path == current.path) return false;
      current = parent;
    }
  }

  bool get hasBuildRunner {
    final pubspec = _loadMap(file('pubspec.yaml'));
    for (final section in ['dependencies', 'dev_dependencies']) {
      if (_map(pubspec[section]).containsKey('build_runner')) return true;
    }
    return false;
  }

  Map<String, Object?> toJson() => {
    'name': packageName,
    'clientEntrypoint': clientEntrypoint,
    'ssrEntrypoint': ssrEntrypoint,
    'serverEntrypoint': serverEntrypoint,
    'staticDirectory': staticDirectory,
    'outputDirectory': outputDirectory,
    'styleEntrypoints': styleEntrypoints,
    'styleOutput': styleOutput,
    'foreignComponents': [
      for (final component in foreignComponents) component.toJson(),
    ],
    'foreignModules': foreignModules,
  };

  String toJsonString() => const JsonEncoder.withIndent('  ').convert(toJson());
}

Map<String, dynamic> _loadMap(File file) {
  try {
    final value = loadYaml(file.readAsStringSync());
    return _map(value);
  } on YamlException catch (error) {
    throw ReactToolException('Invalid YAML in ${file.path}: $error');
  } on FileSystemException catch (error) {
    throw ReactToolException('Could not read ${file.path}: ${error.message}');
  }
}

Map<String, dynamic> _map(Object? value) {
  if (value is! Map) return <String, dynamic>{};
  return {for (final entry in value.entries) '${entry.key}': entry.value};
}

String? _string(Object? value) =>
    value is String && value.trim().isNotEmpty ? value.trim() : null;

List<String> _stringList(Object? value) {
  if (value is String) {
    final path = _string(value);
    return path == null ? const [] : [path];
  }
  if (value is! List) return const [];
  return [
    for (final item in value)
      if (item is String && item.trim().isNotEmpty) item.trim(),
  ];
}

bool? _boolNullable(Object? value) => value is bool ? value : null;

List<ReactForeignComponentConfig> _foreignComponents(Object? value) {
  final result = <ReactForeignComponentConfig>[];
  if (value is Map) {
    for (final entry in value.entries) {
      final name = _string(entry.key);
      final details = _map(entry.value);
      final module = _string(entry.value) ?? _string(details['module']);
      if (name != null && module != null) {
        result.add(
          ReactForeignComponentConfig(
            name: name,
            module: module,
            exportName: _string(details['export']),
            props: _typedProps(details['props']),
          ),
        );
      }
    }
  } else if (value is List) {
    for (final item in value) {
      final details = _map(item);
      final name = _string(details['name']);
      final module = _string(details['module']);
      if (name != null && module != null) {
        result.add(
          ReactForeignComponentConfig(
            name: name,
            module: module,
            exportName: _string(details['export']),
            props: _typedProps(details['props']),
          ),
        );
      }
    }
  }
  return result;
}

Map<String, String> _typedProps(Object? value) {
  final map = _map(value);
  return {
    for (final entry in map.entries)
      if (entry.value is String && entry.value.trim().isNotEmpty)
        entry.key: entry.value.trim(),
  };
}

List<String> _discoverCssModules(Directory root, String staticDirectory) {
  final directory = Directory(p.join(root.path, staticDirectory));
  if (!directory.existsSync()) return const [];
  final paths = <String>[];
  for (final entity in directory.listSync(recursive: true)) {
    if (entity is! File) continue;
    final relative = p.relative(entity.path, from: root.path);
    final basename = p.basename(relative);
    if (basename.contains('.module.scss') ||
        basename.contains('.module.sass') ||
        basename.contains('.module.css')) {
      paths.add(relative);
    }
  }
  paths.sort();
  return paths;
}

String? _pathValue(Map<String, dynamic> map, String key, [String? nestedKey]) {
  final value = map[key];
  if (nestedKey != null && value is Map) {
    return _string(value[nestedKey]);
  }
  return _string(value);
}
