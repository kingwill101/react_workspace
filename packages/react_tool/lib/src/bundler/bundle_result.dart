/// Outcome of a [JavaScriptBundler.bundle] call.
final class BundleResult {
  /// Absolute path of the produced output file.
  final String outputFile;

  final int outputBytes;

  final Duration duration;

  /// Input files recorded in the bundler metafile.
  final List<String> inputs;

  /// Non-fatal diagnostics surfaced by the bundler.
  final List<String> warnings;

  const BundleResult({
    required this.outputFile,
    required this.outputBytes,
    required this.duration,
    required this.inputs,
    required this.warnings,
  });
}
