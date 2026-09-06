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
    // One binding across renders, as in a mounted component: the same Dart
    // values must reuse the same boxes so React sees stable dependencies.
    final binding = JsBinding();
    expect(binding.useMemo(() => 'computed', [callback, model]), 'computed');

    final first =
        _globalThis.getProperty('__reactDartMemoDependencies'.toJS) as JSArray;
    expect(first.length, 2);

    expect(binding.useMemo(() => 'computed', [callback, model]), 'computed');
    final second =
        _globalThis.getProperty('__reactDartMemoDependencies'.toJS) as JSArray;
    expect(second.length, 2);
    expect(second[0], same(first[0]));
    expect(second[1], same(first[1]));

    // Distinct-but-equal value objects must not share a box, or React would
    // treat the dependency as unchanged when the Dart instance is replaced.
    final firstTwin = _EqualModel(1);
    final secondTwin = _EqualModel(1);
    expect(firstTwin == secondTwin, isTrue);
    expect(identical(firstTwin, secondTwin), isFalse);
    expect(binding.useMemo(() => 'computed', [firstTwin]), 'computed');
    final twinFirst =
        _globalThis.getProperty('__reactDartMemoDependencies'.toJS) as JSArray;
    expect(binding.useMemo(() => 'computed', [secondTwin]), 'computed');
    final twinSecond =
        _globalThis.getProperty('__reactDartMemoDependencies'.toJS) as JSArray;
    expect(twinSecond[0], isNot(same(twinFirst[0])));
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

/// Value object with structural equality for dependency-identity tests.
final class _EqualModel {
  final int id;

  _EqualModel(this.id);

  @override
  bool operator ==(Object other) => other is _EqualModel && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
