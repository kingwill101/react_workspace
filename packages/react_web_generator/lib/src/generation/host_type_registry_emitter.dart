import 'dart:io';

import '../complete/model.dart';

/// Emits the complete Web host-type registry consumed by `react_codegen`.
final class HostTypeRegistryEmitter {
  const HostTypeRegistryEmitter();

  /// Renders the registry deterministically from [model].
  String emit(CompleteWebModel model) {
    final output = StringBuffer()
      ..writeln('// GENERATED CODE — DO NOT EDIT')
      ..writeln('// Full host-type table derived from the complete Web model.')
      ..writeln('const generatedWebHostTypes = <String, (String, String)>{');
    for (final name in model.interfaces.keys.toList()..sort()) {
      output.writeln("  '$name': ('web', '$name'),");
    }
    for (final name in model.mixins.keys.toList()..sort()) {
      output.writeln("  '$name': ('web', '$name'),");
    }
    output.writeln('};');
    return output.toString();
  }

  /// Writes the rendered registry to [destination].
  void emitTo(CompleteWebModel model, File destination) {
    destination.parent.createSync(recursive: true);
    destination.writeAsStringSync(emit(model));
  }
}
