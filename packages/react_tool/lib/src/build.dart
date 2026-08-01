import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:sass/sass.dart' as sass;
import 'package:yaml/yaml.dart';

import 'project_config.dart';
import 'styles.dart';

/// Runs the standardized React Dart build pipeline.
final class ReactBuilder {
  final ReactProjectConfig config;
  final bool release;
  final void Function(String message) log;

  const ReactBuilder({
    required this.config,
    required this.release,
    this.log = print,
  });

  Future<void> build() async {
    // Generate style bindings before code generation so client entrypoints may
    // import them during the same build.
    await _compileStylesheets();

    if (config.hasBuildRunner) {
      await _runDart([
        'run',
        'build_runner',
        'build',
        if (_isWorkspaceRoot) '--workspace',
      ]);
    } else {
      log('Skipping build_runner: build_runner is not declared.');
    }

    final output = config.directory(config.outputDirectory);
    await output.create(recursive: true);
    await _copyStaticAssets(output);
    await _writeStylesheetLinks(output);
    await _writeForeignComponents();

    final client = config.clientEntrypoint;
    if (client != null && config.file(client).existsSync()) {
      await _compile(
        input: client,
        output: p.join(config.outputDirectory, 'client.js'),
        optimization: release ? '-O2' : '-O0',
      );
      await _writeBrowserRuntime();
    } else {
      log('Skipping client build: ${client ?? '(not configured)'} not found.');
    }

    final ssr = config.ssrEntrypoint;
    if (ssr != null && config.file(ssr).existsSync()) {
      await _compile(
        input: ssr,
        output: p.join(config.outputDirectory, 'ssr.js'),
        optimization: '-O2',
      );
      await _writeSsrWorker();
    } else {
      log('Skipping SSR build: ${ssr ?? '(not configured)'} not found.');
    }

    await File(
      p.join(output.path, 'manifest.json'),
    ).writeAsString('${config.toJsonString()}\n');
  }

  bool get _isWorkspaceRoot {
    final value = _loadPubspec()['workspace'];
    return value is List;
  }

  Map<String, dynamic> _loadPubspec() {
    final value = loadYaml(config.file('pubspec.yaml').readAsStringSync());
    if (value is! Map) return {};
    return {for (final entry in value.entries) '${entry.key}': entry.value};
  }

  Future<void> _copyStaticAssets(Directory output) async {
    final source = config.directory(config.staticDirectory);
    if (!source.existsSync()) {
      log('Skipping static assets: ${config.staticDirectory} not found.');
      return;
    }

    await for (final entity in source.list(recursive: true)) {
      final relative = p.relative(entity.path, from: source.path);
      if (_isBuildInputOrArtifact(relative)) continue;
      final destination = File(p.join(output.path, relative));
      if (entity is Directory) {
        await destination.parent.create(recursive: true);
      } else if (entity is File) {
        await destination.parent.create(recursive: true);
        await entity.copy(destination.path);
      }
    }
    log('Copied static assets → ${output.path}');
  }

  bool _isBuildInputOrArtifact(String relative) {
    final client = config.clientEntrypoint;
    final clientName = client == null ? null : p.basename(client);
    final clientRelative = client == null
        ? null
        : p.relative(
            config.pathFor(client),
            from: config.pathFor(config.staticDirectory),
          );
    if (clientRelative != null &&
        (relative == clientRelative ||
            relative.startsWith('$clientName.') ||
            relative == p.setExtension(clientName!, '.js'))) {
      return true;
    }

    for (final stylesheet in config.styleEntrypoints) {
      final stylesheetRelative = p.relative(
        config.pathFor(stylesheet),
        from: config.pathFor(config.staticDirectory),
      );
      if (relative == stylesheetRelative) return true;
      final bindingRelative = p.relative(
        p.setExtension(config.pathFor(stylesheet), '.dart'),
        from: config.pathFor(config.staticDirectory),
      );
      if (relative == bindingRelative) return true;
      final generatedRelative = p.normalize(_stylesheetOutputName(stylesheet));
      if (relative == generatedRelative) return true;
    }
    return false;
  }

  Future<void> _compileStylesheets() async {
    if (config.styleEntrypoints.isEmpty) return;

    for (final stylesheet in config.styleEntrypoints) {
      final input = config.file(stylesheet);
      if (!input.existsSync()) {
        throw ReactToolException(
          'Configured stylesheet does not exist: ${input.path}',
        );
      }

      final outputName = _stylesheetOutputName(stylesheet);
      final output = config.file(p.join(config.outputDirectory, outputName));
      await output.parent.create(recursive: true);
      log(
        'Compiling $stylesheet → ${p.relative(output.path, from: config.root.path)}',
      );
      try {
        final result = ReactStyleCompiler(
          release: release,
          identity: p.relative(input.path, from: config.root.path),
        ).compile(input.path);
        await output.writeAsString(result.css);
        if (result.isModule) {
          final bindings = File(p.setExtension(input.path, '.dart'));
          await bindings.writeAsString(
            emitCssModuleBindings(
              sourcePath: input.path,
              classes: result.classes,
            ),
          );
          log(
            'Generated CSS Module bindings → '
            '${p.relative(bindings.path, from: config.root.path)}',
          );
        }
      } on sass.SassException catch (error) {
        throw ReactToolException(
          'Sass compilation failed for $stylesheet: $error',
        );
      }
    }
  }

