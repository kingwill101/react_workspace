import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:react_web_generator/react_web_generator.dart';
import 'package:react_web_generator/src/model/type_ref.dart';
import 'package:test/test.dart';

void main() {
  test(
    'generation paths are rooted independently of the working directory',
    () {
      final root = Directory.systemTemp.createTempSync('web_generation_paths_');
      addTearDown(() => root.deleteSync(recursive: true));
      final paths = WebGenerationPaths(root);

      expect(
        paths.webApisSnapshot.path,
        p.join(root.absolute.path, 'tool/web_idl/snapshots/web_apis.json'),
      );
      expect(
        paths.relative(paths.hostTypeRegistry.path),
        p.join(
          'packages',
          'react_codegen',
          'lib',
          'src',
          'generated',
          'web_host_types.g.dart',
        ),
      );
    },
  );

  test('host registry output is sorted and deterministic', () {
    const model = CompleteWebModel(
      interfaces: {
        'Zeta': IdlInterface(name: 'Zeta', spec: 'z'),
        'Alpha': IdlInterface(name: 'Alpha', spec: 'a'),
      },
      mixins: {
        'Gamma': IdlMixin(name: 'Gamma', spec: 'g'),
        'Beta': IdlMixin(name: 'Beta', spec: 'b'),
      },
      dictionaries: {},
      namespaces: {},
      enums: {},
      typedefs: {},
      callbacks: {},
      callbackInterfaces: {},
      specOf: {'Zeta': 'z', 'Alpha': 'a', 'Gamma': 'g', 'Beta': 'b'},
    );

    final output = const HostTypeRegistryEmitter().emit(model);

    expect(output.indexOf("'Alpha'"), lessThan(output.indexOf("'Zeta'")));
    expect(output.indexOf("'Beta'"), lessThan(output.indexOf("'Gamma'")));
    expect(const HostTypeRegistryEmitter().emit(model), output);
  });

  test('neutral surface imports only types present in emitted signatures', () {
    final root = Directory.systemTemp.createTempSync('neutral_imports_');
    addTearDown(() => root.deleteSync(recursive: true));
    const model = CompleteWebModel(
      interfaces: {
        'Source': IdlInterface(
          name: 'Source',
          spec: 'source',
          members: [
            IdlOperation(
              name: 'Target',
              returnType: NamedTypeRef(typeId: 'web.Target'),
            ),
            IdlAttribute(
              name: 'used',
              type: NamedTypeRef(typeId: 'web.Used'),
              readonly: true,
            ),
          ],
        ),
        'Target': IdlInterface(name: 'Target', spec: 'target'),
        'Used': IdlInterface(name: 'Used', spec: 'used'),
      },
      mixins: {},
      dictionaries: {},
      namespaces: {'empty': IdlNamespace(name: 'empty', spec: 'empty')},
      enums: {},
      typedefs: {},
      callbacks: {},
      callbackInterfaces: {},
      specOf: {
        'Source': 'source',
        'Target': 'target',
        'Used': 'used',
        'empty': 'empty',
      },
    );

    NeutralSurfaceEmitter(model).emitTo(root.path);

    final source = File(p.join(root.path, 'source.dart')).readAsStringSync();
    expect(source, contains("import 'used.dart';"));
    expect(source, isNot(contains("import 'target.dart';")));
    final empty = File(p.join(root.path, 'empty.dart')).readAsStringSync();
    expect(empty, isNot(contains('web_runtime.dart')));
  });
}
