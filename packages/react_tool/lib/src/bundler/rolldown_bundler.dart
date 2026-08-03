import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

import '../js_environment.dart';
import '../project_config.dart';
import 'bundle_request.dart';
import 'bundle_result.dart';
import 'bundler.dart';

/// Bundles the foreign graph with the environment's pinned `rolldown` npm
/// package (Rollup-compatible API), behind the same stable request/response
/// contract as [EsbuildBundler].
///
/// The driver is refreshed on every bundle because it is tool-owned protocol
/// and may evolve between react_tool versions; the rolldown version itself is
/// pinned in the managed environment (`bundling.backend: rolldown`).
final class RolldownBundler implements JavaScriptBundler {
  final JsEnvironment environment;

  RolldownBundler({required this.environment});

  @override
  String get name => 'rolldown';

  @override
  Future<BundleResult> bundle(BundleRequest request) async {
    final stopwatch = Stopwatch()..start();

    final rolldownEntry = environment.rolldownEntry();
    final driver = File(p.join(environment.root.path, 'rolldown_driver.mjs'));
    await driver.parent.create(recursive: true);
    await driver.writeAsString(_rolldownDriver);

    final options = <String, Object?>{
      'entryPoints': request.entryPoints,
      'outfile': request.outputFile,
      'platform': request.target == JavaScriptTarget.node ? 'node' : 'browser',
      'external': request.externals,
      'conditions': request.conditions,
      'minify': request.minify,
      'sourceMaps': request.sourceMaps,
      'npmRoot': request.npmRoot,
    };

    final result = await Process.run(
      'node',
      [driver.path, rolldownEntry.path, jsonEncode(options)],
      environment: {
        ...Platform.environment,
        // Consumed by the driver's node-externals plugin.
        'REACT_NPM_ROOT': request.npmRoot,
      },
    );

    if (result.exitCode != 0) {
      throw ReactToolException(
        '${request.name} bundle failed with rolldown:\n${result.stderr}',
      );
    }

    final output = File(request.outputFile);
    if (!await output.exists()) {
      throw ReactToolException(
        'rolldown completed but did not produce ${request.outputFile}.',
      );
    }

    stopwatch.stop();

    final response = result.stdout.toString().trim().isEmpty
        ? const <String, dynamic>{}
        : jsonDecode(result.stdout as String) as Map<String, dynamic>;
    return BundleResult(
      outputFile: output.path,
      outputBytes: await output.length(),
      duration: stopwatch.elapsed,
      inputs: [
        for (final input in response['inputs'] as List<dynamic>? ?? const [])
          input as String,
      ],
      outputs: [
        for (final output in response['outputs'] as List<dynamic>? ?? const [])
          output as String,
      ],
      warnings: [
        for (final warning
            in response['warnings'] as List<dynamic>? ?? const [])
          warning as String,
      ],
    );
  }
}

/// Node driver that runs the environment's rolldown programmatically. Options
/// arrive as JSON argv; a node-externals plugin rewrites external bare
/// specifiers to absolute paths through the environment's npm root (node
/// target only — the browser target keeps them bare for the import map), so
/// the worker and the foreign bundle share one React instance. On success it
/// prints a structured summary (inputs/outputs and warnings) consumed by
/// [RolldownBundler].
const _rolldownDriver = r'''
import { pathToFileURL } from 'node:url';
import { createRequire } from 'node:module';
import { basename } from 'node:path';
import { writeFileSync } from 'node:fs';

const [rolldownEntry, json] = process.argv.slice(2);
const { rolldown } = await import(pathToFileURL(rolldownEntry).href);
const opts = JSON.parse(json);

const require = createRequire(process.cwd() + '/x.js');
const npmRoot = process.env.REACT_NPM_ROOT || opts.npmRoot;
const externals = opts.external ?? [];
const isExternal = (source) =>
  externals.some((spec) => source === spec || source.startsWith(spec + '/'));

const nodeExternals = {
  name: 'react-node-externals',
  resolveId(source) {
    if (!isExternal(source)) return null;
    if (opts.platform !== 'node') return { id: source, external: true };
    try {
      return {
        id: require.resolve(source, { paths: [npmRoot] }),
        external: true,
      };
    } catch (error) {
      return {
        errors: [{
          message: `Cannot resolve external "${source}" in the JS environment: ${error.message}`,
        }],
      };
    }
  },
};

const inputs = [];
const recordInputs = {
  name: 'record-inputs',
  transform(code, id) {
    if (!id.startsWith('\0')) inputs.push(id);
    return null;
  },
};

try {
  const bundle = await rolldown({
    input: opts.entryPoints,
    platform: opts.platform,
    resolve: {
      conditionNames: [...(opts.conditions ?? ['development']), 'import'],
    },
    plugins: [nodeExternals, recordInputs],
    logLevel: 'silent',
  });

  const { output } = await bundle.generate({
    format: 'es',
    sourcemap: opts.sourceMaps ? true : false,
    minify: opts.minify ?? false,
    entryFileNames: basename(opts.outfile),
  });

  for (const chunk of output) {
    if (chunk.type !== 'chunk' || !chunk.isEntry) continue;
    writeFileSync(opts.outfile, chunk.code);
    if (chunk.map) writeFileSync(opts.outfile + '.map', chunk.map.toString());
  }

  console.log(JSON.stringify({
    inputs,
    outputs: [
      opts.outfile,
      ...(opts.sourceMaps ? [opts.outfile + '.map'] : []),
    ],
    warnings: [],
  }));
} catch (error) {
  console.error(error?.message ?? String(error));
  process.exit(1);
}
''';
