import 'dart:io';

import 'package:react_web_generator/react_web_generator.dart';
import 'package:react_web_generator/src/bcd_filter.dart';
import 'package:react_web_generator/src/complete/package_web_mappings.dart';
import 'package:react_web_generator/src/emit/dom_factory_emitter.dart';
import 'package:react_web_generator/src/emit/svg_factory_emitter.dart';

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
  final neutralEmitter = NeutralSurfaceEmitter(completeModel);
  neutralEmitter.emitTo(neutralWebSurfaceDir);
  print('Generated complete neutral Web surface → $neutralWebSurfaceDir/');
  print(
    '  Definitions: ${completeModel.definitionCount} across ${completeModel.specOf.values.toSet().length} specs',
  );

  // Verify against the emitted manifest written by NeutralSurfaceEmitter.
  const manifestPath =
      'packages/react_web/lib/src/generated/emitted_manifest.json';
  final manifest = EmittedManifest.fromFile(manifestPath);
  final verifier = CompletenessVerifier.withManifest(
    model: completeModel,
    manifest: manifest,
  );
  final report = verifier.verifyAgainstManifest(manifest);
  File(
    '$neutralWebSurfaceDir/../completeness_report.json',
  ).writeAsStringSync(verifier.toJsonNice(report));
  print(
    'Completeness report → $neutralWebSurfaceDir/../completeness_report.json',
  );
  print('  emitted_manifest → $manifestPath');
  print(
    '  definitions.dropped=${(report['definitions'] as Map)['dropped']} '
    'members.dropped=${(report['members'] as Map)['dropped']}',
  );

  // Generate host-type registry for react_codegen from the complete model.
  const hostTypesPath =
      'packages/react_codegen/lib/src/generated/web_host_types.g.dart';
  final hostBuf = StringBuffer();
  hostBuf.writeln('// GENERATED CODE — DO NOT EDIT');
  hostBuf.writeln(
    '// Full host-type table derived from the complete Web model.',
  );
  hostBuf.writeln('const generatedWebHostTypes = <String, (String, String)>{');
  for (final name in completeModel.interfaces.keys.toList()..sort()) {
    hostBuf.writeln("  '$name': ('web', '$name'),");
  }
  // Also include mixins that can appear as host values via implements.
  for (final name in completeModel.mixins.keys.toList()..sort()) {
    hostBuf.writeln("  '$name': ('web', '$name'),");
  }
  hostBuf.writeln('};');
  File(hostTypesPath).writeAsStringSync(hostBuf.toString());
  print(
    'Generated host-type registry → $hostTypesPath (${completeModel.interfaces.length} interfaces)',
  );

  // Generated SSR throwing surface (same declarations as browser; throws at runtime).
  SsrSurfaceEmitter(completeModel).emitTo(neutralWebSurfaceDir);
  print('Generated SSR throwing surface → $neutralWebSurfaceDir/ssr.dart');

  // Focused per-spec libraries, e.g. `import 'package:react_web/storage.dart'`.
  const apisDir = 'packages/react_web/lib/apis';
  NeutralSurfaceEmitter(
    completeModel,
  ).emitFocusedLibraries(apisDir, completeModel.specOf.values.toSet().toList());
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
  final svgElements = builder.buildSvg();

  final factoryEmitter = FactoryEmitter(elements);
  final factoryCode = factoryEmitter.emit();

  final outDir = Directory(generatedDir);
  await outDir.create(recursive: true);
  await File('${outDir.path}/elements.dart').writeAsString(factoryCode);

  final packageWebMappings = await PackageWebMappings.load(
    Directory.current.path,
  );
  final browserAdapterEmitter = BrowserAdapterEmitter(
    completeModel,
    packageWebNames: packageWebMappings.typeToLibrary.keys.toSet(),
  );
  browserAdapterEmitter.emitToDirectory(outDir.path);

  DomFactoryEmitter(allElements).emitToDirectory(outDir.path);
  SvgFactoryEmitter(svgElements).emitToDirectory(outDir.path);

  SsrMetadataEmitter(allElements).emitToDirectory(outDir.path);

  print(
    'Generated ${elements.length} element factories → ${outDir.path}/elements.dart',
  );
  print('Generated browser adapter → ${outDir.path}/browser_adapter.dart');
  print('Generated DOM factories → ${outDir.path}/dom.dart');
  print(
    'Generated ${svgElements.length} SVG factories → ${outDir.path}/svg.dart',
  );
  print('Generated SSR metadata → ${outDir.path}/ssr_metadata.dart');
}
