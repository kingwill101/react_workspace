import 'dart:async';
import 'dart:io';

import 'package:artisanal/args.dart';
import 'package:path/path.dart' as p;
import 'build.dart';
import 'bundler/dart_usage.dart';
import 'bundler/bundle_manifest.dart';
import 'project_config.dart';
import 'scaffold.dart';
import 'ts_bindings.dart';

/// Runs the React CLI programmatically.
Future<void> runReactTool(List<String> args) async {
  await ReactCommandRunner().run(args);
}

class ReactCommandRunner extends CommandRunner<void> {
  ReactCommandRunner()
    : super('react', 'Build and run React Dart applications.') {
    addCommand(DoctorCommand());
    addCommand(InitCommand());
    addCommand(GenerateCommand());
    addCommand(BuildCommand());
    addCommand(CleanCommand());
    addCommand(ServeCommand());
    addCommand(JsCommand());
    addCommand(TsCommand());
    addCommand(AnalyzeCommand());
    addCommand(TestCommand());
  }
}

/// `react generate` — runs only Dart code generation and source syncing.
final class GenerateCommand extends Command<void> {
  GenerateCommand() {
    argParser.addFlag(
      'sync-only',
      defaultsTo: false,
      help:
          'Synchronize outputs from an existing workspace build without '
          'running build_runner again.',
    );
  }

  @override
  String get name => 'generate';

  @override
  String get description =>
      'Generate Dart sources into lib/.generated without building bundles.';

  @override
  Future<void> run() async {
    final config = ReactProjectConfig.load();
    final builder = ReactBuilder(config: config, release: false, log: line);
    final syncOnly = option('sync-only') as bool? ?? false;
    if (syncOnly) {
      await builder.syncGeneratedSources();
    } else {
      await builder.generateSources();
    }
    info('Generated sources are ready in lib/.generated/.');
  }
}

final class DoctorCommand extends Command<void> {
  @override
  String get name => 'doctor';

  @override
  String get description => 'Inspect the current React Dart project.';

  @override
  Future<void> run() async {
    final config = ReactProjectConfig.load();
    line('React Dart project: ${config.packageName}');
    line('Root: ${config.root.path}');
    line(
      'Configuration: ${config.hasReactYaml ? 'react.yaml' : 'pubspec.yaml defaults'}',
    );
    _reportFile(config, config.clientEntrypoint, 'client');
    _reportFile(config, config.ssrEntrypoint, 'SSR');
    _reportFile(config, config.serverEntrypoint, 'server');
    for (final stylesheet in config.styleEntrypoints) {
      _reportFile(config, stylesheet, 'style');
    }
    _reportDirectory(config, config.staticDirectory, 'static');
    line('Output: ${config.pathFor(config.outputDirectory)}');

    if (!config.hasBuildRunner) {
      warn(
        'build_runner is not declared; generated components will not rebuild.',
      );
    }
    if (!config.hasNodePackageManifest) {
      warn(
        'package.json is missing; the generated SSR worker expects React packages from Node.',
      );
    }

    // Analysis and testing readiness (new facilities)
    _reportAnalysis(config);
    _reportTesting(config);
  }

  void _reportAnalysis(ReactProjectConfig config) {
    final hasAnalysis = config.file('analysis_options.yaml').existsSync();
    final hasAnalyzerPlugin = config
        .file('pubspec.yaml')
        .readAsStringSync()
        .contains('react_analyzer');
    line(
      '  analysis: ${hasAnalysis ? '✓ analysis_options.yaml' : '✗ missing'} ${hasAnalyzerPlugin ? '+ react_analyzer' : ''}',
    );
    if (!hasAnalysis) {
      info(
        '    Run `dart run react_tool:react analyze` or add analysis_options.yaml for live diagnostics.',
      );
    }
    // Check for react_analysis import usage
    final hasReactAnalysisDep = config
        .file('pubspec.yaml')
        .readAsStringSync()
        .contains('react_analysis');
    if (!hasReactAnalysisDep) {
      info('    Tip: add react_analysis for component/hook/SSR diagnostics.');
    }
  }

