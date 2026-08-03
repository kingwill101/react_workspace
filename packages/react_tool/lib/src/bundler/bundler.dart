import 'bundle_request.dart';
import 'bundle_result.dart';

/// Strategy for bundling the foreign module graph for a target.
///
/// Backends keep esbuild and Rolldown interchangeable without changing
/// [ReactBuilder]'s pipeline.
abstract interface class JavaScriptBundler {
  /// Backend name recorded in the bundle manifest (e.g. `esbuild`).
  String get name;

  Future<BundleResult> bundle(BundleRequest request);
}
