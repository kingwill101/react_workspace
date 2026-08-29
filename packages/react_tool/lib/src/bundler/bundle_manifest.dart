import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

/// Runtime artifacts for a single build target as recorded in
/// `bundle_manifest.json`.
final class BundleManifestTarget {
  /// Entry module for the target (relative to the output directory).
  final String entry;

  /// Dart-compiled application module for the target.
  final String dart;

  /// Intermediate loader module, when the entry is a bundled artifact.
  final String? loader;

  /// SSR runtime module, present for the SSR target only.
  final String? runtime;

  /// Foreign (bundler) aggregate, present when the project has foreign
  /// components or modules.
  final String? foreign;

  final int dartBytes;
  final int? foreignBytes;

  const BundleManifestTarget({
    required this.entry,
    required this.dart,
    this.loader,
    this.runtime,
    this.foreign,
    required this.dartBytes,
    this.foreignBytes,
  });

  factory BundleManifestTarget.fromJson(Map<String, Object?> json) {
    final bytes = (json['bytes'] as Map?)?.cast<String, Object?>() ?? const {};
    return BundleManifestTarget(
      entry: json['entry'] as String,
      dart: json['dart'] as String,
      loader: json['loader'] as String?,
      runtime: json['runtime'] as String?,
      foreign: json['foreign'] as String?,
      dartBytes: (bytes['dart'] as num).toInt(),
      foreignBytes: (bytes['foreign'] as num?)?.toInt(),
    );
  }
}

/// Parsed `bundle_manifest.json`, describing every runtime artifact a build
/// emitted per target so servers and tooling can load modules without
/// hardcoding file names.
final class BundleManifest {
  final int schema;
  final String bundler;
  final String mode;
  final BundleManifestTarget? browser;
  final BundleManifestTarget? ssr;

  const BundleManifest._({
    required this.schema,
    required this.bundler,
    required this.mode,
    this.browser,
    this.ssr,
  });

  /// Loads the manifest emitted for [outputDirectory]. Returns an empty
  /// manifest (no targets) when the build predates the manifest or emitted
  /// none, so callers can fall back to legacy file names.
  factory BundleManifest.load(Directory outputDirectory) {
    final file = File(p.join(outputDirectory.path, 'bundle_manifest.json'));
    if (!file.existsSync()) {
      return const BundleManifest._(
        schema: 0,
        bundler: 'none',
        mode: 'development',
      );
    }
    final json = jsonDecode(file.readAsStringSync()) as Map<String, Object?>;
    return BundleManifest._(
      schema: (json['schema'] as num?)?.toInt() ?? 0,
      bundler: json['bundler'] as String? ?? 'none',
      mode: json['mode'] as String? ?? 'development',
      browser: json['browser'] is Map<String, Object?>
          ? BundleManifestTarget.fromJson(
              (json['browser'] as Map).cast<String, Object?>(),
            )
          : null,
      ssr: json['ssr'] is Map<String, Object?>
          ? BundleManifestTarget.fromJson(
              (json['ssr'] as Map).cast<String, Object?>(),
            )
          : null,
    );
  }

  /// Entry module for the SSR target relative to the output directory, when a
  /// server-side build was emitted.
  String? get ssrEntry => ssr?.entry;

  /// Entry module for the browser target relative to the output directory,
  /// when a client build was emitted.
  String? get browserEntry => browser?.entry;

  /// Intermediate browser loader, when one was emitted.
  String? get browserLoader => browser?.loader;
}
