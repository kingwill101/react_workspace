import 'package:react_codegen/src/model/model.dart';
import 'package:react_codegen/src/output/callback_emitter.dart';
import 'package:react_codegen/src/output/js_bridge_emitter.dart';
import 'package:test/test.dart';

void main() {
  test('round-trips declared component children through React props', () {
    const reactNode = NamedTypeRef(symbol: 'ReactNode');
    const childrenType = NamedTypeRef(
      symbol: 'List',
      typeArguments: [reactNode],
    );
    const component = ReactComponentModel(
      name: 'Panel',
      componentId: 'package:example/panel.dart#Panel',
      returnType: reactNode,
      props: [ReactPropModel(name: 'children', type: childrenType)],
      propsRecord: RecordTypeRef(
        named: [RecordFieldRef(name: 'children', type: childrenType)],
      ),
    );

    final output = const JsBridgeEmitter(callbackEmitter: CallbackEmitter())
        .emit(
          const ReactLibraryModel(
            inputFile: 'panel.dart',
            reactFile: 'panel.react.dart',
            components: [component],
          ),
        );

    expect(
      output,
      contains("o.setProperty('children'.toJS, toReactJS(props.children));"),
    );
    expect(output, contains('final children = reactChildrenFromJS(js);'));
    expect(output, isNot(contains('props.children.jsify()')));
  });
}
