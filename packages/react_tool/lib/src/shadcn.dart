import 'package:artisanal/args.dart';
import 'package:path/path.dart' as p;

import 'component.dart';
import 'project_config.dart';

/// Optional shadcn convenience commands built on the generic component API.
///
/// This adapter only supplies shadcn's conventional directory, filename,
/// export, and runtime-name defaults. The resulting declaration is still a
/// normal `foreign.components` entry.
final class ShadcnCommand extends Command<void> {
  ShadcnCommand() {
    addSubcommand(_AddShadcnComponentCommand());
  }

  @override
  String get name => 'shadcn';

  @override
  String get description => 'Convenience commands for shadcn components.';
}

final class _AddShadcnComponentCommand extends Command<void> {
  _AddShadcnComponentCommand() {
    argParser
      ..addOption(
        'directory',
        defaultsTo: 'web/components/ui',
        help: 'Directory containing shadcn component source files.',
      )
      ..addOption(
        'namespace',
        defaultsTo: 'shadcn',
        help: 'Runtime namespace for the component.',
      )
      ..addOption(
        'export',
        help: 'Named TypeScript export (defaults to the component name).',
      )
      ..addOption(
        'style',
        help: 'Optional local CSS/Sass entrypoint for the component.',
      )
      ..addFlag(
        'validate',
        defaultsTo: true,
        help: 'Generate the wrapper and validate the project bundle.',
      )
      ..addFlag(
        'infer',
        defaultsTo: false,
        help: 'Infer props from a typed local TypeScript declaration.',
      );
  }

  @override
  String get name => 'add';

  @override
  String get description =>
      'Declare an existing shadcn component for Dart consumption.';

  @override
  String get invocation => 'react shadcn add <component>';

  @override
  Future<void> run() async {
    final rest = argResults!.rest;
    if (rest.length != 1) {
      usageException('Expected one shadcn component name, such as `button`.');
    }

    final config = ReactProjectConfig.load();
    final reactFile = config.file('react.yaml');
    if (!reactFile.existsSync()) {
      throw const ReactToolException(
        '`react shadcn add` requires an explicit react.yaml file.',
      );
    }

    final component = shadcnComponentName(rest.single);
    final exportName = _validateShadcnScalar(
      option('export') as String? ?? shadcnPascalCase(component),
      'export name',
    );
    final directory = _validateShadcnScalar(
      option('directory') as String? ?? 'web/components/ui',
      'component directory',
    );
    final module = p.join(directory, '$component.tsx');
    final moduleFile = config.file(module);
    if (!moduleFile.existsSync()) {
      throw ReactToolException(
        'shadcn component "$component" was not found at ${moduleFile.path}.',
      );
    }

    final namespace = _validateShadcnScalar(
      option('namespace') as String? ?? 'shadcn',
      'runtime namespace',
    );
    final runtimeName = '$namespace.$exportName';
    if (config.foreignComponents.any(
      (existing) => existing.name == runtimeName,
    )) {
      throw ReactToolException(
        'A foreign component named "$runtimeName" is already declared.',
      );
    }

    final props = <String, String>{};
    if (option('infer') as bool? ?? false) {
      props.addAll(
        await inferForeignComponentProps(
          config: config,
          module: module,
          exportName: exportName,
        ),
      );
    }

    final original = reactFile.readAsStringSync();
    var updated = addForeignComponentYaml(
      original,
      name: runtimeName,
      module: module,
      exportName: exportName,
      props: props,
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
        info('Declared $runtimeName from $module in ${reactFile.path}.');
        await generateAndValidateForeignComponents(
          config,
          validate: option('validate') as bool? ?? true,
          log: line,
        );
      },
    );
  }
}

/// Normalizes a shadcn component argument to its conventional kebab-case
/// source filename.
String shadcnComponentName(String value) {
  if (value.contains('/') || value.contains('\\')) {
    throw ReactToolException('Invalid shadcn component name "$value".');
  }
  var result = p.basenameWithoutExtension(value).toLowerCase();
  if (result.isEmpty || !RegExp(r'^[a-z0-9][a-z0-9-]*$').hasMatch(result)) {
    throw ReactToolException('Invalid shadcn component name "$value".');
  }
  return result;
}

/// Converts a shadcn kebab-case component name to its conventional export
/// name.
String shadcnPascalCase(String value) => value
    .split('-')
    .map((part) => part[0].toUpperCase() + part.substring(1))
    .join();

String _validateShadcnScalar(String value, String label) {
  if (value.trim().isEmpty || value.contains('\n') || value.contains('\r')) {
    throw ReactToolException('Invalid $label "$value".');
  }
  return value;
}
