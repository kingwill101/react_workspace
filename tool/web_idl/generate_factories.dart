import 'dart:convert';
import 'dart:io';

import 'package:react_web_generator/react_web_generator.dart';
import 'package:react_web_generator/src/normalize/model_builder.dart';
import 'package:react_web_generator/src/emit/model_json_emitter.dart';
import 'package:react_web_generator/src/emit/neutral_interface_emitter.dart';

const webApisJson = 'tool/web_idl/snapshots/web_apis.json';
const overlayJson = 'packages/react_web_generator/config/react_dom_overlay.json';
const elementsJson = 'packages/react_web_generator/config/milestone_w1_elements.json';
const neutralInterfacesJson = 'packages/react_web_generator/config/neutral_interfaces.json';
const neutralWebModelJson = 'packages/react_web_generator/config/neutral_web_model.json';
const generatedDir = 'packages/react_web/lib/src/generated';

Future<void> main() async {
  // Step 1: Build the neutral web model from Web IDL + React declarations
  final modelBuilder = ModelBuilder(webIdlPath: webApisJson);
  final model = modelBuilder.build();

  // Write the neutral model JSON (single source of truth)
  ModelJsonEmitter(model).writeTo(neutralWebModelJson);
  print('Generated neutral web model → $neutralWebModelJson');
  print('  Types: ${model.types.length}');
  print('  Elements: ${model.elements.length}');

  // Generate Dart interface files from the neutral web model
  final interfaceEmitter = NeutralInterfaceEmitter(model);
  interfaceEmitter.emitToDirectory('packages/react_web/lib/src');
  print('Generated interface files → packages/react_web/src/');
  print('  - types/html_interfaces.dart');
  print('  - event_interfaces.dart');

  // Step 2: Build element IR for factory/adapter generation
  final builder = await WebHostIrBuilder.create(
    packageRoot: Directory.current.path,
    webApisJsonPath: webApisJson,
    overlayPath: overlayJson,
    elementsPath: elementsJson,
  );
  final elements = builder.build();

  // Read neutral interface model for adapter emitter
  final interfaceModel = jsonDecode(
    await File(neutralInterfacesJson).readAsString(),
  ) as Map<String, dynamic>;

  // Generate element factories
  final factoryEmitter = FactoryEmitter(elements);
  final factoryCode = factoryEmitter.emit();

  final outDir = Directory(generatedDir);
  await outDir.create(recursive: true);
  await File('${outDir.path}/elements.dart').writeAsString(factoryCode);

  // Generate browser adapter
  final adapterEmitter = AdapterEmitter(elements, interfaceModel);
  final adapterCode = adapterEmitter.emit();
  await File('${outDir.path}/browser_adapter.dart').writeAsString(adapterCode);

  print('Generated ${elements.length} element factories → ${outDir.path}/elements.dart');
  print('Generated browser adapter → ${outDir.path}/browser_adapter.dart');
}
