import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

import 'web_dart_type.dart';

/// Resolves IDL interface names to their [package:web] Dart types.
///
/// Uses the `package_config.json` of the containing package to locate the
/// installed `package:web`, then indexes all exported extension types so
/// generation fails when an allowlisted element's required interface is not
/// available in the actual installed version.
final class PackageWebResolver {
  final Map<String, WebDartType> _interfaces = {};
  final List<String> _errors = [];

  PackageWebResolver._();

  static Future<PackageWebResolver> create(String packageRoot) async {
    final resolver = PackageWebResolver._();
    await resolver._load(packageRoot);
    return resolver;
  }

  bool containsInterface(String idlName) => _interfaces.containsKey(idlName);

  WebDartType resolveInterface(String idlName) {
    final type = _interfaces[idlName];
    if (type == null) {
      throw StateError(
        'IDL interface "$idlName" is not available in the installed '
        'package:web.',
      );
    }
    return type;
  }

  Future<void> _load(String packageRoot) async {
    final pkgConfig = File(p.join(packageRoot, '.dart_tool', 'package_config.json'));
    if (!await pkgConfig.exists()) {
      _errors.add('package_config.json not found at ${pkgConfig.path}');
      return;
    }

    final config = jsonDecode(await pkgConfig.readAsString()) as Map<String, dynamic>;
    final packages = config['packages'] as List<dynamic>;

    Map<String, dynamic>? webPkg;
    for (final pkg in packages) {
      final pkgMap = pkg as Map<String, dynamic>;
      if (pkgMap['name'] == 'web') {
        webPkg = pkgMap;
        break;
      }
    }

    if (webPkg == null) {
      _errors.add('package:web not found in package_config.json');
      return;
    }

    final webRootUri = webPkg['rootUri'] as String;
    final webPkgDir = _resolveUri(webRootUri, packageRoot);
    final webLib = Directory(p.join(webPkgDir, 'lib'));
    if (!await webLib.exists()) {
      _errors.add('package:web lib/ not found at ${webLib.path}');
      return;
    }

    await _indexTypes(webLib, webLib.path);
  }

  Future<void> _indexTypes(Directory libDir, String libRoot) async {
    final files = libDir.listSync(recursive: true).whereType<File>();
    for (final file in files) {
      if (!file.path.endsWith('.dart')) continue;
      final content = await file.readAsString();
      _findExtensionTypes(content, file.path, libRoot);
    }
  }

  void _findExtensionTypes(String source, String filePath, String libRoot) {
    final extTypeRegex = RegExp(
      r'extension\s+type\s+(\w+)',
    );
    for (final m in extTypeRegex.allMatches(source)) {
      final name = m.group(1)!;
      if (name.startsWith('_')) continue;
      final relPath = p.relative(filePath, from: libRoot);
      final import = Uri.parse('package:web/$relPath');
      _interfaces[name] = WebDartType(
        symbol: name,
        import: import,
        nullable: false,
      );
    }
  }

  String _resolveUri(String uri, String basePath) {
    if (uri.startsWith('file://')) {
      return Uri.parse(uri).toFilePath();
    }
    if (uri.startsWith('package:')) {
      return p.join(basePath, '.dart_tool', uri.replaceAll(':', '/'));
    }
    return uri;
  }
}