  String _stylesheetOutputName(String stylesheet) =>
      config.styleOutput != null && config.styleEntrypoints.length == 1
      ? config.styleOutput!
      : '${p.basenameWithoutExtension(stylesheet)}.css';

  Future<void> _writeStylesheetLinks(Directory output) async {
    if (config.styleEntrypoints.isEmpty) return;
    final index = File(p.join(output.path, 'index.html'));
    if (!index.existsSync()) return;

    var source = await index.readAsString();
    final links = <String>[];
    for (final stylesheet in config.styleEntrypoints) {
      final href = p.posix.joinAll(p.split(_stylesheetOutputName(stylesheet)));
      final link = '<link rel="stylesheet" href="$href">';
      if (!source.contains('href="$href"')) links.add(link);
    }
    if (links.isEmpty) return;
    final insertion = '${links.join('\n')}\n';
    source = source.contains('</head>')
        ? source.replaceFirst('</head>', '$insertion</head>')
        : '$insertion$source';
    await index.writeAsString(source);
  }

  Future<void> _writeForeignComponents() async {
    if (config.foreignComponents.isEmpty) return;

    final buffer = StringBuffer()..writeln('// Generated by react_tool.');
    for (var index = 0; index < config.foreignComponents.length; index++) {
      final component = config.foreignComponents[index];
      final localName = '_reactForeignComponent$index';
      final specifier = _foreignModuleSpecifier(component.module);
      if (component.exportName == null || component.exportName == 'default') {
        buffer.writeln("import $localName from '$specifier';");
      } else {
        buffer.writeln(
          "import { ${component.exportName} as $localName } from '$specifier';",
        );
      }
    }
    buffer.writeln();
    for (var index = 0; index < config.foreignComponents.length; index++) {
      final component = config.foreignComponents[index];
      buffer.writeln(
        "globalThis.__reactDartRegisterComponent('${component.name}', "
        "_reactForeignComponent$index);",
      );
    }

    final output = config.directory(config.outputDirectory);
    await File(
      p.join(output.path, 'foreign_components.mjs'),
    ).writeAsString(buffer.toString());
    log(
      'Generated ${p.join(config.outputDirectory, 'foreign_components.mjs')}',
    );
    await _writeForeignBindings();
  }

  Future<void> _writeForeignBindings() async {
    final buffer = StringBuffer()
      ..writeln('// GENERATED CODE - DO NOT MODIFY BY HAND.')
      ..writeln("import 'package:react/react.dart' as react;")
      ..writeln();

    for (final component in config.foreignComponents) {
      final functionName = _dartIdentifier(component.name);
      buffer.writeln('react.ReactNode $functionName({');
      for (final entry in component.props.entries) {
        final parameter = _foreignParameter(entry.key);
        final type = entry.value
            .replaceAll('ReactNode', 'react.ReactNode')
            .replaceAll('ReactCallback', 'react.ReactCallback');
        final required = !type.trim().endsWith('?');
        buffer.writeln('  ${required ? 'required ' : ''}$type $parameter,');
      }
      buffer
        ..writeln('  String? key,')
        ..writeln('  List<react.ReactNode> children = const [],')
        ..writeln('}) => react.foreignComponent(')
        ..writeln("  '${component.name}',")
        ..writeln('  props: {');
      for (final entry in component.props.entries) {
        final parameter = _foreignParameter(entry.key);
        buffer.writeln("    '${entry.key}': $parameter,");
      }
      buffer
        ..writeln('  },')
        ..writeln('  key: key,')
        ..writeln('  children: children,')
        ..writeln(');')
        ..writeln();
    }

    final bindings = config.file('lib/foreign_components.g.dart');
    await bindings.parent.create(recursive: true);
    await bindings.writeAsString(buffer.toString());
    log('Generated ${bindings.path}');
  }

  String _dartIdentifier(String value) {
    final words = value
        .split(RegExp(r'[^a-zA-Z0-9]+'))
        .where((word) => word.isNotEmpty)
        .toList();
    if (words.isEmpty) return '_component';
    final result =
        words.first.toLowerCase() +
        words
            .skip(1)
            .map((word) => word[0].toUpperCase() + word.substring(1))
            .join();
    return RegExp(r'^[0-9]').hasMatch(result) ? '_$result' : result;
  }

  String _foreignParameter(String value) {
    final identifier = _dartIdentifier(value);
    return switch (identifier) {
      'key' || 'children' => '${identifier}Prop',
      _ => identifier,
    };
  }

