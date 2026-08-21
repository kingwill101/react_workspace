import 'dart:io';

import 'package:artisanal/args.dart';
import 'package:path/path.dart' as p;

import 'build.dart';
import 'project_config.dart';
import 'ts_bindings.dart';

/// CLI commands for declaring foreign React components.
final class ComponentCommand extends Command<void> {
  ComponentCommand({Directory? workingDirectory})
    : _workingDirectory = workingDirectory ?? Directory.current {
    addSubcommand(_AddComponentCommand(_workingDirectory));
  }

  final Directory _workingDirectory;

  @override
  String get name => 'component';

  @override
  String get description => 'Manage foreign React component declarations.';
}

final class _AddComponentCommand extends Command<void> {
  _AddComponentCommand(this._workingDirectory) {
    argParser
      ..addOption(
        'export',
        defaultsTo: 'default',
        help: 'The TypeScript export to register (default: default).',
      )
      ..addFlag(
        'infer',
        defaultsTo: false,
        help: 'Infer prop types from the local TypeScript declaration.',
      )
      ..addOption(
        'version',
        defaultsTo: '*',
        help: 'npm version range for a bare package module (default: *).',
      )
      ..addOption(
        'style',
        help: 'Local CSS/Sass entrypoint to include with this component.',
      )
      ..addFlag(
        'validate',
        defaultsTo: true,
        help: 'Generate the wrapper and validate the project bundle.',
      );
  }

  final Directory _workingDirectory;

  @override
  String get name => 'add';

  @override
  String get description =>
      'Declare a React component and its Dart-facing props.';

  @override
  String get invocation =>
      'react component add <runtime-name> <module> [<prop:type> ...] '
      '| <npm-module> --export <Export>';

