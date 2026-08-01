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

Builder componentBuilder(BuilderOptions options) => const ReactComponentBuilder(
  ReactCompiler(
    reader: ReactComponentReader(typeReader: ReactTypeReader()),
    publicApiEmitter: PublicApiEmitter(),
    jsBridgeEmitter: JsBridgeEmitter(callbackEmitter: CallbackEmitter()),
  ),
);

Builder aggregateBuilder(BuilderOptions options) => AggregateBuilder();

Builder serverFunctionBuilder(BuilderOptions options) =>
    const ServerFunctionBuilder();
