import 'dart:convert';

import 'package:crypto/crypto.dart';

import 'server_function_model.dart';

/// Generates `ServerFunctionJsonCodec<T>` implementations for server
/// function arguments and results.
final class CodecEmitter {
  const CodecEmitter();

  /// Computes the contract hash from the canonical representation.
  String computeContractHash(String canonical) {
    final bytes = utf8.encode(canonical);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }

  /// Returns the codec class name for a given prefix.
  String codecClassName(String functionName, String suffix) =>
      '_\$${_dartSafeName(functionName)}_${suffix}Codec';

  /// Emits the codec class source for the arguments record.
  String emitArgsCodec(ServerFunctionModel model) {
    final args = model.arguments;
    final className = codecClassName(model.name, 'args');
    final dartType = _recordDartType(args);
    final buffer = StringBuffer();

    buffer.writeln(
      'final class $className extends ServerFunctionJsonCodec<'
      '$dartType> {',
    );
    buffer.writeln('  @override');
    buffer.writeln('  $dartType decode(dynamic json) {');
    buffer.writeln(
      '    if (json == null || json is! Map) json = <String, dynamic>{};',
    );
    buffer.writeln('    final m = json as Map<String, dynamic>;');
    for (final field in args.fields) {
      buffer.writeln(
        '    final ${field.name} = '
        '${_decodeExpr(field.serialization, "m['${field.name}']")};',
      );
    }
    final fieldNames = args.fields.map((f) => '${f.name}: ${f.name}');
    buffer.writeln('    return (${fieldNames.join(', ')});');
    buffer.writeln('  }');
    buffer.writeln();
    buffer.writeln('  @override');
    buffer.writeln('  Map<String, dynamic> encode($dartType value) {');
    buffer.writeln('    return {');
    for (final field in args.fields) {
      buffer.writeln(
        "      '${field.name}': "
        '${_encodeExpr(field.serialization, 'value.${field.name}')},',
      );
    }
    buffer.writeln('    };');
    buffer.writeln('  }');
    buffer.writeln('}');
    return buffer.toString();
  }

  /// Emits the codec class source for the result type.
  String emitResultCodec(ServerFunctionModel model) {
    final result = model.result;
    final dartType = _resultDartType(result);
    final className = codecClassName(model.name, 'result');
    final buffer = StringBuffer();

    if (result is VoidSerialization) {
      buffer.writeln(
        'final class $className extends ServerFunctionJsonCodec<'
        'void> {',
      );
      buffer.writeln('  @override');
      buffer.writeln('  void decode(dynamic json) => null;');
      buffer.writeln('  @override');
      buffer.writeln('  Null encode(void value) => null;');
      buffer.writeln('}');
      return buffer.toString();
    }

    buffer.writeln(
      'final class $className extends ServerFunctionJsonCodec<'
      '$dartType> {',
    );
    buffer.writeln('  @override');
    buffer.writeln('  $dartType decode(dynamic json) {');
    buffer.writeln('    return ${_decodeExpr(result, 'json')};');
    buffer.writeln('  }');
    buffer.writeln('  @override');
    buffer.writeln('  dynamic encode($dartType value) {');
    buffer.writeln('    return ${_encodeExpr(result, 'value')};');
    buffer.writeln('  }');
    buffer.writeln('}');
    return buffer.toString();
  }

  String _recordDartType(RecordSerialization record) {
    if (record.fields.isEmpty) return '({})';
    final parts = record.fields.map(
      (f) => '${_typeAnnotation(f.serialization)} ${f.name}',
    );
    return '({${parts.join(', ')}})';
  }

  String _resultDartType(TypeSerialization type) {
    if (type is VoidSerialization) return 'void';
    return _typeAnnotation(type);
  }

  /// Convert a [TypeSerialization] to a Dart type annotation string.
  String _typeAnnotation(TypeSerialization type) {
    if (type is PrimitiveSerialization) {
      return type.nullable ? '${type.dartName}?' : type.dartName;
    }
    if (type is VoidSerialization) return 'void';
    if (type is ListSerialization) {
      return 'List<${_typeAnnotation(type.element)}>';
    }
    if (type is MapSerialization) {
      return 'Map<String, ${_typeAnnotation(type.value)}>';
    }
    if (type is DateTimeSerialization) {
      return type.nullable ? 'DateTime?' : 'DateTime';
    }
    if (type is UriSerialization) {
      return type.nullable ? 'Uri?' : 'Uri';
    }
    if (type is EnumSerialization) {
      return type.nullable ? '${type.className}?' : type.className;
    }
    if (type is RecordSerialization) return _recordDartType(type);
    if (type is ServerDataSerialization) return type.className;
    return 'dynamic';
  }