  String _foreignModuleSpecifier(String module) {
    final moduleFile = config.file(module);
    if (!moduleFile.existsSync()) return module;

    final staticRoot = config.directory(config.staticDirectory).path;
    final absolute = moduleFile.absolute.path;
    final staticAbsolute = Directory(staticRoot).absolute.path;
    if (p.isWithin(staticAbsolute, absolute) || absolute == staticAbsolute) {
      final relative = p.relative(absolute, from: staticAbsolute);
      return './${p.posix.joinAll(p.split(relative))}';
    }
    final relative = p.relative(
      absolute,
      from: config.directory(config.outputDirectory).absolute.path,
    );
    return p.posix.joinAll(p.split(relative));
  }

  Future<void> _compile({
    required String input,
    required String output,
    required String optimization,
  }) async {
    final outputPath = config.pathFor(output);
    await Directory(p.dirname(outputPath)).create(recursive: true);
    log('Compiling $input → $outputPath');
    await _runDart([
      'compile',
      'js',
      optimization,
      '-o',
      outputPath,
      config.pathFor(input),
    ]);
  }

  Future<void> _runDart(List<String> arguments) async {
    log('dart ${arguments.join(' ')}');
    await Directory(p.join(config.root.path, '.tmp')).create(recursive: true);
    final result = await Process.run(
      Platform.resolvedExecutable,
      arguments,
      workingDirectory: config.root.path,
      environment: {...Platform.environment, 'TMP': '.tmp'},
    );
    if (result.stdout.toString().trim().isNotEmpty) {
      stdout.write(result.stdout);
    }
    if (result.stderr.toString().trim().isNotEmpty) {
      stderr.write(result.stderr);
    }
    if (result.exitCode != 0) {
      throw ReactToolException(
        'Command failed with exit code ${result.exitCode}: '
        '${Platform.resolvedExecutable} ${arguments.join(' ')}',
      );
    }
  }

  Future<void> _writeBrowserRuntime() async {
    final output = config.directory(config.outputDirectory);
    await File(
      p.join(output.path, 'callback_trampoline.mjs'),
    ).writeAsString(_callbackTrampoline);

    final index = File(p.join(output.path, 'index.html'));
    if (!index.existsSync()) return;
    final source = await index.readAsString();
    if (source.contains('callback_trampoline.mjs')) return;

    const clientScript = '<script type="module" src="client.js"></script>';
    const runtimeScript =
        '<script type="module" src="callback_trampoline.mjs"></script>';
    final foreignScript = config.foreignComponents.isEmpty
        ? ''
        : '<script type="module" src="foreign_components.mjs"></script>';
    final scripts = [
      runtimeScript,
      if (foreignScript.isNotEmpty) foreignScript,
    ].join('\n');
    final updated = source.contains(clientScript)
        ? source.replaceFirst(clientScript, '$scripts\n$clientScript')
        : '$source\n$scripts\n';
    await index.writeAsString(updated);
  }

  Future<void> _writeSsrWorker() async {
    final output = config.directory(config.outputDirectory);
    await File(p.join(output.path, 'ssr_worker.mjs')).writeAsString(_ssrWorker);
    log('Generated ${p.join(config.outputDirectory, 'ssr_worker.mjs')}');
  }
}

// Keep this protocol asset owned by the tool so projects do not need to copy
// package-internal files by hand.
const _callbackTrampoline = r'''globalThis.__dartReactCallbacks ??= {};

globalThis.__dartReactCallbacks.create = function create(reference, dispatch) {
  return function (...args) {
    return dispatch(reference, args);
  };
};

globalThis.__dartReactCallbacks.createPromise = function createPromise(executor) {
  return new Promise(executor);
};

globalThis.__dartReactCallbacks.invoke = function invoke(fn, args) {
  return fn(...args);
};

globalThis.__reactDartForeignComponents ??= {};
globalThis.__reactDartRegisterComponent = function registerComponent(name, component) {
  globalThis.__reactDartForeignComponents[name] = component;
};
globalThis.__reactDartResolveComponent = function resolveComponent(name) {
  return globalThis.__reactDartForeignComponents[name];
};
''';

const _ssrWorker = r'''import React from 'react';
import ReactDOMServer from 'react-dom/server';
import http from 'node:http';

globalThis.React = React;
await import('./callback_trampoline.mjs');
if (process.env.REACT_FOREIGN_COMPONENTS !== 'false') {
  try { await import('./foreign_components.mjs'); } catch (_) {}
}
await import('./ssr.js');

const port = Number(process.env.REACT_SSR_PORT ?? 3001);

http.createServer((req, res) => {
  let body = '';
  req.on('data', chunk => body += chunk);
  req.on('end', () => {
    try {
      const request = JSON.parse(body || '{}');
      const renderRequest = {
        id: request.component ?? request.id,
        props: request.props ?? {},
      };
      const element = globalThis.__REACT_RENDER__(renderRequest);
      const html = ReactDOMServer.renderToString(element);
      res.writeHead(200, {'content-type': 'application/json'});
      res.end(JSON.stringify({html, props: renderRequest.props}));
    } catch (error) {
      console.error(error);
      res.writeHead(500, {'content-type': 'application/json'});
      res.end(JSON.stringify({error: String(error?.message ?? error)}));
    }
  });
}).listen(port, () => console.log(`React SSR worker :${port}`));
''';
