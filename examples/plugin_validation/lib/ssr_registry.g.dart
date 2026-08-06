// GENERATED CODE — DO NOT EDIT

import 'package:react/react.dart';
import 'package:plugin_validation/hook_errors.react.dart' show idHookInConditional;
import 'package:plugin_validation/hook_errors.react.dart' show idHookInLoop;
import 'package:plugin_validation/hook_errors.react.dart' show idHookAfterReturn;
import 'package:plugin_validation/hook_errors.react.dart' show idHookCorrect;
import 'package:plugin_validation/ssr_errors.react.dart' show idSsrBadRead;
import 'package:plugin_validation/ssr_errors.react.dart' show idSsrGoodRead;
import 'package:plugin_validation/ssr_errors.react.dart' show idSsrClientOnly;
import 'package:plugin_validation/ssr_errors.react.dart' show idSsrDocumentRead;
import 'package:plugin_validation/valid_component.react.dart' show idGreeting;
import 'package:plugin_validation/valid_component.react.dart' show idCard;

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
  SsrComponentRegistry.register(    idHookInConditional.value, (_) => const Empty());
  SsrComponentRegistry.register(    idHookInLoop.value, (_) => const Empty());
  SsrComponentRegistry.register(    idHookAfterReturn.value, (_) => const Empty());
  SsrComponentRegistry.register(    idHookCorrect.value, (_) => const Empty());
  SsrComponentRegistry.register(    idSsrBadRead.value, (_) => const Empty());
  SsrComponentRegistry.register(    idSsrGoodRead.value, (_) => const Empty());
  SsrComponentRegistry.register(    idSsrClientOnly.value, (_) => const Empty());
  SsrComponentRegistry.register(    idSsrDocumentRead.value, (_) => const Empty());
  SsrComponentRegistry.register(    idGreeting.value, (_) => const Empty());
  SsrComponentRegistry.register(    idCard.value, (_) => const Empty());
}