  /// Generate an encode expression for a value of [type].
  String _encodeExpr(TypeSerialization type, String value) {
    if (type is VoidSerialization ||
        type is PrimitiveSerialization && type.dartName == 'Null') {
      return 'null';
    }
    if (type is PrimitiveSerialization) {
      // String, int, num, double, bool all pass through
      return value;
    }
    if (type is ListSerialization) {
      return '${value}.map((__e) => ${_encodeExpr(type.element, '__e')}).toList()';
    }
    if (type is MapSerialization) {
      return '${value}.map((__k, __v) => MapEntry(__k, ${_encodeExpr(type.value, '__v')}))';
    }
    if (type is DateTimeSerialization) {
      return '${value}.toIso8601String()';
    }
    if (type is UriSerialization) {
      return '${value}.toString()';
    }
    if (type is EnumSerialization) {
      return '${value}.name';
    }
    if (type is RecordSerialization) {
      final parts = type.fields.map(
        (f) =>
            "'${f.name}': ${_encodeExpr(f.serialization, '$value.${f.name}')}",
      );
      return '{${parts.join(', ')}}';
    }
    if (type is ServerDataSerialization) {
      final parts = type.fields.map(
        (f) =>
            "'${f.name}': ${_encodeExpr(f.serialization, '$value.${f.name}')}",
      );
      return '{${parts.join(', ')}}';
    }
    return value;
  }

  /// Generate a decode expression from a JSON variable to the Dart type.
  String _decodeExpr(TypeSerialization type, String jsonVar) {
    if (type is VoidSerialization ||
        type is PrimitiveSerialization && type.dartName == 'Null') {
      return 'null';
    }
    if (type is PrimitiveSerialization) {
      final n = type.dartName;
      final q = type.nullable;
      if (n == 'String')
        return q ? '$jsonVar as String?' : '$jsonVar as String';
      if (n == 'int')
        return q ? '($jsonVar as num?)?.toInt()' : '($jsonVar as num).toInt()';
      if (n == 'num') return q ? '$jsonVar as num?' : '$jsonVar as num';
      if (n == 'double')
        return q
            ? '($jsonVar as num?)?.toDouble()'
            : '($jsonVar as num).toDouble()';
      if (n == 'bool') return q ? '$jsonVar as bool?' : '$jsonVar as bool';
      return q ? '$jsonVar as $n?' : '$jsonVar as $n';
    }
    if (type is ListSerialization) {
      final elem = type.element;
      if (elem is VoidSerialization) {
        return '($jsonVar as List?)?.cast<Never>() ?? <Never>[]';
      }
      final elemDecode = _decodeExpr(elem, '__e');
      final elemType = _typeAnnotation(elem);
      return '($jsonVar as List?)'
          '?.map<$elemType>((__e) => $elemDecode)'
          '.toList() ?? <$elemType>[]';
    }
    if (type is MapSerialization) {
      final val = type.value;
      if (val is VoidSerialization) {
        return '($jsonVar as Map<String, dynamic>?) ?? <String, dynamic>{}';
      }
      final valDecode = _decodeExpr(val, '__v');
      final valType = _typeAnnotation(val);
      return '($jsonVar as Map<String, dynamic>?)'
          '?.map<String, $valType>'
          '((__k, __v) => MapEntry(__k, $valDecode))';
    }
    if (type is DateTimeSerialization) {
      if (type.nullable) {
        return '($jsonVar as String?) != null ? DateTime.parse($jsonVar as String) : null';
      }
      return 'DateTime.parse($jsonVar as String)';
    }
    if (type is UriSerialization) {
      if (type.nullable) {
        return '($jsonVar as String?) != null ? Uri.parse($jsonVar as String) : null';
      }
      return 'Uri.parse($jsonVar as String)';
    }
    if (type is EnumSerialization) {
      if (type.nullable) {
        return '($jsonVar as String?) != null ? ${type.className}.values.byName($jsonVar as String) : null';
      }
      return '${type.className}.values.byName($jsonVar as String)';
    }
    if (type is RecordSerialization) {
      final parts = type.fields.map((f) {
        final decode = _decodeExpr(f.serialization, "m['${f.name}']");
        return '${f.name}: $decode';
      });
      return 'switch ($jsonVar) { dynamic m when m is Map<String, dynamic> => '
          '(${parts.join(', ')}), _ => throw ArgumentError(\'Expected a JSON object\') }';
    }
    if (type is ServerDataSerialization) {
      final parts = type.fields.map((f) {
        final decode = _decodeExpr(f.serialization, "m['${f.name}']");
        return '${f.name}: $decode';
      });
      return 'switch ($jsonVar) { dynamic m when m is Map<String, dynamic> => '
          '${type.className}(${parts.join(', ')}), _ => throw ArgumentError(\'Expected a JSON object\') }';
    }
    return '$jsonVar as dynamic';
  }

  String _dartSafeName(String name) {
    final cleaned = name.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
    if (cleaned.isEmpty) return 'unknown';
    return cleaned[0].toLowerCase() + cleaned.substring(1);
  }
}
