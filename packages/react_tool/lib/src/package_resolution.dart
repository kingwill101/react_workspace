import 'dart:io';

import 'package:package_config/package_config.dart';
import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

/// Finds this project's resolution without borrowing an unrelated parent app.
///
/// Only explicit Dart workspace members share a parent package configuration.
/// An unresolved standalone project must not discover wrappers or write managed
/// npm artifacts into an enclosing checkout merely because it is nested there.
Future<({PackageConfig config, File file})?> findProjectPackageConfig(
  Directory project,
) {
  final pubspec = File(p.join(project.path, 'pubspec.yaml'));
  final yaml = pubspec.existsSync()
      ? loadYaml(pubspec.readAsStringSync())
      : null;
  return findPackageConfigAndFile(
    project,
    recurse: yaml is Map && yaml['resolution'] == 'workspace',
  );
}
