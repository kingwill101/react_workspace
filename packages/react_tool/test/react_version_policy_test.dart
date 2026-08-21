import 'dart:convert';
import 'dart:io';

import 'package:react_tool/src/react_versions.dart';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

void main() {
  final root = _workspaceRoot();

  test('wrapper peer ranges match the framework support policy', () {
    final packages = Directory(
      '${root.path}/packages',
    ).listSync().whereType<Directory>();

    for (final package in packages) {
      final pubspec = File('${package.path}/pubspec.yaml');
      if (!pubspec.existsSync()) continue;
      final yaml = loadYaml(pubspec.readAsStringSync()) as YamlMap;
      final react = yaml['react'];
      if (react is! YamlMap) continue;
      final js = react['js'];
      if (js is! YamlMap) continue;
      final peers = js['peers'];
      if (peers is! YamlMap) continue;

      expect(
        peers['react'],
        ReactVersionPolicy.supportedPeerRange,
        reason: '${pubspec.path} has a stale React peer range',
      );
      expect(
        peers['react-dom'],
        ReactVersionPolicy.supportedPeerRange,
        reason: '${pubspec.path} has a stale React DOM peer range',
      );
    }
  });

  test('workspace examples start from the managed React version', () {
    for (final relativePath in [
      'package.json',
      'examples/client/package.json',
      'examples/superdesk/package.json',
      'packages/react_server_routed/example/package.json',
    ]) {
      final file = File('${root.path}/$relativePath');
      final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      final dependencies = json['dependencies'] as Map<String, dynamic>;
      const expected = '^${ReactVersionPolicy.managedVersion}';
      expect(dependencies['react'], expected, reason: relativePath);
      expect(dependencies['react-dom'], expected, reason: relativePath);
    }
  });

  test('scaffolds receive the managed React version as template data', () {
    final template = File(
      '${root.path}/packages/react_tool/lib/src/scaffold/templates/'
      'package.json.liquid',
    ).readAsStringSync();
    expect(template, contains('^{{ reactVersion }}'));
    expect(template, isNot(contains('18.3.1')));
  });
}

Directory _workspaceRoot() {
  var current = Directory.current.absolute;
  while (!File('${current.path}/pubspec.yaml').existsSync() ||
      !Directory('${current.path}/packages/react_tool').existsSync()) {
    final parent = current.parent;
    if (parent.path == current.path) {
      throw StateError('Could not locate the React workspace root.');
    }
    current = parent;
  }
  return current;
}
