import 'dart:io';

import 'package:react_web_generator/react_web_generator.dart';
import 'package:react_web_generator/src/normalize/model_builder.dart';
import 'package:react_web_generator/src/emit/model_json_emitter.dart';
import 'package:react_web_generator/src/emit/neutral_interface_emitter.dart';

const webApisJson = 'tool/web_idl/snapshots/web_apis.json';
const overlayJson =
    'packages/react_web_generator/config/react_dom_overlay.json';
const neutralWebModelJson =
    'packages/react_web_generator/config/neutral_web_model.json';
const generatedDir = 'packages/react_web/lib/src/generated';

Future<void> main() async {
  // === Complete Web IDL surface (replaces the old reachability pipeline) ===
  final raw = CompleteWebModelBuilder(webIdlPath: webApisJson).loadRaw();
  final completeModel = mergeRawModel(raw);

  const neutralWebSurfaceDir = 'packages/react_web/lib/src/generated/web';
  NeutralSurfaceEmitter(completeModel).emitTo(neutralWebSurfaceDir);
  print('Generated complete neutral Web surface → $neutralWebSurfaceDir/');
  print('  Definitions: ${completeModel.definitionCount} across ${completeModel.specOf.values.toSet().length} specs');

  final verifier = CompletenessVerifier(model: completeModel, emittedModel: completeModel);
  final report = verifier.verify();
  File(neutralWebSurfaceDir + '/../completeness_report.json')
      .writeAsStringSync(verifier.toJsonNice(report));
  print('Completeness report → $neutralWebSurfaceDir/../completeness_report.json');
  print('  definitions.dropped=${(report['definitions'] as Map)['dropped']} '
      'members.dropped=${(report['members'] as Map)['dropped']}');

  // Generated SSR throwing surface (same declarations as browser; throws at runtime).
  SsrSurfaceEmitter(completeModel).emitTo(neutralWebSurfaceDir);
  print('Generated SSR throwing surface → $neutralWebSurfaceDir/ssr.dart');

  // Focused per-spec libraries, e.g. `import 'package:react_web/storage.dart'`.
  const apisDir = 'packages/react_web/lib/apis';
  NeutralSurfaceEmitter(completeModel).emitFocusedLibraries(
    apisDir,
    completeModel.specOf.values.toSet().toList(),
  );
  print('Generated focused libraries → $apisDir/');

  final modelBuilder = ModelBuilder(webIdlPath: webApisJson);
  final model = modelBuilder.build();

  ModelJsonEmitter(model).writeTo(neutralWebModelJson);
  print('Generated neutral web model → $neutralWebModelJson');
  print('  Types: ${model.types.length}');
  print('  Elements: ${model.elements.length}');

  final interfaceEmitter = NeutralInterfaceEmitter(model);
  interfaceEmitter.emitToDirectory(generatedDir);
  print('Generated interface files → $generatedDir/');
  print('  - types/html_interfaces.dart');
  print('  - event_interfaces.dart');

  final builder = await WebHostIrBuilder.create(
    packageRoot: Directory.current.path,
    webApisJsonPath: webApisJson,
    overlayPath: overlayJson,
    rootsPath: 'packages/react_web_generator/config/roots.json',
  );
  final elements = builder.build();

  final factoryEmitter = FactoryEmitter(elements);
  final factoryCode = factoryEmitter.emit();

  final outDir = Directory(generatedDir);
  await outDir.create(recursive: true);
  await File('${outDir.path}/elements.dart').writeAsString(factoryCode);

  final browserAdapterEmitter = BrowserAdapterEmitter(model);
  browserAdapterEmitter.emitToDirectory(outDir.path);

  final ssrEmitter = SsrMetadataEmitter(model);
  ssrEmitter.emitToDirectory(outDir.path);

  print(
    'Generated ${elements.length} element factories → ${outDir.path}/elements.dart',
  );
  print('Generated browser adapter → ${outDir.path}/browser_adapter.dart');
  print('Generated SSR metadata → ${outDir.path}/ssr_metadata.dart');
}
