import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:source_gen/source_gen.dart';

import '../model/model.dart';

final class ReactTypeReader {
  const ReactTypeReader();

  ReactTypeRef read(DartType type) {
    final code = type.getDisplayString();
    final nullable = _isNullable(type);
    final baseCode = _stripNullability(code);

    if (type is VoidType) {
      return const NamedTypeRef(symbol: 'void');
    }

    if (type.isDartCoreString) {
      return NamedTypeRef(symbol: 'String', nullable: nullable);
    }

    if (type.isDartCoreInt) {
      return NamedTypeRef(symbol: 'int', nullable: nullable);
    }

    if (type.isDartCoreDouble || type.isDartCoreNum) {
      return NamedTypeRef(symbol: 'num', nullable: nullable);
    }

    if (type.isDartCoreBool) {
      return NamedTypeRef(symbol: 'bool', nullable: nullable);
    }

    if (baseCode == 'ReactNode') {
      return NamedTypeRef(symbol: 'ReactNode', nullable: nullable);
    }

    if (type is InterfaceType && type.element.name == 'List') {
      return NamedTypeRef(
        symbol: 'List',
        typeArguments: [read(type.typeArguments.single)],
        nullable: nullable,
      );
    }

    if (type is InterfaceType && type.element.name == 'Map') {
      return NamedTypeRef(
        symbol: 'Map',
        typeArguments: type.typeArguments.map(read).toList(),
        nullable: nullable,
      );
    }

    // ── react_web host types ───────────────────────────────────────────────
    // Recognise any interface whose *base* name is listed in the host-type
    // table, but only when the type originates from `package:react_web`.
    // This prevents an application-defined `Event`/`Node`/`Element` from
    // being misclassified.
    if (type is InterfaceType) {
      final rawName = type.element.name;
      final libUri = type.element.library.uri.toString();
      final isReactWeb =
          libUri.contains('react_web') || libUri.contains('package:web');
      final hostEntry = ReactTypes.webHostTypes[rawName];
      if (hostEntry != null && isReactWeb) {
        final (hostNamespace, typeId) = hostEntry;
        return HostTypeRef(
          hostNamespace: hostNamespace,
          typeId: typeId,
          nullable: nullable,
        );
      }
      // Fallback: if name is a known host type but library is not
      // react_web, still check for exact react_web uri to avoid false
      // positives from user-defined types with same short name.
      if (hostEntry != null && !isReactWeb) {
        // Do not emit HostTypeRef for non-react_web libraries.
      }
    }
    // ── end react_web host types ───────────────────────────────────────────

    if (type is FunctionType) {
      return _readFunction(type);
    }

    if (type is RecordType) {
      return _readRecord(type);
    }

    return NamedTypeRef(symbol: code, nullable: nullable);
  }

  ReactTypeRef _readRecord(RecordType record) {
    final namedFields = <RecordFieldRef>[];

    for (final field in record.namedFields) {
      namedFields.add(RecordFieldRef(name: field.name, type: read(field.type)));
    }

    return RecordTypeRef(named: namedFields, nullable: _isNullable(record));
  }

  ReactTypeRef _readFunction(FunctionType type) {
    final parameters = type.formalParameters;

    for (final parameter in parameters) {
      if (parameter.isNamed || parameter.isOptionalPositional) {
        throw InvalidGenerationSourceError(
          'React callback parameters must currently be required positional parameters. Unsupported callback type: ${type.getDisplayString()}.',
        );
      }
    }

    final returnType = type.returnType;
    final asynchronous =
        returnType is InterfaceType && returnType.element.name == 'Future';

    if (asynchronous) {
      throw InvalidGenerationSourceError(
        'Async React callback results are not implemented yet: ${type.getDisplayString()}.',
      );
    }

    var index = 0;
    return FunctionTypeRef(
      positional: [
        for (final parameter in parameters)
          FunctionParameterRef(
            name: parameter.name ?? 'param${index++}',
            type: read(parameter.type),
          ),
      ],
      result: read(returnType),
      nullable: _isNullable(type),
      asynchronous: false,
    );
  }

  static bool _isNullable(DartType type) =>
      type.nullabilitySuffix == NullabilitySuffix.question;

  static String _stripNullability(String code) {
    if (code.endsWith('?')) {
      return code.substring(0, code.length - 1);
    }

    return code;
  }
}
