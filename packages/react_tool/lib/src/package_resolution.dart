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
) async {
  final pubspec = File(p.join(project.path, 'pubspec.yaml'));
  Object? yaml;
  try {
    yaml = pubspec.existsSync() ? loadYaml(pubspec.readAsStringSync()) : null;
  } on YamlException {
    // Invalid metadata must not grant access to a parent's resolution.
  }
  if (yaml is Map && yaml['resolution'] == 'workspace') {
    var parent = project.parent;
    while (true) {
      final spec = File(p.join(parent.path, 'pubspec.yaml'));
      if (spec.existsSync()) {
        try {
          final document = loadYaml(spec.readAsStringSync());
          if (document is Map && document['workspace'] is List) {
            // Stop at the workspace boundary even before its first pub get.
            final resolution = await findPackageConfigAndFile(
              parent,
              recurse: false,
            );
            final name = yaml['name'];
            final package = name is String ? resolution?.config[name] : null;
            if (package == null) return null;
            try {
              if (!p.equals(
                Directory.fromUri(package.root).resolveSymbolicLinksSync(),
                project.resolveSymbolicLinksSync(),
              )) {
                return null;
              }
            } on FileSystemException {
              return null;
            }
            return resolution;
          }
          // A standalone ancestor is not this member's workspace.
          if (document is Map && document['resolution'] != 'workspace') {
            return null;
          }
        } on YamlException {
          return null;
        }
      }
      final next = parent.parent;
      if (next.path == parent.path) return null;
      parent = next;
    }
  }
  return findPackageConfigAndFile(project, recurse: false);
}
