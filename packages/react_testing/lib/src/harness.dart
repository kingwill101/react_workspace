import 'dart:async';
import 'dart:io';

import 'package:react_server/react_server.dart';
import 'package:react_tool/react_tool.dart';
import 'package:server_testing/server_testing.dart';

/// Builds React artifacts and boots the generated Node SSR worker.
///
/// Server integration remains transport-neutral: compose [ssrClient],
/// [indexTemplate], and [outputDirectory] with the application package under
/// test, adapt that application with its `server_testing_*` adapter, and pass
/// the resulting [RequestHandler] to [createClient].
final class ReactTestHarness {
  final ReactProjectConfig config;
  final Process? ssrWorker;
  final ReactSsrClient? ssrClient;
  final Directory outputDirectory;
  final String indexTemplate;

  const ReactTestHarness._({
    required this.config,
    required this.ssrWorker,
    required this.ssrClient,
    required this.outputDirectory,
    required this.indexTemplate,
  });

  /// Builds [projectRoot] and starts its generated SSR worker.
  ///
  /// [reactVersion] overrides the managed React and React DOM version so the
  /// same project can be exercised at each supported compatibility boundary.
  ///
  /// [buildTimeout] covers the complete code-generation, browser compilation,
  /// SSR compilation, and bundling pipeline.
  ///
  /// [runCodegen] may be disabled by an orchestrator that has already run a
  /// workspace-wide build and synchronized its generated sources.
  static Future<ReactTestHarness> start({
    required Directory projectRoot,
    bool release = false,
    bool ssr = true,
    bool runCodegen = true,
    String? reactVersion,
    String? ssrRuntime,
    Duration buildTimeout = const Duration(minutes: 10),
  }) async {
    final loadedConfig = ReactProjectConfig.load(projectRoot);
    if (ssrRuntime != null && ssrRuntime != 'node' && ssrRuntime != 'fetch') {
      throw ArgumentError.value(
        ssrRuntime,
        'ssrRuntime',
        'Expected `node` or `fetch`.',
      );
    }
    final config = loadedConfig.copyWith(ssrRuntime: ssrRuntime);
    final buildLogs = <String>[];
    try {
      await ReactBuilder(
            config: config,
            release: release,
            managedReactVersion: reactVersion,
            log: (m) => buildLogs.add(m),
          )
          .build(runCodegen: runCodegen)
          .timeout(
            buildTimeout,
            onTimeout: () => throw ReactToolException(
              'Timed out building ${projectRoot.path} after '
              '${buildTimeout.inSeconds}s.\n'
              'Logs:\n${buildLogs.take(50).join('\n')}',
            ),
          );
    } catch (e) {
      throw ReactToolException(
        'Failed to build ${projectRoot.path}: $e\n'
        'Builder logs:\n${buildLogs.take(100).join('\n')}',
      );
    }
    // Verify build output exists before launching SSR worker.
    final outputDir = config.directory(config.outputDirectory);
    if (!outputDir.existsSync()) {
      throw ReactToolException('Build output missing at ${outputDir.path}');
    }

    Process? worker;
    ReactSsrClient? ssrClient;
    try {
      if (ssr) {
        final manifest = BundleManifest.load(outputDir);
        final workerFile = config.file(
          '${config.outputDirectory}/${manifest.ssrEntry ?? 'ssr.entry.mjs'}',
        );
        if (!workerFile.existsSync()) {
          throw ReactToolException(
            'SSR output was not generated at ${workerFile.path}. '
            'Build logs:\n${buildLogs.take(20).join('\n')}',
          );
        }
        final ssrPort = await _freePort();
        worker = await Process.start(
          'node',
          [workerFile.path],
          workingDirectory: config.root.path,
          // Capture stdio instead of inherit so we can report early exit.
          mode: ProcessStartMode.normal,
          environment: {...Platform.environment, 'REACT_SSR_PORT': '$ssrPort'},
        );
        // Forward worker output to a buffer for diagnostics on failure.
        final workerOutput = StringBuffer();
        worker.stdout
            .transform(const SystemEncoding().decoder)
            .listen(workerOutput.write);
        worker.stderr
            .transform(const SystemEncoding().decoder)
            .listen(workerOutput.write);
        await _waitForPort(ssrPort, worker: worker, output: workerOutput);
        await _waitForSsrHealth(ssrPort, worker: worker, output: workerOutput);
        ssrClient = ReactSsrClient(
          endpoint: Uri.parse('http://127.0.0.1:$ssrPort/'),
        );
      }

      final indexFile = File('${outputDir.path}/index.html');
      if (!indexFile.existsSync()) {
        throw ReactToolException(
          'Built index template missing at ${indexFile.path}',
        );
      }

      return ReactTestHarness._(
        config: config,
        ssrWorker: worker,
        ssrClient: ssrClient,
        outputDirectory: outputDir,
        indexTemplate: indexFile.readAsStringSync(),
      );
    } catch (_) {
      ssrClient?.close();
      worker?.kill(ProcessSignal.sigterm);
      rethrow;
    }
  }

