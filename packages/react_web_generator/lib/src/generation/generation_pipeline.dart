import 'dart:io';

import '../bcd_filter.dart';
import '../complete/complete.dart';
import '../complete/emit/completeness_verifier.dart';
import '../complete/emit/neutral_surface_emitter.dart';
import '../complete/emit/ssr_surface_emitter.dart';
import '../complete/package_web_mappings.dart';
import '../emit/browser_adapter_emitter.dart';
import '../emit/dom_factory_emitter.dart';
import '../emit/factory_emitter.dart';
import '../emit/react_event_emitter.dart';
import '../emit/ssr_metadata_emitter.dart';
import '../emit/svg_factory_emitter.dart';
import '../ir_builder.dart';
import '../web_host_ir.dart';
import 'generation_paths.dart';
import 'host_type_registry_emitter.dart';

/// Summary of one successful Web bindings generation run.
final class WebGenerationReport {
  /// Number of complete Web IDL definitions.
  final int definitionCount;

  /// Number of Web specification groups represented by the model.
  final int specificationCount;

  /// Number of strict starter-facing element factories.
  final int strictElementCount;

  /// Number of all generated HTML element factories.
  final int htmlElementCount;

  /// Number of all generated SVG element factories.
  final int svgElementCount;

  /// Completeness report written by the verification phase.
  final Map<String, Object?> completeness;

  const WebGenerationReport({
    required this.definitionCount,
    required this.specificationCount,
    required this.strictElementCount,
    required this.htmlElementCount,
    required this.svgElementCount,
    required this.completeness,
  });
}

/// Runs the complete normalized Web IDL to React Dart bindings pipeline.
///
/// The phases are deliberately ordered and named: load and merge the model,
/// emit neutral declarations, verify completeness, emit runtime adapters, then
/// emit host factories and metadata. Every output path comes from [paths].
final class WebBindingsGenerator {
  /// Inputs and output locations for this run.
  final WebGenerationPaths paths;

  /// Receives concise phase-level progress messages.
  final void Function(String message) log;

  const WebBindingsGenerator({required this.paths, this.log = print});

  /// Creates a generator rooted at the React workspace [workspaceRoot].
  factory WebBindingsGenerator.forWorkspace(
    Directory workspaceRoot, {
    void Function(String message) log = print,
  }) =>
      WebBindingsGenerator(paths: WebGenerationPaths(workspaceRoot), log: log);

  /// Generates every owned output and returns run statistics.
  Future<WebGenerationReport> generate() async {
    paths.validate();
    final model = _loadModel();
    final specifications = model.specOf.values.toSet().toList();

    _emitNeutralSurface(model, specifications);
    final completeness = _verifyNeutralSurface(model);
    _emitHostTypeRegistry(model);
    _emitRuntimeSurfaces(model);

    final hostElements = await _buildHostElements();
    await _emitHostElements(model, hostElements);
    await _formatOutputs();

    return WebGenerationReport(
      definitionCount: model.definitionCount,
      specificationCount: specifications.length,
      strictElementCount: hostElements.strict.length,
      htmlElementCount: hostElements.html.length,
      svgElementCount: hostElements.svg.length,
      completeness: completeness,
    );
  }

  CompleteWebModel _loadModel() {
    final filter = BcdFilter.load(submodulePath: paths.dartWebSubmodule.path);
    final raw = CompleteWebModelBuilder(
      webIdlPath: paths.webApisSnapshot.path,
      bcdFilter: filter,
    ).loadRaw();
    final model = mergeRawModel(raw);
    log(
      'Loaded ${model.definitionCount} Web definitions across '
      '${model.specOf.values.toSet().length} specifications.',
    );
    return model;
  }

  void _emitNeutralSurface(
    CompleteWebModel model,
    List<String> specifications,
  ) {
    final emitter = NeutralSurfaceEmitter(model);
    emitter.emitTo(paths.neutralWebSurface.path);
    emitter.emitFocusedLibraries(paths.focusedApis.path, specifications);
    log(
      'Emitted neutral surface and ${specifications.length} focused libraries.',
    );
  }

  Map<String, Object?> _verifyNeutralSurface(CompleteWebModel model) {
    final manifest = EmittedManifest.fromFile(paths.emittedManifest.path);
    final verifier = CompletenessVerifier.withManifest(
      model: model,
      manifest: manifest,
    );
    final report = verifier.verifyAgainstManifest(manifest);
    paths.completenessReport.writeAsStringSync(verifier.toJsonNice(report));
    log('Verified emitted definitions and members against the manifest.');
    return report;
  }

  void _emitHostTypeRegistry(CompleteWebModel model) {
    const HostTypeRegistryEmitter().emitTo(model, paths.hostTypeRegistry);
    log('Emitted the react_codegen host-type registry.');
  }

  void _emitRuntimeSurfaces(CompleteWebModel model) {
    SsrSurfaceEmitter(model).emitTo(paths.neutralWebSurface.path);
    const ReactEventEmitter().emitToDirectory(paths.generated.path);
    log('Emitted SSR declarations and React synthetic events.');
  }

  Future<_HostElementSets> _buildHostElements() async {
    final builder = await WebHostIrBuilder.create(
      packageRoot: paths.workspaceRoot.path,
      webApisJsonPath: paths.webApisSnapshot.path,
      overlayPath: paths.overlay.path,
      rootsPath: paths.roots.path,
    );
    return _HostElementSets(
      strict: builder.build(),
      html: builder.buildAll(),
      svg: builder.buildSvg(),
    );
  }

  Future<void> _emitHostElements(
    CompleteWebModel model,
    _HostElementSets elements,
  ) async {
    paths.generated.createSync(recursive: true);
    paths
        .file('packages/react_web/lib/src/generated/elements.dart')
        .writeAsStringSync(FactoryEmitter(elements.strict).emit());

    final mappings = await PackageWebMappings.load(paths.workspaceRoot.path);
    BrowserAdapterEmitter(
      model,
      packageWebNames: mappings.typeToLibrary.keys.toSet(),
    ).emitToDirectory(paths.generated.path);
    DomFactoryEmitter(elements.html).emitToDirectory(paths.generated.path);
    SvgFactoryEmitter(elements.svg).emitToDirectory(paths.generated.path);
    SsrMetadataEmitter(elements.html).emitToDirectory(paths.generated.path);
    log(
      'Emitted ${elements.strict.length} strict, '
      '${elements.html.length} HTML, and ${elements.svg.length} SVG factories.',
    );
  }

  Future<void> _formatOutputs() async {
    final result = await Process.run(Platform.resolvedExecutable, [
      'format',
      paths.generated.path,
      paths.focusedApis.path,
      paths.hostTypeRegistry.path,
    ], workingDirectory: paths.workspaceRoot.path);
    if (result.exitCode != 0) {
      throw ProcessException(
        Platform.resolvedExecutable,
        ['format', '<generated outputs>'],
        '${result.stderr}',
        result.exitCode,
      );
    }
    log('Formatted all generated Dart outputs.');
  }
}

final class _HostElementSets {
  final List<WebHostElementIR> strict;
  final List<WebHostElementIR> html;
  final List<WebHostElementIR> svg;

  const _HostElementSets({
    required this.strict,
    required this.html,
    required this.svg,
  });
}
