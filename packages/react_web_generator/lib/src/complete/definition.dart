/// Web IDL definition kinds for the complete model.
library;

import '../model/type_ref.dart';
import 'member.dart';

sealed class WebIdlDefinition {
  final String name;
  /// Specification module this definition was declared in (a key of `idl`).
  final String spec;
  final List<ExtAttr> extAttrs;

  const WebIdlDefinition({
    required this.name,
    required this.spec,
    this.extAttrs = const [],
  });

  String get kindName;

  Map<String, Object?> toJson();
}

final class IdlInterface extends WebIdlDefinition {
  final String? inheritance;
  final List<IdlMember> members;
  /// names of interface mixins pulled in via `X includes Y`.
  final List<String> includedMixins;
  final bool partial;

  const IdlInterface({
    required super.name,
    required super.spec,
    this.inheritance,
    this.members = const [],
    this.includedMixins = const [],
    this.partial = false,
    super.extAttrs = const [],
  });

  @override
  String get kindName => 'interface';

  @override
  Map<String, Object?> toJson() => {
    'kind': 'interface',
    'name': name,
    'spec': spec,
    if (inheritance != null) 'inheritance': inheritance,
    'members': members.map((m) => m.toJson()).toList(),
    'includedMixins': includedMixins,
    'partial': partial,
  };
}

final class IdlMixin extends WebIdlDefinition {
  final List<IdlMember> members;
  final bool partial;

  const IdlMixin({
    required super.name,
    required super.spec,
    this.members = const [],
    this.partial = false,
    super.extAttrs = const [],
  });

  @override
  String get kindName => 'mixin';

  @override
  Map<String, Object?> toJson() => {
    'kind': 'mixin',
    'name': name,
    'spec': spec,
    'members': members.map((m) => m.toJson()).toList(),
    'partial': partial,
  };
}

final class IdlDictionary extends WebIdlDefinition {
  final String? inheritance;
  final List<IdlField> fields;
  final bool partial;

  const IdlDictionary({
    required super.name,
    required super.spec,
    this.inheritance,
    this.fields = const [],
    this.partial = false,
    super.extAttrs = const [],
  });

  @override
  String get kindName => 'dictionary';

  @override
  Map<String, Object?> toJson() => {
    'kind': 'dictionary',
    'name': name,
    'spec': spec,
    if (inheritance != null) 'inheritance': inheritance,
    'fields': fields.map((f) => f.toJson()).toList(),
    'partial': partial,
  };
}

final class IdlNamespace extends WebIdlDefinition {
  final List<IdlMember> members;
  final bool partial;

  const IdlNamespace({
    required super.name,
    required super.spec,
    this.members = const [],
    this.partial = false,
    super.extAttrs = const [],
  });

  @override
  String get kindName => 'namespace';

  @override
  Map<String, Object?> toJson() => {
    'kind': 'namespace',
    'name': name,
    'spec': spec,
    'members': members.map((m) => m.toJson()).toList(),
    'partial': partial,
  };
}

final class IdlEnum extends WebIdlDefinition {
  final List<String> values;

  const IdlEnum({
    required super.name,
    required super.spec,
    this.values = const [],
    super.extAttrs = const [],
  });

  @override
  String get kindName => 'enum';

  @override
  Map<String, Object?> toJson() => {
    'kind': 'enum',
    'name': name,
    'spec': spec,
    'values': values,
  };
}

final class IdlTypedef extends WebIdlDefinition {
  final TypeRef type;

  const IdlTypedef({
    required super.name,
    required super.spec,
    required this.type,
    super.extAttrs = const [],
  });

  @override
  String get kindName => 'typedef';

  @override
  Map<String, Object?> toJson() => {
    'kind': 'typedef',
    'name': name,
    'spec': spec,
    'type': type.toJson(),
  };
}

final class IdlCallback extends WebIdlDefinition {
  final TypeRef returnType;
  final List<IdlParameter> parameters;

  const IdlCallback({
    required super.name,
    required super.spec,
    required this.returnType,
    this.parameters = const [],
    super.extAttrs = const [],
  });

  @override
  String get kindName => 'callback';

  @override
  Map<String, Object?> toJson() => {
    'kind': 'callback',
    'name': name,
    'spec': spec,
    'returnType': returnType.toJson(),
    'parameters': parameters.map((p) => p.toJson()).toList(),
  };
}

final class IdlCallbackInterface extends WebIdlDefinition {
  final List<IdlMember> members;

  const IdlCallbackInterface({
    required super.name,
    required super.spec,
    this.members = const [],
    super.extAttrs = const [],
  });

  @override
  String get kindName => 'callbackInterface';

  @override
  Map<String, Object?> toJson() => {
    'kind': 'callbackInterface',
    'name': name,
    'spec': spec,
    'members': members.map((m) => m.toJson()).toList(),
  };
}

final class IdlIncludes extends WebIdlDefinition {
  /// The interface that includes the mixin.
  final String target;
  /// The mixin that gets included.
  final String includes;

  const IdlIncludes({
    required super.name,
    required super.spec,
    required this.target,
    required this.includes,
  });

  @override
  String get kindName => 'includes';

  @override
  Map<String, Object?> toJson() => {
    'kind': 'includes',
    'name': name,
    'spec': spec,
    'target': target,
    'includes': includes,
  };
}
