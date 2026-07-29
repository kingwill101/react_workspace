import 'package:react_web_generator/src/emit/factory_emitter.dart';
import 'package:react_web_generator/src/web_host_ir.dart';
import 'package:react_web_generator/src/web_dart_type.dart';
import 'package:test/test.dart';

Uri pkg(String s) => Uri.parse(s);

void main() {
  group('FactoryEmitter', () {
    final element = WebHostElementIR(
      tagName: 'div',
      factoryName: 'div',
      namespace: WebNamespace.html,
      elementType: WebDartType(
        symbol: 'HTMLDivElement',
        import: pkg('package:web/web.dart'),
        nullable: false,
      ),
      voidElement: false,
      props: [
        WebHostPropIR(
          idlName: 'id',
          dartName: 'id',
          reactName: 'id',
          dartType: WebDartType(
            symbol: 'String',
            import: pkg('dart:core'),
            nullable: true,
          ),
          required: false,
          clientOnly: false,
          ssrBehavior: WebSsrBehavior.attribute,
        ),
        WebHostPropIR(
          idlName: 'className',
          dartName: 'className',
          reactName: 'className',
          dartType: WebDartType(
            symbol: 'String',
            import: pkg('dart:core'),
            nullable: true,
          ),
          required: false,
          clientOnly: false,
          ssrBehavior: WebSsrBehavior.attribute,
        ),
      ],
      events: [
        WebEventPropIR(
          domEventName: 'click',
          reactName: 'onClick',
          captureName: 'onClickCapture',
          reactEventType: WebDartType(
            symbol: 'ReactMouseEvent',
            import: pkg('package:react_web/events.dart'),
            nullable: false,
            typeArguments: [
              WebDartType(
                symbol: 'HTMLDivElement',
                import: pkg('package:web/web.dart'),
                nullable: false,
              ),
            ],
          ),
          nativeEventType: WebDartType(
            symbol: 'MouseEvent',
            import: pkg('package:web/web.dart'),
            nullable: false,
          ),
        ),
      ],
    );

    test('generates host type constant', () {
      final output = FactoryEmitter([element]).emit();
      expect(
        output,
        contains("const _divHostType = HostType<Map<String, Object?>>('html', 'div');"),
      );
    });

    test('generates factory function with all parameter kinds', () {
      final output = FactoryEmitter([element]).emit();
      expect(output, contains('ReactNode div({'));
      expect(output, contains('String? id,'));
      expect(output, contains('String? className,'));
      expect(output, contains('void Function(ReactMouseEvent<HTMLDivElement>)? onClick,'));
      expect(output, contains('void Function(ReactMouseEvent<HTMLDivElement>)? onClickCapture,'));
      expect(output, contains('void Function(HTMLDivElement?)? ref,'));
      expect(output, contains('List<ReactNode> children = const [],'));
      expect(output, contains('String? key,'));
      expect(output, contains('Map<String, Object?> additionalProps = const {},'));
    });

    test('generates HostNode return with id and className conditionals', () {
      final output = FactoryEmitter([element]).emit();
      expect(output, contains("if (id != null) 'id': id,"));
      expect(output, contains("if (className != null) 'className': className,"));
    });

    test('wraps event callbacks in ReactEventProp', () {
      final output = FactoryEmitter([element]).emit();
      expect(output, contains("ReactEventProp(_divOnClick(onClick))"));
      expect(output, contains("ReactEventProp(_divOnClickCapture(onClickCapture))"));
    });

    test('wraps ref callbacks in ReactRefProp', () {
      final output = FactoryEmitter([element]).emit();
      expect(output, contains("ReactRefProp(_divRef(ref))"));
    });

    test('generates event specs with hostValue kind', () {
      final output = FactoryEmitter([element]).emit();
      expect(output, contains('kind: ReactValueKind.hostValue,'));
      expect(output, contains("hostNamespace: 'web'"));
      expect(
        output,
        contains(
          "typeId: 'ReactMouseEvent<HTMLDivElement>'",
        ),
      );
    });

    test('generates event wrapper with callback function', () {
      final output = FactoryEmitter([element]).emit();
      expect(output, contains('ReactCallback _divOnClick(void Function(ReactMouseEvent<HTMLDivElement>) callback)'));
      expect(output, contains("debugName: 'div.onClick'"));
      expect(output, contains('callback(arguments[0] as ReactMouseEvent<HTMLDivElement>);'));
    });

    test('generates capture event wrapper', () {
      final output = FactoryEmitter([element]).emit();
      expect(output, contains("debugName: 'div.onClickCapture'"));
    });

    test('generates ref wrapper', () {
      final output = FactoryEmitter([element]).emit();
      expect(output, contains('ReactCallback _divRef(void Function(HTMLDivElement?) callback)'));
      expect(output, contains("debugName: 'div.ref'"));
      expect(output, contains('callback(value == null ? null : value as HTMLDivElement);'));
    });

    test('generates deterministic output (same input, same output)', () {
      final a = FactoryEmitter([element]).emit();
      final b = FactoryEmitter([element]).emit();
      expect(a, equals(b));
    });

    test('regenerating different elements produces different output', () {
      final divOutput = FactoryEmitter([element]).emit();

      final span = WebHostElementIR(
        tagName: 'span',
        factoryName: 'span',
        namespace: WebNamespace.html,
        elementType: WebDartType(
          symbol: 'HTMLSpanElement',
          import: pkg('package:web/web.dart'),
          nullable: false,
        ),
        voidElement: false,
        props: [],
        events: [],
      );

      final spanOutput = FactoryEmitter([span]).emit();
      expect(spanOutput, isNot(equals(divOutput)));
      expect(spanOutput, contains("const _spanHostType = HostType<Map<String, Object?>>('html', 'span');"));
    });

    test('generates void elements with element type and ref', () {
      final img = WebHostElementIR(
        tagName: 'img',
        factoryName: 'img',
        namespace: WebNamespace.html,
        elementType: WebDartType(
          symbol: 'HTMLImageElement',
          import: pkg('package:react_web/src/generated/html_interfaces.dart'),
          nullable: false,
        ),
        voidElement: true,
        props: [],
        events: [],
      );

      final output = FactoryEmitter([img]).emit();
      expect(output, contains("HostType<Map<String, Object?>>('html', 'img')"));
      expect(output, contains('ReactNode img({'));
      expect(output, contains('void Function(HTMLImageElement?)? ref,'));
    });

    test('multiple elements are emitted', () {
      final div = element;
      final span = WebHostElementIR(
        tagName: 'span',
        factoryName: 'span',
        namespace: WebNamespace.html,
        elementType: WebDartType(
          symbol: 'HTMLSpanElement',
          import: pkg('package:web/web.dart'),
          nullable: false,
        ),
        voidElement: false,
        props: [],
        events: [],
      );

      final output = FactoryEmitter([div, span]).emit();
      expect(output, contains('const _divHostType'));
      expect(output, contains('const _spanHostType'));
      expect(output, contains('ReactNode div({'));
      expect(output, contains('ReactNode span({'));
    });
  });
}
