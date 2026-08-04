/// Raw collections read directly from a `web_apis.json` snapshot, before
/// partial merging / `includes` folding.
library;

import 'definition.dart';
import 'member.dart';

final class RawWebModel {
  final Map<String, List<IdlInterface>> interfaces;
  final Map<String, List<IdlMixin>> mixins;
  final Map<String, List<IdlDictionary>> dictionaries;
  final Map<String, List<IdlNamespace>> namespaces;
  final Map<String, IdlEnum> enums;
  final Map<String, IdlTypedef> typedefs;
  final Map<String, IdlCallback> callbacks;
  final Map<String, IdlCallbackInterface> callbackInterfaces;
  final List<IdlIncludes> includes;
  final Map<String, String> specOf;

  const RawWebModel({
    required this.interfaces,
    required this.mixins,
    required this.dictionaries,
    required this.namespaces,
    required this.enums,
    required this.typedefs,
    required this.callbacks,
    required this.callbackInterfaces,
    required this.includes,
    required this.specOf,
  });
}
