import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

import '../js_environment.dart';
import '../project_config.dart';
import 'bundle_request.dart';
import 'bundle_result.dart';
import 'bundler.dart';

/// Bundles the foreign graph with the environment's esbuild.
///
/// The esbuild driver is refreshed on every bundle because it is tool-owned
/// protocol and may evolve between react_tool versions.
final class EsbuildBundler implements JavaScriptBundler {
  final JsEnvironment environment;

  EsbuildBundler({required this.environment});

  @override
  String get name => 'esbuild';

  @override
  Future<BundleResult> bundle(BundleRequest request) async {
    final stopwatch = Stopwatch()..start();

    final esbuildEntry = await environment.esbuildEntry();
    final driver = File(p.join(environment.root.path, 'esbuild_driver.mjs'));
    await driver.parent.create(recursive: true);
    await driver.writeAsString(_esbuildDriver);

    final options = <String, Object?>{
      'entryPoints': request.entryPoints,
      'outfile': request.outputFile,
      'bundle': true,
      'format': 'esm',
      'platform': request.target == JavaScriptTarget.node ? 'node' : 'browser',
      if (request.target == JavaScriptTarget.node) 'target': ['node20'],
      'external': request.externals,
      'conditions': request.conditions,
      'minify': request.minify,
      'sourcemap': request.sourceMaps ? 'linked' : false,
      'metafile': true,
      'logLevel': 'silent',
      'nodePaths': [request.npmRoot],
    };

    final result = await Process.run(
      'node',
      [driver.path, esbuildEntry.path, jsonEncode(options)],
      environment: {
        ...Platform.environment,
        // Consumed by the driver's node-externals plugin.
        'REACT_NPM_ROOT': request.npmRoot,
      },
    );

    if (result.exitCode != 0) {
      throw ReactToolException(
        '${request.name} bundle failed with esbuild:\n${result.stderr}',
      );
    }

    final output = File(request.outputFile);
    if (!await output.exists()) {
      throw ReactToolException(
        'esbuild completed but did not produce ${request.outputFile}.',
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
      warnings: [
        for (final warning
            in response['warnings'] as List<dynamic>? ?? const [])
          warning as String,
      ],
    );
  }
}

/// Node driver that runs the environment's esbuild programmatically. Options
/// arrive as JSON argv; for the node platform it adds an onResolve plugin that
/// rewrites external bare specifiers to absolute paths through the
/// environment's npm root, so the worker never depends on a node_modules
/// walk-up. On success it prints a structured summary (metafile inputs/outputs
/// and warnings) consumed by [EsbuildBundler].
const _esbuildDriver = r'''
import { pathToFileURL } from 'node:url';
import { createRequire } from 'node:module';

const [esbuildEntry, json] = process.argv.slice(2);
const { build } = await import(pathToFileURL(esbuildEntry).href);
const opts = JSON.parse(json);

const require = createRequire(process.cwd() + '/x.js');
const npmRoot = process.env.REACT_NPM_ROOT || opts.npmRoot;
if (opts.platform === 'node' && Array.isArray(opts.external)) {
  const externals = opts.external;
  opts.plugins = [{
    name: 'react-node-externals',
    setup(build) {
      build.onResolve({ filter: /.*/ }, (args) => {
        for (const spec of externals) {
          if (args.path === spec || args.path.startsWith(spec + '/')) {
            try {
              return {
                path: require.resolve(args.path, { paths: [npmRoot] }),
                external: true,
              };
            } catch (error) {
              return {
                errors: [{
                  text: `Cannot resolve external "${args.path}" in the JS environment: ${error.message}`,
                }],
              };
            }
          }
        }
        return null;
      });
    },
  }];
}

try {
  const result = await build(opts);
  console.log(JSON.stringify({
    inputs: Object.keys(result?.metafile?.inputs ?? {}),
    outputs: Object.keys(result?.metafile?.outputs ?? {}),
    warnings: (result?.warnings ?? []).map(warning => warning.text),
  }));
} catch (error) {
  const lines = error?.errors?.map((e) => e.text) ?? [String(error)];
  console.error(lines.join('\n'));
  process.exit(1);
}
''';
