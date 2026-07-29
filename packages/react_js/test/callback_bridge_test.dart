import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'package:react_js/react_js.dart';
import 'package:test/test.dart';

@JS('globalThis')
external JSObject get _testGlobalThis;

@JS('Promise')
external JSAny _testNewPromise(JSFunction executor);

void main() {
  setUp(() {
    final callbacks = JSObject();
    _testGlobalThis.setProperty('__dartReactCallbacks'.toJS, callbacks);
    callbacks.setProperty(
      'create'.toJS,
      (JSAny? reference, JSExportedDartFunction dispatch) {
        return (JSArray<JSAny?> args) {
          return dispatch.callAsFunction(null, reference, args);
        }.toJS;
      }.toJS,
    );
    callbacks.setProperty(
      'createPromise'.toJS,
      (JSFunction executor) {
        return _testNewPromise(executor);
      }.toJS,
    );
    callbacks.setProperty(
      'invoke'.toJS,
      (JSFunction callback, JSArray<JSAny?> args) {
        return callback.callAsFunction(null, args);
      }.toJS,
    );
  });

  group('callbackToJS', () {
    test('caches JS wrapper for the same callback', () {
      final callback = ReactCallback(
        debugName: 'test.cache',
        signature: const (
          positional: [reactInt],
          result: reactVoid,
          asynchronous: false,
        ),
        invoke: (_) => null,
      );

      final first = callbackToJS(callback);
      final second = callbackToJS(callback);

      expect(identical(first, second), isTrue);
    });

    test('async callback creates a JS wrapper', () {
      final callback = ReactCallback(
        debugName: 'test.async',
        signature: const (
          positional: [reactInt],
          result: reactInt,
          asynchronous: true,
        ),
        invoke: (arguments) {
          return Future.value(arguments[0] as int);
        },
      );

      expect(callbackToJS(callback), isNotNull);
    });
  });
}
