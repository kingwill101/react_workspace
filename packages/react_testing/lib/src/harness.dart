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
    await ReactBuilder(config: config, release: release, log: (_) {}).build();

    Process? worker;
    ReactSsrClient? ssrClient;
    try {
      if (ssr) {
        final workerFile = config.file(
          '${config.outputDirectory}/ssr_worker.mjs',
        );
        if (!workerFile.existsSync()) {
          throw ReactToolException(
            'SSR output was not generated at ${workerFile.path}.',
          );
        }
        final ssrPort = await _freePort();
        worker = await Process.start(
          'node',
          [workerFile.path],
          workingDirectory: config.root.path,
          mode: ProcessStartMode.inheritStdio,
          environment: {...Platform.environment, 'REACT_SSR_PORT': '$ssrPort'},
        );
        await _waitForPort(ssrPort);
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

Future<void> _waitForPort(int port) async {
  for (var attempt = 0; attempt < 100; attempt++) {
    try {
      final socket = await Socket.connect('127.0.0.1', port);
      await socket.close();
      return;
    } on SocketException {
      await Future<void>.delayed(const Duration(milliseconds: 100));
    }
  }
  throw ReactToolException('Timed out waiting for port $port.');
}