  void _reportTesting(ReactProjectConfig config) {
    final hasTestDir = config.directory('test').existsSync();
    final pubspec = config.file('pubspec.yaml').readAsStringSync();
    final hasReactTesting = pubspec.contains('react_testing');
    final hasTestPackage =
        pubspec.contains(' test:') || pubspec.contains('test:');
    line(
      '  testing: ${hasTestDir ? '✓ test/' : '✗ no test/'} ${hasReactTesting ? '+ react_testing' : ''} ${hasTestPackage ? '+ test' : ''}',
    );
    if (!hasTestDir || !hasReactTesting) {
      info(
        '    Run `dart test` — scaffold now includes react_testing examples (see test/app_test.dart).',
      );
    }
  }

  void _reportFile(ReactProjectConfig config, String? relative, String label) {
    final exists = relative != null && config.file(relative).existsSync();
    line('  $label: ${relative ?? '(not configured)'} ${exists ? '✓' : '✗'}');
  }

  void _reportDirectory(
    ReactProjectConfig config,
    String relative,
    String label,
  ) {
    final exists = config.directory(relative).existsSync();
    line('  $label: $relative ${exists ? '✓' : '✗'}');
  }
}

final class BuildCommand extends Command<void> {
  @override
  String get name => 'build';

  @override
  String get description =>
      'Generate code and compile the client and SSR bundles, and optionally '
      'the server binary.';

  BuildCommand() {
    argParser
      ..addFlag(
        'release',
        abbr: 'r',
        defaultsTo: false,
        help: 'Use release optimization for the client bundle.',
      )
      ..addFlag(
        'server',
        defaultsTo: false,
        help:
            'Compile the server entrypoint to a native binary with '
            'dart compile exe.',
      )
      ..addFlag(
        'watch',
        defaultsTo: false,
        help: 'Rebuild when project files change.',
      );
  }

  @override
  Future<void> run() async {
    final config = ReactProjectConfig.load();
    final release = option('release') as bool? ?? false;
    final server = option('server') as bool? ?? false;
    final watch = option('watch') as bool? ?? false;
    final builder = ReactBuilder(
      config: config,
      release: release,
      server: server,
      log: line,
    );
    await builder.build();
    info('Build complete.');
    if (watch) {
      await _watchProject(config, () async {
        try {
          await builder.build();
          info('Build complete.');
        } catch (error) {
          warn('Build failed: $error');
        }
      });
    }
  }
}

/// `react js install` — provisions the managed JS environment (or validates
/// the host one) without a full build, so errors surface early.
final class JsCommand extends Command<void> {
  @override
  String get name => 'js';

  @override
  String get description =>
      'Provision the JS environment for wrapper packages.';

  JsCommand() {
    addSubcommand(_JsInstallCommand());
    addSubcommand(_JsSyncCommand());
  }
}

final class _JsInstallCommand extends Command<void> {
  @override
  String get name => 'install';

  @override
  String get description =>
      'Install exact wrapper versions into .dart_tool/react/js.';

  @override
  Future<void> run() async {
    final config = ReactProjectConfig.load();
    final builder = ReactBuilder(config: config, release: false, log: line);
    await builder.ensureJsEnvironment();
    info('JS environment ready.');
  }
}

final class _JsSyncCommand extends Command<void> {
  @override
  String get name => 'sync';

  @override
  String get description =>
      'Validate that the host JS project satisfies every wrapper.';

  @override
  Future<void> run() async {
    final config = ReactProjectConfig.load();
    if (!config.jsHostMode) {
      warn('Not in host JS mode (react.yaml foreign.host is not set).');
      return;
    }
    final builder = ReactBuilder(config: config, release: false, log: line);
    await builder.ensureJsEnvironment();
    info('Host JS environment satisfies all wrappers.');
  }
}

/// `react ts bind <specifier> <names...>` — generates typed Dart foreign-
/// component helpers from a package's TypeScript declarations, using the
/// native oxc extractor.
final class TsCommand extends Command<void> {
  @override
  String get name => 'ts';

