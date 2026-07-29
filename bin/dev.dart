import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_static/shelf_static.dart';
import 'package:watcher/watcher.dart';

sealed class DevEvent {
  const DevEvent();
}

final class FileChanged extends DevEvent {
  final String path;
  const FileChanged(this.path);
}

final class ClientBuilt extends DevEvent {
  final Duration took;
  const ClientBuilt(this.took);
}

final class SsrBuilt extends DevEvent {
  final Duration took;
  const SsrBuilt(this.took);
}

final class WorkerRestarted extends DevEvent {
  const WorkerRestarted();
}

final class ServerReady extends DevEvent {
  final int port;
  const ServerReady(this.port);
}

final class BuildError extends DevEvent {
  final String message;
  const BuildError(this.message);
}

class ProcessHandle {
  final Process _process;
  ProcessHandle(this._process);
  void killTree() => _process.kill(ProcessSignal.sigterm);
}

Future<void> main() async {
  final ctrl = StreamController<DevEvent>.broadcast();
  final events = ctrl.stream;
  events.listen(
    (e) => switch (e) {
      FileChanged(:var path) => print('[watch] $path'),
      ClientBuilt(:var took) => print('[client] ${took.inMilliseconds}ms'),
      SsrBuilt(:var took) => print('[ssr] ${took.inMilliseconds}ms'),
      WorkerRestarted() => print('[ssr] worker restarted'),
      ServerReady(:var port) => print('[server] http://localhost:$port'),
      BuildError(:var message) => stderr.writeln('[error] $message'),
    },
  );

  final watchDirs = [
    'lib',
    'example/lib',
    'packages/react/lib',
    'packages/react_codegen/lib',
  ];
  for (var dir in watchDirs) {
    if (!Directory(dir).existsSync()) continue;
    DirectoryWatcher(dir).events.listen((ev) {
      if (ev.path.endsWith('.dart')) ctrl.add(FileChanged(ev.path));
    });
  }

  ProcessHandle? worker;

  Future<void> buildAll() async {
    final env = {'TMP': '.tmp'};
    final res = await Process.run('dart', [
      'run',
      'build_runner',
      'build',
      '--workspace',
    ], environment: env);
    if (res.exitCode != 0) {
      ctrl.add(BuildError(res.stdout.toString() + res.stderr.toString()));
    } else {
      ctrl.add(const FileChanged('build_runner:done'));
    }
  }

  Future<void> buildClient() async {
    final sw = Stopwatch()..start();
    final env = {'TMP': '.tmp'};
    final res = await Process.run('dart', [
      'compile',
      'js',
      '-O0',
      '-o',
      'example/web/client.js',
      'example/web/client.dart',
    ], environment: env);
    sw.stop();
    switch (res.exitCode) {
      case 0:
        ctrl.add(ClientBuilt(sw.elapsed));
      default:
        ctrl.add(BuildError(res.stderr.toString()));
    }
  }

  Future<void> buildSsr() async {
    final sw = Stopwatch()..start();
    final env = {'TMP': '.tmp'};
    final res = await Process.run('dart', [
      'compile',
      'js',
      '-O2',
      '-o',
      'build/ssr.js',
      'example/lib/ssr.dart',
    ], environment: env);
    sw.stop();
    switch (res.exitCode) {
      case 0:
        ctrl.add(SsrBuilt(sw.elapsed));
      default:
        ctrl.add(BuildError(res.stderr.toString()));
    }
  }

  Future<void> restartWorker() async {
    worker?.killTree();
    worker = ProcessHandle(
      await Process.start('node', [
        'ssr_worker.mjs',
      ], mode: ProcessStartMode.inheritStdio),
    );
    ctrl.add(const WorkerRestarted());
  }

  Future<void> startShelf() async {
    final indexTemplate = File('example/web/index.html').readAsStringSync();
    final staticHandler = createStaticHandler(
      'example/web',
      defaultDocument: 'index.html',
    );
    final handler = const Pipeline().addMiddleware(logRequests()).addHandler((
      Request req,
    ) async {
      final isPage =
          req.url.path == '' ||
          req.url.path == '/' ||
          req.url.path == 'index.html';
      if (isPage) {
        try {
          final c = HttpClient();
          final proxy = await c.post('localhost', 3001, '/');
          proxy.write(
            jsonEncode({
              'id': 'package:react_workspace/example/lib/app.dart#App',
              'props': {'title': 'hi'},
            }),
          );
          final res = await proxy.close();
          final body = await res.transform(const Utf8Decoder()).join();
          final data = jsonDecode(body) as Map;
          final html = indexTemplate
              .replaceAll('{{SSR}}', (data['html'] as String?) ?? '')
              .replaceAll('{{PROPS}}', jsonEncode(data['props']));
          return Response.ok(html, headers: {'content-type': 'text/html'});
        } catch (_) {
          // SSR worker not available, serve plain template
          final plain = indexTemplate
              .replaceAll('{{SSR}}', '')
              .replaceAll('{{PROPS}}', '{}');
          return Response.ok(plain, headers: {'content-type': 'text/html'});
        }
      }
      return await staticHandler(req);
    });
    final server = await io.serve(handler, 'localhost', 8080);
    ctrl.add(ServerReady(server.port));
  }

  await buildAll();
  await Future.wait([buildClient(), buildSsr()]);
  await restartWorker();
  await startShelf();

  await for (final e in events) {
    switch (e) {
      case FileChanged(:var path) when path.contains('.dart'):
        await buildAll();
        await Future.wait([buildClient(), buildSsr()]);
        await restartWorker();
      case SsrBuilt():
        await restartWorker();
      default:
        break;
    }
  }
}
