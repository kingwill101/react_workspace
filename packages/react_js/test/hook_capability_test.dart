@TestOn('node')
library;

import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:react_js/react_js.dart';
import 'package:test/test.dart';

@JS('globalThis')
external JSObject get _globalThis;

@JS('eval')
external JSAny? _eval(JSString source);

void main() {
  late JSObject react;

  setUp(() {
    react = JSObject();
    _globalThis.setProperty('React'.toJS, react);
  });

  test('useOptimistic explains the React version requirement', () {
    expect(
      // This exercises the renderer binding directly, outside a component.
      // ignore: invalid_hook_call
      () => JsBinding().useOptimistic(0, (int state, int action) => state),
      throwsA(
        isA<UnsupportedError>().having(
          (error) => error.message,
          'message',
          contains('useOptimistic requires React 19 or newer'),
        ),
      ),
    );
  });

  test('useActionState explains the React version requirement', () {
    expect(
      // This exercises the renderer binding directly, outside a component.
      // ignore: invalid_hook_call
      () => JsBinding().useActionState<int, int>(
        (state, action) => state,
        0,
        null,
      ),
      throwsA(
        isA<UnsupportedError>().having(
          (error) => error.message,
          'message',
          contains('useActionState requires React 19 or newer'),
        ),
      ),
    );
  });

  test('useDeferredValue omits the optional argument when absent', () {
    _eval(
      '''globalThis.React.useDeferredValue = function(value, initialValue) {
        globalThis.__reactDartDeferredArgumentCount = arguments.length;
        return arguments.length === 1 ? value : initialValue;
      };'''
          .toJS,
    );

    expect(JsBinding().useDeferredValue(42, null), 42);
    expect(
      (_globalThis.getProperty('__reactDartDeferredArgumentCount'.toJS)
              as JSNumber)
          .toDartInt,
      1,
    );
  });

  test('useDeferredValue forwards a supplied initial value', () {
    _eval(
      '''globalThis.React.useDeferredValue = function(value, initialValue) {
        globalThis.__reactDartDeferredArgumentCount = arguments.length;
        return arguments.length === 1 ? value : initialValue;
      };'''
          .toJS,
    );

    expect(JsBinding().useDeferredValue(42, 7), 7);
    expect(
      (_globalThis.getProperty('__reactDartDeferredArgumentCount'.toJS)
              as JSNumber)
          .toDartInt,
      2,
    );
  });

  test('hook dependencies accept raw Dart values by stable identity', () {
    _eval(
      '''globalThis.React.useMemo = function(factory, dependencies) {
        globalThis.__reactDartMemoDependencies = dependencies;
        return factory();
      };'''
          .toJS,
    );

    int callback(int value) => value + 1;
    final model = Object();
    expect(
      JsBinding().useMemo(() => 'computed', [callback, model]),
      'computed',
    );

    final dependencies =
        _globalThis.getProperty('__reactDartMemoDependencies'.toJS) as JSArray;
    expect(dependencies.length, 2);
  });

  test('renderer passes children as variadic createElement arguments', () {
    _eval(
      '''globalThis.React.createElement = function() {
        globalThis.__reactDartCreateElementArguments = Array.from(arguments);
        return {};
      };'''
          .toJS,
    );

    runWithReactRuntime(
      ReactRuntime(
        target: ReactRenderTarget.test,
        capabilities: ReactRuntimeCapabilities.browser,
        binding: JsBinding(),
        renderer: JsRenderer(),
      ),
      () => JsRenderer().render(
        div(
          children: [
            div(key: 'first'),
            div(key: 'second'),
          ],
        ),
      ),
    );

    final arguments =
        _globalThis.getProperty('__reactDartCreateElementArguments'.toJS)
            as JSArray;
    expect(arguments.length, 4);
  });
}