  @override
  String get description =>
      'Generate typed Dart bindings from TypeScript declarations.';

  TsCommand() {
    addSubcommand(_TsBindCommand());
  }
}

final class _TsBindCommand extends Command<void> {
  @override
  String get name => 'bind';

  @override
  String get description =>
      'Extract declarations from an npm package and emit Dart helpers.';

  _TsBindCommand() {
    argParser
      ..addOption(
        'output',
        abbr: 'o',
        help:
            'Where to write the generated file (default: '
            'lib/<specifier>_bindings.g.dart).',
      )
      ..addOption(
        'prefix',
        help:
            'JS registration namespace (default: the specifier, camelized). '
            'Prefixes the `prefix.Name` keys registered by the shim; Dart '
            'helpers always use the bare component name.',
      )
      ..addOption(
        'type-prefix',
        help:
            'Prefix for generated type names (classes, enums, typedefs). '
            'Use when extracting a second module so its types do not collide '
            'with an already-generated file.',
      )
      ..addOption(
        'shim',
        help:
            'Also write a JS shim registering the bound components at this '
            'path (wire it into react.yaml under foreign.modules). When the '
            'extraction includes use* hooks the shim also registers the '
            '__reactDartHooks hook bridge.',
      )
      ..addOption(
        'hooks',
        help:
            'Also write a Dart hooks file for the extracted use* hooks at '
            'this path. Hooks run through the shim bridge during render and '
            'decode into typed values (maps, records, value classes).',
      )
      ..addOption(
        'npm-root',
        help: 'Override the npm root used for type resolution.',
      )
      ..addOption(
        'namespace',
        help:
            'Namespace for hook bridge registration under '
            'globalThis.__reactDartBindings[namespace]. '
            'When set, hooks register under '
            'globalThis.__reactDartBindings.<namespace> instead of '
            'globalThis.__reactDartHooks, preventing collisions '
            'when multiple wrappers are loaded.',
      );
  }

  @override
  String get invocation => 'react ts bind [<specifier> [<name...>]]';

  @override
  Future<void> run() async {
    final rest = argResults!.rest;
    final config = ReactProjectConfig.load();
    final builder = ReactBuilder(config: config, release: false, log: line);

    final npmRoot =
        option('npm-root') as String? ??
        (await builder.ensureJsEnvironment())?.npmRoot ??
        p.join('.dart_tool', 'react', 'js');
    final npmRootDir = Directory(npmRoot);
    if (!npmRootDir.existsSync()) {
      throw ReactToolException(
        'No JS environment at $npmRoot. Run `react js install` first.',
      );
    }

    if (rest.isEmpty) {
      // Declarative mode: regenerate every `js.bind` group from react.yaml.
      if (config.jsBindGroups.isEmpty) {
        usageException(
          'Expected: react ts bind <specifier> <name...>, or declare '
          '`react.js.bind` groups in react.yaml and run `react ts bind` '
          'with no arguments.',
        );
      }
      for (final group in config.jsBindGroups) {
        await _runBindGroup(
          config: config,
          npmRoot: npmRoot,
          specifier: group.specifier,
          names: group.names,
          outputPath: group.output,
          shimPath: group.shim,
          hooksPath: group.hooks,
          namespace: group.namespace,
          prefix: group.prefix,
          typePrefix: group.typePrefix,
          exclude: group.exclude,
        );
      }
      return;
    }

    // Explicit mode: `react ts bind <specifier> [<name...>]`. No names
    // means "discover the exported components and hooks".
    final specifier = rest.first;
    final names = rest.skip(1).toList();
    await _runBindGroup(
      config: config,
      npmRoot: npmRoot,
      specifier: specifier,
      names: names,
      outputPath: option('output') as String?,
      shimPath: option('shim') as String?,
      hooksPath: option('hooks') as String?,
      namespace: option('namespace') as String?,
      prefix: option('prefix') as String?,
      typePrefix: option('type-prefix') as String?,
      exclude: const [],
    );
  }

