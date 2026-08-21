/// React package versions supported and provisioned by `react_tool`.
///
/// Keep wrapper peer ranges, scaffold manifests, compatibility tests, and the
/// maintainer documentation synchronized with these values.
abstract final class ReactVersionPolicy {
  /// The React version installed when no wrapper or host project selects one.
  static const managedVersion = '18.3.1';

  /// The npm peer range accepted from React wrapper packages.
  static const supportedPeerRange = '>=18 <20';

  /// The boundary versions used by compatibility validation.
  static const compatibilityBaselines = ['18.3.1', '19.0.0'];
}
