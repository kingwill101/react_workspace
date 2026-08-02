import 'dart:async';
import 'dart:io';

import 'package:artisanal/args.dart';
import 'package:path/path.dart' as p;
import 'build.dart';
import 'project_config.dart';
import 'ts_bindings.dart';

/// Runs the React CLI programmatically.
Future<void> runReactTool(List<String> args) async {
  await ReactCommandRunner().run(args);
}

class ReactCommandRunner extends CommandRunner<void> {
  ReactCommandRunner()
    : super('react', 'Build and run React Dart applications.') {
    addCommand(DoctorCommand());
    addCommand(BuildCommand());
    addCommand(CleanCommand());
    addCommand(ServeCommand());
    addCommand(JsCommand());
    addCommand(TsCommand());
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
      'Generate code and compile the client and SSR bundles.';

  BuildCommand() {
    argParser
      ..addFlag(
        'release',
        abbr: 'r',
        defaultsTo: false,
        help: 'Use release optimization for the client bundle.',
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
    final watch = option('watch') as bool? ?? false;
    final builder = ReactBuilder(config: config, release: release, log: line);
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
        help: 'Where to write the generated file (default: '
            'lib/<specifier>_bindings.g.dart).',
      )
      ..addOption(
        'prefix',
        help: 'JS registration namespace (default: the specifier, camelized). '
            'Prefixes the `prefix.Name` keys registered by the shim; Dart '
            'helpers always use the bare component name.',
      )
      ..addOption(
        'type-prefix',
        help: 'Prefix for generated type names (classes, enums, typedefs). '
            'Use when extracting a second module so its types do not collide '
            'with an already-generated file.',
      )
      ..addOption(
        'shim',
        help: 'Also write a JS shim registering the bound components at this '
            'path (wire it into react.yaml under foreign.modules). When the '
            'extraction includes use* hooks the shim also registers the '
            '__reactDartHooks hook bridge.',
      )
      ..addOption(
        'hooks',
        help: 'Also write a Dart hooks file for the extracted use* hooks at '
            'this path. Hooks run through the shim bridge during render and '
            'decode into typed values (maps, records, value classes).',
      )
      ..addOption(
        'npm-root',
        help: 'Override the npm root used for type resolution.',
      );
  }

  @override
  String get invocation => 'react ts bind <specifier> <name...>';

  @override
  Future<void> run() async {
    final rest = argResults!.rest;
    if (rest.length < 2) {
      usageException('Expected: react ts bind <specifier> <name...>');
    }
    final specifier = rest.first;
    final names = rest.skip(1).toList();

    final config = ReactProjectConfig.load();
    final builder = ReactBuilder(config: config, release: false, log: line);

    final npmRoot = option('npm-root') as String? ??
        (await builder.ensureJsEnvironment())?.npmRoot ??
        p.join('.dart_tool', 'react', 'js');
    final npmRootDir = Directory(npmRoot);
    if (!npmRootDir.existsSync()) {
      throw ReactToolException(
        'No JS environment at $npmRoot. Run `react js install` first.',
      );
    }
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

    info('Extracting $names from $specifier…');
    final extractor = TsBindingExtractor(npmRoot);
    final result = await extractor.extract(
      specifier: specifier,
      names: names,
    );

    final prefix = option('prefix') as String? ?? lowerCamel(specifier);
    final code = generateBindings(
      specifier: specifier,
      declarations: result.declarations,
      commandLine: 'react ts bind $specifier ${names.join(' ')}',
      prefix: prefix,
      entryComment: result.entry,
      typePrefix: option('type-prefix') as String? ?? '',
    );

    final output = option('output') as String? ??
        p.join('lib', '${lowerCamel(specifier)}_bindings.g.dart');
    final outputFile = config.file(output);
    outputFile.parent.createSync(recursive: true);
    outputFile.writeAsStringSync(code);

    final shimPath = option('shim') as String?;
    if (shimPath != null) {
      final shim = generateShim(
        specifier: specifier,
        prefix: prefix,
        declarations: result.declarations,
        commandLine: 'react ts bind $specifier ${names.join(' ')} --shim',
      );
      final shimFile = config.file(shimPath);
      shimFile.parent.createSync(recursive: true);
      shimFile.writeAsStringSync(shim);
      info('Wrote shim to ${shimFile.path}');
    }

    final hooksPath = option('hooks') as String?;
    if (hooksPath != null) {
      final hooksFile = config.file(hooksPath);
      String? bindingsImport;
      Set<String>? reuseTypeNames;
      final bindingsPath = option('output') as String?;
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
            reuseTypeNames = _generatedTopLevelNames(bindingsFile.readAsStringSync());
          }
        }
      }
      final hooks = generateHooks(
        specifier: specifier,
        declarations: result.declarations,
        commandLine: 'react ts bind $specifier ${names.join(' ')} --hooks',
        entryComment: result.entry,
        typePrefix: option('type-prefix') as String? ?? '',
        bindingsImport: bindingsImport,
        reuseTypeNames: reuseTypeNames,
      );
      hooksFile.parent.createSync(recursive: true);
      hooksFile.writeAsStringSync(hooks);
      info('Wrote ${result.declarations.where((d) => d.kind == 'hook').length} hook(s) to ${hooksFile.path}');
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

final class ServeCommand extends Command<void> {
  @override
  String get name => 'serve';

  @override
  String get description =>
      'Build the project and run the standardized Dart server and SSR worker.';

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
      final workerFile = config.file(
        '${config.outputDirectory}/ssr_worker.mjs',
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
      if (serverEntrypoint == null ||
          !config.file(serverEntrypoint).existsSync()) {
        throw const ReactToolException(
          'No server entrypoint found. Expected bin/server.dart or configure '
          'server.entrypoint in react.yaml.',
        );
      }

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
    } catch (_) {
      await _stopProcess(worker);
      rethrow;
    }
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
    final output = config.directory(config.outputDirectory);
    var removed = false;
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
