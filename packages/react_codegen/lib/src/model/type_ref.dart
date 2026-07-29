import 'dart:core';

sealed class ReactTypeRef {
  const ReactTypeRef();
}

final class NamedTypeRef extends ReactTypeRef {
  final String symbol;
  final Uri? import;
  final List<ReactTypeRef> typeArguments;
  final bool nullable;

  const NamedTypeRef({
    required this.symbol,
    this.import,
    this.typeArguments = const [],
    this.nullable = false,
  });
}

final class FunctionTypeRef extends ReactTypeRef {
  final List<FunctionParameterRef> positional;
  final List<FunctionParameterRef> named;
  final ReactTypeRef result;
  final bool nullable;
  final bool asynchronous;

  const FunctionTypeRef({
    this.positional = const [],
    this.named = const [],
    required this.result,
    this.nullable = false,
    this.asynchronous = false,
  });
}

final class RecordTypeRef extends ReactTypeRef {
  final List<RecordFieldRef> positional;
  final List<RecordFieldRef> named;
  final bool nullable;

  const RecordTypeRef({
    this.positional = const [],
    this.named = const [],
    this.nullable = false,
  });
}

final class RecordFieldRef {
  final String name;
  final ReactTypeRef type;

  const RecordFieldRef({required this.name, required this.type});
}

final class FunctionParameterRef {
  final String name;
  final ReactTypeRef type;
  final bool named;
  final bool required;

  const FunctionParameterRef({
    required this.name,
    required this.type,
    this.named = false,
    this.required = true,
  });
}

abstract final class ReactTypes {
  static const string = NamedTypeRef(symbol: 'String');
  static const integer = NamedTypeRef(symbol: 'int');
  static const number = NamedTypeRef(symbol: 'num');
  static const boolean = NamedTypeRef(symbol: 'bool');
  static const reactNode = NamedTypeRef(symbol: 'ReactNode');
  static const voidType = NamedTypeRef(symbol: 'void');
  static const dynamicType = NamedTypeRef(symbol: 'dynamic');
}
