import 'dart:io';
import 'dart:isolate';

import 'package:artisanal/args.dart';
import 'package:liquify/liquify.dart';
import 'package:path/path.dart' as p;

import 'project_config.dart';

const _templatesPackageUri = 'package:react_tool/src/scaffold/templates/';

/// Scaffold templates, mapped from template name (including the `.liquid`
/// extension) to the relative path written into the generated project.
const _templateOutputs = <String, String>{
  'pubspec.yaml.liquid': 'pubspec.yaml',
  'analysis_options.yaml.liquid': 'analysis_options.yaml',
  '.gitignore.liquid': '.gitignore',
  'react.yaml.liquid': 'react.yaml',
  'package.json.liquid': 'package.json',
  'web/index.html.liquid': 'web/index.html',
  'web/styles.scss.liquid': 'web/styles.scss',
  'web/client.dart.liquid': 'web/client.dart',
  'lib/app.dart.liquid': 'lib/app.dart',
  'lib/greeting.dart.liquid': 'lib/greeting.dart',
  'lib/ssr.dart.liquid': 'lib/ssr.dart',
  'bin/server.dart.liquid': 'bin/server.dart',
  'Dockerfile.liquid': 'Dockerfile',
  '.dockerignore.liquid': '.dockerignore',
  'README.md.liquid': 'README.md',
};

/// Generates a new React Dart project from Liquid templates.
final class ScaffoldGenerator {
  ScaffoldGenerator({void Function(Object)? log}) : log = log ?? print;

  /// Receives status and guidance lines while scaffolding.
  final void Function(Object) log;

  /// Renders every template into [target]. Throws [ReactToolException] if
  /// [target] already exists unless [force] is set.
  Future<void> generate({
    required String name,
    required String packagesPath,
    required Directory target,
    bool force = false,
  }) async {
    if (target.existsSync() && !force) {
      throw ReactToolException(
        '${target.path} already exists. Pass --force to overwrite it.',
      );
    }

    final templatesDir = await _templatesDirectory();
    final data = <String, dynamic>{
      'name': name,
      'packagesPath': packagesPath,
      'title': _humanize(name),
    };

    for (final entry in _templateOutputs.entries) {
      final source = File(p.join(templatesDir.path, entry.key));
      final template = Template.parse(source.readAsStringSync(), data: data);
      final output = File(p.join(target.path, entry.value));
      output.parent.createSync(recursive: true);
      output.writeAsStringSync(template.render());
    }
  }

  Future<Directory> _templatesDirectory() async {
    final uri = await Isolate.resolvePackageUri(
      Uri.parse(_templatesPackageUri),
    );
    if (uri == null) {
      throw const ReactToolException(
        'Could not locate the scaffold templates in react_tool.',
      );
    }
    return Directory.fromUri(uri);
  }

  static String _humanize(String name) => name
      .split('_')
      .map(
        (part) => part.isEmpty
            ? part
            : '${part[0].toUpperCase()}${part.substring(1)}',
      )
      .join(' ');
}

/// `react init <project-name>` — scaffolds a minimal React Dart project with
/// SSR and server functions.
final class InitCommand extends Command<void> {
  @override
  String get name => 'init';

  @override
  String get description =>
      'Scaffold a new React Dart project with SSR and server functions.';

  @override
  String get invocation => 'react init <project-name>';

  InitCommand({Directory? workingDirectory})
    : _workingDirectory = workingDirectory ?? Directory.current {
    argParser
      ..addOption(
        'packages',
        defaultsTo: '../packages',
        help: 'Path to the react_* package directories referenced by the '
            'generated pubspec (default: ../packages).',
      )
      ..addFlag(
        'force',
        defaultsTo: false,
        help: 'Overwrite an existing directory.',
      );
  }

  /// Directory the project is created in (injectable for tests).
  final Directory _workingDirectory;

  @override
  Future<void> run() async {
    final arguments = argResults!.rest;
    if (arguments.length != 1) {
      usageException('Expected exactly one project name.');
    }
    final name = arguments.first;
    _validateName(name);

    final packagesPath = option('packages') as String? ?? '../packages';
    final force = option('force') as bool? ?? false;
    final target = Directory(p.join(_workingDirectory.path, name));

    await ScaffoldGenerator(log: line).generate(
      name: name,
      packagesPath: packagesPath,
      target: target,
      force: force,
    );

    info('Created $name/.');
    info('Next steps:');
    line('  cd $name');
    line('  dart pub get');
    line('  dart run react_tool:react build');
    line('  dart run react_tool:react serve');
  }

  void _validateName(String name) {
    final valid = RegExp(r'^[a-z][a-z0-9_]*$');
    if (!valid.hasMatch(name)) {
      usageException(
        'Invalid project name "$name". Use lowercase letters, digits, and '
        'underscores, starting with a letter.',
      );
    }
  }
}
