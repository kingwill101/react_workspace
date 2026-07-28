import 'package:react/react.dart';
import 'package:test/test.dart';

void main() {
  group('ReactCallback arity', () {
    test('zero arguments', () {
      var called = false;
      final callback = ReactCallback(
        debugName: 'test.zero',
        signature: const (
          positional: [],
          result: reactVoid,
          asynchronous: false,
        ),
        invoke: (_) {
          called = true;
          return null;
        },
      );

      callback.invoke([]);
      expect(called, isTrue);
    });

    test('ignores extra arguments', () {
      var received = -1;
      final callback = ReactCallback(
        debugName: 'test.extra',
        signature: const (
          positional: [reactInt],
          result: reactVoid,
          asynchronous: false,
        ),
        invoke: (arguments) {
          received = arguments[0] as int;
          return null;
        },
      );

      callback.invoke([1, 2, 3]);
      expect(received, 1);
    });

    test('invokes with exact argument count', () {
      var received = <Object?>[];
      final callback = ReactCallback(
        debugName: 'test.exact',
        signature: const (
          positional: [reactInt, reactString],
          result: reactVoid,
          asynchronous: false,
        ),
        invoke: (arguments) {
          received = arguments;
          return null;
        },
      );

      callback.invoke([1, 'two']);
      expect(received, equals([1, 'two']));
    });

    test('five arguments', () {
      var sum = 0;
      final callback = ReactCallback(
        debugName: 'test.many',
        signature: const (
          positional: [
            reactInt,
            reactInt,
            reactInt,
            reactInt,
            reactInt,
          ],
          result: reactInt,
          asynchronous: false,
        ),
        invoke: (arguments) {
          sum = arguments
              .cast<int>()
              .fold(0, (a, b) => a + b);
          return sum;
        },
      );

      final result = callback.invoke([1, 2, 3, 4, 5]);
      expect(sum, 15);
      expect(result, 15);
    });

    test('async invoke returns a future result', () async {
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

      final result = await callback.invoke([7]);
      expect(result, 7);
    });
  });

  group('ReactCallback result encoding', () {
    test('void result returns null', () {
      final callback = ReactCallback(
        signature: const (
          positional: [],
          result: reactVoid,
          asynchronous: false,
        ),
        invoke: (_) => null,
      );

      expect(callback.invoke([]), isNull);
    });

    test('nullable int result passes through null', () {
      final callback = ReactCallback(
        signature: const (
          positional: [],
          result: (kind: ReactValueKind.integer, nullable: true, hostNamespace: null, typeId: null, codecId: null),
          asynchronous: false,
        ),
        invoke: (_) => null,
      );

      expect(callback.invoke([]), isNull);
    });

    test('non-nullable void result returns null', () {
      final callback = ReactCallback(
        signature: const (
          positional: [],
          result: reactVoid,
          asynchronous: false,
        ),
        invoke: (_) => null,
      );

      expect(callback.invoke([]), isNull);
    });
  });

}
