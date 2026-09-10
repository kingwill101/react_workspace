import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:path/path.dart' as p;
import 'package:react_tool/react_tool.dart';
import 'package:test/test.dart';
import 'support/debug_protocol.dart';
import 'support/port_lifecycle.dart';

void main() {
  test(
    'full-stack debug serves SSR and DDC and restores templates on stop',
    () async {
      final reuse = Platform.environment['REACT_DEBUG_FIXTURE'];
      final temporary = reuse == null
          ? await Directory.systemTemp.createTemp('react_debug_session_')
          : Directory(reuse).absolute;
      final marker = File('${temporary.path}/.react_debug_test_fixture');
      if (reuse != null) {
        if (!marker.existsSync() || marker.readAsStringSync() != 'v1\n') {
          throw StateError(
            'Refusing to reuse an unmarked debug fixture: ${temporary.path}',
          );
        }
      } else {
        await marker.writeAsString('v1\n');
      }
      if (reuse == null &&
          Platform.environment['REACT_KEEP_DEBUG_FIXTURE'] != '1') {
        addTearDown(() => temporary.delete(recursive: true));
      } else {
        print('[debug gate] Retaining fixture: ${temporary.path}');
      }
      final uri = await Isolate.resolvePackageUri(
        Uri.parse('package:react_tool/react_tool.dart'),
      );
      final packages = p.dirname(p.dirname(p.dirname(p.fromUri(uri!))));
      final project = Directory('${temporary.path}/app');
      if (reuse == null) {
        await ScaffoldGenerator().generate(
          name: 'debug_consumer',
          packagesPath: packages,
          target: project,
        );
      }
      const appSource = r'''
import 'package:react_dom/react_dom.dart';
import 'package:debug_consumer/.generated/react/greeting.client.g.dart';
@reactComponent
ReactNode App(({String title}) props) {
  final (count, setCount) = useState(0);
  final (message, setMessage) = useState('Waiting');
  void increment(Object? event) {
    setCount(count + 1);
  }
  return div(children: [
    h1(children: [props.title]),
    button(id: 'increment', onClick: increment, children: ['Count $count']),
    button(id: 'greet', onClick: (_) async {
      setMessage(await greetAction(name: 'debug'));
    }, children: ['Greet']),
    div(id: 'message', children: [message]),
  ]);
}
''';
      final appSourceFile = File('${project.path}/lib/react/app.dart');
      await appSourceFile.writeAsString(appSource);
      final get = await Process.run(Platform.resolvedExecutable, [
        'pub',
        'get',
      ], workingDirectory: project.path);
      expect(get.exitCode, 0, reason: '${get.stdout}\n${get.stderr}');
      final index = File('${project.path}/web/index.html');
      final original = await index.readAsString();
      final reserved = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
      final port = reserved.port;
      await reserved.close();
      final chromeProfiles = Directory('${temporary.path}/chrome')
        ..createSync();
      final chromeProfile = await chromeProfiles.createTemp('profile_');
      // Chromium binds a Unix socket below TMPDIR, whose address is limited to
      // roughly 108 bytes. Keep its data on the selected disk-backed temp root,
      // but use a short alias for the socket path in long workspace locations.
      final chromeRuntime = Directory('${temporary.path}/chrome_runtime')
        ..createSync();
      final shortRuntime = await Directory('/tmp').createTemp('react_cdp_');
      addTearDown(() => shortRuntime.delete(recursive: true));
      final runtimeAlias = Link('${shortRuntime.path}/r');
      await runtimeAlias.create(chromeRuntime.path);
      final chrome = await Process.start(
        Platform.environment['CHROME_EXECUTABLE'] ?? 'chromium',
        [
          '--headless',
          '--disable-gpu',
          '--remote-debugging-port=0',
          '--user-data-dir=${chromeProfile.path}',
          'about:blank',
        ],
        environment: {'TMP': runtimeAlias.path, 'TMPDIR': runtimeAlias.path},
      );
      final chromeOutput = StringBuffer();
      final chromeStreams = [
        chrome.stdout.transform(utf8.decoder).listen(chromeOutput.write),
        chrome.stderr.transform(utf8.decoder).listen(chromeOutput.write),
      ];
      addTearDown(() async {
        chrome.kill();
        await chrome.exitCode;
        for (final stream in chromeStreams) {
          await stream.cancel();
        }
      });
      final chromeInfo = File('${chromeProfile.path}/DevToolsActivePort');
      int? chromeExit;
      unawaited(chrome.exitCode.then((code) => chromeExit = code));
      for (
        var i = 0;
        i < 600 && !chromeInfo.existsSync() && chromeExit == null;
        i++
      ) {
        await Future<void>.delayed(const Duration(milliseconds: 100));
      }
      expect(
        chromeInfo.existsSync(),
        isTrue,
        reason: 'Chromium exit: $chromeExit\n$chromeOutput',
      );
      final chromePort = (await chromeInfo.readAsLines()).first;
      final process = await Process.start(Platform.resolvedExecutable, [
        'run',
        'react_tool:react',
        'serve',
        '--debug',
        '--poll',
        '--no-launch-browser',
        '--chrome-debug-port',
        chromePort,
        '--port',
        '$port',
      ], workingDirectory: project.path);
      final output = StringBuffer();
      void record(String line) {
        output.writeln(line);
        if (RegExp(
          r'Error|error|WARNING|SEVERE|Starting|Compiling|Built with|Debug service|SSR worker|Server running|Full-stack',
        ).hasMatch(line)) {
          print('[debug session] $line');
        }
      }

      final subscriptions = [
        process.stdout
            .transform(utf8.decoder)
            .transform(const LineSplitter())
            .listen(record),
        process.stderr
            .transform(utf8.decoder)
            .transform(const LineSplitter())
            .listen(record),
      ];
      var exited = false;
      unawaited(
        process.exitCode.then((_) {
          exited = true;
        }),
      );
      addTearDown(() async {
        if (!exited) {
          process.kill(ProcessSignal.sigterm);
          await process.exitCode.timeout(
            const Duration(seconds: 20),
            onTimeout: () {
              process.kill(ProcessSignal.sigkill);
              return -1;
            },
          );
        }
        for (final subscription in subscriptions) {
          await subscription.cancel();
        }
      });
      final client = HttpClient()
        ..connectionTimeout = const Duration(seconds: 2);
      addTearDown(() => client.close(force: true));
      Future<String> fetch(String path) async {
        final response = await (await client.getUrl(
          Uri.parse('http://127.0.0.1:$port$path'),
        )).close();
        final body = await utf8.decoder.bind(response).join();
        if (response.statusCode != 200) {
          throw StateError('HTTP ${response.statusCode}');
        }
        return body;
      }

      // A fresh consumer compiles the generators, browser and SSR before DDC.
      // Allow cold compilation on constrained hosts without relaxing any of
      // the debugger or lifecycle deadlines below.
      final deadline = DateTime.now().add(const Duration(minutes: 15));
      String? page;
      String? script;
      while (DateTime.now().isBefore(deadline) && !exited) {
        try {
          page = await fetch('/');
          script = await fetch('/client.dart.js');
          if (!script.contains('<html') && script.contains('dart')) break;
        } catch (_) {}
        await Future<void>.delayed(const Duration(seconds: 1));
      }
      expect(exited, isFalse, reason: output.toString());
      expect(
        page,
        contains('<h1>Hello from SSR</h1>'),
        reason: output.toString(),
      );
      expect(page, contains('/client.dart.js'));
      expect(page, isNot(contains('/browser.js')));
      expect(script, isNot(contains('<html')), reason: output.toString());
      expect(script, contains('dart'), reason: output.toString());
      print('[debug gate] SSR HTML and DDC script available');
      final targetsResponse = await (await client.getUrl(
        Uri.parse('http://127.0.0.1:$chromePort/json/list'),
      )).close();
      final targets =
          jsonDecode(await utf8.decoder.bind(targetsResponse).join()) as List;
      final browser = await DebugProtocol.connect(
        targets.firstWhere(
              (target) => target['type'] == 'page',
            )['webSocketDebuggerUrl']
            as String,
      );
      addTearDown(browser.close);
      final browserErrors = StringBuffer();
      final browserEvents = browser.events.stream.listen((event) {
        if (event['method'] == 'Runtime.exceptionThrown' ||
            event['method'] == 'Network.loadingFailed') {
          browserErrors.writeln(jsonEncode(event));
        }
      });
      addTearDown(browserEvents.cancel);
      await browser.call('Page.enable');
      await browser.call('Runtime.enable');
      await browser.call('Network.enable');
      Future<Object?> evaluate(String expression) async => (await browser.call(
        'Runtime.evaluate',
        {'expression': expression, 'returnByValue': true},
      ))['result']['value'];
      Future<void> waitFor(
        Future<bool> Function() ready, {
        Duration timeout = const Duration(seconds: 60),
      }) async {
        final until = DateTime.now().add(timeout);
        while (DateTime.now().isBefore(until)) {
          if (await ready()) return;
          await Future<void>.delayed(const Duration(milliseconds: 100));
        }
        fail('Browser condition timed out.\n$browserErrors\n$output');
      }

      // Verify the incremental compiler independently of DWDS attachment and
      // browser refresh, so a failed build is not misreported as a UI timeout.
      await appSourceFile.writeAsString(
        appSource.replaceAll('Count ', 'Probe '),
      );
      await waitFor(
        () async => (await fetch(
          '/packages/debug_consumer/react/app.ddc.js',
        )).contains('"Probe "'),
        timeout: const Duration(minutes: 2),
      );
      print('[debug gate] Incremental DDC source rebuild verified');
      await appSourceFile.writeAsString(appSource);
      await waitFor(
        () async => (await fetch(
          '/packages/debug_consumer/react/app.ddc.js',
        )).contains('"Count "'),
        timeout: const Duration(minutes: 2),
      );
      await browser.call('Page.navigate', {'url': 'http://127.0.0.1:$port/'});
      print('[debug gate] Navigated Chromium to the gateway');
      await waitFor(
        () async =>
            await evaluate(
              "Object.keys(document.querySelector('#increment') || {}).some(k => k.startsWith('__reactProps'))",
            ) ==
            true,
      );
      await evaluate("document.querySelector('#increment').click()");
      await waitFor(
        () async =>
            await evaluate(
              "document.querySelector('#increment')?.textContent",
            ) ==
            'Count 1',
      );
      final service = File(
        '${project.path}/.dart_tool/react/server_vm_service.json',
      );
      print('[debug gate] Hydration and browser event verified');
      expect(service.existsSync(), isTrue, reason: output.toString());
      final serviceUri = Uri.parse(
        jsonDecode(service.readAsStringSync())['uri'] as String,
      );
      expect(serviceUri.host, '127.0.0.1');
      final serverVm = await DebugProtocol.connect(
        serviceUri.resolve('ws').replace(scheme: 'ws').toString(),
        jsonRpc: true,
      );
      addTearDown(serverVm.close);
      final nativeInfo = await serverVm.call('getVM');
      final nativeIsolate = (nativeInfo['isolates'] as List).firstWhere(
        (isolate) => isolate['name'] == 'main',
      )['id'];
      await serverVm.call('streamListen', {'streamId': 'Debug'});
      final greeting = await File(
        '${project.path}/lib/react/greeting.dart',
      ).readAsLines();
      final nativeBreakpoint = await serverVm.call(
        'addBreakpointWithScriptUri',
        {
          'isolateId': nativeIsolate,
          'scriptUri': 'package:debug_consumer/react/greeting.dart',
          'line':
              greeting.indexWhere((line) => line.contains("return 'Hello")) + 1,
        },
      );
      final nativePaused = serverVm.events.stream
          .firstWhere(
            (event) =>
                event['method'] == 'streamNotify' &&
                event['params']['event']['kind'] == 'PauseBreakpoint',
          )
          .timeout(const Duration(seconds: 30));
      await evaluate("document.querySelector('#greet').click()");
      await nativePaused;
      print('[debug gate] Dart server breakpoint hit');
      await serverVm.call('resume', {'isolateId': nativeIsolate});
      await serverVm.call('removeBreakpoint', {
        'isolateId': nativeIsolate,
        'breakpointId': nativeBreakpoint['id'],
      });
      await waitFor(
        () async =>
            (await evaluate("document.querySelector('#message')?.textContent")
                    as String?)
                ?.contains('Hello, debug!') ??
            false,
      );

      final debugUriPattern = RegExp(r'Debug service listening on (\S+)');
      print('[debug gate] Server action response verified');
      // webdev serve enables debugging but starts the VM service lazily when
      // the user invokes its documented Alt+D / Option+D command.
      for (final type in ['keyDown', 'keyUp']) {
        await browser.call('Input.dispatchKeyEvent', {
          'type': type,
          'key': 'd',
          'code': 'KeyD',
          'modifiers': 1,
          'windowsVirtualKeyCode': 68,
        });
      }
      await waitFor(() async => debugUriPattern.hasMatch(output.toString()));
      final browserVm = await DebugProtocol.connect(
        debugUriPattern.firstMatch(output.toString())!.group(1)!,
        jsonRpc: true,
      );
      addTearDown(browserVm.close);
      final browserInfo = await browserVm.call('getVM');
      final isolate = browserInfo['isolates'][0]['id'] as String;
      final scripts = await browserVm.call('getScripts', {
        'isolateId': isolate,
      });
      final appScript = (scripts['scripts'] as List).firstWhere(
        (script) => (script['uri'] as String).endsWith('/react/app.dart'),
      );
      await browserVm.call('streamListen', {'streamId': 'Debug'});
      final breakpoint = await browserVm.call('addBreakpointWithScriptUri', {
        'isolateId': isolate,
        'scriptUri': appScript['uri'],
        'line':
            appSource
                .split('\n')
                .indexWhere((line) => line.contains('setCount(count + 1)')) +
            1,
      });
      final paused = browserVm.events.stream
          .firstWhere(
            (event) =>
                event['method'] == 'streamNotify' &&
                event['params']['event']['kind'] == 'PauseBreakpoint',
          )
          .timeout(const Duration(seconds: 30));
      final click = evaluate("document.querySelector('#increment').click()");
      await paused;
      print('[debug gate] Browser Dart breakpoint hit');
      await browserVm.call('resume', {'isolateId': isolate});
      await click;
      await browserVm.call('removeBreakpoint', {
        'isolateId': isolate,
        'breakpointId': breakpoint['id'],
      });
      await browser.call('Page.reload');
      await waitFor(
        () async =>
            await evaluate(
              "document.querySelector('#increment')?.textContent === 'Count 0' && "
              "Object.keys(document.querySelector('#increment') || {}).some(k => k.startsWith('__reactProps'))",
            ) ==
            true,
      );
      print('[debug gate] Explicit page reload verified');
      await appSourceFile.writeAsString(
        appSource.replaceAll('Count ', 'Clicks '),
      );
      print('[debug gate] Authored source updated');
      await waitFor(
        () async =>
            await evaluate(
              "document.querySelector('#increment')?.textContent",
            ) ==
            'Clicks 0',
        timeout: const Duration(minutes: 2),
      );
      final vm = await (await client.getUrl(
        serviceUri.resolve('getVM'),
      )).close();
      expect(
        jsonDecode(await utf8.decoder.bind(vm).join())['result']['type'],
        'VM',
      );
      process.kill(ProcessSignal.sigterm);
      await process.exitCode.timeout(const Duration(seconds: 20));
      expect(service.existsSync(), isFalse);
      expect(await index.readAsString(), original);
      expect(
        await File('${project.path}/build/react/index.html').readAsString(),
        contains('/browser.js'),
      );
      final sessionPorts = <int>{
        port,
        serviceUri.port,
        for (final match in RegExp(
          r'(?:http|ws)://(?:localhost|127\.0\.0\.1):(\d+)',
        ).allMatches(output.toString()))
          int.parse(match.group(1)!),
        for (final match in RegExp(
          r'React SSR worker :(\d+)',
        ).allMatches(output.toString()))
          int.parse(match.group(1)!),
      };
      for (final sessionPort in sessionPorts) {
        await waitForPortClosed(sessionPort);
      }
      print(
        '[debug gate] Automatic refresh, template restoration, and closed ports verified',
      );
    },
    timeout: const Timeout(Duration(minutes: 25)),
    tags: ['browser'],
    skip: Platform.environment['REACT_BROWSER_TESTS'] != '1'
        ? 'Set REACT_BROWSER_TESTS=1 to run the Chromium/DWDS integration gate.'
        : false,
  );
}
