import 'dart:io';

import 'package:code_assets/code_assets.dart';
import 'package:hooks/hooks.dart';
import 'package:native_prebuilt/hooks.dart';
import 'package:native_toolchain_rust/native_toolchain_rust.dart';

import 'package:react_tool/src/hook/react_tool_prebuilts.g.dart';

const _assetName = 'src/ts_bindings.g.dart';
const _cratePath = 'native';

/// Builds the Rust TS-extraction library (oxc) as a code asset for
/// react_tool. The asset name matches the file holding the `@Native`
/// externals so the VM links them automatically.
void main(List<String> args) async {
  await build(args, (input, output) async {
    if (!input.config.buildCodeAssets) return;

    await PrebuiltCodeAssetBuilder(
      assetName: _assetName,
      libraryStem: 'react_ts_bindings',
      manifest: react_toolPrebuilts,
      linkModeResolver: (_) => DynamicLoadingBundled(),
      // Workspace checkouts must exercise the current Rust source. Published
      // packages use native_prebuilt's verified release/cache resolution.
      resolvers: _isWorkspaceCheckout(input.packageRoot)
          ? const <PrebuiltResolver>[]
          : null,
      sourceFallback: SourceFallback(
        sources: const [
          LocalSource(paths: <String>['.']),
        ],
        builder: HookBuilderSourceBuilder.factory(
          (_, _) =>
              const RustBuilder(assetName: _assetName, cratePath: _cratePath),
        ),
      ),
    ).run(input: input, output: output, logger: null);
  });
}

bool _isWorkspaceCheckout(Uri packageRoot) {
  var directory = Directory.fromUri(packageRoot).absolute;
  while (true) {
    if (File('${directory.path}/pubspec.yaml').existsSync() &&
        Directory('${directory.path}/packages').existsSync()) {
      return true;
    }
    final parent = directory.parent;
    if (parent.path == directory.path) return false;
    directory = parent;
  }
}
