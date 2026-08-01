import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'server_function_model.dart';

/// Reads [@serverFunction] annotations from a library and produces
/// [ServerFunctionModel]s for code generation.
final class ServerFunctionReader {
  static const _serverFunctionChecker = TypeChecker.fromUrl(
    'package:react_actions/src/annotations.dart#ServerFunctionAnnotation',
  );
  static const _serverDataChecker = TypeChecker.fromUrl(
    'package:react_actions/src/annotations.dart#ServerDataAnnotation',
  );

  /// Reads all server functions defined in [library].
  List<ServerFunctionModel> read(LibraryElement library, AssetId input) {
    final results = <ServerFunctionModel>[];

    for (final annotated in LibraryReader(
      library,
    ).annotatedWith(_serverFunctionChecker)) {
      // Use ExecutableElement (same pattern as component_reader.dart)
      if (annotated.element is! ExecutableElement) {
        throw InvalidGenerationSourceError(
          '@serverFunction must be on a top-level function.',
          element: annotated.element,
        );
      }
      final executable = annotated.element as ExecutableElement;

      final name = executable.name!;

      if (executable.formalParameters.isEmpty ||
          !_isValidContextParameter(executable.formalParameters.first)) {
        throw InvalidGenerationSourceError(
          '$name: first parameter must be a required positional '
          'ServerFunctionContext.',
          element: executable,
        );
      }

      // Skip the injected ServerFunctionContext parameter.
      final wireParams = executable.formalParameters.skip(1).toList();

      final namedFields = <FieldSerialization>[];
      for (final param in wireParams) {
        if (!param.isNamed) {
          throw InvalidGenerationSourceError(
            '$name: parameters after the context must be named.',
            element: param,
          );
        }
        if (!param.isRequired) {
          throw InvalidGenerationSourceError(
            '$name: optional named parameters are not supported in Phase 1. '
            "Parameter '${param.name}' must be 'required'.",
            element: param,
          );
        }

        namedFields.add(
          FieldSerialization(
            name: param.name!,
            serialization: _serializeType(param.type, input),
          ),
        );
      }

      final returnType = executable.returnType;
      final resultType = _unwrapFuture(returnType);

      final arguments = RecordSerialization(namedFields);
      final result = _serializeType(resultType, input);

      // Collect all contract URIs from args and result types
      final contractUris = <String>{
        ...collectContractUris(arguments),
        ...collectContractUris(result),
      };

      results.add(
        ServerFunctionModel(
          name: name,
          importUri: _buildImportUri(input),
          contractImportUris: contractUris.toList(),
          arguments: arguments,
          result: result,
        ),
      );
    }

    return results;
  }

  String _buildImportUri(AssetId input) {
    final path = input.path.startsWith('lib/')
        ? input.path.substring('lib/'.length)
        : input.path;
    return 'package:${input.package}/$path';
  }

  bool _isValidContextParameter(FormalParameterElement parameter) {
    if (!parameter.isRequiredPositional) return false;
    final type = parameter.type;
    if (type.nullabilitySuffix != NullabilitySuffix.none ||
        type is! InterfaceType ||
        type.element.name != 'ServerFunctionContext') {
      return false;
    }
    final sourceUri = _elementSourceUri(type.element);
    return sourceUri.endsWith('/react_server/src/context.dart') ||
        sourceUri == 'package:react_server/src/context.dart';
  }

