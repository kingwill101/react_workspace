/// Indexes top-level declarations in the installed `package:web` so a snapshot
/// definition can be verified to have a `package:web` mapping.
///
/// A definition present in the snapshot but with no `package:web` mapping is a
/// generator defect: generation of the browser surface must fail, not quietly
/// drop the type.
library;

import 'dart:io';

import 'package:package_config/package_config.dart';
import 'package:path/path.dart' as p;

final class PackageWebMappings {
  /// type name -> package:web library uri (e.g. `package:web/src/dom/html.dart`).
  final Map<String, String> typeToLibrary;

  const PackageWebMappings(this.typeToLibrary);

  bool contains(String name) => typeToLibrary.containsKey(name);
  String? libraryOf(String name) => typeToLibrary[name];
  int get length => typeToLibrary.length;

  /// Scans the `package:web` resolved from [packageRoot]'s package config.
  static Future<PackageWebMappings> load(String packageRoot) async {
    final root = Directory(packageRoot).absolute.path;
    final pkgConfig = File(p.join(root, '.dart_tool', 'package_config.json'));
    if (!await pkgConfig.exists()) {
      throw StateError('package_config.json not found at ${pkgConfig.path}');
    }
    final config = await loadPackageConfig(pkgConfig);
    final webPkg = config['web'];
    if (webPkg == null) {
      throw StateError('package:web not found in package_config.json');
    }
    final webLib = Directory(p.join(webPkg.root.toFilePath(), 'lib'));
    final map = <String, String>{};
    final reExt = RegExp(r'^extension type (\w+)');
    final reTypedef = RegExp(r'^typedef (\w+)');
    final reClass = RegExp(r'^abstract class (\w+)|^final class (\w+)|^class (\w+)|^mixin (\w+)|^extension (\w+)');

    for (final file in webLib.listSync(recursive: true).whereType<File>()) {
      if (!file.path.endsWith('.dart')) continue;
      final rel = p.relative(file.path, from: webLib.path);
      final lib = Uri.parse('package:web/$rel').toString();
      final content = await file.readAsString();
      for (final line in content.split('\n')) {
        final trimmed = line.trimLeft();
        for (final m in reExt.allMatches(trimmed)) {
          map.putIfAbsent(m[1]!, () => lib);
        }
        for (final m in reTypedef.allMatches(trimmed)) {
          map.putIfAbsent(m[1]!, () => lib);
        }
        for (final m in reClass.allMatches(trimmed)) {
          final name = m.group(1) ?? m.group(2) ?? m.group(3) ?? m.group(4) ?? m.group(5);
          if (name != null) map.putIfAbsent(name, () => lib);
        }
      }
    }
    return PackageWebMappings(map);
  }

  /// Names that are defined in the snapshot but not exported/declared by the
  /// installed `package:web`. An empty set means full mapping coverage.
  Set<String> missingTypes(Iterable<String> names) =>
      names.where((n) => !typeToLibrary.containsKey(n)).toSet();
}
