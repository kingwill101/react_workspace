import 'package:build/build.dart';
import 'package:glob/glob.dart';

/// Combining builder that collects all generated [.react.g.dart] files and
/// produces [react_components.g.dart] with a single [registerReactComponents]
/// function.
class AggregateBuilder implements Builder {
  @override
  final buildExtensions = {
    r'$lib$': ['react_components.g.dart'],
  };

  @override
  Future<void> build(BuildStep step) async {
    final inputs = await step.findAssets(
      Glob('**/*.react.g.dart'),
    ).toList();

    if (inputs.isEmpty) return;

    // Parse each file for 'void registerXxx()' declarations.
    final regNames = <String>[];
    final imports = <String>[];

    for (final aid in inputs) {
      final content = await step.readAsString(aid);
      for (final m in RegExp(r'void\s+(register\w+)\s*\(').allMatches(content)) {
        final name = m.group(1)!;
        if (regNames.contains(name)) continue;
        regNames.add(name);
        // Derive a unique prefix from the component name
        final cname = name.startsWith('register')
            ? name.substring(8)
            : name;
        final prefix = cname.isEmpty ? 'c' : '${cname[0].toLowerCase()}${cname.substring(1)}';
        imports.add("import '${aid.uri}' as $prefix;");
      }
    }

    if (regNames.isEmpty) return;

    final buf = StringBuffer()
      ..writeln('// GENERATED CODE — DO NOT EDIT')
      ..writeln();
    for (final imp in imports) {
      buf.writeln(imp);
    }
    buf.writeln();
    buf.writeln('/// Registers all generated React components.');
    buf.writeln('void registerReactComponents() {');
    for (final name in regNames) {
      final cname = name.startsWith('register') ? name.substring(8) : name;
      final prefix = cname.isEmpty ? 'c' : '${cname[0].toLowerCase()}${cname.substring(1)}';
      buf.writeln('  $prefix.$name();');
    }
    buf.writeln('}');

    final pkg = inputs.first.package;
    await step.writeAsString(
      AssetId(pkg, 'lib/react_components.g.dart'),
      buf.toString(),
    );
  }
}