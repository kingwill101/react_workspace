// GENERATED CODE — DO NOT EDIT
// ignore_for_file: type=lint

import 'package:react/react.dart';
import 'package:example/app.react.dart' show idApp;

/// Maps canonical component IDs to their SSR builders.
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

void registerKnownSsComponentIds() {
  SsrComponentRegistry.register(    idApp.value, (_) => const Empty());
}
