import '../model/model.dart';

final class PublicApiEmitter {
  const PublicApiEmitter();

  String emit(ReactLibraryModel model) {
    final buffer = StringBuffer();

    for (final component in model.components) {
      buffer.writeln("import 'package:react/react.dart';");
      buffer.writeln();
      buffer.writeln("const id${component.name} = ComponentId('${component.componentId}');");
      buffer.writeln();
      buffer.writeln('ReactNode ${component.name}({');
      buffer.writeln('  ${_params(component)}');
      buffer.writeln('}) {');
      buffer.writeln('  final props = ${_propsLiteral(component)};');
      buffer.writeln('  return Component(id${component.name}, props, key: key, children: children);');
      buffer.writeln('}');
      buffer.writeln();
    }

    return buffer.toString();
  }

  String _params(ReactComponentModel component) {
    final parts = <String>[];

    for (final prop in component.props) {
      final typeCode = _typeCode(prop.type);
      if (prop.required) {
        parts.add('required $typeCode ${prop.name}');
      } else {
        parts.add('$typeCode ${prop.name}');
      }
    }

    parts.add("String? key");
    parts.add("List<ReactNode> children = const []");

    return parts.join(',\n  ');
  }

  String _propsLiteral(ReactComponentModel component) {
    final parts = component.props.map((prop) => '${prop.name}: ${prop.name}').join(', ');
    return '($parts)';
  }

  String _typeCode(ReactTypeRef type) {
    if (type is NamedTypeRef) {
      final args = type.typeArguments.map(_typeCode).join(', ');
      final suffix = args.isEmpty ? '' : '<$args>';
      final nullable = type.nullable ? '?' : '';
      return '${type.symbol}$suffix$nullable';
    }

    if (type is FunctionTypeRef) {
      final params = type.positional.map((p) => _typeCode(p.type)).join(', ');
      final named = type.named.isEmpty ? '' : '{${type.named.map((p) => '${_typeCode(p.type)} ${p.name}').join(', ')}}';
      final suffix = type.nullable ? '?' : '';
      return '${_typeCode(type.result)} Function($params${named.isEmpty ? '' : ' $named'})$suffix';
    }

    return 'dynamic';
  }
}
