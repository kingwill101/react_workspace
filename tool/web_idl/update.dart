/// Refreshes the normalized Web data for the pinned `package:web` release.
///
/// This command reads the WebRef datasets locked by the `third_party/web`
/// submodule. It does not advance the submodule or select newer Web APIs.
library;

import 'dart:convert';
import 'dart:io';

const _pinPath = 'tool/web_idl/pin.json';
const _snapshotPath = 'tool/web_idl/snapshots/web_apis.json';
const _provenancePath = 'tool/web_idl/snapshots/provenance.json';
const _normalizerPath = 'tool/web_idl/preparse.mjs';

Future<void> main(List<String> arguments) async {
  if (arguments.contains('--help') || arguments.contains('-h')) {
    stdout.writeln('''
Refresh the normalized Web IDL snapshot for the pinned package:web release.

Usage:
  dart run tool/web_idl/update.dart

The package:web version, upstream tag, commit, and submodule path are declared
in $_pinPath. Advance that pin separately before running this command.
''');
    return;
  }
  if (arguments.isNotEmpty) {
    throw ArgumentError('Unknown arguments: ${arguments.join(' ')}');
  }

  final pin = _WebIdlPin.read(File(_pinPath));
  await _validatePin(pin);

  final dataDirectory = '${pin.submodulePath}/web_generator/lib/src';
  await _run('npm', [
    'ci',
    '--no-audit',
    '--no-fund',
    '--ignore-scripts',
  ], workdir: dataDirectory);
  await _run('node', [_normalizerPath]);
  await _writeProvenance(pin, dataDirectory);

  stdout.writeln('Updated $_snapshotPath for package:web ${pin.version}.');
}

Future<void> _validatePin(_WebIdlPin pin) async {
  final submodule = Directory(pin.submodulePath);
  if (!submodule.existsSync()) {
    throw StateError(
      'Missing ${pin.submodulePath}. Run '
      '`git submodule update --init ${pin.submodulePath}`.',
    );
  }

  final commit = (await _capture('git', [
    '-C',
    pin.submodulePath,
    'rev-parse',
    'HEAD',
  ])).trim();
  if (commit != pin.commit) {
    throw StateError(
      'package:web ${pin.version} requires ${pin.commit}, but '
      '${pin.submodulePath} is at $commit.',
    );
  }

  final revisionCommit = (await _capture('git', [
    '-C',
    pin.submodulePath,
    'rev-parse',
    '${pin.revision}^{commit}',
  ])).trim();
  if (revisionCommit != pin.commit) {
    throw StateError(
      '${pin.revision} resolves to $revisionCommit; expected ${pin.commit}.',
    );
  }

  final upstreamVersion = _pubspecVersion(
    File('${pin.submodulePath}/web/pubspec.yaml'),
  );
  if (upstreamVersion != pin.version) {
    throw StateError(
      '${pin.submodulePath}/web reports $upstreamVersion; expected '
      '${pin.version}.',
    );
  }

  for (final path in [
    'packages/react_web/pubspec.yaml',
    'packages/react_web_generator/pubspec.yaml',
  ]) {
    final dependency = _dependencyVersion(File(path), 'web');
    final expected = '^${pin.version}';
    if (dependency != expected) {
      throw StateError(
        '$path must start its compatible `web` range at ${pin.version}; '
        'expected `$expected`, found `$dependency`.',
      );
    }
  }
}

Future<void> _writeProvenance(_WebIdlPin pin, String dataDirectory) async {
  final lock =
      jsonDecode(File('$dataDirectory/package-lock.json').readAsStringSync())
          as Map<String, dynamic>;
  final packages = lock['packages'] as Map<String, dynamic>;

  String version(String package) {
    final entry = packages['node_modules/$package'] as Map<String, dynamic>?;
    final value = entry?['version'];
    if (value is! String) {
      throw StateError('Missing $package version in package-lock.json.');
    }
    return value;
  }

  final provenance = {
    'packageWebVersion': pin.version,
    'dartWebRevision': pin.revision,
    'dartWebCommit': pin.commit,
    'webref': {
      '@webref/idl': version('@webref/idl'),
      '@webref/css': version('@webref/css'),
      '@webref/elements': version('@webref/elements'),
    },
    'source':
        'dart-lang/web web_generator data '
        '(${pin.submodulePath} @ ${pin.revision})',
    'normalizer': _normalizerPath,
    'generateAll': pin.generateAll,
  };
  File(_provenancePath).writeAsStringSync(
    '${const JsonEncoder.withIndent('  ').convert(provenance)}\n',
  );
}

String _pubspecVersion(File file) {
  final match = RegExp(
    r'^version:\s*([^\s#]+)',
    multiLine: true,
  ).firstMatch(file.readAsStringSync());
  if (match == null) throw StateError('Missing version in ${file.path}.');
  return match[1]!;
}

String _dependencyVersion(File file, String dependency) {
  final match = RegExp(
    '^  ${RegExp.escape(dependency)}:\\s*([^\\s#]+)',
    multiLine: true,
  ).firstMatch(file.readAsStringSync());
  if (match == null) {
    throw StateError('Missing $dependency dependency in ${file.path}.');
  }
  return match[1]!;
}

Future<void> _run(
  String executable,
  List<String> arguments, {
  String? workdir,
}) async {
  stdout.writeln('+ $executable ${arguments.join(' ')}');
  final process = await Process.start(
    executable,
    arguments,
    workingDirectory: workdir,
    mode: ProcessStartMode.inheritStdio,
    runInShell: Platform.isWindows,
  );
  final exitCode = await process.exitCode;
  if (exitCode != 0) {
    throw ProcessException(executable, arguments, '', exitCode);
  }
}

Future<String> _capture(String executable, List<String> arguments) async {
  final result = await Process.run(executable, arguments);
  if (result.exitCode != 0) {
    throw ProcessException(
      executable,
      arguments,
      result.stderr as String,
      result.exitCode,
    );
  }
  return result.stdout as String;
}

final class _WebIdlPin {
  final String version;
  final String revision;
  final String commit;
  final String submodulePath;
  final bool generateAll;

  const _WebIdlPin({
    required this.version,
    required this.revision,
    required this.commit,
    required this.submodulePath,
    required this.generateAll,
  });

  factory _WebIdlPin.read(File file) {
    final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
    return _WebIdlPin(
      version: json['packageWebVersion'] as String,
      revision: json['dartWebRevision'] as String,
      commit: json['dartWebCommit'] as String,
      submodulePath: json['submodulePath'] as String,
      generateAll: json['generateAll'] as bool,
    );
  }
}
