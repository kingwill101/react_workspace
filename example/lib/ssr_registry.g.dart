// GENERATED CODE — DO NOT EDIT

import 'package:react/react.dart';

/// Maps canonical component IDs to their SSR builders.
///
/// Generated from the component model. Application-specific defaults
/// (e.g. fallback values) are applied by the application in
/// [SsrComponentRegistry.register].
final class SsrComponentRegistry {
  SsrComponentRegistry._();

  static final _builders = <String, ReactNode Function(Map<String, dynamic>)>{};

  static void register(String id, ReactNode Function(Map<String, dynamic>) builder) {
    _builders[id] = builder;
  }

  static ReactNode build(String id, Map<String, dynamic> props) {
    final builder = _builders[id];
    if (builder == null) return const Empty();
    return builder(props);
  }

  static Set<String> get knownIds => _builders.keys.toSet();
}