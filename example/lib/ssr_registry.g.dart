// GENERATED CODE — DO NOT EDIT

import 'package:react/react.dart';
import 'package:example/app.react.dart' show idApp;
import 'package:example/avatar.react.dart' show idAvatar;
import 'package:example/badge.react.dart' show idBadge;
import 'package:example/counter.react.dart' show idCounter;

/// Maps canonical component IDs to their SSR builders.
///
/// Generated from the component model. Application-specific defaults
/// (e.g. fallback values) are applied by the application in
/// [registerSsrComponentBuilders].
final class SsrComponentRegistry {
  SsrComponentRegistry._();

  static final _builders = <String, ReactNode Function(Map<String, dynamic>)>{};

  static void register(
    String id,
    ReactNode Function(Map<String, dynamic>) builder,
  ) {
    _builders[id] = builder;
  }

  static ReactNode build(String id, Map<String, dynamic> props) {
    final builder = _builders[id];
    if (builder == null) return const Empty();
    return builder(props);
  }

  static Set<String> get knownIds => _builders.keys.toSet();
}

/// Registers all known component ID placeholders with [SsrComponentRegistry].
/// Application-specific builders must be registered separately using
/// [SsrComponentRegistry.register].
void registerKnownSsComponentIds() {
  SsrComponentRegistry.register(idApp.value, (_) => const Empty());
  SsrComponentRegistry.register(idAvatar.value, (_) => const Empty());
  SsrComponentRegistry.register(idBadge.value, (_) => const Empty());
  SsrComponentRegistry.register(idCounter.value, (_) => const Empty());
}
