import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

import 'project_config.dart';
import 'project_setup.dart';

/// One actionable project diagnostic, also suitable for editor consumption.
final class DoctorFinding {
  const DoctorFinding(this.id, this.status, this.message, [this.fix]);
  final String id;
  final String status;
  final String message;
  final String? fix;

  Map<String, Object?> toJson() => {
    'id': id,
    'status': status,
    'message': message,
    'fix': fix,
  };
}

/// Checks the current project without installing tools or modifying files.
Future<List<DoctorFinding>> inspectReactProject(
  ReactProjectConfig? config, {
  Directory? root,
  Future<ProcessResult> Function(String, List<String>)? probe,
}) async {
  final findings = <DoctorFinding>[];
  Map readConfiguration(File file, {bool optional = false}) {
    if (optional && !file.existsSync()) return const {};
    try {
      final value = loadYaml(file.readAsStringSync());
      if (value is Map) return value;
      if (optional && value == null) return const {};
      throw const FormatException('Expected a YAML mapping.');
    } catch (error) {
      findings.add(
        DoctorFinding(
          'configuration:${file.path}',
          'error',
          'Cannot read ${file.path}: $error',
          'Correct the YAML mapping in ${file.path}.',
        ),
      );
      return const {};
    }
  }

  if (config == null) {
    final directory = root ?? Directory.current;
    try {
      config = ReactProjectConfig.load(directory);
    } on ReactToolException catch (error) {
      findings.add(
        DoctorFinding(
          'configuration',
          'error',
          '$error',
          'Correct pubspec.yaml or react.yaml and run doctor again.',
        ),
      );
      // Continue independent checks without pretending invalid settings loaded.
      config = ReactProjectConfig(
        root: directory,
        packageName: '',
        clientEntrypoint: null,
        ssrEntrypoint: null,
        serverEntrypoint: null,
        staticDirectory: 'web',
        outputDirectory: 'build/react',
        styleEntrypoints: const [],
        styleOutput: 'styles.css',
        foreignComponents: const [],
      );
    }
  }
  var owner = config.root;
  try {
    owner = analysisRoot(config.root);
  } on ReactToolException catch (error) {
    findings.add(
      DoctorFinding(
        'workspace',
        'error',
        '$error',
        'Correct the package or workspace pubspec.yaml.',
      ),
    );
  }
  final packageFile = File(
    p.join(owner.path, '.dart_tool/package_config.json'),
  );
  final resolved = <String, String>{};
  if (!packageFile.existsSync()) {
    findings.add(
      const DoctorFinding(
        'packages',
        'error',
        'Dependencies have not been resolved.',
        'Run dart pub get.',
      ),
    );
  } else {
    try {
      final document = jsonDecode(packageFile.readAsStringSync()) as Map;
      for (final package in document['packages'] as List) {
        resolved[package['name'] as String] = packageFile.uri
            .resolve(package['rootUri'] as String)
            .toFilePath();
      }
      findings.add(
        DoctorFinding(
          'packages',
          'ok',
          'Resolved ${resolved.length} packages using ${packageFile.path}.',
        ),
      );
    } catch (error) {
      findings.add(
        DoctorFinding(
          'packages',
          'error',
          'Invalid package configuration: $error',
          'Run dart pub get.',
        ),
      );
    }
  }
  for (final name in [
    'react_core',
    'react_tool',
    'react_codegen',
    'build_runner',
  ]) {
    final location = resolved[name];
    final exists =
        location != null && File(p.join(location, 'pubspec.yaml')).existsSync();
    findings.add(
      DoctorFinding(
        'package:$name',
        exists ? 'ok' : 'error',
        location == null
            ? '$name is not resolved.'
            : exists
            ? '$name: $location'
            : '$name resolves to a missing package at $location.',
        location == null
            ? 'Declare $name in pubspec.yaml and run dart pub get.'
            : exists
            ? null
            : 'Restore the package path or run dart pub get to repair resolution.',
      ),
    );
  }
  final coreRoot = resolved['react_core'];
  if (coreRoot != null) {
    final familyRoot = p.dirname(p.normalize(coreRoot));
    // Local workspace packages conventionally share a packages/ directory.
    if (File(p.join(familyRoot, 'react_tool/pubspec.yaml')).existsSync()) {
      for (final name in ['react_tool', 'react_codegen', 'react_analysis']) {
        final actual = resolved[name];
        final expected = p.join(familyRoot, name);
        if (actual != null && !p.equals(p.normalize(actual), expected)) {
          findings.add(
            DoctorFinding(
              'mixed-source:$name',
              'warning',
              'Local react_core is mixed with $name from $actual.',
              'Resolve $name from $expected using the workspace or dependency_overrides.',
            ),
          );
        }
      }
    }
  }
  var entries = 0;
  final pubspec = readConfiguration(config.file('pubspec.yaml'));
  final settingsValue = config.file('react.yaml').existsSync()
      ? readConfiguration(config.file('react.yaml'), optional: true)
      : pubspec['react'];
  final settings = settingsValue is Map ? settingsValue : const {};
  for (final entry in {
    'client': config.clientEntrypoint,
    'ssr': config.ssrEntrypoint,
    'server': config.serverEntrypoint,
  }.entries) {
    final exists =
        entry.value != null && config.file(entry.value!).existsSync();
    final section = settings[entry.key];
    final explicit =
        (section is Map && section['entrypoint'] is String) ||
        settings['${entry.key}Entrypoint'] is String;
    if (exists) entries++;
    findings.add(
      DoctorFinding(
        'entry:${entry.key}',
        exists
            ? 'ok'
            : explicit
            ? 'error'
            : 'optional',
        exists
            ? '${entry.key}: ${entry.value}'
            : explicit
            ? '${entry.key}: configured entrypoint ${entry.value} is missing.'
            : '${entry.key}: not present (optional target).',
        !exists && explicit
            ? 'Create ${entry.value} or correct its entrypoint in the React configuration.'
            : null,
      ),
    );
  }
  if (entries == 0) {
    findings.add(
      const DoctorFinding(
        'entrypoints',
        'error',
        'No application entrypoint exists.',
        'Configure an existing client, SSR, or server entrypoint in react.yaml.',
      ),
    );
  }
  final options = File(p.join(owner.path, 'analysis_options.yaml'));
  final yaml = readConfiguration(options, optional: true);
  final plugins = yaml['plugins'];
  final memberOptions = config.file('analysis_options.yaml');
  final inheritsRoot =
      p.equals(owner.absolute.path, config.root.absolute.path) ||
      !memberOptions.existsSync() ||
      _includesOptions(
        memberOptions,
        options,
        resolved,
        <String>{},
        (file) => readConfiguration(file, optional: true),
      );
  final enabled =
      plugins is Map && plugins.containsKey('react_analyzer') && inheritsRoot;
  final plugin = enabled ? plugins['react_analyzer'] : null;
  final pluginPath = plugin is Map ? plugin['path'] : null;
  final missingPlugin =
      pluginPath is String &&
      !File(p.join(owner.path, pluginPath, 'pubspec.yaml')).existsSync();
  findings.add(
    DoctorFinding(
      'analyzer',
      missingPlugin
          ? 'error'
          : enabled
          ? 'ok'
          : 'warning',
      missingPlugin
          ? 'React analyzer local package is missing: $pluginPath.'
          : enabled
          ? 'React analyzer configured at ${options.path}.'
          : !inheritsRoot
          ? '${memberOptions.path} does not inherit the workspace analyzer configuration.'
          : 'React analyzer is not configured at ${owner.path}.',
      missingPlugin
          ? 'Correct plugins.react_analyzer.path in ${options.path}.'
          : enabled
          ? null
          : 'Run dart run react_tool:react setup (or setup --packages <local-packages>).',
    ),
  );
  if (pluginPath is String && !missingPlugin) {
    final overrides = plugins is Map ? plugins['dependency_overrides'] : null;
    final engine = overrides is Map ? overrides['react_analysis'] : null;
    final enginePath = engine is Map ? engine['path'] : null;
    final exists =
        enginePath is String &&
        File(p.join(owner.path, enginePath, 'pubspec.yaml')).existsSync();
    findings.add(
      DoctorFinding(
        'analyzer:engine',
        exists
            ? 'ok'
            : enginePath is String
            ? 'error'
            : 'warning',
        exists
            ? 'Local analyzer engine configured at $enginePath.'
            : enginePath is String
            ? 'Local analyzer engine is missing: $enginePath.'
            : 'Local analyzer plugin has no local react_analysis override; app overrides do not affect plugin resolution.',
        exists
            ? null
            : 'Set plugins.dependency_overrides.react_analysis.path in ${options.path} to the local engine package.',
      ),
    );
  }
  final generated = config.directory('lib/.generated');
  DateTime? newestOutput;
  if (generated.existsSync()) {
    await for (final file in generated.list(
      recursive: true,
      followLinks: false,
    )) {
      if (file is! File || !file.path.endsWith('.dart')) continue;
      final modified = (await file.stat()).modified;
      if (newestOutput == null || modified.isAfter(newestOutput)) {
        newestOutput = modified;
      }
    }
  }
  var stale = false;
  for (final directory in ['lib', 'web', 'bin']) {
    final source = config.directory(directory);
    if (!source.existsSync()) continue;
    await for (final file in source.list(recursive: true, followLinks: false)) {
      if (file is! File ||
          !file.path.endsWith('.dart') ||
          p.isWithin(generated.path, file.path)) {
        continue;
      }
      if (newestOutput != null &&
          (await file.stat()).modified.isAfter(newestOutput)) {
        stale = true;
      }
    }
  }
  findings.add(
    DoctorFinding(
      'codegen',
      newestOutput != null && !stale ? 'ok' : 'warning',
      newestOutput == null
          ? 'Generated sources have not been prepared.'
          : stale
          ? 'Authored Dart files are newer than generated sources.'
          : 'Generated sources exist with no newer authored Dart files. Run generate to verify all build inputs.',
      newestOutput != null && !stale
          ? null
          : 'Run dart run react_tool:react generate.',
    ),
  );
  final run =
      probe ??
      (String executable, List<String> args) => Process.run(
        executable,
        args,
        runInShell: Platform.isWindows && executable == 'npm',
      );
  for (final tool in [Platform.resolvedExecutable, 'node', 'npm']) {
    final name = tool == Platform.resolvedExecutable ? 'dart' : tool;
    try {
      final result = await run(tool, [
        '--version',
      ]).timeout(const Duration(seconds: 10));
      findings.add(
        DoctorFinding(
          'tool:$name',
          result.exitCode == 0 ? 'ok' : 'error',
          '$name: ${result.stdout.toString().trim()} ${result.stderr.toString().trim()}',
          result.exitCode == 0
              ? null
              : 'Install $name and ensure it is available on PATH.',
        ),
      );
    } catch (error) {
      findings.add(
        DoctorFinding(
          'tool:$name',
          'error',
          '$name unavailable: $error',
          'Install $name and ensure it is available on PATH.',
        ),
      );
    }
  }
  return findings;
}

bool _includesOptions(
  File file,
  File target,
  Map<String, String> packages,
  Set<String> seen,
  Map Function(File) readConfiguration,
) {
  final path = p.normalize(file.absolute.path);
  if (path == p.normalize(target.absolute.path)) return true;
  if (!seen.add(path) || !file.existsSync()) return false;
  final document = readConfiguration(file);
  final includes = document['include'];
  for (final value in includes is List ? includes : [includes]) {
    if (value is! String) continue;
    final uri = Uri.parse(value);
    String? included;
    if (uri.scheme == 'package') {
      final parts = uri.pathSegments;
      final root = parts.isEmpty ? null : packages[parts.first];
      if (root != null) included = p.joinAll([root, 'lib', ...parts.skip(1)]);
    } else if (!uri.hasScheme) {
      included = p.join(file.parent.path, value);
    }
    if (included != null &&
        _includesOptions(
          File(included),
          target,
          packages,
          seen,
          readConfiguration,
        )) {
      return true;
    }
  }
  return false;
}
