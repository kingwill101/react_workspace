import 'package:hooks/hooks.dart';
import 'package:native_toolchain_rust/native_toolchain_rust.dart';

/// Builds the Rust TS-extraction library (oxc) as a code asset for
/// react_tool. The asset name matches the file holding the `@Native`
/// externals so the VM links them automatically.
void main(List<String> args) async {
  await build(args, (input, output) async {
    await const RustBuilder(
      assetName: 'src/ts_bindings.g.dart',
    ).run(input: input, output: output);
  });
}