  /// Runs a single extraction + generation. [names] empty means discovery.
  Future<void> _runBindGroup({
    required ReactProjectConfig config,
    required String npmRoot,
    required String specifier,
    required List<String> names,
    required String? outputPath,
    required String? shimPath,
    required String? hooksPath,
    required String? namespace,
    required String? prefix,
    required String? typePrefix,
    required List<String> exclude,
  }) async {
    // Subpath specifiers (e.g. `react-router-dom/server`) live under the
    // top-level package directory; check that package only.
    final packagePart = specifier.split('/').first;
    final packageDir = Directory(p.join(npmRoot, 'node_modules', packagePart));
    if (!packageDir.existsSync()) {
      throw ReactToolException(
        '$packagePart is not installed in the managed JS environment '
        '($npmRoot). Add a wrapper package that depends on it, or install '
        'it manually, then retry.',
      );
    }

    final discover = names.isEmpty;
    if (discover) {
      info('Discovering exported components and hooks from $specifier…');
    } else {
      info('Extracting $names from $specifier…');
    }
    final extractor = TsBindingExtractor(npmRoot);
    final result = await extractor.extract(
      specifier: specifier,
      names: names,
      all: discover,
    );

    if (exclude.isNotEmpty) {
      result.declarations.removeWhere((d) => exclude.contains(d.name));
    }
    if (discover && result.skipped.isNotEmpty) {
      warn(
        'Filtered out non-component exports from $specifier: '
        '${result.skipped.join(', ')}',
      );
    }

    final nameTail = names.join(' ');
    final effectivePrefix = prefix ?? lowerCamel(specifier);
    final code = generateBindings(
      specifier: specifier,
      declarations: result.declarations,
      commandLine: 'react ts bind $specifier $nameTail'.trimRight(),
      prefix: effectivePrefix,
      entryComment: result.entry,
      typePrefix: typePrefix ?? '',
    );

    final output =
        outputPath ?? p.join('lib', '${lowerCamel(specifier)}_bindings.g.dart');
    final outputFile = config.file(output);
    outputFile.parent.createSync(recursive: true);
    outputFile.writeAsStringSync(code);
    final dartOutputs = <File>[outputFile];

    if (shimPath != null) {
      final shim = generateShim(
        specifier: specifier,
        prefix: effectivePrefix,
        declarations: result.declarations,
        commandLine: 'react ts bind $specifier $nameTail --shim'.trimRight(),
        namespace: namespace ?? '',
      );
      final shimFile = config.file(shimPath);
      shimFile.parent.createSync(recursive: true);
      shimFile.writeAsStringSync(shim);
      info('Wrote shim to ${shimFile.path}');
    }

    if (hooksPath != null) {
      final hooksFile = config.file(hooksPath);
      String? bindingsImport;
      Set<String>? reuseTypeNames;
      final bindingsPath = outputPath;
      if (bindingsPath != null) {
        final bindingsFile = config.file(bindingsPath);
        if (bindingsFile.existsSync()) {
          // The hooks file imports the bindings file and reuses its types
          // (e.g. `RelativeRoutingType`), so both can be exported together.
          final relative = hooksFile.parent.path == bindingsFile.parent.path
              ? p.basename(bindingsFile.path)
              : p.relative(bindingsFile.path, from: hooksFile.parent.path);
          if (relative.endsWith('.dart')) {
            bindingsImport = relative;
            reuseTypeNames = _generatedTopLevelNames(
              bindingsFile.readAsStringSync(),
            );
          }
        }
      }
      final hooks = generateHooks(
        specifier: specifier,
        declarations: result.declarations,
        commandLine: 'react ts bind $specifier $nameTail --hooks'.trimRight(),
        entryComment: result.entry,
        typePrefix: option('type-prefix') as String? ?? '',
        bindingsImport: bindingsImport,
        reuseTypeNames: reuseTypeNames,
        namespace: namespace ?? '',
      );
      hooksFile.parent.createSync(recursive: true);
      hooksFile.writeAsStringSync(hooks);
      dartOutputs.add(hooksFile);
      info(
        'Wrote ${result.declarations.where((d) => d.kind == 'hook').length} '
        'hook(s) to ${hooksFile.path}',
      );
    }

    final formatResult = await Process.run(Platform.resolvedExecutable, [
      'format',
      ...dartOutputs.map((file) => file.path),
    ], workingDirectory: config.root.path);
    if (formatResult.exitCode != 0) {
      throw ReactToolException(
        'Failed to format generated Dart bindings:\n${formatResult.stderr}',
      );
    }

    info(
      'Wrote ${result.declarations.length} binding(s) '
      '(from ${result.files} type files) to ${outputFile.path}',
    );
  }
}

