import 'package:build/build.dart';
import 'package:glob/glob.dart';

/// Combining builder that collects all generated [.react.g.dart] files and
/// produces [react_components.g.dart] with a single [registerReactComponents]
/// function.
///
/// It also generates [ssr_registry.g.dart] that maps canonical [ComponentId]
/// values to SSR component builders, eliminating hardcoded ID strings.
class AggregateBuilder implements Builder {
  @override
  final buildExtensions = {
    r'$lib$': ['react_components.g.dart', 'ssr_registry.g.dart'],
  };

  @override
  Future<void> build(BuildStep step) async {
    final inputs = await step.findAssets(
      Glob('**/*.react.g.dart'),
    ).toList();

    if (inputs.isEmpty) return;

    final regNames = <String>[];
    final imports = <String>[];
    final idImports = <String>[];
    final idConstants = <String>[];

    for (final aid in inputs) {
      final content = await step.readAsString(aid);
      final reactDartUri = _toReactDartUri(aid.uri);

      for (final m in RegExp(r'void\s+(register\w+)\s*\(').allMatches(content)) {
        final name = m.group(1)!;
        if (regNames.contains(name)) continue;
        regNames.add(name);
        final cname = name.startsWith('register') ? name.substring(8) : name;
        final prefix = cname.isEmpty ? 'c' : '${cname[0].toLowerCase()}${cname.substring(1)}';

        imports.add("import '$reactDartUri' as $prefix;");
        idImports.add("import '$reactDartUri' show id$cname;");
        idConstants.add('    id$cname.value');
      }
    }

    if (regNames.isEmpty) return;

    final pkg = inputs.first.package;

    await _writeComponentsRegistry(step, pkg, imports, regNames);
    await _writeSsRegistry(step, pkg, idImports, idConstants);
  }

  String _toReactDartUri(Uri uri) =>
      uri.toString().replaceAll('.react.g.dart', '.react.dart');

  Future<void> _writeComponentsRegistry(
    BuildStep step,
    String pkg,
    List<String> imports,
    List<String> regNames,
  ) async {
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

    await step.writeAsString(
      AssetId(pkg, 'lib/react_components.g.dart'),
      buf.toString(),
    );
  }

  Future<void> _writeSsRegistry(
    BuildStep step,
    String pkg,
    List<String> idImports,
    List<String> idConstants,
  ) async {
    final buf = StringBuffer()
      ..writeln('// GENERATED CODE — DO NOT EDIT')
      ..writeln();
    buf.writeln("import 'package:react/react.dart';");
    for (final imp in idImports) {
      buf.writeln(imp);
    }
    buf.writeln();
    buf.writeln('/// Maps canonical component IDs to their SSR builders.');
    buf.writeln('///');
    buf.writeln('/// Generated from the component model. Application-specific defaults');
    buf.writeln('/// (e.g. fallback values) are applied by the application in');
    buf.writeln('/// [registerSsrComponentBuilders].');
    buf.writeln('final class SsrComponentRegistry {');
    buf.writeln('  SsrComponentRegistry._();');
    buf.writeln();
    buf.writeln('  static final _builders = <String, ReactNode Function(Map<String, dynamic>)>{};');
    buf.writeln();
    buf.writeln('  static void register(String id, ReactNode Function(Map<String, dynamic>) builder) {');
    buf.writeln('    _builders[id] = builder;');
    buf.writeln('  }');
    buf.writeln();
    buf.writeln('  static ReactNode build(String id, Map<String, dynamic> props) {');
    buf.writeln('    final builder = _builders[id];');
    buf.writeln('    if (builder == null) return const Empty();');
    buf.writeln('    return builder(props);');
    buf.writeln('  }');
    buf.writeln();
    buf.writeln('  static Set<String> get knownIds => _builders.keys.toSet();');
    buf.writeln('}');
    buf.writeln();
    buf.writeln('/// Registers all known component ID placeholders with [SsrComponentRegistry].');
    buf.writeln('/// Application-specific builders must be registered separately using');
    buf.writeln('/// [SsrComponentRegistry.register].');
    buf.writeln('void registerKnownSsComponentIds() {');
    for (final constant in idConstants) {
      buf.writeln('  SsrComponentRegistry.register($constant, (_) => const Empty());');
    }
    buf.writeln('}');

    await step.writeAsString(
      AssetId(pkg, 'lib/ssr_registry.g.dart'),
      buf.toString(),
    );
  }
}