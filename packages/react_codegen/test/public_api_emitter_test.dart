import 'package:react_codegen/src/model/model.dart';
import 'package:react_codegen/src/output/public_api_emitter.dart';
import 'package:test/test.dart';

void main() {
  test('emits a callable factory with a typed props builder', () {
    const stringType = NamedTypeRef(symbol: 'String');
    const nullableStringType = NamedTypeRef(symbol: 'String', nullable: true);
    const component = ReactComponentModel(
      name: 'Card',
      componentId: 'package:example/card.dart#Card',
      returnType: NamedTypeRef(symbol: 'ReactNode'),
      props: [
        ReactPropModel(name: 'title', type: stringType),
        ReactPropModel(
          name: 'subtitle',
          type: nullableStringType,
          required: false,
        ),
      ],
      propsRecord: RecordTypeRef(
        named: [
          RecordFieldRef(name: 'title', type: stringType),
          RecordFieldRef(name: 'subtitle', type: nullableStringType),
        ],
      ),
    );

    final output = const PublicApiEmitter().emit(
      const ReactLibraryModel(
        inputFile: 'card.dart',
        reactFile: 'card.react.dart',
        components: [component],
      ),
    );

    expect(output, contains('const Card = _CardFactory();'));
    expect(output, contains('final class _CardFactory'));
    expect(output, contains('ReactNode call({'));
    expect(output, contains('CardPropsBuilder props()'));
    expect(output, contains('late String title;'));
    expect(output, contains('String? subtitle;'));
    expect(output, isNot(contains('ReactChildren children')));
    expect(output, contains('children: const []'));
    expect(output, contains('ReactNode call()'));
  });

  test('only exposes children when the authored component declares them', () {
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

    final output = const PublicApiEmitter().emit(
      const ReactLibraryModel(
        inputFile: 'panel.dart',
        reactFile: 'panel.react.dart',
        components: [component],
      ),
    );

    expect(output, contains('ReactChildren children = const []'));
    expect(output, contains('final normalizedChildren = normalizeChildren'));
    expect(output, contains('children: normalizedChildren'));
    expect(output, contains('children: childValues ?? this.children,'));
  });
}
