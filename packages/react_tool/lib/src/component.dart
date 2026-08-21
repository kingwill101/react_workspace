import 'package:artisanal/args.dart';

import 'project_config.dart';

/// CLI commands for declaring local foreign React components.
final class ComponentCommand extends Command<void> {
  ComponentCommand() {
    addSubcommand(_AddComponentCommand());
  }

  @override
  String get name => 'component';

  @override
  String get description => 'Manage foreign React component declarations.';
}

final class _AddComponentCommand extends Command<void> {
  _AddComponentCommand() {
    argParser.addOption(
      'export',
      defaultsTo: 'default',
      help: 'The TypeScript export to register (default: default).',
    );
  }

  @override
  String get name => 'add';

  @override
  String get description =>
      'Declare a local React component and its Dart-facing props.';

  @override
  String get invocation =>
      'react component add <runtime-name> <module> [<prop:type> ...]';

  @override
  Future<void> run() async {
    final rest = argResults!.rest;
    if (rest.length < 2) {
      usageException(
        'Expected a runtime name, module path, and optional prop:type values.',
      );
    }

    final config = ReactProjectConfig.load();
    final reactFile = config.file('react.yaml');
    if (!reactFile.existsSync()) {
      throw const ReactToolException(
        '`react component add` requires an explicit react.yaml file so it can '
        'preserve the project configuration. Create one with `react init` '
        'or add react.yaml first.',
      );
    }

    final name = _validateScalar(rest[0], 'runtime name');
    final module = _validateScalar(rest[1], 'module path');
    final moduleFile = config.file(module);
    if (!moduleFile.existsSync()) {
      throw ReactToolException(
        'Component module does not exist: ${moduleFile.path}',
      );
    }

    final props = <String, String>{};
    for (final raw in rest.skip(2)) {
      final separator = raw.indexOf(':');
      if (separator <= 0 || separator == raw.length - 1) {
        usageException('Invalid prop "$raw". Use <name>:<DartType>.');
      }
      final propName = _validateIdentifier(raw.substring(0, separator));
      final type = _validateScalar(
        raw.substring(separator + 1),
        'type for $propName',
      );
      if (props.containsKey(propName)) {
        usageException('Prop "$propName" was provided more than once.');
      }
      props[propName] = type;
    }

    if (config.foreignComponents.any((component) => component.name == name)) {
      throw ReactToolException(
        'A foreign component named "$name" is already declared.',
      );
    }

    final exportName = _validateScalar(
      option('export') as String? ?? 'default',
      'export name',
    );
    final updated = addForeignComponentYaml(
      reactFile.readAsStringSync(),
      name: name,
      module: module,
      exportName: exportName,
      props: props,
    );
    reactFile.writeAsStringSync(updated);
    info('Declared $name from $module in ${reactFile.path}.');
    info('Run `dart run react_tool:react generate` to write the Dart wrapper.');
  }
}

/// Adds one component to a structured `foreign.components` block.
///
/// This function deliberately edits only the foreign component section and
/// refuses ambiguous legacy list-shaped `foreign:` blocks. Keeping the text
/// update narrow preserves comments and unrelated project configuration.
String addForeignComponentYaml(
  String source, {
  required String name,
  required String module,
  required String exportName,
  Map<String, String> props = const {},
}) {
  final lines = source.split('\n');
  if (lines.isEmpty) {
    return _newForeignComponentsYaml(
      name,
      module,
      exportName,
      props,
    ).join('\n');
  }

  final foreignIndex = lines.indexWhere(
    (line) => line.trimRight() == 'foreign:',
  );
  final entry = _componentYaml(name, module, exportName, props);
  if (foreignIndex < 0) {
    final result = StringBuffer(source);
    if (!source.endsWith('\n')) result.write('\n');
    if (source.isNotEmpty) result.write('\n');
    result.write(
      _newForeignComponentsYaml(name, module, exportName, props).join('\n'),
    );
    return result.toString();
  }

  final componentsIndex = _findComponentsIndex(lines, foreignIndex);
  if (componentsIndex >= 0) {
    final insertion = _blockEnd(lines, componentsIndex, 2);
    lines.insertAll(insertion, entry);
  } else {
    final foreignEnd = _blockEnd(lines, foreignIndex, 0);
    final next = foreignIndex + 1 < lines.length ? lines[foreignIndex + 1] : '';
    if (next.trimLeft().startsWith('-')) {
      throw const ReactToolException(
        'The `foreign:` block uses the legacy list form. Convert it to '
        '`foreign:\n  components:` before using `component add`.',
      );
    }
    lines.insertAll(foreignEnd, ['  components:', ...entry]);
  }
  return lines.join('\n');
}

int _findComponentsIndex(List<String> lines, int foreignIndex) {
  for (var i = foreignIndex + 1; i < lines.length; i++) {
    final line = lines[i];
    if (line.trim().isEmpty) continue;
    if (_indent(line) <= 0) break;
    if (_indent(line) == 2 && line.trim() == 'components:') return i;
  }
  return -1;
}

int _blockEnd(List<String> lines, int start, int parentIndent) {
  for (var i = start + 1; i < lines.length; i++) {
    final line = lines[i];
    if (line.trim().isEmpty) continue;
    if (_indent(line) <= parentIndent) return i;
  }
  return lines.length;
}

int _indent(String line) => line.length - line.trimLeft().length;

List<String> _newForeignComponentsYaml(
  String name,
  String module,
  String exportName,
  Map<String, String> props,
) => [
  'foreign:',
  '  components:',
  ..._componentYaml(name, module, exportName, props),
];

List<String> _componentYaml(
  String name,
  String module,
  String exportName,
  Map<String, String> props,
) => [
  '    - name: ${_yamlScalar(name)}',
  '      module: ${_yamlScalar(module)}',
  '      export: ${_yamlScalar(exportName)}',
  if (props.isNotEmpty) ...[
    '      props:',
    for (final entry in props.entries)
      '        ${entry.key}: ${_yamlScalar(entry.value)}',
  ],
];

String _yamlScalar(String value) => "'${value.replaceAll("'", "''")}'";

String _validateScalar(String value, String label) {
  if (value.trim().isEmpty || value.contains('\n') || value.contains('\r')) {
    throw ReactToolException('Invalid $label "$value".');
  }
  return value;
}

String _validateIdentifier(String value) {
  if (!RegExp(r'^[A-Za-z_][A-Za-z0-9_]*$').hasMatch(value)) {
    throw ReactToolException('Invalid prop name "$value".');
  }
  return value;
}
