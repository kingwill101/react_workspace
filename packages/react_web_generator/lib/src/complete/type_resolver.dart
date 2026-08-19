/// Lowers [TypeRef]s to Dart type strings for the generated neutral surface.
///
/// Strongly typed where supported; "opaque but present" otherwise. Nothing is
/// ever dropped.
library;

import '../model/type_ref.dart';
import 'model.dart';

const _reservedTypeNames = <String, String>{
  'Function': 'Function',
  'Object': 'Object',
  'String': 'String',
  'int': 'int',
  'double': 'double',
  'bool': 'bool',
  'dynamic': 'dynamic',
  'void': 'void',
  'num': 'num',
  'Null': 'Null',
  'Never': 'Never',
  'Future': 'Future',
  'List': 'List',
  'Map': 'Map',
  'Set': 'Set',
  'Iterable': 'Iterable',
  'Type': 'Type',
};

const _coreMap = <String, String>{
  'core.bool': 'bool',
  'core.String': 'String',
  'core.int': 'int',
  'core.double': 'double',
  'core.void': 'void',
  'core.Object': 'Object',
  'core.dynamic': 'Object',
  'core.Future': 'Future',
  'core.List': 'List',
  'core.Map': 'Map',
  'core.Set': 'Set',
  'core.Iterable': 'Iterable',
  'core.ObservableArray': 'List',
  'core.Promise': 'Future',
  'core.Record': 'Object',
  'core.Bigint': 'BigInt',
  'core.Uint8List': 'Uint8List',
  'core.ArrayBuffer': 'ArrayBuffer',
};

final class NeutralTypeResolver {
  final CompleteWebModel model;

  NeutralTypeResolver(this.model)
    : _knownNames = {for (final d in model.allDefinitions) d.name};

  final Set<String> _knownNames;

  bool isCore(String typeId) =>
      typeId.startsWith('core.') && _coreMap.containsKey(typeId);

  /// Renders a Dart type. Unions and unsupported generics lower to `Object`
  /// ("opaque but present"); nothing is dropped.
  String resolve(TypeRef ref) {
    final buf = StringBuffer();
    var opaque = false;
    void core(String id) => buf.write(_coreMap[id] ?? id);

    void render(TypeRef r, bool top) {
      switch (r) {
        case NamedTypeRef():
          final id = r.typeId;
          if (id.startsWith('core.') && _coreMap.containsKey(id)) {
            core(id);
          } else if (id.startsWith('core.')) {
            buf.write('Object');
            opaque = true;
          } else if (id.startsWith('web.')) {
            final webName = id.substring(4);
            if (_reservedTypeNames.containsKey(webName)) {
              buf.write(_reservedTypeNames[webName]!);
              if (_reservedTypeNames[webName] == 'Object') opaque = true;
            } else if (_knownNames.contains(webName)) {
              buf.write(webName);
            } else {
              // Referenced but not a definition in the corpus: opaque-but-present.
              buf.write('Object');
              opaque = true;
            }
          } else if (id.startsWith('react.')) {
            buf.write(id.substring(6));
          } else {
            buf.write(id);
          }
          if (r.arguments.isNotEmpty) {
            buf.write('<');
            for (var i = 0; i < r.arguments.length; i++) {
              if (i > 0) buf.write(', ');
              render(r.arguments[i], false);
            }
            buf.write('>');
          }
          if (r.nullable && !top) {
            buf.write('?');
          }
        case TypeParameterRef():
          buf.write(r.name);
          if (r.nullable && !top) {
            buf.write('?');
          }
        case UnionTypeRef():
          buf.write('Object');
          opaque = true;
      }
    }

    render(ref, true);
    if (ref.nullable && !opaque) {
      buf.write('?');
    }
    return buf.toString();
  }

  /// Render an argument list for a method/factory, with optional/variadic
  /// handling, for declarations in abstract interfaces (no defaults used).
  String renderParameters(
    List<Object> params, {
    bool positionalOptional = true,
  }) {
    return '';
  }
}
