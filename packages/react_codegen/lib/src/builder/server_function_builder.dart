import 'package:build/build.dart';

import '../server_function/codec_emitter.dart';
import '../server_function/action_file_emitter.dart';
import '../server_function/client_file_emitter.dart';
import '../server_function/registry_file_emitter.dart';
import '../server_function/server_function_reader.dart';

/// A `package:build` Builder that processes `@serverFunction` annotations
/// and generates three files:
/// - `*.action.g.dart` — shared ref + codecs
/// - `*.client.g.dart` — browser proxy
/// - `*.registry.g.dart` — server registration
final class ServerFunctionBuilder implements Builder {
  const ServerFunctionBuilder();

  @override
  final buildExtensions = const {
    '.dart': [
      '.action.g.dart',
      '.client.g.dart',
      '.registry.g.dart',
    ],
  };

  @override
  Future<void> build(BuildStep step) async {
    final inputId = step.inputId;

    // Skip files that contain ".action.", ".client.", or ".registry." in
    // their name to avoid re-processing generated outputs.
    if (inputId.pathSegments.any((s) =>
        s.contains('.action.') ||
        s.contains('.client.') ||
        s.contains('.registry.'))) {
      return;
    }

    if (!await step.resolver.isLibrary(step.inputId)) {
      return;
    }

    final library = await step.inputLibrary;

    final reader = ServerFunctionReader();
    final models = reader.read(library, inputId);

    if (models.isEmpty) {
      return;
    }

    const codecEmitter = CodecEmitter();
    const actionEmitter = ActionFileEmitter(codecEmitter: codecEmitter);
    const clientEmitter = ClientFileEmitter();
    const registryEmitter = RegistryFileEmitter();

    // Emit a single action file containing all functions in this source
    final actionContent = actionEmitter.emitAll(models);
    await step.writeAsString(
      inputId.changeExtension('.action.g.dart'),
      actionContent,
    );

    // Emit a single client file containing all functions in this source
    final clientContent = clientEmitter.emitAll(models);
    await step.writeAsString(
      inputId.changeExtension('.client.g.dart'),
      clientContent,
    );

    // Emit a single registry file containing all functions in this source
    final registryContent = registryEmitter.emitAll(models);
    await step.writeAsString(
      inputId.changeExtension('.registry.g.dart'),
      registryContent,
    );
  }
}
