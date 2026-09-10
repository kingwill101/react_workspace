import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';
import 'support/debug_protocol.dart';

void main() {
  test(
    'debug transport receives replies from real Chromium',
    () async {
      final root = await Directory.systemTemp.createTemp('react_cdp_test_');
      addTearDown(() => root.delete(recursive: true));
      final short = await Directory('/tmp').createTemp('rcdp_');
      addTearDown(() => short.delete(recursive: true));
      final alias = Link('${short.path}/r');
      await alias.create(root.path);
      final chrome = await Process.start(
        Platform.environment['CHROME_EXECUTABLE'] ?? 'chromium',
        [
          '--headless',
          '--remote-debugging-port=0',
          '--user-data-dir=${root.path}/profile',
          'about:blank',
        ],
        environment: {'TMPDIR': alias.path, 'TMP': alias.path},
      );
      final errors = StringBuffer();
      final stdout = chrome.stdout.listen((_) {});
      final stderr = chrome.stderr.transform(utf8.decoder).listen(errors.write);
      addTearDown(() async {
        chrome.kill();
        await chrome.exitCode;
        await stdout.cancel();
        await stderr.cancel();
      });
      final info = File('${root.path}/profile/DevToolsActivePort');
      for (var i = 0; i < 100 && !info.existsSync(); i++) {
        await Future<void>.delayed(const Duration(milliseconds: 100));
      }
      expect(info.existsSync(), isTrue, reason: errors.toString());
      final port = (await info.readAsLines()).first;
      final client = HttpClient();
      addTearDown(() => client.close(force: true));
      final response = await (await client.getUrl(
        Uri.parse('http://127.0.0.1:$port/json/list'),
      )).close();
      final targets =
          jsonDecode(await utf8.decoder.bind(response).join()) as List;
      final protocol = await DebugProtocol.connect(
        targets.firstWhere((t) => t['type'] == 'page')['webSocketDebuggerUrl']
            as String,
      );
      addTearDown(protocol.close);
      await protocol.call('Page.enable');
      final result = await protocol.call('Runtime.evaluate', {
        'expression': '1 + 1',
        'returnByValue': true,
      });
      expect(result['result']['value'], 2);
    },
    tags: ['browser'],
    skip: Platform.environment['REACT_BROWSER_TESTS'] != '1',
  );
}
