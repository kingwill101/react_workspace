import 'package:react_web_generator/src/complete/definition.dart';
import 'package:react_web_generator/src/complete/member.dart';
import 'package:react_web_generator/src/complete/model.dart';
import 'package:react_web_generator/src/emit/browser_adapter_plan.dart';
import 'package:react_web_generator/src/model/type_ref.dart';
import 'package:test/test.dart';

void main() {
  test('discovers wrapper closure and constructible interfaces', () {
    final model = _model(
      interfaces: {
        'Element': const IdlInterface(
          name: 'Element',
          spec: 'dom',
          members: [
            IdlAttribute(
              name: 'ownerDocument',
              type: NamedTypeRef(typeId: 'web.Document'),
              readonly: true,
            ),
          ],
        ),
        'Document': const IdlInterface(name: 'Document', spec: 'dom'),
        'BroadcastChannel': const IdlInterface(
          name: 'BroadcastChannel',
          spec: 'html',
          members: [IdlConstructor(parameters: [])],
        ),
        'Unreferenced': const IdlInterface(name: 'Unreferenced', spec: 'test'),
      },
    );

    final plan = BrowserAdapterPlanner(model).build();

    expect(
      plan.wrapperNames,
      containsAll(['Element', 'Document', 'BroadcastChannel']),
    );
    expect(plan.wrapperNames, isNot(contains('Unreferenced')));
    expect(plan.constructibleNames, ['BroadcastChannel']);
  });

  test('classifies callbacks and records escaped JavaScript names', () {
    final model = _model(
      interfaces: {
        'Element': const IdlInterface(
          name: 'Element',
          spec: 'dom',
          members: [
            IdlAttribute(
              name: 'class',
              type: NamedTypeRef(typeId: 'core.String'),
              readonly: false,
            ),
            IdlAttribute(
              name: 'handler',
              type: NamedTypeRef(typeId: 'web.Handler'),
              readonly: false,
            ),
          ],
        ),
      },
      callbacks: {
        'Handler': const IdlCallback(
          name: 'Handler',
          spec: 'dom',
          returnType: NamedTypeRef(typeId: 'core.void'),
        ),
      },
    );

    final plan = BrowserAdapterPlanner(model).build();

    expect(plan.memberKinds['BrowserElement.class_'], 'string');
    expect(plan.jsNames['BrowserElement.class_'], 'class');
    expect(plan.memberKinds['BrowserElement.handler'], 'jsfunction');
  });
}

CompleteWebModel _model({
  required Map<String, IdlInterface> interfaces,
  Map<String, IdlCallback> callbacks = const {},
}) => CompleteWebModel(
  interfaces: interfaces,
  mixins: const {},
  dictionaries: const {},
  namespaces: const {},
  enums: const {},
  typedefs: const {},
  callbacks: callbacks,
  callbackInterfaces: const {},
  specOf: {
    for (final interface in interfaces.values) interface.name: interface.spec,
    for (final callback in callbacks.values) callback.name: callback.spec,
  },
);