  /// Creates a client using the adapter chosen by the server under test.
  TestClient createClient(
    RequestHandler handler, {
    TransportMode mode = TransportMode.inMemory,
  }) => TestClient(handler, mode: mode);

  /// Resolves a built asset relative to [outputDirectory].
  File asset(String relativePath) =>
      File('${outputDirectory.path}/$relativePath');

  Future<void> close() async {
    ssrClient?.close();
    ssrWorker?.kill(ProcessSignal.sigterm);
    await ssrWorker?.exitCode.timeout(
      const Duration(seconds: 5),
      onTimeout: () => -1,
    );
  }
}

Future<int> _freePort() async {
  final socket = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
  final port = socket.port;
  await socket.close();
  return port;
}

Future<void> _waitForPort(
  int port, {
  Process? worker,
  StringBuffer? output,
}) async {
  for (var attempt = 0; attempt < 60; attempt++) {
    // If worker exited early, surface its output immediately.
    if (worker != null) {
      final exit = await worker.exitCode.timeout(
        Duration.zero,
        onTimeout: () => -1,
      );
      if (exit != -1) {
        throw ReactToolException(
          'SSR worker exited early with code $exit while waiting for port $port.\n'
          'Output:\n${_previewOutput(output)}',
        );
      }
    }
    try {
      final socket = await Socket.connect('127.0.0.1', port);
      await socket.close();
      return;
    } on SocketException {
      // Exponential backoff: 100ms, 150ms, 225ms …
      final delay = Duration(milliseconds: 100 + attempt * 20);
      await Future<void>.delayed(delay);
    }
  }
  throw ReactToolException(
    'Timed out waiting for SSR port $port after 60 attempts.\n'
    'Worker output:\n${_previewOutput(output)}',
  );
}

Future<void> _waitForSsrHealth(
  int port, {
  Process? worker,
  StringBuffer? output,
}) async {
  final client = HttpClient()..connectionTimeout = const Duration(seconds: 2);
  try {
    for (var attempt = 0; attempt < 30; attempt++) {
      if (worker != null) {
        final exit = await worker.exitCode.timeout(
          Duration.zero,
          onTimeout: () => -1,
        );
        if (exit != -1) {
          throw ReactToolException(
            'SSR worker exited before health check (code $exit).\n'
            'Output:\n${_previewOutput(output)}',
          );
        }
      }
      try {
        final req = await client.getUrl(Uri.parse('http://127.0.0.1:$port/'));
        final resp = await req.close().timeout(const Duration(seconds: 2));
        // Worker is healthy if it responds (even 404) without hanging.
        await resp.drain<void>();
        return;
      } catch (_) {
        await Future<void>.delayed(Duration(milliseconds: 200 + attempt * 30));
      }
    }
    throw ReactToolException(
      'SSR health check failed for port $port after 30 attempts.\n'
      'Worker output:\n${_previewOutput(output)}',
    );
  } finally {
    client.close(force: true);
  }
}

String? _previewOutput(StringBuffer? output) {
  final value = output?.toString();
  if (value == null || value.length <= 2000) return value;
  return value.substring(0, 2000);
}
