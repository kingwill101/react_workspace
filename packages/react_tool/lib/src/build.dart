import 'dart:convert';
import 'dart:io';

import 'package:package_config/package_config.dart';
import 'package:path/path.dart' as p;
import 'package:sass/sass.dart' as sass;
import 'package:yaml/yaml.dart';

import 'bundler/bundle_report.dart';
import 'bundler/bundle_request.dart';
import 'bundler/bundle_result.dart';
import 'bundler/bundler.dart';
import 'bundler/dart_usage.dart';
import 'bundler/esbuild_bundler.dart';
import 'bundler/rolldown_bundler.dart';
import 'bundler/shim_pruning.dart';
import 'bundler/usage_scan.dart';
import 'js_environment.dart';
import 'project_config.dart';
import 'react_versions.dart';
import 'styles.dart';

/// Directory under `lib/` reserved for source files produced by React codegen.
///
/// Keeping this boundary hidden makes the authored project surface easier to
/// navigate while preserving normal Dart package imports.
const generatedSourceDirectory = '.generated';

/// Runs the standardized React Dart build pipeline.
final class ReactBuilder {
  final ReactProjectConfig config;
  final bool release;

  /// Whether to compile the server entrypoint to a native binary with
  /// `dart compile exe` (deployment artifact that needs no Dart runtime).
  final bool server;

  final void Function(String message) log;

  /// Package manager command used to provision missing npm dependencies
  /// (defaults to `npm`; may be an absolute path for testing).
  final String npmCommand;

  /// Overrides the managed React and React DOM version.
  ///
  /// This is primarily used by compatibility harnesses. Wrapper peer ranges
  /// still take precedence when they select an installed version.
  final String? managedReactVersion;

  JavaScriptBundler? _bundler;

  /// Per-target [BundleResult] from the latest build, keyed by `browser`/`ssr`.
  final Map<String, BundleResult> _bundleResults = {};

  ReactBuilder({
    required this.config,
    required this.release,
    this.server = false,
    this.log = print,
    this.npmCommand = 'npm',
    this.managedReactVersion,
  });

  /// Provisions (or validates) the JS environment for wrapper packages.
  /// Public so `react js install` can surface provisioning errors early.
  Future<JsEnvironment?> ensureJsEnvironment({
    Map<String, String> additionalDependencies = const {},
  }) => _prepareJsEnvironment(additionalDependencies: additionalDependencies);

  /// Runs Dart code generation and syncs every generated source into the
  /// hidden `lib/.generated/` tree without compiling browser or SSR bundles.
  Future<void> generateSources() async {
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
    await syncGeneratedSources();
    // Project-level foreign component wrappers are source-generation output
    // too. Generate them here so `react generate` is sufficient for analyzers
    // and editors that import `lib/.generated/foreign_components.g.dart`.
    await _writeForeignComponents(null);
  }

  /// Synchronizes existing build-runner outputs into `lib/.generated/`.
  ///
  /// This is useful after one workspace-wide `build_runner build --workspace`
  /// invocation: each application can expose its generated package imports
  /// without compiling the same builders again.
  Future<void> syncGeneratedSources() async {
    await _syncGeneratedSources();
  }

  /// Removes the synchronized Dart sources owned by React code generation.
  ///
  /// Returns whether a generated source directory existed and was removed.
  /// Build-runner's cache remains under `.dart_tool` and can be managed with
  /// the standard Dart build commands.
  Future<bool> cleanGeneratedSources() async {
    final generated = config.directory(p.join('lib', generatedSourceDirectory));
    if (!generated.existsSync()) return false;
    await generated.delete(recursive: true);
    log('Removed ${generated.path}');
    return true;
  }

  /// Builds browser, SSR, style, asset, and foreign-module artifacts.
  ///
  /// Set [runCodegen] to false only when a successful build-runner invocation
  /// has already populated the workspace cache. Existing outputs are still
  /// synchronized into `lib/.generated/` before compilation.
  Future<void> build({bool runCodegen = true}) async {
    final jsEnvironment = await _prepareJsEnvironment();
    _bundler = switch (jsEnvironment) {
      null => null,
      final environment => switch (config.bundlingBackend) {
        'rolldown' => RolldownBundler(environment: environment),
        _ => EsbuildBundler(environment: environment),
      },
    };

    // Generate style bindings before code generation so client entrypoints may
    // import them during the same build.
    await _compileStylesheets();

    if (runCodegen) {
      await generateSources();
    } else {
      await syncGeneratedSources();
    }

    final output = config.directory(config.outputDirectory);
    await output.create(recursive: true);
    await _copyStaticAssets(output);
    await _writeStylesheetLinks(output);

    // Foreign bindings must exist before the Dart entrypoints compile (they
    // import the generated helpers). The foreign *bundles* are built after
    // compilation so they can be pruned to what the app actually uses.
    await _writeForeignComponents(jsEnvironment);

    var hasClient = false;
    final client = config.clientEntrypoint;
    if (client != null && config.file(client).existsSync()) {
      await _compile(
        input: client,
        output: p.join(config.outputDirectory, 'client.js'),
        optimization: release ? '-O2' : '-O0',
      );
      hasClient = true;
      await _writeBrowserEntry(jsEnvironment);
    } else {
      log('Skipping client build: ${client ?? '(not configured)'} not found.');
    }

    var hasSsr = false;
    final ssr = config.ssrEntrypoint;
    if (ssr != null && config.file(ssr).existsSync()) {
      await _compile(
        input: ssr,
        output: p.join(config.outputDirectory, 'ssr.js'),
        optimization: '-O2',
      );
      hasSsr = true;
      await _writeSsrBootstrap(jsEnvironment);
    } else {
      log('Skipping SSR build: ${ssr ?? '(not configured)'} not found.');
    }

    // Semantic Dart usage manifests.
    // The semantic pass is authoritative only when `complete == true`;
    // otherwise the bundler unions it with the compiled-JS scan (fail-safe).
    final dotReactDir = Directory(p.join('.dart_tool', 'react'));
    final browserUsage = await writeUsageManifest(
      entryPath: config.clientEntrypoint != null
          ? p.join(config.root.path, config.clientEntrypoint!)
          : null,
      target: 'browser',
      dotDartToolReact: dotReactDir,
      projectRoot: config.root.path,
    );
    final ssrUsage = await writeUsageManifest(
      entryPath: config.ssrEntrypoint != null
          ? p.join(config.root.path, config.ssrEntrypoint!)
          : null,
      target: 'ssr',
      dotDartToolReact: dotReactDir,
      projectRoot: config.root.path,
    );
    // Native SSR compatibility stub — extended once WebApiRuntimeInfo generation lands.
    await _writeNativeSsrCompatibility(
      browserUsage: browserUsage,
      ssrUsage: ssrUsage,
      dotDartToolReact: dotReactDir,
    );

    await _bundleForeignTargets(
      jsEnvironment,
      dartBrowserUsage: browserUsage,
      dartSsrUsage: ssrUsage,
    );

    final serverBinary = server ? await _compileServer() : null;

    await File(
      p.join(output.path, 'manifest.json'),
    ).writeAsString('${config.toJsonString()}\n');
    await _writeBundleManifest(
      hasClient: hasClient,
      hasSsr: hasSsr,
      serverBinary: serverBinary,
    );
    await _writeBundleReport(hasClient: hasClient, hasSsr: hasSsr);
  }

