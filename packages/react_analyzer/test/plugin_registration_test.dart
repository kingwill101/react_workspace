// The concrete registry is the analysis_server_plugin host implementation.
// ignore_for_file: implementation_imports

import 'package:analysis_server_plugin/src/registry.dart';
import 'package:react_analyzer/main.dart';
import 'package:test/test.dart';

void main() {
  test('registers every React rule, fix, and assist with the plugin host', () {
    final registry = PluginRegistryImpl('react_analyzer_test');

    plugin.register(registry);

    expect(plugin, isA<ReactAnalyzerPlugin>());
    expect(plugin.name, 'React Dart analyzer');
    expect(
      registry.warningRules.keys,
      containsAll(<String>[
        'invalid_react_component',
        'invalid_hook_call',
        'browser_api_during_ssr',
        'js_interop_in_server',
        'browser_import_in_server',
        'generated_bridge_import',
      ]),
    );
    expect(registry.warningRules, hasLength(6));
    expect(
      registry.fixKinds.keys.map((kind) => kind.id),
      containsAll(<String>[
        'react.fix.addClientOnly',
        'react.fix.replaceWithPublicApi',
      ]),
    );
    expect(
      registry.fixKinds.values.expand((codes) => codes),
      containsAll(<String>[
        'browser_api_during_ssr',
        'generated_bridge_import',
      ]),
    );
    expect(
      registry.assistKinds.map((kind) => kind.id),
      contains('react.assist.convertToReactComponent'),
    );
  });
}
