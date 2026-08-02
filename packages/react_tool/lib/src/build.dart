import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:sass/sass.dart' as sass;
import 'package:yaml/yaml.dart';

import 'js_environment.dart';
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

  /// Provisions (or validates) the JS environment for wrapper packages.
  /// Public so `react js install` can surface provisioning errors early.
  Future<JsEnvironment?> ensureJsEnvironment() => _prepareJsEnvironment();

  Future<void> build() async {
    final jsEnvironment = await _prepareJsEnvironment();

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
    await _writeForeignComponents(jsEnvironment);

    final client = config.clientEntrypoint;
    if (client != null && config.file(client).existsSync()) {
      await _compile(
        input: client,
        output: p.join(config.outputDirectory, 'client.js'),
        optimization: release ? '-O2' : '-O0',
      );
      await _writeBrowserRuntime(jsEnvironment);
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
      await _writeSsrWorker(jsEnvironment);
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

  Future<void> _writeForeignComponents(JsEnvironment? environment) async {
    final wrappers = await _discoverWrappers();
    final hasProjectModules =
        config.foreignModules.isNotEmpty || config.foreignComponents.isNotEmpty;
    if (!hasProjectModules && wrappers.every((w) => w.isEmpty)) return;

    // Per-target aggregate entries: absolute import paths so esbuild resolves
    // each wrapper's public npm specifiers through the managed environment.
    final entries = <String, List<String>>{'browser': [], 'ssr': []};
    final componentRegistrations =
        <({String path, String name, String? export})>[];

    // Project-level foreign modules (react.yaml) apply to both targets.
    for (final module in config.foreignModules) {
      final path = await _resolveModulePath(module);
      entries['browser']!.add(path);
      entries['ssr']!.add(path);
    }

    for (final component in config.foreignComponents) {
      final path = await _resolveModulePath(component.module);
      componentRegistrations.add((
        path: path,
        name: component.name,
        export: component.exportName,
      ));
      entries['browser']!.add(path);
      entries['ssr']!.add(path);
    }

    // Wrapper entries per target (shared applies to both).
    for (final wrapper in wrappers) {
      for (final target in wrapper.targets) {
        if (!entries.containsKey(target)) continue;
        final entry = wrapper.entryFor(target);
        if (entry == null) continue;
        final path = await _resolveWrapperEntry(wrapper.packageName, entry);
        entries[target]!.add(path);
      }
    }

    final output = config.directory(config.outputDirectory);
    final foreignDir = Directory(p.join(output.path, 'foreign'));
    await foreignDir.create(recursive: true);

    for (final target in const ['browser', 'ssr']) {
      final targetEntries = entries[target]!;
      if (targetEntries.isEmpty) continue;
      final entryDir = Directory(p.join(foreignDir.path, target));
      await entryDir.create(recursive: true);

      final buffer = StringBuffer()..writeln('// Generated by react_tool.');
      for (final path in targetEntries) {
        final registered = [
          for (final r in componentRegistrations)
            if (r.path == path) r,
        ];
        if (registered.isEmpty) {
          buffer.writeln("import ${jsonEncode(path)};");
          continue;
        }
        final isDefault = registered.every(
          (r) => r.export == null || r.export == 'default',
        );
        if (isDefault && registered.length == 1) {
          buffer
            ..writeln("import _foreignDefault from ${jsonEncode(path)};")
            ..writeln("globalThis.__reactDartRegisterComponent("
                "'${registered.single.name}', _foreignDefault);");
          continue;
        }
        for (final r in registered) {
          final local = '_foreign${r.name}';
          if (r.export == null || r.export == 'default') {
            buffer
              ..writeln("import $local from ${jsonEncode(path)};")
              ..writeln("globalThis.__reactDartRegisterComponent("
                  "'${r.name}', $local);");
          } else {
            buffer
              ..writeln("import { ${r.export} as $local } "
                  "from ${jsonEncode(path)};")
              ..writeln("globalThis.__reactDartRegisterComponent("
                  "'${r.name}', $local);");
          }
        }
      }

      final entryFile = File(p.join(entryDir.path, 'entry.mjs'));
      await entryFile.writeAsString(buffer.toString());
      await _bundleTarget(
        environment: environment,
        target: target,
        entry: entryFile.path,
        outfile: p.join(entryDir.path, 'bundle.mjs'),
      );
      log(
        'Bundled foreign $target entry → '
        '${p.join(config.outputDirectory, 'foreign', target, 'bundle.mjs')}',
      );
    }
    await _writeForeignBindings();
  }

  /// Bundles one target aggregate with esbuild under the target's platform
  /// conditions. Failure is fatal — there is no unbundled fallback.
  Future<void> _bundleTarget({
    required JsEnvironment? environment,
    required String target,
    required String entry,
    required String outfile,
  }) async {
    if (environment == null) {
      throw const ReactToolException(
        'Foreign modules require a managed JS environment, but none was '
        'provisioned. Run: react js install',
      );
    }
    final esbuildEntry = await environment.esbuildEntry();
    final driver = File(p.join(environment.root.path, 'driver.mjs'));
    await driver.parent.create(recursive: true);
    // Always refresh: the driver is tool-owned protocol and may evolve
    // between react_tool versions.
    await driver.writeAsString(_esbuildDriver);

    final externals = await _mergedExternals();
    final options = {
      'entryPoints': [entry],
      'outfile': outfile,
      'bundle': true,
      'format': 'esm',
      'platform': target == 'ssr' ? 'node' : 'browser',
      if (target == 'ssr') 'target': ['node20'],
      'external': externals,
      'conditions': [release ? 'production' : 'development'],
      'minify': release,
      'sourcemap': release ? false : 'linked',
      'logLevel': 'info',
      'nodePaths': [environment.npmRoot],
    };
    final result = await Process.run('node', [
      driver.path,
      esbuildEntry.path,
      jsonEncode(options),
    ], environment: {
      ...Platform.environment,
      // Consumed by the driver's node-externals plugin.
      'REACT_NPM_ROOT': environment.npmRoot,
    });
    if (result.exitCode != 0) {
      throw ReactToolException(
        'esbuild $target bundle failed:\n${result.stderr}',
      );
    }
  }

  /// Externals declared by the project and every wrapper (deduplicated),
  /// always including react and react-dom so they stay singletons.
  Future<List<String>> _mergedExternals() async {
    final result = <String>{'react', 'react-dom'};
    result.addAll(config.foreignExternals);
    for (final wrapper in await _discoverWrappers()) {
      result.addAll(wrapper.externals);
    }
    return result.toList();
  }

  /// Provisions the managed JS environment (or validates the host one) for
  /// the wrapper packages in the dependency graph. Also required when the
  /// project declares foreign modules/components directly.
  Future<JsEnvironment?> _prepareJsEnvironment() async {
    final wrappers = await _discoverWrappers();
    final needsEnvironment = config.foreignComponents.isNotEmpty ||
        config.foreignModules.isNotEmpty ||
        wrappers.any((w) => !w.isEmpty);
    if (!needsEnvironment) return null;
    final builder = JsEnvironmentBuilder(
      projectRoot: config.root,
      packageName: config.packageName,
      configEsbuildPath: config.esbuildPath,
      host: config.jsHostMode,
      log: log,
      npmCommand: npmCommand,
    );
    return builder.ensure(wrappers, required: needsEnvironment);
  }

  /// Descriptors of every wrapper package in the dependency graph.
  Future<List<JsWrapperDescriptor>> _discoverWrappers() async {
    final wrappers = <JsWrapperDescriptor>[];
    for (final (name, rootPath) in await _dependencyPackages()) {
      final pubspecFile = File(p.join(rootPath, 'pubspec.yaml'));
      if (!pubspecFile.existsSync()) continue;
      final yaml = loadYaml(pubspecFile.readAsStringSync());
      final descriptor = JsWrapperDescriptor.parse(
        name,
        yaml is Map ? yaml.cast<String, dynamic>() : {},
      );
      if (descriptor != null) wrappers.add(descriptor);
    }
    return wrappers;
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

  /// Resolves a project-level module (relative path or `package:` URI) to an
  /// absolute file path for the aggregate entry.
  Future<String> _resolveModulePath(String module) async {
    if (module.startsWith('package:')) {
      final match = RegExp(r'^package:([^/]+)/(.+)$').firstMatch(module);
      if (match == null) {
        throw ReactToolException(
          'Invalid package module specifier "$module". '
          'Expected package:name/path/to/file.mjs.',
        );
      }
      final root = _resolvePackageRoot(match.group(1)!);
      final relative = match.group(2)!;
      final packagePath = relative.startsWith('lib/')
          ? relative
          : p.join('lib', relative);
      return p.join(root, packagePath);
    }
    final moduleFile = config.file(module);
    if (!moduleFile.existsSync()) {
      throw ReactToolException(
        'Foreign module "$module" not found at ${moduleFile.path}.',
      );
    }
    return moduleFile.absolute.path;
  }

  /// Resolves a wrapper's entry file (package-relative) to an absolute path.
  Future<String> _resolveWrapperEntry(String packageName, String entry) async {
    final root = _resolvePackageRoot(packageName);
    final path = p.join(root, entry);
    if (!File(path).existsSync()) {
      throw ReactToolException(
        'Wrapper entry "$entry" for package "$packageName" not found at '
        '$path.',
      );
    }
    return path;
  }

  /// Absolute root directory of [packageName] from the package config.
  String _resolvePackageRoot(String packageName) {
    final packageConfig = _findPackageConfig();
    if (packageConfig == null) {
      throw ReactToolException(
        'Cannot resolve package "$packageName": missing '
        '.dart_tool/package_config.json. Run dart pub get first.',
      );
    }
    final decoded = jsonDecode(packageConfig.readAsStringSync());
    final packages = (decoded as Map)['packages'] as List;
    for (final entry in packages) {
      final map = entry as Map;
      if (map['name'] != packageName) continue;
      final rootUri = map['rootUri'] as String;
      final configDir = packageConfig.parent.path;
      return rootUri.startsWith('file:')
          ? Uri.parse(rootUri).toFilePath()
          : p.normalize(p.joinAll([configDir, ...p.split(rootUri)]));
    }
    throw ReactToolException(
      'Package "$packageName" is not a dependency of this project.',
    );
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

  Future<void> _writeBrowserRuntime(JsEnvironment? environment) async {
    final output = config.directory(config.outputDirectory);
    await File(
      p.join(output.path, 'callback_trampoline.mjs'),
    ).writeAsString(_callbackTrampoline);

    final index = File(p.join(output.path, 'index.html'));
    if (!index.existsSync()) return;
    var source = await index.readAsString();

    // Pin the import map to the exact React version the environment resolved
    // so browser and SSR always share one instance.
    if (environment != null) {
      source = source.replaceAllMapped(
        RegExp(r'https://esm\.sh/(react(?:-dom)?)@[0-9.]+'),
        (match) =>
            'https://esm.sh/${match.group(1)}@${environment.reactVersion}',
      );
    }
    if (source.contains('callback_trampoline.mjs')) {
      await index.writeAsString(source);
      return;
    }

    const clientScript = '<script type="module" src="client.js"></script>';
    const runtimeScript =
        '<script type="module" src="callback_trampoline.mjs"></script>';
    final wrappers = await _discoverWrappers();
    final hasForeign = config.foreignComponents.isNotEmpty ||
        config.foreignModules.isNotEmpty ||
        wrappers.any((w) => !w.isEmpty);
    final foreignScript = hasForeign
        ? '<script type="module" src="foreign/browser/bundle.mjs"></script>'
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

  Future<void> _writeSsrWorker(JsEnvironment? environment) async {
    final output = config.directory(config.outputDirectory);
    var worker = _ssrWorker;
    if (environment != null) {
      // Import React through the environment's exact versions so the worker
      // shares one instance with the foreign bundle.
      worker = worker
          .replaceFirst(
            "import React from 'react';",
            "import React from '${environment.resolveForNode('react')}';",
          )
          .replaceFirst(
            "import ReactDOMServer from 'react-dom/server';",
            "import ReactDOMServer from "
            "'${environment.resolveForNode('react-dom/server')}';",
          )
          .replaceFirst(
            "import http from 'node:http';",
            "import http from 'node:http';\n"
                "import { createRequire } from 'node:module';\n"
                // The node bundles keep react/react-dom external; some
                // packages (e.g. react-router-dom's UMD build) require them
                // dynamically at init. Bind require to the environment's npm
                // root so it resolves the SAME installed instances.
                "globalThis.require ??= createRequire("
                "${jsonEncode(p.join(environment.npmRoot, 'x.js'))});\n"
                // dart2js's Random.secure() reads `self.crypto` (uuid, used
                // by riverpod 3 for element ids, calls it at startup). Node
                // has no `self`; alias it to the global, whose `crypto` is
                // node's webcrypto.
                "globalThis.self ??= globalThis;",
          )
          .replaceFirst(
            "./foreign_components.mjs",
            './foreign/ssr/bundle.mjs',
          );
    }
    await File(p.join(output.path, 'ssr_worker.mjs')).writeAsString(worker);
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
  await import('./foreign/ssr/bundle.mjs');
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

/// Node driver that runs the environment's esbuild programmatically. Options
/// arrive as JSON argv; for the node platform it adds an onResolve plugin that
/// rewrites external bare specifiers to absolute paths through the
/// environment's npm root, so the worker never depends on a node_modules
/// walk-up.
const _esbuildDriver = r'''
import { pathToFileURL } from 'node:url';
import { createRequire } from 'node:module';

const [esbuildEntry, json] = process.argv.slice(2);
const { build } = await import(pathToFileURL(esbuildEntry).href);
const opts = JSON.parse(json);

const require = createRequire(process.cwd() + '/x.js');
const npmRoot = process.env.REACT_NPM_ROOT || opts.npmRoot;
if (opts.platform === 'node' && Array.isArray(opts.external)) {
  const externals = opts.external;
  opts.plugins = [{
    name: 'react-node-externals',
    setup(build) {
      build.onResolve({ filter: /.*/ }, (args) => {
        for (const spec of externals) {
          if (args.path === spec || args.path.startsWith(spec + '/')) {
            try {
              return {
                path: require.resolve(args.path, { paths: [npmRoot] }),
                external: true,
              };
            } catch (error) {
              return {
                errors: [{
                  text: `Cannot resolve external "${args.path}" in the JS environment: ${error.message}`,
                }],
              };
            }
          }
        }
        return null;
      });
    },
  }];
}

try {
  await build(opts);
} catch (error) {
  const lines = error?.errors?.map((e) => e.text) ?? [String(error)];
  console.error(lines.join('\n'));
  process.exit(1);
}
''';
