import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:sass/sass.dart' as sass;
import 'package:yaml/yaml.dart';

import 'project_config.dart';
import 'styles.dart';

/// Runs the standardized React Dart build pipeline.
final class ReactBuilder {
  final ReactProjectConfig config;
  final bool release;
  final void Function(String message) log;

  /// Package manager command used to provision missing npm dependencies
  /// (defaults to `npm`; may be an absolute path for testing).
  final String npmCommand;

  const ReactBuilder({
    required this.config,
    required this.release,
    this.log = print,
    this.npmCommand = 'npm',
  });

  Future<void> build() async {
    await _ensureNpmDependencies();

    // Generate style bindings before code generation so client entrypoints may
    // import them during the same build.
    await _compileStylesheets();

    if (config.hasBuildRunner) {
      await _runDart([
        'run',
        'build_runner',
        'build',
        if (_isWorkspaceRoot) '--workspace',
      ]);
    } else {
      log('Skipping build_runner: build_runner is not declared.');
    }

    await _syncGeneratedSources();

    final output = config.directory(config.outputDirectory);
    await output.create(recursive: true);
    await _copyStaticAssets(output);
    await _writeStylesheetLinks(output);
    await _writeForeignComponents();

    final client = config.clientEntrypoint;
    if (client != null && config.file(client).existsSync()) {
      await _compile(
        input: client,
        output: p.join(config.outputDirectory, 'client.js'),
        optimization: release ? '-O2' : '-O0',
      );
      await _writeBrowserRuntime();
    } else {
      log('Skipping client build: ${client ?? '(not configured)'} not found.');
    }

    final ssr = config.ssrEntrypoint;
    if (ssr != null && config.file(ssr).existsSync()) {
      await _compile(
        input: ssr,
        output: p.join(config.outputDirectory, 'ssr.js'),
        optimization: '-O2',
      );
      await _writeSsrWorker();
    } else {
      log('Skipping SSR build: ${ssr ?? '(not configured)'} not found.');
    }

    await File(
      p.join(output.path, 'manifest.json'),
    ).writeAsString('${config.toJsonString()}\n');
  }