  /// Resolves a [DartType] to a [TypeSerialization] for codec generation.
  TypeSerialization _serializeType(DartType type, AssetId input) {
    final nullable = type.nullabilitySuffix == NullabilitySuffix.question;

    if (type is VoidType) {
      return const VoidSerialization();
    }

    if (type.isDartCoreString) {
      return PrimitiveSerialization('String', nullable: nullable);
    }
    if (type.isDartCoreInt) {
      return PrimitiveSerialization('int', nullable: nullable);
    }
    if (type.isDartCoreDouble) {
      return PrimitiveSerialization('double', nullable: nullable);
    }
    if (type.isDartCoreNum) {
      return PrimitiveSerialization('num', nullable: nullable);
    }
    if (type.isDartCoreBool) {
      return PrimitiveSerialization('bool', nullable: nullable);
    }
    if (type.isDartCoreNull || type.isBottom) {
      return const PrimitiveSerialization('Null');
    }

    // List<T>
    if (type is InterfaceType && type.element.name == 'List') {
      final elementType = type.typeArguments.single;
      return ListSerialization(_serializeType(elementType, input));
    }

    // Map<String, V>
    if (type is InterfaceType && type.element.name == 'Map') {
      final keyType = type.typeArguments[0];
      final valueType = type.typeArguments[1];
      if (!keyType.isDartCoreString) {
        throw InvalidGenerationSourceError(
          'Map keys must be String for server function parameters. '
          'Found: ${keyType.getDisplayString()}',
        );
      }
      return MapSerialization(_serializeType(valueType, input));
    }

    // DateTime / Uri
    if (type is InterfaceType && type.element.name == 'DateTime') {
      return DateTimeSerialization(nullable: nullable);
    }
    if (type is InterfaceType && type.element.name == 'Uri') {
      return UriSerialization(nullable: nullable);
    }

    // Record types
    if (type is RecordType) {
      final fields = <FieldSerialization>[];
      for (final field in type.namedFields) {
        fields.add(
          FieldSerialization(
            name: field.name,
            serialization: _serializeType(field.type, input),
          ),
        );
      }
      return RecordSerialization(fields);
    }

    // Interface or class type
    if (type is InterfaceType) {
      final element = type.element;

      // Check if enum — use ClassElement.getDisplayString approach
      // to avoid relying on isEnum getter
      final isEnum = element is ClassElement && _isEnumClass(element);

      if (isEnum) {
        final cls = element;
        final importUri = _elementSourceUri(cls);
        return EnumSerialization(
          importUri: importUri,
          className: cls.name!,
          nullable: nullable,
        );
      }

      // @serverData class
      if (_serverDataChecker.hasAnnotationOf(element)) {
        final cls = element as ClassElement;
        final fields = _resolveServerDataFields(cls, input);
        final importUri = _elementSourceUri(cls);
        return ServerDataSerialization(
          importUri: importUri,
          className: cls.name!,
          fields: fields,
        );
      }

      throw InvalidGenerationSourceError(
        'Unsupported server function parameter type: '
        "${type.getDisplayString()}. "
        'Only primitives, records, List, Map, DateTime, Uri, enums, '
        'and @serverData classes are supported.',
        element: element,
      );
    }

    throw InvalidGenerationSourceError(
      'Unsupported server function parameter type: '
      "${type.getDisplayString()}.",
    );
  }

  /// Detects if a [ClassElement] is an enum.
  ///
  /// Uses display string heuristic to avoid analyzer API differences
  /// across versions.
  bool _isEnumClass(ClassElement element) {
    // Enums have a synthetic enum superclass and specific metadata.
    // Use the element's display string which includes 'enum'.
    try {
      // Enums are implicitly abstract and have a specific supertype.
      return element.isAbstract && element.supertype?.element.name == 'Enum';
    } catch (_) {
      return false;
    }
  }

  /// Resolves the serializable fields of a @serverData class.
  List<FieldSerialization> _resolveServerDataFields(
    ClassElement element,
    AssetId input,
  ) {
    final fields = <FieldSerialization>[];
    final ctor = element.constructors
        .where((c) => c.isPublic && !c.isFactory)
        .firstOrNull;

    if (ctor != null) {
      for (final param in ctor.formalParameters) {
        if (param.isNamed || param.isRequiredPositional) {
          final field = element.fields.firstWhere(
            (f) => f.name == param.name,
            orElse: () => throw InvalidGenerationSourceError(
              '@serverData class ${element.name} has constructor '
              "parameter '${param.name}' with no matching field.",
              element: element,
            ),
          );
          fields.add(
            FieldSerialization(
              name: param.name!,
              serialization: _serializeType(field.type, input),
            ),
          );
        }
      }
    } else {
      for (final field in element.fields) {
        if (!field.isStatic && field.isPublic) {
          fields.add(
            FieldSerialization(
              name: field.name!,
              serialization: _serializeType(field.type, input),
            ),
          );
        }
      }
    }

    return fields;
  }

  /// Extracts the source URI from an element using safe access.
  String _elementSourceUri(Element element) {
    try {
      // In analyzer 14.x, use firstFragment.source.uri
      final fragment = (element as dynamic).firstFragment;
      if (fragment != null) {
        final source = (fragment as dynamic).source;
        if (source != null) {
          final uri = (source as dynamic).uri;
          if (uri != null) return uri.toString();
        }
      }
    } catch (_) {}
    try {
      // Fallback: use library identifier for element's library
      final lib = (element as dynamic).library;
      if (lib != null) {
        final identifier = (lib as dynamic).identifier;
        if (identifier != null && identifier is String) return identifier;
      }
    } catch (_) {}
    return '';
  }

  DartType _unwrapFuture(DartType type) {
    if (type is InterfaceType &&
        type.element.name == 'Future' &&
        type.typeArguments.length == 1) {
      return type.typeArguments.single;
    }
    return type;
  }
}
