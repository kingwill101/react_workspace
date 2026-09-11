import 'dart:io';

import 'package:path/path.dart' as p;

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
