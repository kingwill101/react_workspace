import 'dart:convert';
import 'dart:io';

import 'package:react_web_generator/react_web_generator.dart';

Future<void> main() async {
  final builder = await WebHostIrBuilder.create(
    packageRoot: Directory.current.path,
    webApisJsonPath: 'tool/web_idl/snapshots/web_apis.json',
    overlayPath: 'packages/react_web_generator/config/react_dom_overlay.json',
    elementsPath: 'packages/react_web_generator/config/milestone_w1_elements.json',
  );

  final elements = builder.build();

  // Read neutral interface model
  final interfaceModel = jsonDecode(
    await File('packages/react_web_generator/config/neutral_interfaces.json').readAsString(),
  ) as Map<String, dynamic>;

  // Generate element factories
  final factoryEmitter = FactoryEmitter(elements);
  final factoryCode = factoryEmitter.emit();

  final outDir = Directory('packages/react_web/lib/src/generated');
  await outDir.create(recursive: true);
  await File('${outDir.path}/elements.dart').writeAsString(factoryCode);

  // Generate browser adapter
  final adapterEmitter = AdapterEmitter(elements, interfaceModel);
  final adapterCode = adapterEmitter.emit();
  await File('${outDir.path}/browser_adapter.dart').writeAsString(adapterCode);

  print('Generated ${elements.length} element factories → ${outDir.path}/elements.dart');
  print('Generated browser adapter → ${outDir.path}/browser_adapter.dart');
}
