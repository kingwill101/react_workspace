/// Describes how to serialize a type for JSON transport.
sealed class TypeSerialization {
  const TypeSerialization();

  /// Canonical type representation for contract hashing.
  String get canonical;
}

/// A primitive JSON type (String, int, double, bool, Null).
final class PrimitiveSerialization extends TypeSerialization {
  final String dartName;
  final bool nullable;

  const PrimitiveSerialization(this.dartName, {this.nullable = false});

  @override
  String get canonical => nullable ? '$dartName?' : dartName;
}

/// The `void` type — no value is returned.
final class VoidSerialization extends TypeSerialization {
  const VoidSerialization();

  @override
  String get canonical => 'void';
}

/// A `List<T>` type.
final class ListSerialization extends TypeSerialization {
  final TypeSerialization element;

  const ListSerialization(this.element);

  @override
  String get canonical => 'List<${element.canonical}>';
}

/// A `Map<String, V>` type.
final class MapSerialization extends TypeSerialization {
  final TypeSerialization value;

  const MapSerialization(this.value);

  @override
  String get canonical => 'Map<String,${value.canonical}>';
}

/// A `DateTime` type.
final class DateTimeSerialization extends TypeSerialization {
  final bool nullable;

  const DateTimeSerialization({this.nullable = false});

  @override
  String get canonical => nullable ? 'DateTime?' : 'DateTime';
}

/// A `Uri` type.
final class UriSerialization extends TypeSerialization {
  final bool nullable;

  const UriSerialization({this.nullable = false});

  @override
  String get canonical => nullable ? 'Uri?' : 'Uri';
}

/// An enum type.
final class EnumSerialization extends TypeSerialization {
  final String importUri;
  final String className;
  final bool nullable;

  const EnumSerialization({
    required this.importUri,
    required this.className,
    this.nullable = false,
  });

  @override
  String get canonical => nullable ? '$className?' : className;
}

/// A record type `({K1 v1, K2 v2, ...})`.
final class RecordSerialization extends TypeSerialization {
  final List<FieldSerialization> fields;

  const RecordSerialization(this.fields);

  @override
  String get canonical {
    final parts = fields.map((f) => '${f.serialization.canonical} ${f.name}');
    return '({${parts.join(', ')}})';
  }
}

/// A `@serverData` class.
final class ServerDataSerialization extends TypeSerialization {
  final String importUri;
  final String className;
  final List<FieldSerialization> fields;

  const ServerDataSerialization({
    required this.importUri,
    required this.className,
    required this.fields,
  });

  @override
  String get canonical =>
      '$className(${fields.map((f) => '${f.serialization.canonical} ${f.name}').join(', ')})';
}

/// Collects all contract import URIs referenced by [type] and its children.
Set<String> collectContractUris(TypeSerialization type) {
  return switch (type) {
    ServerDataSerialization(importUri: var uri, fields: var fields) => {
      if (uri.isNotEmpty) uri,
      ...fields.expand((f) => collectContractUris(f.serialization)),
    },
    EnumSerialization(importUri: var uri) => {if (uri.isNotEmpty) uri},
    ListSerialization(element: var e) => collectContractUris(e),
    MapSerialization(value: var v) => collectContractUris(v),
    RecordSerialization(fields: var fields) =>
      fields.expand((f) => collectContractUris(f.serialization)).toSet(),
    _ => <String>{},
  };
}

/// Field description for records and @serverData classes.
final class FieldSerialization {
  final String name;
  final TypeSerialization serialization;

  const FieldSerialization({required this.name, required this.serialization});
}

/// A parsed server function ready for code generation.
final class ServerFunctionModel {
  /// The function's Dart name.
  final String name;

  /// The package-relative URI for this function's own library.
  final String importUri;

  /// URIs for all contract libraries referenced by [arguments] and [result].
  ///
  /// These are the files that define `@serverData` classes and enums
  /// used by this function. The generated action file imports these
  /// instead of [importUri] (which is server-only).
  final List<String> contractImportUris;

  /// Serialization for the arguments record.
  ///
  /// This is always a [RecordSerialization] with the named parameters
  /// (excluding the [ServerFunctionContext] first parameter).
  final RecordSerialization arguments;

  /// Serialization for the return value.
  final TypeSerialization result;

  /// Canonical identifier shared by the generated client and registry.
  String get functionId => '$importUri#$name';

  /// Canonical contract string used for hashing.
  String get contractCanonical =>
      '$functionId|${arguments.canonical}|${result.canonical}';

  /// The basename of the source file without extension.
  ///
  /// For `package:example/lib/todos/todos_actions.dart`, returns
  /// `todos_actions`. Used to derive the `.action.g.dart` import path.
  String get sourceFileName {
    final segments = importUri.split('/');
    final last = segments.last; // e.g. "todos_actions.dart"
    if (last.endsWith('.dart')) {
      return last.substring(0, last.length - '.dart'.length);
    }
    return last;
  }

  const ServerFunctionModel({
    required this.name,
    required this.importUri,
    this.contractImportUris = const [],
    required this.arguments,
    required this.result,
  });
}
