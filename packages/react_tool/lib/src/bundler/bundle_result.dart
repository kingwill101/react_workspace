/// Outcome of a [JavaScriptBundler.bundle] call.
final class BundleResult {
  /// Absolute path of the produced output file.
  final String outputFile;

  final int outputBytes;

  final Duration duration;

  /// Input files recorded in the bundler metafile.
  final List<String> inputs;

  /// Output files recorded in the bundler metafile (bundle plus any source
  /// map or chunk artifacts).
  final List<String> outputs;

  /// Non-fatal diagnostics surfaced by the bundler.
  final List<String> warnings;

  const BundleResult({
    required this.outputFile,
    required this.outputBytes,
    required this.duration,
    required this.inputs,
    required this.outputs,
    required this.warnings,
  });
}
