import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package_resolution.dart';
import 'project_config.dart';

/// Keeps webdev's PATH-based SDK discovery aligned with the running Dart VM.
Map<String, String> debugEnvironment({
  String? executable,
  Map<String, String>? environment,
  bool? windows,
}) {
  final values = {...environment ?? Platform.environment};
  final isWindows = windows ?? Platform.isWindows;
  final pathKey = values.keys.firstWhere(
    (key) => isWindows ? key.toUpperCase() == 'PATH' : key == 'PATH',
    orElse: () => 'PATH',
  );
  final context = p.Context(style: isWindows ? p.Style.windows : p.Style.posix);
  final sdkBin = context.dirname(executable ?? Platform.resolvedExecutable);
  final previous = values[pathKey];
  values[pathKey] = [
    sdkBin,
    if (previous != null && previous.isNotEmpty) previous,
  ].join(isWindows ? ';' : ':');
  return values;
}

/// Forwarded build options also keep polling daemons distinct from native ones.
List<String> debugBuildOptions({required bool poll}) => [
  if (poll)
    for (final builder in ['component', 'aggregate', 'server_function'])
      '--define=react_codegen|$builder=watcher=polling',
];

/// Rejects unsupported companions before a debug session mutates templates.
Future<void> ensurePollingSupport(Directory project) async {
  final resolution = await findProjectPackageConfig(project);
  final generator = resolution?.config['react_codegen'];
  if (generator != null) {
    final manifest = File.fromUri(generator.root.resolve('react_tooling.json'));
    try {
      final value = jsonDecode(await manifest.readAsString());
      if (value is Map &&
          value['schemaVersion'] == 1 &&
          value['features'] is List &&
          (value['features'] as List).contains('polling_watcher')) {
        return;
      }
    } on FileSystemException {
      // Older published generators have no capability manifest.
    } on FormatException {
      // An invalid manifest must not silently disable the requested mode.
    }
  }
  throw const ReactToolException(
    '--poll requires a react_codegen version with polling watcher support. '
    'Upgrade react_codegen alongside react_tool, or use matching local '
    '--packages paths, then run dart pub get.',
  );
}
