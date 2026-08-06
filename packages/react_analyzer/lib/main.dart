import 'package:analysis_server_plugin/plugin.dart';
import 'package:analysis_server_plugin/registry.dart';

import 'src/assists/convert_to_react_component_assist.dart';
import 'src/fixes/add_client_only_fix.dart';
import 'src/fixes/replace_with_public_api_fix.dart';
import 'src/rules/browser_api_during_ssr_rule.dart';
import 'src/rules/browser_import_in_server_rule.dart';
import 'src/rules/generated_bridge_import_rule.dart';
import 'src/rules/invalid_hook_call_rule.dart';
import 'src/rules/invalid_react_component_rule.dart';
import 'src/rules/js_interop_in_server_rule.dart';

final plugin = ReactAnalyzerPlugin();

class ReactAnalyzerPlugin extends Plugin {
  @override
  String get name => 'React Dart analyzer';

  @override
  void register(PluginRegistry registry) {
    registry
      ..registerWarningRule(InvalidReactComponentRule())
      ..registerWarningRule(InvalidHookCallRule())
      ..registerWarningRule(BrowserApiDuringSsrRule())
      ..registerWarningRule(JsInteropInServerRule())
      ..registerWarningRule(BrowserImportInServerRule())
      ..registerWarningRule(GeneratedBridgeImportRule());

    registry.registerFixForRule(
      BrowserApiDuringSsrRule.code,
      AddClientOnlyFix.new,
    );
    registry.registerFixForRule(
      GeneratedBridgeImportRule.code,
      ReplaceWithPublicApiFix.new,
    );

    registry.registerAssist(ConvertToReactComponentAssist.new);
  }
}