  /// Compiles the server entrypoint to a native binary with `dart compile exe`.
  ///
  /// Returns the binary's path relative to the output directory, or null when
  /// the entrypoint is not configured (or missing) and nothing was built.
  Future<String?> _compileServer() async {
    final server = config.serverEntrypoint;
    if (server == null || !config.file(server).existsSync()) {
      log(
        'Skipping server compile: ${server ?? '(not configured)'} not found.',
      );
      return null;
    }
    final output = config.directory(config.outputDirectory);
    await output.create(recursive: true);
    final name = Platform.isWindows ? 'server.exe' : 'server';
    final relative = p.join('.', name);
    final outputPath = p.join(output.path, relative);
    log('Compiling $server → $outputPath');
    await _runDart([
      'compile',
      'exe',
      '-o',
      outputPath,
      config.pathFor(server),
    ]);
    return relative;
  }

  /// Copies build_runner outputs (`.react.dart`, `.action.g.dart`, …) from
  /// `.dart_tool/build/generated/<package>/lib` into `lib/.generated/` so
  /// `dart compile js` can resolve the package imports without exposing the
  /// generated files beside authored source files. With `--workspace` the
  /// generated tree lives under the workspace root, hence the upward walk.
  Future<void> _syncGeneratedSources() async {
    final generatedRoot = _findGeneratedRoot(config.packageName);
    final files = <String, File>{};
    final sourceGeneratedFiles = <File>[];

    if (generatedRoot != null) {
      final libSource = Directory(p.join(generatedRoot.path, 'lib'));
      if (libSource.existsSync()) {
        await for (final entity in libSource.list(recursive: true)) {
          if (entity is! File || !entity.path.endsWith('.dart')) continue;
          if (p.basename(entity.path).startsWith(r'$')) continue;
          final relative = p.relative(entity.path, from: libSource.path);
          files[relative] = entity;
        }
      }
    }

    // Include legacy source outputs in the hidden boundary as well. Current
    // react_codegen versions write every output to build_runner's cache, but
    // this keeps migration from older generated trees self-cleaning.
    final libRoot = Directory(p.join(config.root.path, 'lib'));
    if (libRoot.existsSync()) {
      await for (final entity in libRoot.list(recursive: true)) {
        if (entity is! File || !entity.path.endsWith('.dart')) continue;
        final relative = p.relative(entity.path, from: libRoot.path);
        if (relative.startsWith('$generatedSourceDirectory/') ||
            !_isGeneratedSource(relative)) {
          continue;
        }
        files[relative] = entity;
        sourceGeneratedFiles.add(entity);
      }
    }

    final libTarget = Directory(
      p.join(config.root.path, 'lib', generatedSourceDirectory),
    );
    if (files.isEmpty) {
      if (libTarget.existsSync()) await libTarget.delete(recursive: true);
      return;
    }
    if (libTarget.existsSync()) {
      await libTarget.delete(recursive: true);
    }
    await libTarget.create(recursive: true);
    var copied = 0;
    for (final entry in files.entries) {
      final relative = entry.key;
      final entity = entry.value;
      final content = await entity.readAsString();
      final relocated = _relocateGeneratedImports(
        content,
        generatedRelativePath: relative,
      );
      final destination = File(p.join(libTarget.path, relative));
      await destination.parent.create(recursive: true);
      await destination.writeAsString(relocated);
      copied++;
    }
    await _runDart(['format', libTarget.path]);
    for (final sourceFile in sourceGeneratedFiles) {
      if (sourceFile.existsSync()) await sourceFile.delete();
    }
    if (copied > 0) {
      log(
        'Synced $copied generated sources into '
        'lib/$generatedSourceDirectory/.',
      );
    }
  }

  String _relocateGeneratedImports(
    String content, {
    required String generatedRelativePath,
  }) {
    final generatedFile = p.join(
      generatedSourceDirectory,
      generatedRelativePath,
    );
    final generatedDirectory = p.dirname(generatedFile);
    final originalDirectory = p.dirname(generatedRelativePath);

    return content.replaceAllMapped(
      RegExp(
        r'''(^\s*(?:import|export|part\s+of)\s+['"])([^'"]+)(['"])''',
        multiLine: true,
      ),
      (match) {
        final prefix = match.group(1)!;
        final uri = match.group(2)!;
        final suffix = match.group(3)!;
        final relocated = _relocateImportUri(
          uri,
          originalDirectory: originalDirectory,
          generatedDirectory: generatedDirectory,
        );
        return '$prefix$relocated$suffix';
      },
    );
  }

  String _relocateImportUri(
    String uri, {
    required String originalDirectory,
    required String generatedDirectory,
  }) {
    if (uri.startsWith('dart:') || uri.startsWith('package:')) {
      if (!uri.startsWith('package:${config.packageName}/')) return uri;
      final packagePath = uri.substring(
        'package:${config.packageName}/'.length,
      );
      if (!_isGeneratedSource(packagePath)) return uri;
      return 'package:${config.packageName}/$generatedSourceDirectory/$packagePath';
    }

    final originalTarget = p.normalize(p.join(originalDirectory, uri));
    if (_isGeneratedSource(originalTarget)) return uri;

    final generatedTarget = p.relative(
      originalTarget,
      from: generatedDirectory,
    );
    return generatedTarget.startsWith('.')
        ? generatedTarget
        : './$generatedTarget';
  }

