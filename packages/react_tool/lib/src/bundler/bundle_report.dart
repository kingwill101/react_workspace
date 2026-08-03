/// Size and composition metrics for one bundled target, emitted in
/// `bundle_report.json` next to `bundle_manifest.json`.
final class BundleReportTarget {
  /// Number of files the bundler emitted for this target (bundle plus any
  /// source map or chunk artifacts).
  final int artifacts;

  final int uncompressedBytes;

  /// Gzip-compressed size of the target bundle.
  final int gzipBytes;

  /// Size of the emitted source map, when source maps are enabled.
  final int? sourceMapBytes;

  /// Packages kept external (shared React instance and wrapper externals).
  final List<String> externals;

  /// Component registration keys retained in the final bundle, e.g.
  /// `reactRouter.Route` or a bare `DatePicker`.
  final List<String> retainedExports;

  /// Hook bridge namespaces retained in the bundle (`reactRouter`,
  /// `__reactDartHooks`, …).
  final List<String> retainedHookNamespaces;

  const BundleReportTarget({
    required this.artifacts,
    required this.uncompressedBytes,
    required this.gzipBytes,
    this.sourceMapBytes,
    required this.externals,
    required this.retainedExports,
    required this.retainedHookNamespaces,
  });

  Map<String, Object?> toJson() => {
    'artifacts': artifacts,
    'uncompressedBytes': uncompressedBytes,
    'gzipBytes': gzipBytes,
    if (sourceMapBytes != null) 'sourceMapBytes': sourceMapBytes,
    'externals': externals,
    'retainedExports': retainedExports,
    'retainedHookNamespaces': retainedHookNamespaces,
  };
}

/// Parsed `bundle_report.json`, describing size and retained-surface metrics
/// for each bundled target.
final class BundleReport {
  final int schema;
  final String mode;
  final BundleReportTarget? browser;
  final BundleReportTarget? ssr;

  const BundleReport._({
    required this.schema,
    required this.mode,
    this.browser,
    this.ssr,
  });

  factory BundleReport.fromJson(Map<String, Object?> json) {
    BundleReportTarget? target(String key) {
      final value = json[key];
      if (value is! Map) return null;
      final map = value.cast<String, Object?>();
      return BundleReportTarget(
        artifacts: (map['artifacts'] as num).toInt(),
        uncompressedBytes: (map['uncompressedBytes'] as num).toInt(),
        gzipBytes: (map['gzipBytes'] as num).toInt(),
        sourceMapBytes: (map['sourceMapBytes'] as num?)?.toInt(),
        externals: List<String>.from(map['externals'] as List? ?? const []),
        retainedExports: List<String>.from(
          map['retainedExports'] as List? ?? const [],
        ),
        retainedHookNamespaces: List<String>.from(
          map['retainedHookNamespaces'] as List? ?? const [],
        ),
      );
    }

    return BundleReport._(
      schema: (json['schema'] as num?)?.toInt() ?? 0,
      mode: json['mode'] as String? ?? 'development',
      browser: target('browser'),
      ssr: target('ssr'),
    );
  }
}