/// Top-level type names declared in a generated Dart file, so a sibling
/// hooks file can reference them instead of redeclaring them.
Set<String> _generatedTopLevelNames(String source) {
  final names = <String>{};
  final pattern = RegExp(
    r'^(?:final\s+)?(?:class|enum|typedef|abstract\s+class|mixin)\s+([A-Za-z_]\w*)',
    multiLine: true,
  );
  for (final match in pattern.allMatches(source)) {
    names.add(match.group(1)!);
  }
  return names;
}

final class AnalyzeCommand extends Command<void> {
  @override
  String get name => 'analyze';

  @override
  String get description =>
      'Run react_analysis validators (components, hooks, SSR, imports) '
      'and report diagnostics.';

  AnalyzeCommand() {
    argParser
      ..addFlag(
        'verbose',
        abbr: 'v',
        defaultsTo: false,
        help: 'Show info-level diagnostics.',
      )
      ..addOption('path', defaultsTo: '.', help: 'Project root to analyze.');
  }

  @override
  Future<void> run() async {
    final verbose = option('verbose') as bool? ?? false;
    final path = option('path') as String? ?? '.';
    final config = ReactProjectConfig.load(Directory(path));
    line('Analyzing ${config.root.path} with react_analysis…');
    // Delegate to dart analyze (react_analyzer rules run via plugin).
    final result = await Process.run('dart', [
      'analyze',
      if (verbose) '--verbose',
      '.',
    ], workingDirectory: config.root.path);
    line(result.stdout.toString());
    if (result.stderr.toString().trim().isNotEmpty) {
      warn(result.stderr.toString());
    }
    // Run resolved DartUsageCollector for per-target manifest preview.
    try {
      final clientPath = config.clientEntrypoint != null
          ? p.join(config.root.path, config.clientEntrypoint!)
          : null;
      final ssrPath = config.ssrEntrypoint != null
          ? p.join(config.root.path, config.ssrEntrypoint!)
          : null;
      if (clientPath != null || ssrPath != null) {
        line('Usage preview (resolved Dart, fail-safe until complete):');
        if (clientPath != null && File(clientPath).existsSync()) {
          final collector = DartUsageCollector();
          final res = await collector.collectEntrypointResolved(
            clientPath,
            projectRoot: config.root.path,
          );
          line(
            '  client: ${config.pathFor(config.clientEntrypoint!)} → components: ${res.components} hooks: ${res.hooks} complete: ${res.complete} resolved: ${res.resolvedLibraries} unresolved: ${res.unresolvedLibraries}',
          );
        }
        if (ssrPath != null && File(ssrPath).existsSync()) {
          final collector = DartUsageCollector();
          final res = await collector.collectEntrypointResolved(
            ssrPath,
            projectRoot: config.root.path,
          );
          line(
            '  ssr: ${config.pathFor(config.ssrEntrypoint!)} → components: ${res.components} hooks: ${res.hooks} complete: ${res.complete}',
          );
        }
      }
    } catch (e) {
      warn('Usage preview failed: $e');
    }
    if (result.exitCode != 0) {
      throw ReactToolException(
        'Analysis found issues (exit ${result.exitCode}).',
      );
    }
    info('Analysis passed — no react_analysis diagnostics.');
  }
}

final class TestCommand extends Command<void> {
  @override
  String get name => 'test';

  @override
  String get description =>
      'Run dart test with react_testing harnesses (supports --coverage).';

