import '../model/model.dart';

final class PublicApiEmitter {
  const PublicApiEmitter();

  String emit(ReactLibraryModel model) {
    final buffer = StringBuffer()
      ..writeln('// GENERATED CODE — DO NOT EDIT')
      ..writeln('// ignore_for_file: type=lint')
      ..writeln()
      ..writeln("import 'package:react/react.dart';")
      ..writeln();

    for (final component in model.components) {
      buffer
        ..writeln(
          "const id${component.name} = ComponentId('${component.componentId}');",
        )
        ..writeln(
          "const ${component.name}Metadata = ReactComponentMetadata(name: '${component.name}');",
        )
        ..writeln();
      buffer.writeln('const ${component.name} = _${component.name}Factory();');
      buffer.writeln();
      buffer.writeln('final class _${component.name}Factory {');
      buffer.writeln('  const _${component.name}Factory();');
      buffer.writeln();
      buffer.writeln(
        '  ReactComponentMetadata get metadata => ${component.name}Metadata;',
      );
      buffer.writeln();
      buffer.writeln('  ReactNode call({');
      buffer.writeln('  ${_params(component)}');
      buffer.writeln('  }) {');
      final children = _childrenProp(component);
      if (children != null && _isChildrenList(children)) {
        buffer.writeln(
          '    final normalizedChildren = normalizeChildren(children);',
        );
      }
      buffer.writeln('    final props = ${_propsLiteral(component)};');
      buffer.writeln(
        '    return Component(id${component.name}, props, key: key, children: ${_componentChildren(component)});',
      );
      buffer.writeln('  }');
      buffer.writeln();
      buffer.writeln(
        '  ${component.name}PropsBuilder props() => ${component.name}PropsBuilder();',
      );
      buffer.writeln('}');
      buffer.writeln();

      _emitPropsBuilder(buffer, component);
    }

    return buffer.toString();
  }

  String _params(ReactComponentModel component) {
    final parts = <String>[];

    for (final prop in component.props.where(
      (prop) => prop.name != 'children',
    )) {
      final typeCode = _typeCode(prop.type);
      if (prop.required) {
        parts.add('required $typeCode ${prop.name}');
      } else {
        parts.add('$typeCode ${prop.name}');
      }
    }

    parts.add("String? key");
    final children = _childrenProp(component);
    if (children != null) {
      parts.add(
        _isChildrenList(children)
            ? 'ReactChildren children = const []'
            : 'required ReactNode children',
      );
    }

    return parts.join(',\n  ');
  }

  String _propsLiteral(ReactComponentModel component) {
    final parts = component.props
        .map(
          (prop) => prop.name == 'children' && _isChildrenList(prop)
              ? 'children: normalizedChildren'
              : '${prop.name}: ${prop.name}',
        )
        .join(', ');
    return '($parts)';
  }

  void _emitPropsBuilder(StringBuffer buffer, ReactComponentModel component) {
    buffer.writeln('final class ${component.name}PropsBuilder {');
    for (final prop in component.props.where(
      (prop) => prop.name != 'children',
    )) {
      final typeCode = _typeCode(prop.type);
      buffer.writeln(
        prop.required
            ? '  late $typeCode ${prop.name};'
            : '  $typeCode ${prop.name};',
      );
    }
    buffer.writeln('  String? key;');
    final children = _childrenProp(component);
    if (children != null) {
      buffer.writeln(
        _isChildrenList(children)
            ? '  ReactChildren children = const [];'
            : '  late ReactNode children;',
      );
    }
    buffer.writeln();
    buffer.writeln(switch (children) {
      null => '  ReactNode call() {',
      final child when _isChildrenList(child) =>
        '  ReactNode call([ReactChildren? childValues]) {',
      _ => '  ReactNode call([ReactNode? childValue]) {',
    });
    buffer.writeln('    return ${component.name}(');
    for (final prop in component.props.where(
      (prop) => prop.name != 'children',
    )) {
      buffer.writeln('      ${prop.name}: ${prop.name},');
    }
    buffer.writeln('      key: key,');
    if (children != null) {
      buffer.writeln(
        _isChildrenList(children)
            ? '      children: childValues ?? this.children,'
            : '      children: childValue ?? this.children,',
      );
    }
    buffer.writeln('    );');
    buffer.writeln('  }');
    buffer.writeln('}');
    buffer.writeln();
  }

  ReactPropModel? _childrenProp(ReactComponentModel component) {
    for (final prop in component.props) {
      if (prop.name == 'children') return prop;
    }
    return null;
  }

  bool _isChildrenList(ReactPropModel prop) =>
      prop.type is NamedTypeRef && (prop.type as NamedTypeRef).symbol == 'List';

  String _componentChildren(ReactComponentModel component) {
    final children = _childrenProp(component);
    if (children == null) return 'const []';
    return _isChildrenList(children) ? 'normalizedChildren' : '[children]';
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
      final named = type.named.isEmpty
          ? ''
          : '{${type.named.map((p) => '${_typeCode(p.type)} ${p.name}').join(', ')}}';
      final suffix = type.nullable ? '?' : '';
      return '${_typeCode(type.result)} Function($params${named.isEmpty ? '' : ' $named'})$suffix';
    }

    return 'dynamic';
  }
}
