import 'type_ref.dart';

enum ReactValueKind {
  void_,
  string,
  integer,
  number,
  boolean,
  reactNode,
  hostValue,
  encodedObject,
  any,
}

final class ReactValueSpecModel {
  final ReactValueKind kind;
  final bool nullable;
  final String? hostNamespace;
  final String? typeId;
  final String? codecId;

  const ReactValueSpecModel({
    required this.kind,
    this.nullable = false,
    this.hostNamespace,
    this.typeId,
    this.codecId,
  });
}

final class ReactCallbackParameter {
  final String name;
  final ReactTypeRef type;
  final ReactValueSpecModel valueSpec;

  const ReactCallbackParameter({
    required this.name,
    required this.type,
    required this.valueSpec,
  });
}

final class ReactCallbackModel {
  final List<ReactCallbackParameter> positional;
  final ReactTypeRef resultType;
  final ReactValueSpecModel result;
  final bool nullable;
  final bool asynchronous;

  const ReactCallbackModel({
    this.positional = const [],
    required this.resultType,
    required this.result,
    this.nullable = false,
    this.asynchronous = false,
  });
}
