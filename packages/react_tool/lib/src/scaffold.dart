import 'dart:io';
import 'dart:isolate';

import 'package:artisanal/args.dart';
import 'package:liquify/liquify.dart';
import 'package:path/path.dart' as p;

import 'project_config.dart';
import 'react_versions.dart';

const _templatesPackageUri = 'package:react_tool/src/scaffold/templates/';

/// Scaffold templates for a full SSR project, mapped from template name
/// (including the `.liquid` extension) to the relative path written into
/// the generated project.
const _ssrTemplateOutputs = <String, String>{
  'pubspec.yaml.liquid': 'pubspec.yaml',
  'analysis_options.yaml.liquid': 'analysis_options.yaml',
  'gitignore.liquid': '.gitignore',
  'vscode_settings.json.liquid': '.vscode/settings.json',
  'react.yaml.liquid': 'react.yaml',
  'package.json.liquid': 'package.json',
  'web/index.html.liquid': 'web/index.html',
  'web/styles.scss.liquid': 'web/styles.scss',
  'web/client.dart.liquid': 'web/client.dart',
  'lib/app.dart.liquid': 'lib/react/app.dart',
  'lib/greeting.dart.liquid': 'lib/react/greeting.dart',
  'lib/ssr.dart.liquid': 'lib/react/ssr.dart',
  'bin/server.dart.liquid': 'bin/server.dart',
  'Dockerfile.liquid': 'Dockerfile',
  'dockerignore.liquid': '.dockerignore',
  'README.md.liquid': 'README.md',
  'test/app_test.dart.liquid': 'test/app_test.dart',
  'test/greeting_test.dart.liquid': 'test/greeting_test.dart',
};

/// Scaffold templates for a client-only project (no SSR, no server).
const _clientTemplateOutputs = <String, String>{
  'pubspec.client.yaml.liquid': 'pubspec.yaml',
  'analysis_options.yaml.liquid': 'analysis_options.yaml',
  'gitignore.liquid': '.gitignore',
  'vscode_settings.json.liquid': '.vscode/settings.json',
  'react.client.yaml.liquid': 'react.yaml',
  'package.json.liquid': 'package.json',
  'web/index.client.html.liquid': 'web/index.html',
  'web/styles.scss.liquid': 'web/styles.scss',
  'web/client.dart.liquid': 'web/client.dart',
  'lib/app.client.dart.liquid': 'lib/react/app.dart',
  'lib/greeting.client.dart.liquid': 'lib/react/greeting.dart',
  'README.client.md.liquid': 'README.md',
  'test/app_test.client.dart.liquid': 'test/app_test.dart',
};

const _routedTemplateOutputs = <String, String>{
  ..._ssrTemplateOutputs,
  'pubspec.routed.yaml.liquid': 'pubspec.yaml',
  'bin/server.routed.dart.liquid': 'bin/server.dart',
  'README.routed.md.liquid': 'README.md',
};

const _routedMinimalTemplateOutputs = <String, String>{
  'pubspec.routed.yaml.liquid': 'pubspec.yaml',
  'analysis_options.yaml.liquid': 'analysis_options.yaml',
  'gitignore.liquid': '.gitignore',
  'vscode_settings.json.liquid': '.vscode/settings.json',
  'react.yaml.liquid': 'react.yaml',
  'package.json.liquid': 'package.json',
  'web/index.html.liquid': 'web/index.html',
  'web/styles.scss.liquid': 'web/styles.scss',
  'web/client.dart.liquid': 'web/client.dart',
  'lib/app.dart.liquid': 'lib/react/app.dart',
  'lib/greeting.dart.liquid': 'lib/react/greeting.dart',
  'lib/ssr.dart.liquid': 'lib/react/ssr.dart',
  'bin/server.routed.dart.liquid': 'bin/server.dart',
  'README.routed-minimal.md.liquid': 'README.md',
};

/// Generates a new React Dart project from Liquid templates.
final class ScaffoldGenerator {
  ScaffoldGenerator({void Function(Object)? log}) : log = log ?? print;

  /// Receives status and guidance lines while scaffolding.
  final void Function(Object) log;

  /// Renders every template into [target]. Throws [ReactToolException] if
  /// [target] already exists unless [force] is set.
  ///
  /// [template] selects the scaffold variant: `'ssr'` (default), `'client'`, or
  /// `'routed'`, or `'routed-minimal'`.
  Future<void> generate({
    required String name,
    required String packagesPath,
    required Directory target,
    bool force = false,
    String template = 'ssr',
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
      'localPackages': packagesPath.trim().isNotEmpty,
      'title': _humanize(name),
      'reactVersion': ReactVersionPolicy.managedVersion,
    };

    final outputs = switch (template) {
      'client' => _clientTemplateOutputs,
      'routed' => _routedTemplateOutputs,
      'routed-minimal' => _routedMinimalTemplateOutputs,
      _ => _ssrTemplateOutputs,
    };

    for (final entry in outputs.entries) {
      final source = File(p.join(templatesDir.path, entry.key));
      final rendered = Template.parse(source.readAsStringSync(), data: data);
      final output = File(p.join(target.path, entry.value));
      output.parent.createSync(recursive: true);
      output.writeAsStringSync(rendered.render());
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

/// `react init <project-name>` — scaffolds a minimal React Dart project.
final class InitCommand extends Command<void> {
  @override
  String get name => 'init';

  @override
  String get description =>
      'Scaffold a new React Dart project for SSR or client-only flows.';

  @override
  String get invocation => 'react init <project-name>';

  InitCommand({Directory? workingDirectory})
    : _workingDirectory = workingDirectory ?? Directory.current {
    argParser
      ..addOption(
        'packages',
        help:
            'Use local react_* package directories instead of hosted pub.dev '
            'packages (for example: --packages ../packages).',
      )
      ..addOption(
        'template',
        defaultsTo: 'ssr',
        allowed: ['ssr', 'client', 'routed', 'routed-minimal'],
        help:
            'Scaffold template variant: "ssr" (default) includes SSR and '
            'server functions; "client" scaffolds a client-only project; '
            '"routed" scaffolds a Shelf-free SSR app using '
            '`react_server_routed` and `routed_io`; '
            '"routed-minimal" uses the same stack with fewer starter files.',
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

    final packagesPath = option('packages') as String? ?? '';
    final force = option('force') as bool? ?? false;
    final template = option('template') as String? ?? 'ssr';
    final target = Directory(p.join(_workingDirectory.path, name));

    await ScaffoldGenerator(log: line).generate(
      name: name,
      packagesPath: packagesPath,
      target: target,
      force: force,
      template: template,
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
