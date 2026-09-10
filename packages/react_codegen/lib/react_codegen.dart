/// Build-runner entrypoints for React component and server-function codegen.
library;

import 'package:build/build.dart';

import 'src/analyzer/component_reader.dart';
import 'src/analyzer/type_reader.dart';
import 'src/compiler/compiler.dart';
import 'src/output/callback_emitter.dart';
import 'src/output/js_bridge_emitter.dart';
import 'src/output/public_api_emitter.dart';
import 'src/builder/component_builder.dart';
import 'src/builder/server_function_builder.dart';
import 'src/aggregate.dart';
import 'src/build_watcher.dart';

/// Creates the per-library React component builder.
Builder componentBuilder(BuilderOptions options) {
  configureReactBuildWatcher(polling: options.config['watcher'] == 'polling');
  return const ReactComponentBuilder(
    ReactCompiler(
      reader: ReactComponentReader(typeReader: ReactTypeReader()),
      publicApiEmitter: PublicApiEmitter(),
      jsBridgeEmitter: JsBridgeEmitter(callbackEmitter: CallbackEmitter()),
    ),
  );
}

/// Creates the package-wide component and action registry builder.
Builder aggregateBuilder(BuilderOptions options) {
  configureReactBuildWatcher(polling: options.config['watcher'] == 'polling');
  return AggregateBuilder();
}

/// Creates the per-library server-function builder.
Builder serverFunctionBuilder(BuilderOptions options) {
  configureReactBuildWatcher(polling: options.config['watcher'] == 'polling');
  return const ServerFunctionBuilder();
}