  bool _isGeneratedSource(String path) {
    final name = p.basename(path);
    return name.endsWith('.react.dart') ||
        name.endsWith('.react.g.dart') ||
        name.endsWith('.action.g.dart') ||
        name.endsWith('.client.g.dart') ||
        name.endsWith('.registry.g.dart') ||
        name == 'react_components.g.dart' ||
        name == 'ssr_registry.g.dart' ||
        name == 'server_actions.g.dart';
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
      final absoluteHref = '/$href';
      source = source.replaceAll('href="$href"', 'href="$absoluteHref"');
      final link = '<link rel="stylesheet" href="$absoluteHref">';
      if (!source.contains('href="$absoluteHref"')) links.add(link);
    }
    if (links.isEmpty) return;
    final insertion = '${links.join('\n')}\n';
    source = source.contains('</head>')
        ? source.replaceFirst('</head>', '$insertion</head>')
        : '$insertion$source';
    await index.writeAsString(source);
  }

  /// Generates `lib/.generated/foreign_components.g.dart` from the project-level
  /// `foreign.components` list. Runs before the Dart entrypoints are compiled
  /// so they may import the generated helpers.
  Future<void> _writeForeignComponents(JsEnvironment? environment) async {
    final wrappers = await _discoverWrappers();
    final hasProjectModules =
        config.foreignModules.isNotEmpty || config.foreignComponents.isNotEmpty;
    if (!hasProjectModules && wrappers.every((w) => w.isEmpty)) return;
    final bindings = config.file(
      p.join('lib', generatedSourceDirectory, 'foreign_components.g.dart'),
    );
    final legacyBindings = config.file('lib/foreign_components.g.dart');
    if (legacyBindings.existsSync()) await legacyBindings.delete();
    if (config.foreignComponents.isEmpty) {
      if (bindings.existsSync()) await bindings.delete();
      return;
    }
    await _writeForeignBindings();
  }

  /// Builds the per-target aggregate entries and bundles them through the
  /// selected JavaScript bundler.
  ///
  /// Runs after the Dart entrypoints are compiled so the aggregate can be
  /// pruned to the foreign surface the compiled `client.js`/`ssr.js` actually
  /// reference per target: generated wrapper shims are rewritten to import and
  /// register only the used components/hooks (letting the bundler tree-shake
  /// the rest of the npm package), and project-level foreign components whose
  /// key never appears are dropped entirely. When a target was not compiled,
  /// its aggregate is emitted unpruned.
  Future<void> _writeNativeSsrCompatibility({
    required dynamic browserUsage,
    required dynamic ssrUsage,
    required Directory dotDartToolReact,
  }) async {
    final out = File(
      p.join(dotDartToolReact.path, 'native_ssr_compatibility.json'),
    );
    final diffOut = File(
      p.join(dotDartToolReact.path, 'browser_ssr_symbol_diff.json'),
    );
    await dotDartToolReact.create(recursive: true);
    // Comprehensive symbol diff — not yet a full native SSR compatibility analysis.
    // The current report compares all runtime-symbol kinds and notes that a true
    // compatibility analysis would need: resolved SSR entry graph + WebApiRuntimeInfo
    // findings + native adapter registry + client-only boundaries + hook support matrix.
    List<String> asList(dynamic usage, String key) {
      if (usage == null) return const [];
      final v = usage is Map ? usage[key] : null;
      if (v is List) return v.map((e) => e.toString()).toList();
      // Fallback for ReactUsageResult objects.
      try {
        final m = (usage as dynamic).toJson() as Map;
        final lv = m[key];
        if (lv is List) return lv.map((e) => e.toString()).toList();
      } catch (_) {}
      return const [];
    }

    final browserComps = asList(browserUsage, 'components');
    final ssrComps = asList(ssrUsage, 'components');
    final browserHooks = asList(browserUsage, 'hooks');
    final ssrHooks = asList(ssrUsage, 'hooks');
    final browserFunctions = asList(browserUsage, 'functions');
    final ssrFunctions = asList(ssrUsage, 'functions');
    final browserValues = asList(browserUsage, 'values');
    final ssrValues = asList(ssrUsage, 'values');

    List<String> diff(List<String> a, List<String> b) =>
        a.where((c) => !b.contains(c)).toList();

    final payload = {
      'summary':
          'browser/ssr symbol diff — WebApiRuntimeInfo emitted, not yet full native SSR compatibility',
      'note':
          'A real compatibility report needs: resolved SSR graph + WebApiRuntimeInfo + adapter registry + client-only boundaries + hook matrix. This file is a symbol diff.',
      'generatedAt': DateTime.now().toIso8601String(),
      'browserComponents': browserComps,
      'ssrComponents': ssrComps,
      'browserHooks': browserHooks,
      'ssrHooks': ssrHooks,
      'browserFunctions': browserFunctions,
      'ssrFunctions': ssrFunctions,
      'browserValues': browserValues,
      'ssrValues': ssrValues,
      'browserOnly': {
        'components': diff(browserComps, ssrComps),
        'hooks': diff(browserHooks, ssrHooks),
        'functions': diff(browserFunctions, ssrFunctions),
        'values': diff(browserValues, ssrValues),
      },
      'ssrOnly': {
        'components': diff(ssrComps, browserComps),
        'hooks': diff(ssrHooks, browserHooks),
        'functions': diff(ssrFunctions, browserFunctions),
        'values': diff(ssrValues, browserValues),
      },
      // Temporary heuristic: compatible only if SSR has no exclusive symbols.
      // Real check would inspect browserApi issues, adapter registry, etc.
      'compatible':
          diff(ssrComps, browserComps).isEmpty &&
          diff(ssrHooks, browserHooks).isEmpty &&
          diff(ssrFunctions, browserFunctions).isEmpty &&
          diff(ssrValues, browserValues).isEmpty,
      'webApiRuntimeInfo':
          'emitted via react_web_generator (SsrMetadataEmitter + FactoryEmitter) on HTML.* factories',
      'issues': [
        if (diff(ssrComps, browserComps).isNotEmpty)
          {
            'kind': 'ssrOnlyComponent',
            'symbols': diff(ssrComps, browserComps),
            'reason':
                'SSR uses components not in browser bundle — may be deliberate server-only, or missing browser entry',
          },
      ],
    };

    // Write both the historical name (for backward compat) and the accurately named diff.
    await out.writeAsString(
      '${const JsonEncoder.withIndent('  ').convert(payload)}\n',
    );
    await diffOut.writeAsString(
      '${const JsonEncoder.withIndent('  ').convert(payload)}\n',
    );
  }

  Future<void> _bundleForeignTargets(
    JsEnvironment? environment, {
    dynamic dartBrowserUsage,
    dynamic dartSsrUsage,
  }) async {
    final wrappers = await _discoverWrappers();
    final hasProjectModules =
        config.foreignModules.isNotEmpty || config.foreignComponents.isNotEmpty;
    if (!hasProjectModules && wrappers.every((w) => w.isEmpty)) return;

    final output = config.directory(config.outputDirectory);
    final foreignDir = Directory(p.join(output.path, 'foreign'));
    await foreignDir.create(recursive: true);

    for (final target in const ['browser', 'ssr']) {
      final dartJs = _compiledDartFor(output, target);

      // Absolute import paths so the bundler resolves each wrapper's public
      // npm specifiers through the managed environment.
      final targetEntries = <String>[];
      final componentRegistrations =
          <({String path, String name, String? export})>[];

      // Project-level foreign modules (react.yaml) apply to both targets.
      // Bare side-effect imports cannot be pruned.
      for (final module in config.foreignModules) {
        targetEntries.add(await _resolveModulePath(module));
      }

      // Project-level foreign components: drop those the compiled Dart output
      // never references on this target.
      // Fail-safe: semantic manifest is authoritative only when complete == true;
      // otherwise union it with the compiled-JS scan so incomplete analysis
      // never silently removes valid registrations.
      final componentKeys = [
        for (final component in config.foreignComponents) component.name,
      ];
      final dartUsage = target == 'browser' ? dartBrowserUsage : dartSsrUsage;
      final jsComponents = dartJs == null
          ? componentKeys.toSet()
          : usedComponentsIn(dartJs, componentKeys).toSet();
      final semanticComponents = dartUsage != null
          ? Set<String>.from(dartUsage.components as List)
          : <String>{};
      final usedComponents = dartUsage == null
          ? jsComponents
          : dartUsage.complete == true
          ? semanticComponents
          : {...semanticComponents, ...jsComponents};
      for (final component in config.foreignComponents) {
        if (!usedComponents.contains(component.name)) continue;
        final path = await _resolveModulePath(component.module);
        componentRegistrations.add((
          path: path,
          name: component.name,
          export: component.exportName,
        ));
        if (!targetEntries.contains(path)) targetEntries.add(path);
      }

      // Wrapper entries per target (shared applies to both). Generated shims
      // are pruned to the used registration surface and aggregator modules
      // (files that only import local modules) are rewritten to import the
      // pruned copies; opaque entries (raw registration modules, prebuilt
      // bundles) are imported as-is.
      final dartUsageForTarget = target == 'browser'
          ? dartBrowserUsage
          : dartSsrUsage;
      for (final wrapper in wrappers) {
        final entry = wrapper.entryFor(target);
        if (entry == null) continue;
        final path = await _resolveWrapperEntry(wrapper.packageName, entry);
        targetEntries.add(
          await _materializeWrapperEntry(
            entryPath: path,
            packageName: wrapper.packageName,
            target: target,
            foreignDir: foreignDir,
            dartJs: dartJs,
            dartUsage: dartUsageForTarget,
          ),
        );
      }

      final entryDir = Directory(p.join(foreignDir.path, target));
      await entryDir.create(recursive: true);
      final entryFile = File(p.join(entryDir.path, 'entry.mjs'));
      if (targetEntries.isEmpty) {
        // Application-level pruning dropped every registration for this
        // target. Still emit an empty bundle so the target bootstraps and
        // bundle_report.json can resolve `foreign/<target>/bundle.mjs`.
        await entryFile.writeAsString('// Generated by react_tool.\n');
        _bundleResults[target] = await _bundleTarget(
          environment: environment,
          target: target,
          entry: entryFile.path,
          outfile: p.join(entryDir.path, 'bundle.mjs'),
        );
        continue;
      }

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
            ..writeln(
              "globalThis.__reactDartRegisterComponent("
              "'${registered.single.name}', _foreignDefault);",
            );
          continue;
        }
        for (var index = 0; index < registered.length; index++) {
          final r = registered[index];
          // Runtime keys may be namespaced (for example `shadcn.Button`),
          // but the imported JavaScript binding must be a valid identifier.
          // Keep the runtime key unchanged and sanitize only this local name.
          final local =
              '_foreign${r.name.replaceAll(RegExp(r'[^A-Za-z0-9_]'), '_')}_$index';
          if (r.export == null || r.export == 'default') {
            buffer
              ..writeln("import $local from ${jsonEncode(path)};")
              ..writeln(
                "globalThis.__reactDartRegisterComponent("
                "'${r.name}', $local);",
              );
          } else {
            final exportPath = r.export!.split('.');
            final exportedName = exportPath.first;
            final componentExpression = exportPath
                .skip(1)
                .fold<String>(local, (value, part) => '$value.$part');
            buffer
              ..writeln(
                "import { $exportedName as $local } "
                "from ${jsonEncode(path)};",
              )
              ..writeln(
                "globalThis.__reactDartRegisterComponent("
                "'${r.name}', $componentExpression);",
              );
          }
        }
      }

      await entryFile.writeAsString(buffer.toString());
      _bundleResults[target] = await _bundleTarget(
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
  }

  /// Recursively materializes a wrapper entry for [target] under
  /// `foreign/<target>/<package>/`, returning the path the aggregate entry
  /// should import.
  ///
  /// Generated shims are pruned to the used components/hooks of the compiled
  /// Dart output; aggregator modules (files whose only content is local
  /// imports) are copied with their imports rewritten to the materialized
  /// copies; any other file is opaque and returned unchanged.
  Future<String> _materializeWrapperEntry({
    required String entryPath,
    required String packageName,
    required String target,
    required Directory foreignDir,
    required String? dartJs,
    dynamic dartUsage,
  }) async {
    final source = await File(entryPath).readAsString();
    final dir = Directory(p.join(foreignDir.path, target, packageName));
    await dir.create(recursive: true);
    final outPath = p.join(dir.path, p.basename(entryPath));

    final shim = parseForeignShim(source);
    if (shim != null) {
      final jsComponents = dartJs == null
          ? shim.componentKeys.toSet()
          : usedComponentsIn(dartJs, shim.componentKeys).toSet();
      final semanticComponents = dartUsage != null
          ? Set<String>.from(
              (dartUsage.components as List).where(shim.componentKeys.contains),
            )
          : <String>{};
      final usedComponents = dartUsage == null
          ? jsComponents
          : (dartUsage.complete == true
                ? semanticComponents
                : ({
                    ...semanticComponents,
                    ...jsComponents,
                  }.where(shim.componentKeys.contains).toSet()));
      final jsHooks = dartJs == null
          ? _allHookKeys(shim)
          : usedHooksIn(dartJs, [
              if (shim.namespace != null) shim.namespace!,
            ]).where(_allHookKeys(shim).contains).toSet();
      final semanticHooks = dartUsage != null
          ? Set<String>.from(
              (dartUsage.hooks as List).where(_allHookKeys(shim).contains),
            )
          : <String>{};
      final usedHooks = dartUsage == null
          ? jsHooks
          : (dartUsage.complete == true
                ? semanticHooks
                : {...semanticHooks, ...jsHooks});
      await File(outPath).writeAsString(
        pruneShim(
          source,
          shim: shim,
          usedComponents: usedComponents,
          usedHooks: usedHooks,
        ),
      );
      return outPath;
    }

    // Aggregator detection: every non-blank, non-comment line is a local
    // import. Anything else makes the file opaque.
    final lines = source.split('\n');
    final localImports = <String>[];
    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty || trimmed.startsWith('//')) continue;
      final match = _localImportRe.firstMatch(trimmed);
      if (match == null) return entryPath;
      localImports.add(match.group(1)!);
    }
    if (localImports.isEmpty) return entryPath;

    final rewritten = StringBuffer();
    for (final line in lines) {
      final match = _localImportRe.firstMatch(line.trim());
      if (match == null) {
        rewritten.writeln(line);
        continue;
      }
      final specifier = match.group(1)!;
      if (!specifier.startsWith('.') || specifier.startsWith('..')) {
        rewritten.writeln(line);
        continue;
      }
      final resolved = p.normalize(p.join(p.dirname(entryPath), specifier));
      final materialized = await _materializeWrapperEntry(
        entryPath: resolved,
        packageName: packageName,
        target: target,
        foreignDir: foreignDir,
        dartJs: dartJs,
        dartUsage: dartUsage,
      );
      var relative = p.relative(materialized, from: dir.path);
      if (!relative.startsWith('.')) relative = './$relative';
      rewritten.writeln("import ${jsonEncode(relative)};");
    }
    await File(outPath).writeAsString(rewritten.toString());
    return outPath;
  }

  /// A local module import (`import './x.mjs';`), as found in aggregator
  /// wrapper entries.
  static final _localImportRe = RegExp(r"^import\s+'([^']+)';?$");

  /// All hook keys a shim can expose: `namespace.useX`, or bare `useX` for the
  /// legacy `__reactDartHooks` bridge.
  Set<String> _allHookKeys(ForeignShim shim) => {
    for (final name in shim.hookNames)
      if (shim.namespace == null) name else '${shim.namespace}.$name',
  };

  /// Bundles one target aggregate through the selected JavaScript bundler
  /// under the target's platform conditions. Failure is fatal — there is no
  /// unbundled fallback.
  Future<BundleResult> _bundleTarget({
    required JsEnvironment? environment,
    required String target,
    required String entry,
    required String outfile,
  }) async {
    final bundler = _bundler;
    if (environment == null || bundler == null) {
      throw const ReactToolException(
        'Foreign modules require a managed JS environment, but none was '
        'provisioned. Run: react js install',
      );
    }

    final result = await bundler.bundle(
      BundleRequest(
        name: 'foreign-$target',
        target: target == 'ssr'
            ? JavaScriptTarget.node
            : JavaScriptTarget.browser,
        entryPoints: [entry],
        outputFile: outfile,
        workingDirectory: config.root.path,
        npmRoot: environment.npmRoot,
        externals: await _mergedExternals(),
        conditions: [release ? 'production' : 'development'],
        minify: release,
        sourceMaps: !release,
      ),
    );
    for (final warning in result.warnings) {
      log('${_bundler?.name ?? 'bundler'} warning ($target): $warning');
    }
    log(
      'Bundled ${result.outputFile} '
      '(${_formatBytes(result.outputBytes)}, '
      '${result.duration.inMilliseconds} ms)',
    );
    return result;
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    final kib = bytes / 1024;
    if (kib < 1024) return '${kib.toStringAsFixed(1)} KiB';
    return '${(kib / 1024).toStringAsFixed(1)} MiB';
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
  Future<JsEnvironment?> _prepareJsEnvironment({
    Map<String, String> additionalDependencies = const {},
  }) async {
    final wrappers = await _discoverWrappers();
    final needsEnvironment =
        config.foreignComponents.isNotEmpty ||
        config.foreignModules.isNotEmpty ||
        config.foreignDependencies.isNotEmpty ||
        additionalDependencies.isNotEmpty ||
        // The SSR bootstrap always imports React and ReactDOM/server, so the
        // worker needs a JS environment even without foreign modules.
        config.ssrEntrypoint != null ||
        wrappers.any((w) => !w.isEmpty);
    if (!needsEnvironment) return null;
    final builder = JsEnvironmentBuilder(
      projectRoot: config.root,
      packageName: config.packageName,
      configEsbuildPath: config.esbuildPath,
      host: config.jsHostMode,
      log: log,
      npmCommand: npmCommand,
      managedReactVersion:
          managedReactVersion ?? ReactVersionPolicy.managedVersion,
      bundlingBackend: config.bundlingBackend,
    );
    final projectDependencies = {
      ...config.foreignDependencies,
      ...additionalDependencies,
    };
    final allWrappers = projectDependencies.isEmpty
        ? wrappers
        : [
            ...wrappers,
            JsWrapperDescriptor(
              packageName: config.packageName,
              // A synthetic shared entry makes the descriptor's dependencies
              // participate in requirement collection without making it a
              // wrapper entry for the foreign bundler.
              entries: {'shared': ''},
              dependencies: projectDependencies,
            ),
          ];
    return builder.ensure(allWrappers, required: needsEnvironment);
  }

  /// Descriptors of every wrapper package in the dependency graph — plus the
  /// project's own descriptor when it declares one, so `react ts bind` run
  /// from inside a wrapper package provisions the JS environment its bind
  /// groups need.
  Future<List<JsWrapperDescriptor>> _discoverWrappers() async {
    final wrappers = <JsWrapperDescriptor>[];

    final ownPubspec = config.file('pubspec.yaml');
    if (ownPubspec.existsSync()) {
      final yaml = loadYaml(ownPubspec.readAsStringSync());
      final own = JsWrapperDescriptor.parse(
        config.packageName,
        yaml is Map ? yaml.cast<String, dynamic>() : {},
      );
      if (own != null) wrappers.add(own);
    }

    for (final (name, rootPath) in await _dependencyPackages()) {
      final pubspecFile = File(p.join(rootPath, 'pubspec.yaml'));
      if (!pubspecFile.existsSync()) continue;
      if (p.normalize(rootPath) == p.normalize(config.root.path)) continue;
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
    final found = await _loadPackageConfig();
    if (found == null) return const [];

    final result = <(String, String)>[];
    for (final package in found.config.packages) {
      if (package.name == config.packageName) continue;
      final rootPath = package.root.toFilePath();
      if (!File(p.join(rootPath, 'pubspec.yaml')).existsSync()) continue;
      result.add((package.name, rootPath));
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
        final type = _foreignDartType(entry.value);
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

    final bindings = config.file(
      p.join('lib', generatedSourceDirectory, 'foreign_components.g.dart'),
    );
    await bindings.parent.create(recursive: true);
    await bindings.writeAsString(buffer.toString());
    await _runDart(['format', bindings.path]);
    log('Generated ${bindings.path}');
  }

  String _dartIdentifier(String value) {
    final words = value
        .split(RegExp(r'[^a-zA-Z0-9]+'))
        .where((word) => word.isNotEmpty)
        .toList();
    if (words.isEmpty) return '_component';
    final first = words.first;
    final result =
        first[0].toLowerCase() +
        first.substring(1) +
        words
            .skip(1)
            .map((word) => word[0].toUpperCase() + word.substring(1))
            .join();
    return RegExp(r'^[0-9]').hasMatch(result) ? '_$result' : result;
  }

  String _foreignDartType(String configuredType) {
    final type = configuredType.trim();
    final nullable = type.endsWith('?');
    final base = nullable ? type.substring(0, type.length - 1).trim() : type;
    if (base == 'Function') {
      return nullable ? 'react.ReactCallback?' : 'react.ReactCallback';
    }
    return type
        .replaceAll('ReactNode', 'react.ReactNode')
        .replaceAll('ReactCallback', 'react.ReactCallback');
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
      final root = await _resolvePackageRoot(match.group(1)!);
      final relative = match.group(2)!;
      final packagePath = relative.startsWith('lib/')
          ? relative
          : p.join('lib', relative);
      return p.join(root, packagePath);
    }
    final moduleFile = config.file(module);
    if (moduleFile.existsSync()) return moduleFile.absolute.path;
    if (_isBareNpmSpecifier(module)) return module;
    throw ReactToolException(
      'Foreign module "$module" not found at ${moduleFile.path}.',
    );
  }

  bool _isBareNpmSpecifier(String module) =>
      !module.startsWith('.') &&
      !p.isAbsolute(module) &&
      !module.startsWith('/') &&
      !module.contains('\\') &&
      p.extension(module).isEmpty;

  /// Resolves a wrapper's entry file (package-relative) to an absolute path.
  Future<String> _resolveWrapperEntry(String packageName, String entry) async {
    final root = await _resolvePackageRoot(packageName);
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
  Future<String> _resolvePackageRoot(String packageName) async {
    final found = await _loadPackageConfig();
    if (found == null) {
      throw ReactToolException(
        'Cannot resolve package "$packageName": missing '
        '.dart_tool/package_config.json. Run dart pub get first.',
      );
    }
    final package = found.config[packageName];
    if (package == null) {
      throw ReactToolException(
        'Package "$packageName" is not a dependency of this project.',
      );
    }
    return package.root.toFilePath();
  }

  /// Loads the workspace package configuration (walking up from the project
  /// root), caching it for the duration of the build. Returns null when no
  /// configuration file exists.
  Future<({PackageConfig config, File file})?> _loadPackageConfig() {
    return _cachedPackageConfig ??= findPackageConfigAndFile(config.root);
  }

  Future<({PackageConfig config, File file})?>? _cachedPackageConfig;

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
      '--suppress-hints',
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

  Future<void> _writeBrowserEntry(JsEnvironment? environment) async {
    final output = config.directory(config.outputDirectory);
    await File(
      p.join(output.path, 'callback_trampoline.mjs'),
    ).writeAsString(_callbackTrampoline);

    final hasForeign = await _hasForeignSurface();

    // The entry absorbs the inline React bootstrap that used to live in
    // index.html: it sets globalThis.React/ReactDOM before importing the
    // trampoline, the foreign bundle, and the Dart client output. The
    // importmap stays in index.html because the browser resolves the bare
    // react specifier, not esbuild.
    //
    // The trampoline/foreign/client are loaded with dynamic imports: static
    // imports are hoisted and evaluated before this module's body runs, which
    // would execute the foreign graph and client.js with globalThis.React
    // still unset. Dynamic imports preserve the old inline-bootstrap ordering
    // (globals first, then registrations, then the Dart app).
    final buffer = StringBuffer()
      ..writeln('// Generated by react_tool.')
      ..writeln("import React from 'react';")
      ..writeln("import ReactDOM from 'react-dom/client';")
      ..writeln()
      ..writeln('globalThis.React = React;')
      ..writeln('globalThis.ReactDOM = ReactDOM;')
      ..writeln()
      ..writeln("await import('./callback_trampoline.mjs');");
    if (hasForeign) {
      buffer.writeln("await import('./foreign/browser/bundle.mjs');");
    }
    buffer.writeln("await import('./client.js');");
    final entryFile = File(p.join(output.path, 'browser.entry.mjs'));
    await entryFile.writeAsString(buffer.toString());
    log('Generated ${p.join(config.outputDirectory, 'browser.entry.mjs')}');

    final index = File(p.join(output.path, 'index.html'));
    if (!index.existsSync()) return;
    var source = await index.readAsString();

    // Document routes may be arbitrarily deep. Keep runtime assets rooted at
    // the application origin so `/state/todos` does not try to load them from
    // `/state/`.
    source = source.replaceAll(
      'src="browser.entry.mjs"',
      'src="/browser.entry.mjs"',
    );

    // Pin the import map to the exact React version the environment resolved
    // so browser and SSR always share one instance.
    if (environment != null) {
      source = source.replaceAllMapped(
        RegExp(r'https://esm\.sh/(react(?:-dom)?)@[0-9.]+'),
        (match) =>
            'https://esm.sh/${match.group(1)}@${environment.reactVersion}',
      );
    }
    if (source.contains('/browser.entry.mjs')) {
      await index.writeAsString(source);
      return;
    }

    // Replace the inline React bootstrap and the per-file module tags with a
    // single entry module (idempotent; also handles fresh templates that only
    // contain the inline bootstrap and the client tag).
    source = source
        .replaceAll(
          RegExp(
            r'<script[^>]*src="/?callback_trampoline\.mjs"[^>]*>\s*</script>',
          ),
          '',
        )
        .replaceAll(
          RegExp(
            r'<script[^>]*src="/?foreign/browser/bundle\.mjs"[^>]*>\s*</script>',
          ),
          '',
        )
        .replaceAll(
          RegExp(r'<script[^>]*src="/?client\.js"[^>]*>\s*</script>'),
          '',
        );
    source = source.replaceAllMapped(
      RegExp(r'<script[^>]*>([\s\S]*?)</script>'),
      (match) =>
          match.group(1)!.contains('globalThis.React') ? '' : match.group(0)!,
    );
    const entryScript =
        '<script type="module" src="/browser.entry.mjs"></script>';
    source = source.contains('</body>')
        ? source.replaceFirst('</body>', '$entryScript\n</body>')
        : '$source\n$entryScript';
    await index.writeAsString(source);
  }

  /// Whether the project declares any foreign components/modules or ships a
  /// wrapper package, i.e. whether foreign aggregate bundles are produced.
  Future<bool> _hasForeignSurface() async {
    final wrappers = await _discoverWrappers();
    return config.foreignComponents.isNotEmpty ||
        config.foreignModules.isNotEmpty ||
        wrappers.any((w) => !w.isEmpty);
  }

  Future<void> _writeSsrBootstrap(JsEnvironment? environment) async {
    final output = config.directory(config.outputDirectory);
    var entry = _ssrEntry;
    if (environment != null) {
      // Import React through the environment's exact versions so the worker
      // shares one instance with the foreign bundle.
      entry = entry
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
            "globalThis.require ??= createRequire('./x.js');",
            "globalThis.require ??= createRequire("
                "${jsonEncode(p.join(environment.npmRoot, 'x.js'))});",
          );
    }
    if (!await _hasForeignSurface()) {
      entry = entry.replaceAll(
        "if (process.env.REACT_FOREIGN_COMPONENTS !== 'false') {\n"
            "  await import('./foreign/ssr/bundle.mjs');\n"
            '}\n',
        '',
      );
    }
    await File(p.join(output.path, 'ssr.entry.mjs')).writeAsString(entry);
    await File(
      p.join(output.path, 'ssr_runtime.mjs'),
    ).writeAsString(_ssrRuntime);
    log(
      'Generated ${p.join(config.outputDirectory, 'ssr.entry.mjs')} and '
      'ssr_runtime.mjs',
    );
  }

  /// Emits a deterministic manifest of every runtime artifact for a target so
  /// servers and tooling can load modules without hardcoding file names.
  Future<void> _writeBundleManifest({
    required bool hasClient,
    required bool hasSsr,
    String? serverBinary,
  }) async {
    final output = config.directory(config.outputDirectory);
    final manifest = <String, Object?>{
      'schema': 1,
      'bundler': _bundler?.name ?? 'none',
      'mode': release ? 'release' : 'development',
    };

    if (hasClient) {
      final dart = File(p.join(output.path, 'client.js'));
      final foreign = File(p.join(output.path, 'foreign/browser/bundle.mjs'));
      manifest['browser'] = <String, Object?>{
        'entry': 'browser.entry.mjs',
        'dart': 'client.js',
        if (foreign.existsSync()) 'foreign': 'foreign/browser/bundle.mjs',
        'bytes': {
          'dart': await dart.length(),
          if (foreign.existsSync()) 'foreign': await foreign.length(),
        },
      };
    }

    if (hasSsr) {
      final dart = File(p.join(output.path, 'ssr.js'));
      final foreign = File(p.join(output.path, 'foreign/ssr/bundle.mjs'));
      manifest['ssr'] = <String, Object?>{
        'entry': 'ssr.entry.mjs',
        'dart': 'ssr.js',
        'runtime': 'ssr_runtime.mjs',
        if (foreign.existsSync()) 'foreign': 'foreign/ssr/bundle.mjs',
        'bytes': {
          'dart': await dart.length(),
          if (foreign.existsSync()) 'foreign': await foreign.length(),
        },
      };
    }

    if (serverBinary != null) {
      manifest['server'] = <String, Object?>{'binary': serverBinary};
    }

    await File(p.join(output.path, 'bundle_manifest.json')).writeAsString(
      '${const JsonEncoder.withIndent('  ').convert(manifest)}\n',
    );
    log('Generated ${p.join(config.outputDirectory, 'bundle_manifest.json')}');
  }

  /// Emits `bundle_report.json`: size and retained-surface metrics per target,
  /// so bundle regressions and wrapper-export retention are measurable across
  /// builds.
  Future<void> _writeBundleReport({
    required bool hasClient,
    required bool hasSsr,
  }) async {
    final output = config.directory(config.outputDirectory);
    final report = <String, Object?>{
      'schema': 1,
      'mode': release ? 'release' : 'development',
    };
    if (hasClient) {
      report['browser'] = await _reportTarget(
        output,
        'browser',
      ).then((r) => r.toJson());
    }
    if (hasSsr) {
      report['ssr'] = await _reportTarget(
        output,
        'ssr',
      ).then((r) => r.toJson());
    }

    await File(
      p.join(output.path, 'bundle_report.json'),
    ).writeAsString('${const JsonEncoder.withIndent('  ').convert(report)}\n');

    final summary = <String>[];
    for (final target in const ['browser', 'ssr']) {
      final json = report[target] as Map<String, Object?>?;
      if (json == null) continue;
      final gzip = _formatBytes((json['gzipBytes'] as num).toInt());
      summary.add(
        '$target: ${json['retainedExports'].toString()}'
        ' (${_formatBytes((json['uncompressedBytes'] as num).toInt())}, '
        '$gzip gzip)',
      );
    }
    log(
      'Bundled sizes: ${summary.join('; ')} '
      '→ ${p.join(config.outputDirectory, 'bundle_report.json')}',
    );
  }

  Future<BundleReportTarget> _reportTarget(
    Directory output,
    String target,
  ) async {
    final bundleFile = File(
      p.join(output.path, 'foreign', target, 'bundle.mjs'),
    );
    final result = _bundleResults[target];
    final dartJs = _compiledDartFor(output, target);
    if (!await bundleFile.exists()) {
      // No foreign components or wrappers for this target, so no aggregate
      // bundle was emitted.
      return BundleReportTarget(
        artifacts: 0,
        uncompressedBytes: 0,
        gzipBytes: 0,
        sourceMapBytes: null,
        externals: await _mergedExternals(),
        retainedExports: const [],
        retainedHookNamespaces: const [],
        usedComponents: const [],
        usedHooks: const [],
      );
    }
    final mapFile = File('${bundleFile.path}.map');
    final text = await bundleFile.readAsString();
    final outputs = result?.outputs ?? const <String>[];
    final retainedExports = _retainedWrapperExports(text);
    final retainedHookNamespaces = _retainedHookNamespaces(text);
    return BundleReportTarget(
      artifacts: outputs.isEmpty ? 1 : outputs.length,
      uncompressedBytes: await bundleFile.length(),
      gzipBytes: gzip.encode(await bundleFile.readAsBytes()).length,
      sourceMapBytes: mapFile.existsSync() ? await mapFile.length() : null,
      externals: await _mergedExternals(),
      retainedExports: retainedExports,
      retainedHookNamespaces: retainedHookNamespaces,
      usedComponents: usedComponentsIn(dartJs ?? '', retainedExports),
      usedHooks: usedHooksIn(dartJs ?? '', retainedHookNamespaces),
    );
  }

  /// The compiled Dart JS output for a target (`client.js` for browser,
  /// `ssr.js` for SSR), or null when the target was not built.
  String? _compiledDartFor(Directory output, String target) {
    final file = File(
      p.join(output.path, target == 'browser' ? 'client.js' : 'ssr.js'),
    );
    if (!file.existsSync()) return null;
    return file.readAsStringSync();
  }

  /// Component registration keys retained in a final bundle: names passed
  /// directly to `__reactDartRegisterComponent(...)` (foreign components) plus
  /// namespaced object keys from generated wrapper shims, e.g.
  /// `'reactRouter.Route': …`. String-literal keys survive minification.
  List<String> _retainedWrapperExports(String bundleText) {
    final names = <String>{};
    for (final match in RegExp(
      r'''__reactDartRegisterComponent\s*\(\s*['"]([^'"]+)['"]''',
    ).allMatches(bundleText)) {
      names.add(match.group(1)!);
    }
    for (final match in RegExp(
      r'''['"]([A-Za-z_$][\w$]*\.[A-Za-z_$][\w$]*)['"]\s*:''',
    ).allMatches(bundleText)) {
      names.add(match.group(1)!);
    }
    return names.toList()..sort();
  }

  /// Hook bridge namespaces retained in a final bundle.
  List<String> _retainedHookNamespaces(String bundleText) {
    final names = <String>{};
    for (final match in RegExp(
      r'__reactDartBindings\.([A-Za-z_$][\w$]*)\s*=',
    ).allMatches(bundleText)) {
      names.add(match.group(1)!);
    }
    if (RegExp(r'__reactDartHooks\s*=').hasMatch(bundleText)) {
      names.add('__reactDartHooks');
    }
    return names.toList()..sort();
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

const _ssrEntry = r'''import React from 'react';
import ReactDOMServer from 'react-dom/server';
import { createRequire } from 'node:module';

globalThis.require ??= createRequire('./x.js');
globalThis.self ??= globalThis;
globalThis.React = React;
globalThis.ReactDOMServer = ReactDOMServer;

await import('./callback_trampoline.mjs');
if (process.env.REACT_FOREIGN_COMPONENTS !== 'false') {
  await import('./foreign/ssr/bundle.mjs');
}
await import('./ssr.js');

await import('./ssr_runtime.mjs');
''';

const _ssrRuntime = r'''import http from 'node:http';
import { Writable } from 'node:stream';

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
      if (request.mode === 'stream') {
        renderStreaming(renderRequest, res);
        return;
      }
      let html;
      try {
        const element = globalThis.__REACT_RENDER__(renderRequest);
        html = globalThis.ReactDOMServer.renderToString(element);
      } catch (error) {
        const fallbackRenderer = globalThis.__REACT_RENDER_FALLBACK__;
        if (!fallbackRenderer) throw error;
        try {
          const fallbackElement = fallbackRenderer({
            ...renderRequest,
            error: String(error?.message ?? error),
          });
          html = globalThis.ReactDOMServer.renderToString(fallbackElement);
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

function renderStreaming(renderRequest, res) {
  let started = false;
  let completed = false;
  let allReady = false;
  let pipeFinished = false;
  const send = event => res.write(JSON.stringify(event) + '\n');
  const finish = () => {
    if (completed || !allReady || !pipeFinished) return;
    completed = true;
    send({type: 'end', props: renderRequest.props});
    res.end();
  };
  const fail = error => {
    if (completed) return;
    completed = true;
    if (!started) {
      res.writeHead(500, {'content-type': 'application/json'});
      res.end(JSON.stringify({error: String(error?.message ?? error)}));
      return;
    }
    send({type: 'error', error: String(error?.message ?? error)});
    res.end();
  };

  try {
    const element = globalThis.__REACT_RENDER__(renderRequest);
    const stream = globalThis.ReactDOMServer.renderToPipeableStream(element, {
      onShellReady() {
        started = true;
        res.writeHead(200, {'content-type': 'application/x-ndjson'});
        send({type: 'start'});
        stream.pipe(new Writable({
          write(chunk, encoding, callback) {
            send({type: 'chunk', html: chunk.toString(encoding)});
            callback();
          },
          final(callback) {
            pipeFinished = true;
            callback();
            finish();
          },
        }));
      },
      onAllReady() {
        allReady = true;
        finish();
      },
      onShellError: fail,
      onError: error => {
        if (started) console.error(error);
      },
    });
  } catch (error) {
    fail(error);
  }
}
''';
