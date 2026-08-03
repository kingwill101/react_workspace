import 'package:build/build.dart';
import 'package:glob/glob.dart';

/// Combining builder that collects generated component and server-action
/// registries into package-level entrypoints.
class AggregateBuilder implements Builder {
  @override
  final buildExtensions = {
    r'$lib$': [
      'react_components.g.dart',
      'ssr_registry.g.dart',
      'server_actions.g.dart',
    ],
  };

  @override
  Future<void> build(BuildStep step) async {
    final currentPkg = step.inputId.package;
    final componentInputs = await step
        .findAssets(Glob('**/*.react.g.dart'))
        .where((a) => a.package == currentPkg)
        .toList();
    final actionInputs = await step
        .findAssets(Glob('**/*.registry.g.dart'))
        .where((a) => a.package == currentPkg)
        .toList();

    if (componentInputs.isNotEmpty) {
      await _writeComponentRegistries(step, currentPkg, componentInputs);
    }
    if (actionInputs.isNotEmpty) {
      await _writeActionRegistry(step, currentPkg, actionInputs);
    }
  }

  Future<void> _writeComponentRegistries(
    BuildStep step,
    String pkg,
    List<AssetId> inputs,
  ) async {
    final regNames = <String>[];
    final imports = <String>[];
    final idImports = <String>[];
    final idConstants = <String>[];

    for (final aid in inputs) {
      final content = await step.readAsString(aid);
      final reactDartUri = _toReactDartUri(aid.uri);

      for (final m in RegExp(
        r'void\s+(register\w+)\s*\(',
      ).allMatches(content)) {
        final name = m.group(1)!;
        if (regNames.contains(name)) continue;
        regNames.add(name);
        final cname = name.substring(8);
        final prefix = cname.isEmpty
            ? 'c'
            : '${cname[0].toLowerCase()}${cname.substring(1)}';

        imports.add("import '${aid.uri}' as $prefix;");
        idImports.add("import '$reactDartUri' show id$cname;");
        idConstants.add('    id$cname.value');
      }
    }

    if (regNames.isEmpty) return;
    await _writeComponentsRegistry(step, pkg, imports, regNames);
    await _writeSsRegistry(step, pkg, idImports, idConstants);
  }

  /// Registry-file registration functions emitted by `RegistryFileEmitter`,
  /// e.g. `registerTodosActions` or `registerGreeting`.
  ///
  /// The name is derived from the source library (see
  /// `registry_file_emitter.dart`), so any `register` function in a
  /// `*.registry.g.dart` file is a candidate.
  static List<String> registrationFunctions(String content) =>
      RegExp(
        r'void\s+(register\w+)\s*\(',
      ).allMatches(content).map((m) => m.group(1)!).toList();

  Future<void> _writeActionRegistry(
    BuildStep step,
    String pkg,
    List<AssetId> inputs,
  ) async {
    final imports = <String>[];
    final registrations = <String>[];

    for (var index = 0; index < inputs.length; index++) {
      final aid = inputs[index];
      final content = await step.readAsString(aid);
      final matches = registrationFunctions(content);
      if (matches.isEmpty) continue;

      final prefix = 'serverActions$index';
      imports.add("import '${aid.uri}' as $prefix;");
      for (final match in matches) {
        registrations.add('  $prefix.$match(registry: registry);');
      }
    }

    final buf = StringBuffer()
      ..writeln('// GENERATED CODE — DO NOT EDIT')
      ..writeln()
      ..writeln("import 'package:react_server/react_server.dart';");
    for (final imp in imports) {
      buf.writeln(imp);
    }
    buf
      ..writeln()
      ..writeln(
        '/// Registers every generated server-function registry in this package.',
      )
      ..writeln('void registerServerActions({')
      ..writeln('  required ServerFunctionRegistry registry,')
      ..writeln('}) {');
    for (final registration in registrations) {
      buf.writeln(registration);
    }
    buf.writeln('}');

    await step.writeAsString(
      AssetId(pkg, 'lib/server_actions.g.dart'),
      buf.toString(),
    );
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
      final cname = name.substring(8);
      final prefix = cname.isEmpty
          ? 'c'
          : '${cname[0].toLowerCase()}${cname.substring(1)}';
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
    buf.writeln('final class SsrComponentRegistry {');
    buf.writeln('  SsrComponentRegistry._();');
    buf.writeln();
    buf.writeln(
      '  static final _builders = <String, ReactNode Function(Map<String, dynamic>)>{};',
    );
    buf.writeln();
    buf.writeln(
      '  static void register(String id, ReactNode Function(Map<String, dynamic>) builder) {',
    );
    buf.writeln('    _builders[id] = builder;');
    buf.writeln('  }');
    buf.writeln();
    buf.writeln(
      '  static ReactNode build(String id, Map<String, dynamic> props) {',
    );
    buf.writeln('    final builder = _builders[id];');
    buf.writeln('    if (builder == null) return const Empty();');
    buf.writeln('    return builder(props);');
    buf.writeln('  }');
    buf.writeln();
    buf.writeln('  static Set<String> get knownIds => _builders.keys.toSet();');
    buf.writeln('}');
    buf.writeln();
    buf.writeln('void registerKnownSsComponentIds() {');
    for (final constant in idConstants) {
      buf.writeln(
        '  SsrComponentRegistry.register($constant, (_) => const Empty());',
      );
    }
    buf.writeln('}');

    await step.writeAsString(
      AssetId(pkg, 'lib/ssr_registry.g.dart'),
      buf.toString(),
    );
  }
}
