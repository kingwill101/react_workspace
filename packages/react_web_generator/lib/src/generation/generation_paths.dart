import 'dart:io';

import 'package:path/path.dart' as p;

/// Files and directories owned by one Web bindings generation run.
///
/// All paths are derived from one workspace root so the generator does not
/// depend on the process working directory after construction.
final class WebGenerationPaths {
  /// Absolute React workspace root.
  final Directory workspaceRoot;

  WebGenerationPaths(Directory workspaceRoot)
    : workspaceRoot = workspaceRoot.absolute;

  /// Validates that [workspaceRoot] has the inputs required by the pipeline.
  void validate() {
    final missing = <String>[
      for (final file in [webApisSnapshot, overlay, roots, reactWebPubspec])
        if (!file.existsSync()) relative(file.path),
    ];
    if (missing.isNotEmpty) {
      throw StateError(
        'The Web generator workspace is missing required inputs:\n'
        '${missing.map((path) => '  - $path').join('\n')}',
      );
    }
  }

  /// Normalized Web API snapshot.
  File get webApisSnapshot => file('tool/web_idl/snapshots/web_apis.json');

  /// React-specific DOM naming and property overlay.
  File get overlay =>
      file('packages/react_web_generator/config/react_dom_overlay.json');

  /// Curated strict roots and void-element configuration.
  File get roots => file('packages/react_web_generator/config/roots.json');

  /// Package declaration containing the exact `package:web` dependency.
  File get reactWebPubspec => file('packages/react_web/pubspec.yaml');

  /// Pinned Dart web submodule used for BCD filtering.
  Directory get dartWebSubmodule => directory('third_party/web');

  /// Root of generated `react_web` implementation files.
  Directory get generated => directory('packages/react_web/lib/src/generated');

  /// Complete neutral Web surface.
  Directory get neutralWebSurface =>
      directory('packages/react_web/lib/src/generated/web');

  /// Focused per-spec public libraries.
  Directory get focusedApis => directory('packages/react_web/lib/apis');

  /// Generated host-type registry consumed by `react_codegen`.
  File get hostTypeRegistry =>
      file('packages/react_codegen/lib/src/generated/web_host_types.g.dart');

  /// Manifest of definitions and members actually emitted.
  File get emittedManifest =>
      file('packages/react_web/lib/src/generated/emitted_manifest.json');

  /// Completeness comparison between the model and emitted manifest.
  File get completenessReport =>
      file('packages/react_web/lib/src/generated/completeness_report.json');

  /// Resolves a workspace-relative file.
  File file(String relativePath) =>
      File(p.join(workspaceRoot.path, relativePath));

  /// Resolves a workspace-relative directory.
  Directory directory(String relativePath) =>
      Directory(p.join(workspaceRoot.path, relativePath));

  /// Returns [path] relative to [workspaceRoot] for logs and diagnostics.
  String relative(String path) => p.relative(path, from: workspaceRoot.path);
}