  TestCommand() {
    argParser
      ..addFlag(
        'coverage',
        defaultsTo: false,
        help: 'Collect coverage and generate lcov.info.',
      )
      ..addOption(
        'path',
        defaultsTo: 'test',
        help: 'Test path to run (default: test).',
      );
  }

  @override
  Future<void> run() async {
    final coverage = option('coverage') as bool? ?? false;
    final path = option('path') as String? ?? 'test';
    final config = ReactProjectConfig.load();
    final args = <String>['test', path];
    if (coverage) {
      args.addAll(['--coverage', 'coverage']);
      line('Running tests with coverage…');
    } else {
      line('Running tests…');
    }
    final result = await Process.run(
      'dart',
      args,
      workingDirectory: config.root.path,
    );
    line(result.stdout.toString());
    if (result.stderr.toString().trim().isNotEmpty) {
      warn(result.stderr.toString());
    }
    if (result.exitCode != 0) {
      throw ReactToolException('Tests failed (exit ${result.exitCode}).');
    }
    info('All tests passed.');
    if (coverage) {
      line('Coverage: coverage/lcov.info');
    }
    // Hint about harnesses
    if (!config.file('test/app_test.dart').existsSync() &&
        !config.file('test/component_test.dart').existsSync()) {
      info(
        'Tip: scaffold includes test/app_test.dart using react_testing — see react_testing README.',
      );
    }
  }
}

final class ServeCommand extends Command<void> {
  @override
  String get name => 'serve';

  @override
  String get description =>
      'Build the project and run the Dart server (and SSR worker if configured).';

  ServeCommand() {
    argParser
      ..addOption(
        'port',
        defaultsTo: '8080',
        help: 'Port passed to the Dart application server.',
      )
      ..addOption(
        'ssr-port',
        defaultsTo: '3001',
        help: 'Port used by the generated SSR worker.',
      )
      ..addFlag(
        'release',
        abbr: 'r',
        defaultsTo: false,
        help: 'Use release optimization for the client bundle.',
      )
      ..addFlag(
        'no-ssr',
        defaultsTo: false,
        help: 'Run only the Dart server without starting the SSR worker.',
      )
      ..addFlag(
        'watch',
        defaultsTo: false,
        help: 'Rebuild and restart the server when project files change.',
      );
  }

  @override
  Future<void> run() async {
    final config = ReactProjectConfig.load();
    final release = option('release') as bool? ?? false;
    final noSsr = option('no-ssr') as bool? ?? false;
    final watch = option('watch') as bool? ?? false;
    final port = _parsePort('port');
    final ssrPort = _parsePort('ssr-port');
    final builder = ReactBuilder(config: config, release: release, log: line);

    await builder.build();

    if (!watch) {
      final processes = await _startProcesses(config, noSsr, port, ssrPort);
      try {
        await processes.server.exitCode;
      } finally {
        await _stopProcess(processes.worker);
        await _stopProcess(processes.server);
      }
      return;
    }

    var processes = await _startProcesses(config, noSsr, port, ssrPort);
    try {
      await _watchProject(config, () async {
        // Keep the current server available if the rebuild fails.
        try {
          await builder.build();
        } catch (error) {
          warn('Build failed; keeping the current server: $error');
          return;
        }

        await _stopProcess(processes.worker);
        await _stopProcess(processes.server);
        processes = await _startProcesses(config, noSsr, port, ssrPort);
        info('Development server restarted.');
      });
    } finally {
      await _stopProcess(processes.worker);
      await _stopProcess(processes.server);
    }
  }

