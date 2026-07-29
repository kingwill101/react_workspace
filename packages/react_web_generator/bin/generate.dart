import 'dart:io';

import 'package:react_web_generator/react_web_generator.dart';
import 'package:react_web_generator/src/normalize/model_builder.dart';
import 'package:react_web_generator/src/emit/model_json_emitter.dart';
import 'package:react_web_generator/src/emit/neutral_interface_emitter.dart';
import 'package:react_web_generator/src/emit/browser_adapter_emitter.dart';
import 'package:react_web_generator/src/emit/ssr_metadata_emitter.dart';
import 'package:react_web_generator/src/emit/dom_factory_emitter.dart';

String _findWorkspaceRoot() {
  var dir = Directory.current.path;
  while (dir != '/') {
    if (File('$dir/pubspec.yaml').existsSync()) {
      final content = File('$dir/pubspec.yaml').readAsStringSync();
      if (content.contains('workspace:')) return dir;
    }
    dir = Directory(dir).parent.path;
  }
  return Directory.current.path;
}

Future<void> main() async {
  final root = _findWorkspaceRoot();

  final modelBuilder = ModelBuilder(
    webIdlPath: '$root/tool/web_idl/snapshots/web_apis.json',
    rootsPath: '$root/packages/react_web_generator/config/roots.json',
  );
  final model = modelBuilder.build();

  ModelJsonEmitter(model).writeTo(
    '$root/packages/react_web_generator/config/neutral_web_model.json',
  );
  print(
    'Generated neutral web model → $root/packages/react_web_generator/config/neutral_web_model.json',
  );
  print('  Types: ${model.types.length}');
  print('  Elements: ${model.elements.length}');

  final interfaceEmitter = NeutralInterfaceEmitter(model);
  interfaceEmitter.emitToDirectory(
    '$root/packages/react_web/lib/src/generated',
  );
  print('Generated interface files → $root/packages/react_web/lib/src/generated/');
  print('  - html_interfaces.dart');
  print('  - event_interfaces.dart');

  final builder = await WebHostIrBuilder.create(
    packageRoot: root,
    webApisJsonPath: '$root/tool/web_idl/snapshots/web_apis.json',
    overlayPath: '$root/packages/react_web_generator/config/react_dom_overlay.json',
    rootsPath: '$root/packages/react_web_generator/config/roots.json',
  );
  final elements = builder.build();

  final factoryEmitter = FactoryEmitter(elements);
  final factoryCode = factoryEmitter.emit();

  final outDir = Directory('$root/packages/react_web/lib/src/generated');
  await outDir.create(recursive: true);
  await File('${outDir.path}/elements.dart').writeAsString(factoryCode);

  final browserAdapterEmitter = BrowserAdapterEmitter(model);
  browserAdapterEmitter.emitToDirectory(outDir.path);

  final ssrEmitter = SsrMetadataEmitter(model);
  ssrEmitter.emitToDirectory(outDir.path);

  final domEmitter = DomFactoryEmitter(model);
  domEmitter.emitToDirectory(outDir.path);

  print('Generated ${elements.length} element factories → ${outDir.path}/elements.dart');
  print('Generated browser adapter → ${outDir.path}/browser_adapter.dart');
  print('Generated SSR metadata → ${outDir.path}/ssr_metadata.dart');
  print('Generated DOM factories → ${outDir.path}/dom.dart');
}