  /// Copies build_runner outputs (`.react.dart`, `.action.g.dart`, …) from
  /// `.dart_tool/build/generated/<package>/lib` back into the project's `lib/`
  /// so `dart compile js` can resolve the relative imports. With `--workspace`
  /// the generated tree lives under the workspace root, hence the upward walk.
  Future<void> _syncGeneratedSources() async {
    final generatedRoot = _findGeneratedRoot(config.packageName);
    if (generatedRoot == null) return;
    final libSource = Directory(p.join(generatedRoot.path, 'lib'));
    if (!libSource.existsSync()) return;

    final libTarget = Directory(p.join(config.root.path, 'lib'));
    await libTarget.create(recursive: true);
    var copied = 0;
    await for (final entity in libSource.list(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;
      if (p.basename(entity.path).startsWith(r'$')) continue; // aggregate $lib$
      final relative = p.relative(entity.path, from: libSource.path);
      await entity.copy(p.join(libTarget.path, relative));
      copied++;
    }
    if (copied > 0) {
      log('Synced $copied generated sources into lib/.');
    }
  }

  Directory? _findGeneratedRoot(String packageName) {
    var current = config.root;
    while (true) {
      final candidate = Directory(
        p.join(current.path, '.dart_tool/build/generated', packageName),
      );
      if (candidate.existsSync()) return candidate;
      final parent = current.parent;
      if (parent.path == current.path) return null;
      current = parent;
    }
  }

  bool get _isWorkspaceRoot {
    final value = _loadPubspec()['workspace'];
    return value is List;
  }

  Map<String, dynamic> _loadPubspec() {
    final value = loadYaml(config.file('pubspec.yaml').readAsStringSync());
    if (value is! Map) return {};
    return {for (final entry in value.entries) '${entry.key}': entry.value};
  }

  Future<void> _copyStaticAssets(Directory output) async {
    final source = config.directory(config.staticDirectory);
    if (!source.existsSync()) {
      log('Skipping static assets: ${config.staticDirectory} not found.');
      return;
    }

    await for (final entity in source.list(recursive: true)) {
      final relative = p.relative(entity.path, from: source.path);
      if (_isBuildInputOrArtifact(relative)) continue;
      final destination = File(p.join(output.path, relative));
      if (entity is Directory) {
        await destination.parent.create(recursive: true);
      } else if (entity is File) {
        await destination.parent.create(recursive: true);
        await entity.copy(destination.path);
      }
    }
    log('Copied static assets → ${output.path}');
  }

  bool _isBuildInputOrArtifact(String relative) {
    final client = config.clientEntrypoint;
    final clientName = client == null ? null : p.basename(client);
    final clientRelative = client == null
        ? null
        : p.relative(
            config.pathFor(client),
            from: config.pathFor(config.staticDirectory),
          );
    if (clientRelative != null &&
        (relative == clientRelative ||
            relative.startsWith('$clientName.') ||
            relative == p.setExtension(clientName!, '.js'))) {
      return true;
    }

    for (final stylesheet in config.styleEntrypoints) {
      final stylesheetRelative = p.relative(
        config.pathFor(stylesheet),
        from: config.pathFor(config.staticDirectory),
      );
      if (relative == stylesheetRelative) return true;
      final bindingRelative = p.relative(
        p.setExtension(config.pathFor(stylesheet), '.dart'),
        from: config.pathFor(config.staticDirectory),
      );
      if (relative == bindingRelative) return true;
      final generatedRelative = p.normalize(_stylesheetOutputName(stylesheet));
      if (relative == generatedRelative) return true;
    }
    return false;
  }

  Future<void> _compileStylesheets() async {
    if (config.styleEntrypoints.isEmpty) return;

    for (final stylesheet in config.styleEntrypoints) {
      final input = config.file(stylesheet);
      if (!input.existsSync()) {
        throw ReactToolException(
          'Configured stylesheet does not exist: ${input.path}',
        );
      }

      final outputName = _stylesheetOutputName(stylesheet);
      final output = config.file(p.join(config.outputDirectory, outputName));
      await output.parent.create(recursive: true);
      log(
        'Compiling $stylesheet → ${p.relative(output.path, from: config.root.path)}',
      );
      try {
        final result = ReactStyleCompiler(
          release: release,
          identity: p.relative(input.path, from: config.root.path),
        ).compile(input.path);
        await output.writeAsString(result.css);
        if (result.isModule) {
          final bindings = File(p.setExtension(input.path, '.dart'));
          await bindings.writeAsString(
            emitCssModuleBindings(
              sourcePath: input.path,
              classes: result.classes,
            ),
          );
          log(
            'Generated CSS Module bindings → '
            '${p.relative(bindings.path, from: config.root.path)}',
          );
        }
      } on sass.SassException catch (error) {
        throw ReactToolException(
          'Sass compilation failed for $stylesheet: $error',
        );
      }
    }
  }

  String _stylesheetOutputName(String stylesheet) =>
      config.styleOutput != null && config.styleEntrypoints.length == 1
      ? config.styleOutput!
      : '${p.basenameWithoutExtension(stylesheet)}.css';

  Future<void> _writeStylesheetLinks(Directory output) async {
    if (config.styleEntrypoints.isEmpty) return;
    final index = File(p.join(output.path, 'index.html'));
    if (!index.existsSync()) return;

    var source = await index.readAsString();
    final links = <String>[];
    for (final stylesheet in config.styleEntrypoints) {
      final href = p.posix.joinAll(p.split(_stylesheetOutputName(stylesheet)));
      final link = '<link rel="stylesheet" href="$href">';
      if (!source.contains('href="$href"')) links.add(link);
    }
    if (links.isEmpty) return;
    final insertion = '${links.join('\n')}\n';
    source = source.contains('</head>')
        ? source.replaceFirst('</head>', '$insertion</head>')
        : '$insertion$source';
    await index.writeAsString(source);
  }

  Future<void> _writeForeignComponents() async {
    final modules = await _allForeignModules();
    if (config.foreignComponents.isEmpty && modules.isEmpty) {
      return;
    }

    final buffer = StringBuffer()..writeln('// Generated by react_tool.');
    for (final module in modules) {
      final specifier = await _foreignModuleSpecifier(module);
      buffer.writeln("import '$specifier';");
    }
    buffer.writeln();
    for (var index = 0; index < config.foreignComponents.length; index++) {
      final component = config.foreignComponents[index];
      final localName = '_reactForeignComponent$index';
      final specifier = await _foreignModuleSpecifier(component.module);
      if (component.exportName == null || component.exportName == 'default') {
        buffer.writeln("import $localName from '$specifier';");
      } else {
        buffer.writeln(
          "import { ${component.exportName} as $localName } from '$specifier';",
        );
      }
    }
    buffer.writeln();
    for (var index = 0; index < config.foreignComponents.length; index++) {
      final component = config.foreignComponents[index];
      buffer.writeln(
        "globalThis.__reactDartRegisterComponent('${component.name}', "
        "_reactForeignComponent$index);",
      );
    }

    final output = config.directory(config.outputDirectory);
    await File(
      p.join(output.path, 'foreign_components.mjs'),
    ).writeAsString(buffer.toString());
    log(
      'Generated ${p.join(config.outputDirectory, 'foreign_components.mjs')}',
    );
    await _writeForeignBindings();
  }

  /// The project's own foreign modules plus shims declared by dependency
  /// packages under `react.shims` in their pubspec. Wrapper packages publish
  /// their shim there so adding the dependency is all a project needs to do.
  Future<List<String>> _allForeignModules() async {
    final modules = [...config.foreignModules];
    for (final shim in await _discoverDependencyShims()) {
      if (!modules.contains(shim)) modules.add(shim);
    }
    return modules;
  }

  Future<List<String>> _discoverDependencyShims() async {
    final shims = <String>[];
    for (final (name, rootPath) in await _dependencyPackages()) {
      final declared = _pubspecReactField(rootPath, 'shims');
      if (declared is! List) continue;
      for (final shim in declared) {
        if (shim is! String || shim.trim().isEmpty) continue;
        shims.add('package:$name/${shim.trim()}');
      }
    }
    return shims;
  }

  /// npm dependencies declared by this project and by wrapper packages
  /// (`react.npm` in pubspec), merged across the dependency graph.
  Future<Map<String, String>> _declaredNpmDependencies() async {
    final result = <String, String>{};

    // The project's own pubspec may declare npm deps for project-local shims.
    final own = _pubspecReactField(config.root.path, 'npm');
    if (own is Map) {
      for (final entry in own.entries) {
        if (entry.key is String && entry.value is String) {
          result[entry.key as String] = entry.value as String;
        }
      }
    }

    for (final (_, rootPath) in await _dependencyPackages()) {
      final declared = _pubspecReactField(rootPath, 'npm');
      if (declared is! Map) continue;
      for (final entry in declared.entries) {
        if (entry.key is String && entry.value is String) {
          result[entry.key as String] ??= entry.value as String;
        }
      }
    }
    return result;
  }

  /// Dependency packages (excluding this project) from the package config.
  Future<List<(String, String)>> _dependencyPackages() async {
    final packageConfig = _findPackageConfig();
    if (packageConfig == null) return const [];
    final decoded = jsonDecode(packageConfig.readAsStringSync());
    final packages = (decoded as Map)['packages'] as List;
    final configDir = packageConfig.parent.path;

    final result = <(String, String)>[];
    for (final entry in packages) {
      final map = entry as Map;
      final name = map['name'] as String;
      if (name == config.packageName) continue;
      final rootUri = map['rootUri'] as String;
      final rootPath = rootUri.startsWith('file:')
          ? Uri.parse(rootUri).toFilePath()
          : p.normalize(p.joinAll([configDir, ...p.split(rootUri)]));
      if (!File(p.join(rootPath, 'pubspec.yaml')).existsSync()) continue;
      result.add((name, rootPath));
    }
    return result;
  }

  /// Reads a field from the `react:` section of a package's pubspec.
  dynamic _pubspecReactField(String rootPath, String field) {
    final pubspec = File(p.join(rootPath, 'pubspec.yaml'));
    if (!pubspec.existsSync()) return null;
    final yaml = loadYaml(pubspec.readAsStringSync());
    final react = yaml is Map ? yaml['react'] : null;
    return react is Map ? react[field] : null;
  }

  /// Makes sure every npm dependency declared by wrapper packages is
  /// installed: merges them into the nearest package.json and runs the package
  /// manager when anything is missing from node_modules.
  Future<void> _ensureNpmDependencies() async {
    final declared = await _declaredNpmDependencies();
    if (declared.isEmpty) return;

    final npmRoot = _findNpmRoot();
    if (npmRoot == null) {
      log(
        'No package.json or node_modules found; skipping npm provisioning for '
        '${declared.keys.join(', ')}.',
      );
      return;
    }

    final packageJson = File(p.join(npmRoot, 'package.json'));
    final manifest = packageJson.existsSync()
        ? jsonDecode(packageJson.readAsStringSync()) as Map<String, dynamic>
        : <String, dynamic>{};
    manifest['dependencies'] ??= <String, dynamic>{};
    final dependencies = manifest['dependencies'] as Map<String, dynamic>;
    var changed = false;
    for (final entry in declared.entries) {
      if (!dependencies.containsKey(entry.key)) {
        dependencies[entry.key] = entry.value;
        changed = true;
      }
    }
    if (changed) {
      const encoder = JsonEncoder.withIndent('  ');
      packageJson.writeAsStringSync('${encoder.convert(manifest)}\n');
    }

    final missing = <String>[
      for (final name in declared.keys)
        if (!_npmResolvable(npmRoot, name)) name,
    ];
    if (missing.isEmpty) {
      log('npm dependencies present: ${declared.keys.join(', ')}');
      return;
    }

    log('Installing npm dependencies: ${missing.join(', ')}');
    final result = await Process.run(
      npmCommand,
      ['install', '--no-audit', '--no-fund'],
      workingDirectory: npmRoot,
    );
    if (result.exitCode != 0) {
      throw ReactToolException(
        'npm install failed (exit ${result.exitCode}): ${result.stderr}',
      );
    }
    log('npm install completed.');
  }

  /// Nearest ancestor of the project containing a package.json or node_modules.
  String? _findNpmRoot() {
    var current = config.root.path;
    while (true) {
      if (File(p.join(current, 'package.json')).existsSync() ||
          Directory(p.join(current, 'node_modules')).existsSync()) {
        return current;
      }
      final parent = p.dirname(current);
      if (parent == current) return null;
      current = parent;
    }
  }

  bool _npmResolvable(String npmRoot, String name) {
    final segments = name.split('/');
    final path = segments.length > 1
        ? p.joinAll(['node_modules', ...segments])
        : p.join('node_modules', name);
    return File(p.join(npmRoot, path, 'package.json')).existsSync();
  }

  Future<void> _writeForeignBindings() async {
    final buffer = StringBuffer()
      ..writeln('// GENERATED CODE - DO NOT MODIFY BY HAND.')
      ..writeln("import 'package:react/react.dart' as react;")
      ..writeln();

    for (final component in config.foreignComponents) {
      final functionName = _dartIdentifier(component.name);
      buffer.writeln('react.ReactNode $functionName({');
      for (final entry in component.props.entries) {
        final parameter = _foreignParameter(entry.key);
        final type = entry.value
            .replaceAll('ReactNode', 'react.ReactNode')
            .replaceAll('ReactCallback', 'react.ReactCallback');
        final required = !type.trim().endsWith('?');
        buffer.writeln('  ${required ? 'required ' : ''}$type $parameter,');
      }
      buffer
        ..writeln('  String? key,')
        ..writeln('  List<react.ReactNode> children = const [],')
        ..writeln('}) => react.foreignComponent(')
        ..writeln("  '${component.name}',")
        ..writeln('  props: {');
      for (final entry in component.props.entries) {
        final parameter = _foreignParameter(entry.key);
        buffer.writeln("    '${entry.key}': $parameter,");
      }
      buffer
        ..writeln('  },')
        ..writeln('  key: key,')
        ..writeln('  children: children,')
        ..writeln(');')
        ..writeln();
    }

    final bindings = config.file('lib/foreign_components.g.dart');
    await bindings.parent.create(recursive: true);
    await bindings.writeAsString(buffer.toString());
    log('Generated ${bindings.path}');
  }

  String _dartIdentifier(String value) {
    final words = value
        .split(RegExp(r'[^a-zA-Z0-9]+'))
        .where((word) => word.isNotEmpty)
        .toList();
    if (words.isEmpty) return '_component';
    final result =
        words.first.toLowerCase() +
        words
            .skip(1)
            .map((word) => word[0].toUpperCase() + word.substring(1))
            .join();
    return RegExp(r'^[0-9]').hasMatch(result) ? '_$result' : result;
  }

  String _foreignParameter(String value) {
    final identifier = _dartIdentifier(value);
    return switch (identifier) {
      'key' || 'children' => '${identifier}Prop',
      _ => identifier,
    };
  }

  Future<String> _foreignModuleSpecifier(String module) async {
    if (module.startsWith('package:')) {
      return _packageModuleSpecifier(module);
    }
    final moduleFile = config.file(module);
    if (!moduleFile.existsSync()) return module;

    final staticRoot = config.directory(config.staticDirectory).path;
    final absolute = moduleFile.absolute.path;
    final staticAbsolute = Directory(staticRoot).absolute.path;
    if (p.isWithin(staticAbsolute, absolute) || absolute == staticAbsolute) {
      final relative = p.relative(absolute, from: staticAbsolute);
      return './${p.posix.joinAll(p.split(relative))}';
    }
    final relative = p.relative(
      absolute,
      from: config.directory(config.outputDirectory).absolute.path,
    );
    return p.posix.joinAll(p.split(relative));
  }

  File? _findPackageConfig() {
    var current = config.root;
    while (true) {
      final candidate = File(
        p.join(current.path, '.dart_tool/package_config.json'),
      );
      if (candidate.existsSync()) return candidate;
      final parent = current.parent;
      if (parent.path == current.path) return null;
      current = parent;
    }
  }

  /// Resolves `package:name/path` to the package's shipped file and vendors it
  /// under `build/react/vendor/name/path` so both the browser bundle and the
  /// Node SSR worker can import it with a relative specifier.
  Future<String> _packageModuleSpecifier(String module) async {
    final match = RegExp(r'^package:([^/]+)/(.+)$').firstMatch(module);
    if (match == null) {
      throw ReactToolException(
        'Invalid package module specifier "$module". '
        'Expected package:name/path/to/file.mjs.',
      );
    }
    final packageName = match.group(1)!;
    final relative = match.group(2)!;

    final packageConfig = _findPackageConfig();
    if (packageConfig == null) {
      throw ReactToolException(
        'Cannot resolve "$module": missing .dart_tool/package_config.json. '
        'Run dart pub get first.',
      );
    }
    final decoded = jsonDecode(packageConfig.readAsStringSync());
    final packages = (decoded as Map)['packages'] as List;
    String? packageRoot;
    for (final entry in packages) {
      final map = entry as Map;
      if (map['name'] == packageName) {
        packageRoot = map['rootUri'] as String;
        break;
      }
    }
    if (packageRoot == null) {
      throw ReactToolException(
        'Package "$packageName" is not a dependency of this project.',
      );
    }

    // rootUri is relative to the package_config.json directory (workspace
    // members live outside the project root) or an absolute file: URI.
    final configDir = packageConfig.parent.path;
    final rootPath = packageRoot.startsWith('file:')
        ? Uri.parse(packageRoot).toFilePath()
        : p.normalize(p.joinAll([configDir, ...p.split(packageRoot)]));
    // package: specifiers address the package lib directory.
    final packagePath = relative.startsWith('lib/')
        ? relative
        : p.join('lib', relative);
    final source = File(p.join(rootPath, packagePath));
    if (!source.existsSync()) {
      throw ReactToolException(
        'Foreign module "$module" not found at ${source.path}.',
      );
    }

    final output = config.directory(config.outputDirectory);
    final vendorPath = p.joinAll([
      'vendor',
      ...p.posix.split(relative),
    ]);
    final destination = File(p.join(output.path, vendorPath));
    await destination.parent.create(recursive: true);
    final bundled = await _bundleForeignModule(source, destination);
    if (bundled) {
      log('Bundled $module → ${p.posix.joinAll(p.split(vendorPath))}');
    } else {
      await source.copy(destination.path);
      log('Vendored $module → ${p.posix.joinAll(p.split(vendorPath))}');
    }
    return './${p.posix.joinAll(p.split(vendorPath))}';
  }

  /// Bundles a foreign shim with esbuild, inlining its npm imports.
  ///
  /// Bare `react` / `react-dom` imports stay external so the shim shares the
  /// React instance the page already loads (import map in the browser,
  /// node_modules in the SSR worker). Returns `false` when esbuild is
  /// unavailable — the shim is then copied verbatim and its npm imports must
  /// be import-mapped by the host page.
  Future<bool> _bundleForeignModule(File source, File destination) async {
    final esbuild = await _findEsbuild();
    if (esbuild == null) return false;
    final result = await Process.run(esbuild, [
      source.path,
      '--bundle',
      '--format=esm',
      '--external:react',
      '--external:react-dom',
      '--outfile=${destination.path}',
    ]);
    if (result.exitCode != 0) {
      log('esbuild failed (${result.stderr}); falling back to copy.');
      return false;
    }
    return true;
  }

  Future<String?> _findEsbuild() async {
    final configured = config.esbuildPath;
    if (configured != null && File(configured).existsSync()) return configured;
    final fromEnv = Platform.environment['ESBUILD'];
    if (fromEnv != null && File(fromEnv).existsSync()) return fromEnv;
    final which = await Process.run('which', ['esbuild']);
    if (which.exitCode == 0) {
      final path = (which.stdout as String).trim();
      if (path.isNotEmpty) return path;
    }
    return null;
  }

  Future<void> _compile({
    required String input,
    required String output,
    required String optimization,
  }) async {
    final outputPath = config.pathFor(output);
    await Directory(p.dirname(outputPath)).create(recursive: true);
    log('Compiling $input → $outputPath');
    await _runDart([
      'compile',
      'js',
      optimization,
      '-o',
      outputPath,
      config.pathFor(input),
    ]);
  }

  Future<void> _runDart(List<String> arguments) async {
    log('dart ${arguments.join(' ')}');
    await Directory(p.join(config.root.path, '.tmp')).create(recursive: true);
    final result = await Process.run(
      Platform.resolvedExecutable,
      arguments,
      workingDirectory: config.root.path,
      environment: {...Platform.environment, 'TMP': '.tmp'},
    );
    if (result.stdout.toString().trim().isNotEmpty) {
      stdout.write(result.stdout);
    }
    if (result.stderr.toString().trim().isNotEmpty) {
      stderr.write(result.stderr);
    }
    if (result.exitCode != 0) {
      throw ReactToolException(
        'Command failed with exit code ${result.exitCode}: '
        '${Platform.resolvedExecutable} ${arguments.join(' ')}',
      );
    }
  }

  Future<void> _writeBrowserRuntime() async {
    final output = config.directory(config.outputDirectory);
    await File(
      p.join(output.path, 'callback_trampoline.mjs'),
    ).writeAsString(_callbackTrampoline);

    final index = File(p.join(output.path, 'index.html'));
    if (!index.existsSync()) return;
    final source = await index.readAsString();
    if (source.contains('callback_trampoline.mjs')) return;

    const clientScript = '<script type="module" src="client.js"></script>';
    const runtimeScript =
        '<script type="module" src="callback_trampoline.mjs"></script>';
    final hasForeign =
        config.foreignComponents.isNotEmpty ||
        (await _allForeignModules()).isNotEmpty;
    final foreignScript = hasForeign
        ? '<script type="module" src="foreign_components.mjs"></script>'
        : '';
    final scripts = [
      runtimeScript,
      if (foreignScript.isNotEmpty) foreignScript,
    ].join('\n');
    final updated = source.contains(clientScript)
        ? source.replaceFirst(clientScript, '$scripts\n$clientScript')
        : '$source\n$scripts\n';
    await index.writeAsString(updated);
  }

  Future<void> _writeSsrWorker() async {
    final output = config.directory(config.outputDirectory);
    await File(p.join(output.path, 'ssr_worker.mjs')).writeAsString(_ssrWorker);
    log('Generated ${p.join(config.outputDirectory, 'ssr_worker.mjs')}');
  }
}

// Keep this protocol asset owned by the tool so projects do not need to copy
// package-internal files by hand.
const _callbackTrampoline = r'''globalThis.__dartReactCallbacks ??= {};

globalThis.__dartReactCallbacks.create = function create(reference, dispatch) {
  return function (...args) {
    return dispatch(reference, args);
  };
};

globalThis.__dartReactCallbacks.createPromise = function createPromise(executor) {
  return new Promise(executor);
};

globalThis.__dartReactCallbacks.invoke = function invoke(fn, args) {
  return fn(...args);
};

globalThis.__reactDartForeignComponents ??= {};
globalThis.__reactDartRegisterComponent = function registerComponent(name, component) {
  globalThis.__reactDartForeignComponents[name] = component;
};
globalThis.__reactDartResolveComponent = function resolveComponent(name) {
  return globalThis.__reactDartForeignComponents[name];
};

globalThis.__reactDartGetErrorBoundary = function getErrorBoundary() {
  if (globalThis.__reactDartErrorBoundary) {
    return globalThis.__reactDartErrorBoundary;
  }

  const React = globalThis.React;
  if (!React || !React.Component) {
    throw new Error('React must be loaded before creating an error boundary');
  }

  class DartErrorBoundary extends React.Component {
    constructor(props) {
      super(props);
      this.state = { hasError: false };
    }

    static getDerivedStateFromError() {
      return { hasError: true };
    }

    componentDidCatch(error, info) {
      if (this.props.onError) {
        this.props.onError(error, info);
      }
    }

    render() {
      return this.state.hasError ? this.props.fallback : this.props.children;
    }
  }

  globalThis.__reactDartErrorBoundary = DartErrorBoundary;
  return DartErrorBoundary;
};
''';

const _ssrWorker = r'''import React from 'react';
import ReactDOMServer from 'react-dom/server';
import http from 'node:http';

globalThis.React = React;
await import('./callback_trampoline.mjs');
if (process.env.REACT_FOREIGN_COMPONENTS !== 'false') {
  try { await import('./foreign_components.mjs'); } catch (_) {}
}
await import('./ssr.js');

const port = Number(process.env.REACT_SSR_PORT ?? 3001);

http.createServer((req, res) => {
  let body = '';
  req.on('data', chunk => body += chunk);
  req.on('end', () => {
    try {
      const request = JSON.parse(body || '{}');
      const renderRequest = {
        id: request.component ?? request.id,
        props: request.props ?? {},
      };
      let html;
      try {
        const element = globalThis.__REACT_RENDER__(renderRequest);
        html = ReactDOMServer.renderToString(element);
      } catch (error) {
        const fallbackRenderer = globalThis.__REACT_RENDER_FALLBACK__;
        if (!fallbackRenderer) throw error;
        try {
          const fallbackElement = fallbackRenderer({
            ...renderRequest,
            error: String(error?.message ?? error),
          });
          html = ReactDOMServer.renderToString(fallbackElement);
        } finally {
          globalThis.__reactDartSSRBoundaryFallback = false;
          globalThis.__reactDartSSRBoundaryError = undefined;
        }
      }
      res.writeHead(200, {'content-type': 'application/json'});
      res.end(JSON.stringify({html, props: renderRequest.props}));
    } catch (error) {
      console.error(error);
      res.writeHead(500, {'content-type': 'application/json'});
      res.end(JSON.stringify({error: String(error?.message ?? error)}));
    }
  });
}).listen(port, () => console.log(`React SSR worker :${port}`));
''';
