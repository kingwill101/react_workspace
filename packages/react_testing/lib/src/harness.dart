import 'dart:async';
import 'dart:io';

import 'package:react_server/react_server.dart';
import 'package:react_tool/react_tool.dart';
import 'package:server_testing/server_testing.dart';
import 'package:server_testing_shelf/server_testing_shelf.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_static/shelf_static.dart';

/// Registers generated server functions with a test harness.
typedef ReactTestHarnessActions =
    void Function(ServerFunctionRegistry registry);

/// Builds and boots a complete React Dart test application.
///
/// The harness owns generated client/SSR artifacts, the Node SSR worker, and
/// a native Shelf application host. It can be used with `server_testing` in
/// memory or with a real browser against [baseUrl].
final class ReactTestHarness {
  final ReactProjectConfig config;
  final HttpServer server;
  final Process? ssrWorker;
  final ReactSsrClient? ssrClient;
  final ReactServerApp application;

  const ReactTestHarness._({
    required this.config,
    required this.server,
    required this.ssrWorker,
    required this.ssrClient,
    required this.application,
  });

  /// Builds and starts a test application for [projectRoot].
  static Future<ReactTestHarness> start({
    required Directory projectRoot,
    required String rootComponent,
    required ReactTestHarnessActions registerActions,
    Map<String, dynamic> Function(Request request)? pageProps,
    bool release = false,
    bool ssr = true,
  }) async {
    final config = ReactProjectConfig.load(projectRoot);
    final buildLogs = <String>[];
    try {
      await ReactBuilder(
        config: config,
        release: release,
        log: (m) => buildLogs.add(m),
      ).build().timeout(
        const Duration(seconds: 120),
        onTimeout: () => throw ReactToolException(
          'Timed out building ${projectRoot.path} after 120s.\n'
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
        worker.stdout.transform(SystemEncoding().decoder).listen(workerOutput.write);
        worker.stderr.transform(SystemEncoding().decoder).listen(workerOutput.write);
        await _waitForPort(ssrPort, worker: worker, output: workerOutput);
        await _waitForSsrHealth(ssrPort, worker: worker, output: workerOutput);
        ssrClient = ReactSsrClient(
          endpoint: Uri.parse('http://127.0.0.1:$ssrPort/'),
        );
      }

      final staticDirectory = config.directory(config.outputDirectory);
      final actionRegistry = ServerFunctionRegistry();
      registerActions(actionRegistry);
      final staticHandler = createStaticHandler(
        staticDirectory.path,
        defaultDocument: 'index.html',
      );
      final application = ReactServerApp(
        actionRegistry: actionRegistry,
        staticHandler: staticHandler,
        indexTemplate: File(
          '${staticDirectory.path}/index.html',
        ).readAsStringSync(),
        ssr: ssrClient,
        rootComponent: rootComponent,
        pageProps: pageProps ?? (_) => <String, dynamic>{},
      );
      final server = await shelf_io.serve(
        application.handler,
        InternetAddress.loopbackIPv4,
        0,
      );

      return ReactTestHarness._(
        config: config,
        server: server,
        ssrWorker: worker,
        ssrClient: ssrClient,
        application: application,
      );
    } catch (_) {
      ssrClient?.close();
      worker?.kill(ProcessSignal.sigterm);
      rethrow;
    }
  }

  String get baseUrl => 'http://127.0.0.1:${server.port}';

  /// Creates an in-memory `server_testing` client for the same app handler.
  TestClient createClient() =>
      TestClient.inMemory(ShelfRequestHandler(application.handler));

  Future<void> close() async {
    ssrClient?.close();
    await server.close(force: true);
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
          'Output:\n${output?.toString().substring(0, 2000)}',
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
    'Worker output:\n${output?.toString().substring(0, 2000)}',
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
            'Output:\n${output?.toString().substring(0, 2000)}',
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
      'Worker output:\n${output?.toString().substring(0, 2000)}',
    );
  } finally {
    client.close(force: true);
  }
}