  Future<({Process? worker, Process server})> _startProcesses(
    ReactProjectConfig config,
    bool noSsr,
    int port,
    int ssrPort,
  ) async {
    Process? worker;
    try {
      final manifest = BundleManifest.load(
        config.directory(config.outputDirectory),
      );
      final workerFile = config.file(
        '${config.outputDirectory}/${manifest.ssrEntry ?? 'ssr.entry.mjs'}',
      );
      if (!noSsr && workerFile.existsSync()) {
        worker = await Process.start(
          'node',
          [workerFile.path],
          workingDirectory: config.root.path,
          mode: ProcessStartMode.inheritStdio,
          environment: {...Platform.environment, 'REACT_SSR_PORT': '$ssrPort'},
        );
        await _waitForPort(ssrPort);
      }

      final serverEntrypoint = config.serverEntrypoint;
      if (serverEntrypoint != null &&
          config.file(serverEntrypoint).existsSync()) {
        final environment = <String, String>{
          ...Platform.environment,
          'PORT': '$port',
          if (worker != null) 'REACT_SSR_URL': 'http://127.0.0.1:$ssrPort/',
        };
        final server = await Process.start(
          Platform.resolvedExecutable,
          ['run', serverEntrypoint],
          workingDirectory: config.root.path,
          mode: ProcessStartMode.inheritStdio,
          environment: environment,
        );
        return (worker: worker, server: server);
      }

      info(
        'No server entrypoint found — starting a static file server '
        'for the client build.',
      );
      final staticServer = await _startStaticServer(config, port);
      return (worker: worker, server: staticServer);
    } catch (_) {
      await _stopProcess(worker);
      rethrow;
    }
  }

  static const _staticServerScript = '''
import "dart:io";

void main() async {
  final port = int.tryParse(Platform.environment["PORT"] ?? "") ?? 8080;
  var root = Directory("build/react");
  if (!root.existsSync()) {
    final web = Directory("web");
    if (web.existsSync()) {
      root = web;
    }
  }
  final server = await HttpServer.bind("0.0.0.0", port);
  print("Static server running on http://localhost:\$port");
  await for (final request in server) {
    final filePath = request.uri.path;
    final file = File("\${root.path}/\$filePath");
    if (await file.exists()) {
      final bytes = await file.readAsBytes();
      final ext = filePath.split(".").last.toLowerCase();
      request.response.headers.contentType = _contentType(ext);
      request.response.add(bytes);
    } else {
      final index = File("\${root.path}/index.html");
      if (await index.exists()) {
        final bytes = await index.readAsBytes();
        request.response.headers.contentType = ContentType.html;
        request.response.add(bytes);
      } else {
        request.response.statusCode = 404;
      }
    }
    request.response.close();
  }
}

ContentType _contentType(String ext) {
  switch (ext) {
    case "html":
      return ContentType.html;
    case "js":
      return ContentType("application", "javascript");
    case "mjs":
      return ContentType("application", "javascript");
    case "css":
      return ContentType("text", "css");
    case "json":
      return ContentType.json;
    case "png":
      return ContentType("image", "png");
    case "jpg":
    case "jpeg":
      return ContentType("image", "jpeg");
    case "gif":
      return ContentType("image", "gif");
    case "svg":
      return ContentType("image", "svg+xml");
    case "wasm":
      return ContentType("application", "wasm");
    case "woff":
      return ContentType("font", "woff");
    case "woff2":
      return ContentType("font", "woff2");
    case "ttf":
      return ContentType("font", "ttf");
    case "ico":
      return ContentType("image", "x-icon");
    case "map":
      return ContentType("application", "json");
    default:
      return ContentType.binary;
  }
}
''';

  static Future<Process> _startStaticServer(
    ReactProjectConfig config,
    int port,
  ) async {
    final script = File(
      p.join(config.root.path, '.dart_tool', 'react', 'static_server.dart'),
    );
    script.parent.createSync(recursive: true);
    script.writeAsStringSync(_staticServerScript);
    return Process.start(
      Platform.resolvedExecutable,
      [script.path],
      workingDirectory: config.root.path,
      mode: ProcessStartMode.inheritStdio,
      environment: {...Platform.environment, 'PORT': '$port'},
    );
  }

  int _parsePort(String name) {
    final value = int.tryParse(option(name) as String? ?? '');
    if (value == null || value < 1 || value > 65535) {
      usageException('Invalid --$name port.');
    }
    return value;
  }
}

