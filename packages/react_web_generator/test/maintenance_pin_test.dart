import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';

void main() {
  final root = _workspaceRoot();
  final pin =
      jsonDecode(File('${root.path}/tool/web_idl/pin.json').readAsStringSync())
          as Map<String, dynamic>;
  final provenance =
      jsonDecode(
            File(
              '${root.path}/tool/web_idl/snapshots/provenance.json',
            ).readAsStringSync(),
          )
          as Map<String, dynamic>;

  test('package:web dependency starts at the upstream binding pin', () {
    final version = pin['packageWebVersion'] as String;
    expect(
      _dependencyVersion(
        File('${root.path}/packages/react_web/pubspec.yaml'),
        'web',
      ),
      '^$version',
    );
    expect(
      _dependencyVersion(
        File('${root.path}/packages/react_web_generator/pubspec.yaml'),
        'web',
      ),
      '^$version',
    );
  });

  test('snapshot provenance matches the canonical pin', () {
    for (final key in [
      'packageWebVersion',
      'dartWebRevision',
      'dartWebCommit',
      'generateAll',
    ]) {
      expect(provenance[key], pin[key], reason: '$key drifted');
    }
    expect(provenance['normalizer'], 'tool/web_idl/preparse.mjs');
  });
}

Directory _workspaceRoot() {
  var current = Directory.current.absolute;
  while (!File('${current.path}/tool/web_idl/pin.json').existsSync()) {
    final parent = current.parent;
    if (parent.path == current.path) {
      throw StateError('Could not locate the React workspace root.');
    }
    current = parent;
  }
  return current;
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
