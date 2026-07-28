import 'dart:convert';
import 'dart:io';

const _pinnedRevision = '12a9ca2ebc08f5a6f2d69aebc7daa1f5a2e6a431';
const _vendorDir = 'tool/vendor/dart_web';
const _snapshotsDir = 'tool/web_idl/snapshots';

Future<void> main(List<String> args) async {
  final revision = args.isNotEmpty ? args[0] : _pinnedRevision;

  await _ensureVendor(revision);
  await _runGenerator();
  await _copySnapshot();
  await _writeProvenance(revision);
}

Future<void> _ensureVendor(String revision) async {
  final vendor = Directory(_vendorDir);
  if (await vendor.exists()) {
    await _run('git', ['fetch', '--tags'], workdir: _vendorDir);
    await _run('git', ['checkout', '--detach', revision], workdir: _vendorDir);
  } else {
    await _run('git', [
      'clone',
      'https://github.com/dart-lang/web.git',
      _vendorDir,
    ]);
    await _run('git', ['checkout', '--detach', revision], workdir: _vendorDir);
  }
}

Future<void> _runGenerator() async {
  await _run('dart', ['pub', 'get'],
      workdir: '$_vendorDir/web_generator');
  await _run('npm', ['install'],
      workdir: '$_vendorDir/web_generator');
  await _run('node', ['preparse_idls.mjs'],
      workdir: '$_vendorDir/web_generator/bin');
}

Future<void> _copySnapshot() async {
  await Directory(_snapshotsDir).create(recursive: true);
  await File(
    '$_vendorDir/web_generator/.dart_tool/web_generator/web_apis.json',
  ).copy('$_snapshotsDir/web_apis.json');
}

Future<void> _writeProvenance(String revision) async {
  await File('$_snapshotsDir/provenance.json').writeAsString(
    const JsonEncoder.withIndent('  ').convert({
      'dartWebRevision': revision,
      'source': 'dart-lang/web web_generator',
      'generateAll': false,
    }),
  );
}

Future<void> _run(String executable, List<String> arguments,
    {String? workdir}) async {
  final result = await Process.run(executable, arguments,
      workingDirectory: workdir, runInShell: true);
  stdout.write(result.stdout as String);
  stderr.write(result.stderr as String);
  if (result.exitCode != 0) {
    throw Exception(
        '$executable ${arguments.join(' ')} failed with exit code ${result.exitCode}');
  }
}