Future<void> _stopProcess(Process? process) async {
  if (process == null) return;
  process.kill(ProcessSignal.sigterm);
  try {
    await process.exitCode.timeout(const Duration(seconds: 5));
  } on TimeoutException {
    process.kill(ProcessSignal.sigkill);
    await process.exitCode;
  }
}

Future<void> _watchProject(
  ReactProjectConfig config,
  Future<void> Function() onChange,
) async {
  // Poll instead of relying only on Directory.watch. This also works on
  // mounted/network filesystems where native file notifications are absent.
  var previous = await _snapshotProject(config);
  var scanning = false;
  final changes = StreamController<void>();
  final poll = Timer.periodic(const Duration(milliseconds: 500), (_) async {
    if (scanning || changes.isClosed) return;
    scanning = true;
    try {
      final current = await _snapshotProject(config);
      if (!_sameSnapshot(previous, current)) {
        previous = current;
        changes.add(null);
      }
    } finally {
      scanning = false;
    }
  });
  final signal = ProcessSignal.sigint.watch().listen((_) {
    changes.close();
  });

  try {
    await for (final _ in changes.stream) {
      await onChange();
    }
  } finally {
    poll.cancel();
    await signal.cancel();
    await changes.close();
  }
}

Future<Map<String, int>> _snapshotProject(ReactProjectConfig config) async {
  final files = <String, int>{};

  Future<void> scan(Directory directory) async {
    await for (final entity in directory.list(followLinks: false)) {
      if (!_isWatchable(config, entity.path)) continue;
      if (entity is Directory) {
        await scan(entity);
      } else if (entity is File) {
        final stat = await entity.stat();
        files[entity.path] = stat.modified.microsecondsSinceEpoch ^ stat.size;
      }
    }
  }

  await scan(config.root);
  return files;
}

bool _sameSnapshot(Map<String, int> previous, Map<String, int> current) {
  if (previous.length != current.length) return false;
  for (final entry in previous.entries) {
    if (current[entry.key] != entry.value) return false;
  }
  return true;
}

bool _isWatchable(ReactProjectConfig config, String path) {
  final relative = p.relative(p.normalize(path), from: config.root.path);
  if (relative == '.') return false;
  final segments = p.split(relative);
  if (segments.isEmpty ||
      segments.first == '.git' ||
      segments.first == 'build') {
    return false;
  }
  if (segments.first == '.dart_tool') return false;

  final name = p.basename(relative);
  if (name.endsWith('.g.dart') ||
      name.endsWith('.react.dart') ||
      name.endsWith('.module.dart')) {
    return false;
  }
  return true;
}

Future<void> _waitForPort(int port) async {
  for (var attempt = 0; attempt < 100; attempt++) {
    try {
      final socket = await Socket.connect('127.0.0.1', port);
      await socket.close();
      return;
    } on SocketException {
      await Future<void>.delayed(const Duration(milliseconds: 100));
    }
  }
  throw ReactToolException('Timed out waiting for port $port.');
}

final class CleanCommand extends Command<void> {
  @override
  String get name => 'clean';

  @override
  String get description => 'Remove generated React build output.';

  @override
  Future<void> run() async {
    final config = ReactProjectConfig.load();
    final builder = ReactBuilder(config: config, release: false, log: line);
    final output = config.directory(config.outputDirectory);
    var removed = await builder.cleanGeneratedSources();
    if (output.existsSync()) {
      await output.delete(recursive: true);
      info('Removed ${output.path}');
      removed = true;
    }
    for (final stylesheet in config.styleEntrypoints) {
      if (!stylesheet.contains('.module.')) continue;
      final bindings = File(
        p.setExtension(config.pathFor(stylesheet), '.dart'),
      );
      if (bindings.existsSync()) {
        await bindings.delete();
        info('Removed ${bindings.path}');
        removed = true;
      }
    }
    if (config.foreignComponents.isNotEmpty) {
      final bindings = config.file('lib/foreign_components.g.dart');
      if (bindings.existsSync()) {
        await bindings.delete();
        info('Removed ${bindings.path}');
        removed = true;
      }
    }
    if (!removed) line('Nothing to clean.');
  }
}
