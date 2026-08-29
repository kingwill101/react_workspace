import 'dart:convert';
import 'dart:io';

import 'package:react_tool/react_tool.dart';
import 'package:test/test.dart';

void main() {
  late Directory root;

  setUp(() async {
    root = await Directory.systemTemp.createTemp('react_tool_manifest_test_');
  });

  tearDown(() async {
    if (root.existsSync()) await root.delete(recursive: true);
  });

  Future<void> writeManifest(Map<String, Object?> manifest) async {
    await File('${root.path}/bundle_manifest.json').writeAsString(
      '${const JsonEncoder.withIndent('  ').convert(manifest)}\n',
    );
  }

  test('loads a manifest emitted by a full build', () async {
    await writeManifest({
      'schema': 1,
      'bundler': 'esbuild',
      'mode': 'development',
      'browser': {
        'entry': 'browser.js',
        'loader': 'browser.entry.mjs',
        'dart': 'client.js',
        'foreign': 'foreign/browser/bundle.mjs',
        'bytes': {'dart': 1024, 'foreign': 2048},
      },
      'ssr': {
        'entry': 'ssr.entry.mjs',
        'dart': 'ssr.js',
        'runtime': 'ssr_runtime.mjs',
        'foreign': 'foreign/ssr/bundle.mjs',
        'bytes': {'dart': 512, 'foreign': 4096},
      },
    });

    final manifest = BundleManifest.load(root);

    expect(manifest.schema, 1);
    expect(manifest.bundler, 'esbuild');
    expect(manifest.mode, 'development');
    expect(manifest.browserEntry, 'browser.js');
    expect(manifest.browserLoader, 'browser.entry.mjs');
    expect(manifest.browser?.dart, 'client.js');
    expect(manifest.browser?.foreign, 'foreign/browser/bundle.mjs');
    expect(manifest.browser?.dartBytes, 1024);
    expect(manifest.browser?.foreignBytes, 2048);
    expect(manifest.browser?.runtime, isNull);
    expect(manifest.ssrEntry, 'ssr.entry.mjs');
    expect(manifest.ssr?.runtime, 'ssr_runtime.mjs');
    expect(manifest.ssr?.dartBytes, 512);
  });

  test('returns an empty manifest when none was emitted', () async {
    final manifest = BundleManifest.load(root);

    expect(manifest.bundler, 'none');
    expect(manifest.browserEntry, isNull);
    expect(manifest.ssrEntry, isNull);
  });

  test('tolerates a target without a foreign bundle or bytes', () async {
    await writeManifest({
      'schema': 1,
      'bundler': 'none',
      'mode': 'release',
      'browser': {
        'entry': 'browser.js',
        'dart': 'client.js',
        'bytes': {'dart': 8192},
      },
    });

    final manifest = BundleManifest.load(root);

    expect(manifest.browser?.foreign, isNull);
    expect(manifest.browser?.foreignBytes, isNull);
    expect(manifest.browser?.dartBytes, 8192);
    expect(manifest.ssrEntry, isNull);
  });
}
