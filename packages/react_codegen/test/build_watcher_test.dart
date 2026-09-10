import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:build/build.dart';
import 'package:react_codegen/react_codegen.dart';
import 'package:test/test.dart';
import 'package:watcher/watcher.dart';

void main() {
  test('builder opt-in is idempotent and polls source lifecycle', () async {
    final directory = await Directory.systemTemp.createTemp('react_poll_');
    addTearDown(() => directory.delete(recursive: true));
    componentBuilder(BuilderOptions.empty);
    // On platforms with native support, ordinary builds retain that default.
    if (FileSystemEntity.isWatchSupported) {
      expect(
        DirectoryWatcher(directory.path),
        isNot(isA<PollingDirectoryWatcher>()),
      );
    }
    const options = BuilderOptions({'watcher': 'polling'});
    componentBuilder(options);
    aggregateBuilder(options);
    serverFunctionBuilder(options);
    final watcher = DirectoryWatcher(
      directory.path,
      pollingDelay: const Duration(milliseconds: 20),
    );
    expect(watcher, isA<PollingDirectoryWatcher>());
    final events = StreamIterator(watcher.events);
    addTearDown(events.cancel);
    final first = events.moveNext();
    await watcher.ready;
    final source = File('${directory.path}/source.dart');
    await source.writeAsString('initial');
    expect(await first.timeout(const Duration(seconds: 5)), isTrue);
    expect(events.current.type, ChangeType.ADD);
    expect(events.current.path, source.path);
    final modified = events.moveNext();
    await source.writeAsString('modified content');
    expect(await modified.timeout(const Duration(seconds: 5)), isTrue);
    expect(events.current.type, ChangeType.MODIFY);
    final removed = events.moveNext();
    await source.delete();
    expect(await removed.timeout(const Duration(seconds: 5)), isTrue);
    expect(events.current.type, ChangeType.REMOVE);
    await events.cancel();
  });

  test('advertises the polling capability to matching tooling', () {
    final manifest = jsonDecode(File('react_tooling.json').readAsStringSync());
    expect(manifest['schemaVersion'], 1);
    expect(manifest['features'], contains('polling_watcher'));
  });
}
