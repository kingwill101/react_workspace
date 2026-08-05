import 'dart:io';

import 'package:react_web_generator/react_web_generator.dart';
import 'package:react_web_generator/src/bcd_filter.dart';
import 'package:react_web_generator/src/complete/package_web_mappings.dart';
import 'package:react_web_generator/src/emit/dom_factory_emitter.dart';

const webApisJson = 'tool/web_idl/snapshots/web_apis.json';
const overlayJson =
    'packages/react_web_generator/config/react_dom_overlay.json';
const generatedDir = 'packages/react_web/lib/src/generated';

Future<void> main() async {
  final bcdFilter = BcdFilter.load();

  // === Complete Web IDL surface (single source of truth) ===
  final raw = CompleteWebModelBuilder(
    webIdlPath: webApisJson,
    bcdFilter: bcdFilter,
  ).loadRaw();
  final completeModel = mergeRawModel(raw);

  const neutralWebSurfaceDir = 'packages/react_web/lib/src/generated/web';
  NeutralSurfaceEmitter(completeModel).emitTo(neutralWebSurfaceDir);
  print('Generated complete neutral Web surface → $neutralWebSurfaceDir/');
  print('  Definitions: ${completeModel.definitionCount} across ${completeModel.specOf.values.toSet().length} specs');

  final verifier = CompletenessVerifier(model: completeModel, emittedModel: completeModel);
  final report = verifier.verify();
  File('$neutralWebSurfaceDir/../completeness_report.json')
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

  // React synthetic event interfaces (authored; typed against the neutral surface).
  const ReactEventEmitter().emitToDirectory(generatedDir);
  print('Generated React event interfaces → $generatedDir/react_events.dart');

  // Host element factories (IR over the IDL snapshot + overlay).
  final builder = await WebHostIrBuilder.create(
    packageRoot: Directory.current.path,
    webApisJsonPath: webApisJson,
    overlayPath: overlayJson,
    rootsPath: 'packages/react_web_generator/config/roots.json',
  );
  final elements = builder.build();
  final allElements = builder.buildAll();

  final factoryEmitter = FactoryEmitter(elements);
  final factoryCode = factoryEmitter.emit();

  final outDir = Directory(generatedDir);
  await outDir.create(recursive: true);
  await File('${outDir.path}/elements.dart').writeAsString(factoryCode);

  final packageWebMappings = await PackageWebMappings.load(Directory.current.path);
  final browserAdapterEmitter = BrowserAdapterEmitter(
    completeModel,
    packageWebNames: packageWebMappings.typeToLibrary.keys.toSet(),
  );
  browserAdapterEmitter.emitToDirectory(outDir.path);

  DomFactoryEmitter(allElements).emitToDirectory(outDir.path);

  SsrMetadataEmitter(allElements).emitToDirectory(outDir.path);

  print(
    'Generated ${elements.length} element factories → ${outDir.path}/elements.dart',
  );
  print('Generated browser adapter → ${outDir.path}/browser_adapter.dart');
  print('Generated DOM factories → ${outDir.path}/dom.dart');
  print('Generated SSR metadata → ${outDir.path}/ssr_metadata.dart');
}