  @override
  Future<void> run() async {
    final rest = argResults!.rest;
    if (rest.isEmpty) {
      usageException(
        'Expected a runtime name and module path, or one bare npm module '
        'with --export.',
      );
    }

    final config = ReactProjectConfig.load(_workingDirectory);
    final reactFile = config.file('react.yaml');
    if (!reactFile.existsSync()) {
      throw const ReactToolException(
        '`react component add` requires an explicit react.yaml file so it can '
        'preserve the project configuration. Create one with `react init` '
        'or add react.yaml first.',
      );
    }

    final exportName = _validateScalar(
      option('export') as String? ?? 'default',
      'export name',
    );
    final candidate = _validateScalar(rest.first, 'module path');
    final candidateFile = config.file(candidate);
    final shorthand =
        rest.length == 1 &&
        !candidateFile.existsSync() &&
        _isNpmSpecifier(candidate);
    if (rest.length < 2 && !shorthand) {
      usageException(
        'Expected a runtime name and module path, or one bare npm module '
        'with --export.',
      );
    }
    final module = _validateScalar(
      shorthand ? candidate : rest[1],
      'module path',
    );
    final name = _validateScalar(
      shorthand
          ? exportName == 'default'
                ? defaultNpmComponentName(module)
                : exportName
          : rest[0],
      'runtime name',
    );
    final moduleFile = config.file(module);
    final localModule = moduleFile.existsSync();
    if (!localModule && !_isNpmSpecifier(module)) {
      throw ReactToolException(
        'Component module does not exist: ${moduleFile.path}',
      );
    }

    final props = <String, String>{};
    for (final raw in rest.skip(shorthand ? 1 : 2)) {
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

    final infer = option('infer') as bool? ?? false;
    if (infer) {
      if (exportName == 'default') {
        throw const ReactToolException(
          '`--infer` currently requires a named export. Pass '
          '`--export ComponentName`.',
        );
      }
      final inferred = await inferForeignComponentProps(
        config: config,
        module: module,
        exportName: exportName,
      );
      for (final entry in inferred.entries) {
        props.putIfAbsent(entry.key, () => entry.value);
      }
    }

    if (config.foreignComponents.any((component) => component.name == name)) {
      throw ReactToolException(
        'A foreign component named "$name" is already declared.',
      );
    }
    final original = reactFile.readAsStringSync();
    var updated = addForeignComponentYaml(
      original,
      name: name,
      module: module,
      exportName: exportName,
      props: props,
      dependencies: localModule
          ? const {}
          : {module: option('version') as String? ?? '*'},
    );
    final style = option('style') as String?;
    if (style != null) {
      final styleFile = config.file(style);
      if (!styleFile.existsSync()) {
        throw ReactToolException(
          'Component stylesheet does not exist: ${styleFile.path}',
        );
      }
      updated = addStylesheetYaml(updated, style);
    }
    await runForeignComponentManifestTransaction(
      file: reactFile,
      original: original,
      updated: updated,
      action: () async {
        info('Declared $name from $module in ${reactFile.path}.');
        await generateAndValidateForeignComponents(
          config,
          validate: option('validate') as bool? ?? true,
          log: line,
        );
      },
    );
  }
}

/// Writes a manifest update and restores [original] if the follow-up action
/// fails. This keeps declaration edits atomic with wrapper generation and
/// build validation.
Future<void> runForeignComponentManifestTransaction({
  required File file,
  required String original,
  required String updated,
  required Future<void> Function() action,
}) async {
  try {
    file.writeAsStringSync(updated);
    await action();
  } catch (_) {
    file.writeAsStringSync(original);
    rethrow;
  }
}

/// Generates project foreign-component wrappers and, by default, validates
/// the browser/SSR bundle through the normal build pipeline.
Future<void> generateAndValidateForeignComponents(
  ReactProjectConfig config, {
  required bool validate,
  required void Function(String message) log,
}) async {
  final builder = ReactBuilder(config: config, release: false, log: log);
  if (validate) {
    await builder.build();
    log('Generated wrappers and validated the React bundle.');
  } else {
    await builder.generateSources();
    log('Generated sources are ready in lib/.generated/.');
  }
}

/// Infers Dart-facing prop types for a named component in a local TypeScript
/// module.
///
/// The module must expose a typed component declaration that the TypeScript
/// extractor can identify. This is intentionally shared by the generic and
/// convenience component commands so there is one inference path to maintain.
Future<Map<String, String>> inferForeignComponentProps({
  required ReactProjectConfig config,
  required String module,
  required String exportName,
}) async {
  final moduleFile = config.file(module);
  final localModule = moduleFile.existsSync();
  final npmRoot = Directory('${config.root.path}/node_modules').existsSync()
      ? config.root.path
      : (await ReactBuilder(
          config: config,
          release: false,
          log: (_) {},
        ).ensureJsEnvironment())?.npmRoot;
  if (npmRoot == null) {
    throw const ReactToolException(
      'Cannot infer props without a Node dependency root. Run `npm install` '
      'or `react js install` first.',
    );
  }

  final result = await TsBindingExtractor(npmRoot).extract(
    specifier: module,
    names: [exportName],
    entry: localModule ? moduleFile.absolute.path : null,
  );
  final declaration = result.declarations.where(
    (declaration) => declaration.name == exportName,
  );
  if (declaration.length != 1 || declaration.single.kind != 'component') {
    throw ReactToolException(
      'Export "$exportName" in $module is not an inferrable React component. '
      'For package-specific member paths that are not declared as typed '
      'object members, provide explicit props.',
    );
  }
  return {
    for (final prop in declaration.single.props)
      prop.name: _dartTypeForInferredProp(prop),
  };
}

String _dartTypeForInferredProp(TsIrProp prop) {
  final base = switch (prop.type.kind) {
    'string' || 'literal' => 'String',
    'number' => 'num',
    'boolean' => 'bool',
    'reactNode' => 'ReactNode',
    'function' || 'hostValue' => 'Function',
    'array' || 'tuple' => 'List<Object?>',
    'object' || 'record' => 'Map<String, Object?>',
    _ => 'Object',
  };
  return prop.required ? base : '$base?';
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
  Map<String, String> dependencies = const {},
}) {
  final lines = source.split('\n');
  if (lines.isEmpty) {
    return _newForeignComponentsYaml(
      name,
      module,
      exportName,
      props,
      dependencies,
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
      _newForeignComponentsYaml(
        name,
        module,
        exportName,
        props,
        dependencies,
      ).join('\n'),
    );
    return result.toString();
  }

  if (dependencies.isNotEmpty) {
    _addForeignDependencies(lines, foreignIndex, dependencies);
  }

  final currentForeignIndex = lines.indexWhere(
    (line) => line.trimRight() == 'foreign:',
  );
  final componentsIndex = _findComponentsIndex(lines, currentForeignIndex);
  if (componentsIndex >= 0) {
    final insertion = _blockEnd(lines, componentsIndex, 2);
    lines.insertAll(insertion, entry);
  } else {
    final foreignEnd = _blockEnd(lines, currentForeignIndex, 0);
    final next = currentForeignIndex + 1 < lines.length
        ? lines[currentForeignIndex + 1]
        : '';
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
  Map<String, String> dependencies,
) => [
  'foreign:',
  if (dependencies.isNotEmpty) ...[
    '  dependencies:',
    ..._dependencyYaml(dependencies),
  ],
  '  components:',
  ..._componentYaml(name, module, exportName, props),
];

void _addForeignDependencies(
  List<String> lines,
  int foreignIndex,
  Map<String, String> dependencies,
) {
  final existing = _findSectionIndex(lines, foreignIndex, 'dependencies');
  if (existing >= 0) {
    lines.insertAll(
      _blockEnd(lines, existing, 2),
      _dependencyYaml(dependencies),
    );
    return;
  }
  final insertion = _blockEnd(lines, foreignIndex, 0);
  lines.insertAll(insertion, [
    '  dependencies:',
    ..._dependencyYaml(dependencies),
  ]);
}

List<String> _dependencyYaml(Map<String, String> dependencies) => [
  for (final entry in dependencies.entries)
    '    ${_yamlScalar(entry.key)}: ${_yamlScalar(entry.value)}',
];

int _findSectionIndex(List<String> lines, int parentIndex, String section) {
  for (var i = parentIndex + 1; i < lines.length; i++) {
    final line = lines[i];
    if (line.trim().isEmpty) continue;
    if (_indent(line) <= 0) break;
    if (_indent(line) == 2 && line.trim() == '$section:') return i;
  }
  return -1;
}

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

/// Derives a stable runtime name for the npm shorthand form of `component add`.
String defaultNpmComponentName(String module) => p
    .basename(module)
    .split(RegExp(r'[-_]'))
    .where((part) => part.isNotEmpty)
    .map((part) => part[0].toUpperCase() + part.substring(1))
    .join();

bool _isNpmSpecifier(String value) =>
    !value.startsWith('.') &&
    !value.startsWith('/') &&
    !value.contains('\\') &&
    !value.contains(':') &&
    p.extension(value).isEmpty;

/// Adds a local stylesheet to the project's regular `styles.entrypoints`.
///
/// The updater preserves the existing style map and refuses shorthand forms
/// that cannot be extended without guessing at the user's intent.
String addStylesheetYaml(String source, String stylesheet) {
  final lines = source.split('\n');
  final scalar = _yamlScalar(stylesheet);
  if (lines.any(
    (line) => line.trim() == '- $scalar' || line.trim() == '- $stylesheet',
  )) {
    return source;
  }

  final stylesIndex = lines.indexWhere((line) => line.trimRight() == 'styles:');
  if (stylesIndex < 0) {
    final result = StringBuffer(source);
    if (!source.endsWith('\n')) result.write('\n');
    if (source.isNotEmpty) result.write('\n');
    result.write('styles:\n  entrypoints:\n    - $scalar');
    return result.toString();
  }

  final entrypointsIndex = _findSectionIndex(lines, stylesIndex, 'entrypoints');
  if (entrypointsIndex >= 0) {
    lines.insertAll(_blockEnd(lines, entrypointsIndex, 2), ['    - $scalar']);
    return lines.join('\n');
  }

  final stylesEnd = _blockEnd(lines, stylesIndex, 0);
  final next = stylesIndex + 1 < lines.length ? lines[stylesIndex + 1] : '';
  if (next.trimLeft().startsWith('-')) {
    lines.insert(stylesEnd, '  - $scalar');
    return lines.join('\n');
  }
  if (next.trim().isEmpty || next.isEmpty) {
    lines.insertAll(stylesEnd, ['  entrypoints:', '    - $scalar']);
    return lines.join('\n');
  }
  throw const ReactToolException(
    'The `styles:` value is a scalar and cannot accept another entrypoint. '
    'Convert it to `styles:\n  entrypoints:` first.',
  );
}
