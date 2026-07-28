import 'package:react_codegen/src/model/model.dart';
import 'package:react_codegen/src/output/callback_emitter.dart';
import 'package:test/test.dart';

void main() {
  group('CallbackEmitter.jsProxy', () {
    test('generates non-nullable callback proxy with invokeJSCallback', () {
      const emitter = CallbackEmitter();
      const callback = ReactCallbackModel(
        positional: [
          ReactCallbackParameter(
            name: 'value',
            type: NamedTypeRef(symbol: 'int', nullable: false),
            valueSpec: ReactValueSpecModel(
              kind: ReactValueKind.integer,
              nullable: false,
            ),
          ),
        ],
        resultType: NamedTypeRef(symbol: 'void'),
        result: ReactValueSpecModel(
          kind: ReactValueKind.void_,
          nullable: false,
        ),
        nullable: false,
        asynchronous: false,
      );

      final output = emitter.jsProxy(
        fieldName: 'onChange',
        callback: callback,
      );

      expect(output, contains('invokeJSCallback'));
      expect(output, contains('encodeReactValue(reactInt, value)'));
      expect(output, contains('onChange'));
    });

    test('generates nullable callback proxy with null check', () {
      const emitter = CallbackEmitter();
      const callback = ReactCallbackModel(
        positional: [
          ReactCallbackParameter(
            name: 'value',
            type: NamedTypeRef(symbol: 'int', nullable: false),
            valueSpec: ReactValueSpecModel(
              kind: ReactValueKind.integer,
              nullable: false,
            ),
          ),
        ],
        resultType: NamedTypeRef(symbol: 'void'),
        result: ReactValueSpecModel(
          kind: ReactValueKind.void_,
          nullable: false,
        ),
        nullable: true,
        asynchronous: false,
      );

      final output = emitter.jsProxy(
        fieldName: 'onChange',
        callback: callback,
      );

      expect(output, contains('_rawonChange'));
      expect(output, contains('isUndefined'));
      expect(output, contains('invokeJSCallback'));
      expect(output, contains('encodeReactValue(reactInt, value)'));
    });

    test('includes decodeReactValue for non-void callback results', () {
      const emitter = CallbackEmitter();
      const callback = ReactCallbackModel(
        positional: [
          ReactCallbackParameter(
            name: 'value',
            type: NamedTypeRef(symbol: 'int', nullable: false),
            valueSpec: ReactValueSpecModel(
              kind: ReactValueKind.integer,
              nullable: false,
            ),
          ),
        ],
        resultType: NamedTypeRef(symbol: 'bool', nullable: false),
        result: ReactValueSpecModel(
          kind: ReactValueKind.boolean,
          nullable: false,
        ),
        nullable: false,
        asynchronous: false,
      );

      final output = emitter.jsProxy(
        fieldName: 'onToggle',
        callback: callback,
      );

      expect(output, contains('decodeReactValue'));
      expect(output, contains('reactBool'));
      expect(output, contains('bool'));
    });

    test('descriptor generates correct ReactCallback expression', () {
      const emitter = CallbackEmitter();
      const callback = ReactCallbackModel(
        positional: [
          ReactCallbackParameter(
            name: 'count',
            type: NamedTypeRef(symbol: 'int', nullable: false),
            valueSpec: ReactValueSpecModel(
              kind: ReactValueKind.integer,
              nullable: false,
            ),
          ),
        ],
        resultType: NamedTypeRef(symbol: 'void'),
        result: ReactValueSpecModel(
          kind: ReactValueKind.void_,
          nullable: false,
        ),
        nullable: false,
        asynchronous: false,
      );

      final output = emitter.descriptor(
        callbackExpression: 'props.onChange',
        debugName: 'Counter.onChange',
        callback: callback,
      );

      expect(output, contains('ReactCallback('));
      expect(output, contains('debugName: \'Counter.onChange\''));
      expect(output, contains('reactInt'));
      expect(output, contains('reactVoid'));
      expect(output, contains('props.onChange'));
      expect(output, contains('arguments[0] as int'));
    });
  });
}