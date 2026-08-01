import 'dart:async';
import 'dart:io';

import 'package:artisanal/args.dart';
import 'package:path/path.dart' as p;
import 'build.dart';
import 'project_config.dart';

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
    argParser.addFlag(
      'release',
      abbr: 'r',
      defaultsTo: false,
      help: 'Use release optimization for the client bundle.',
    );
  }

  @override
  Future<void> run() async {
    final config = ReactProjectConfig.load();
    final release = option('release') as bool? ?? false;
    await ReactBuilder(config: config, release: release, log: line).build();
    info('Build complete.');
  }
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
      );
  }

  @override
  Future<void> run() async {
    final config = ReactProjectConfig.load();
    final release = option('release') as bool? ?? false;
    final noSsr = option('no-ssr') as bool? ?? false;
    final port = _parsePort('port');
    final ssrPort = _parsePort('ssr-port');

    await ReactBuilder(config: config, release: release, log: line).build();

    Process? worker;
    Process? server;
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
      server = await Process.start(
        Platform.resolvedExecutable,
        ['run', serverEntrypoint],
        workingDirectory: config.root.path,
        mode: ProcessStartMode.inheritStdio,
        environment: environment,
      );
      await server.exitCode;
    } finally {
      worker?.kill(ProcessSignal.sigterm);
      server?.kill(ProcessSignal.sigterm);
      await worker?.exitCode;
      await server?.exitCode;
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
