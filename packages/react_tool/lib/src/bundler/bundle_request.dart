/// Execution platform for a bundle request.
enum JavaScriptTarget { browser, node }

/// A single target bundle request handed to a [JavaScriptBundler].
///
/// Carries every esbuild option react_tool needs so alternative backends
/// (e.g. Rolldown) can implement the same contract without knowing about
/// project layout.
final class BundleRequest {
  /// Human-readable label used in error messages and logging.
  final String name;

  final JavaScriptTarget target;

  /// Absolute paths of the aggregate entry files.
  final List<String> entryPoints;

  /// Absolute path of the output bundle.
  final String outputFile;

  /// Project root; used as the working directory for the bundler process.
  final String workingDirectory;

  /// The npm root through which external bare specifiers are resolved.
  final String npmRoot;

  /// Bare specifiers that must stay external (always includes react/react-dom
  /// plus any project- or wrapper-declared externals).
  final List<String> externals;

  /// Package resolution conditions (e.g. `production` vs `development`).
  final List<String> conditions;

  final bool minify;

  final bool sourceMaps;

  const BundleRequest({
    required this.name,
    required this.target,
    required this.entryPoints,
    required this.outputFile,
    required this.workingDirectory,
    required this.npmRoot,
    required this.externals,
    required this.conditions,
    required this.minify,
    required this.sourceMaps,
  });
}
