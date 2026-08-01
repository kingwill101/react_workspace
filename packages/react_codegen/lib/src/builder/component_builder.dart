import 'package:build/build.dart';

import '../analyzer/component_reader.dart';
import '../analyzer/type_reader.dart';
import '../compiler/compiler.dart';
import '../output/callback_emitter.dart';
import '../output/js_bridge_emitter.dart';
import '../output/public_api_emitter.dart';

Builder componentBuilder(BuilderOptions options) {
  const callbackEmitter = CallbackEmitter();

  const compiler = ReactCompiler(
    reader: ReactComponentReader(typeReader: ReactTypeReader()),
    publicApiEmitter: PublicApiEmitter(),
    jsBridgeEmitter: JsBridgeEmitter(callbackEmitter: callbackEmitter),
  );

  return const ReactComponentBuilder(compiler);
}

final class ReactComponentBuilder implements Builder {
  final ReactCompiler compiler;

  const ReactComponentBuilder(this.compiler);

  @override
  final buildExtensions = const {
    '.dart': ['.react.dart', '.react.g.dart'],
  };

  @override
  Future<void> build(BuildStep step) async {
    final path = step.inputId.path;
    // Skip generated files to avoid processing them as components
    if (path.contains('.react.') ||
        path.contains('.action.') ||
        path.contains('.client.') ||
        path.contains('.registry.')) {
      return;
    }

    if (!await step.resolver.isLibrary(step.inputId)) {
      return;
    }

    final library = await step.inputLibrary;
    final output = compiler.compile(library, step.inputId);

    if (output == null) {
      return;
    }

    await step.writeAsString(
      step.inputId.changeExtension('.react.dart'),
      output.publicApi,
    );

    await step.writeAsString(
      step.inputId.changeExtension('.react.g.dart'),
      output.jsBridge,
    );
  }
}
