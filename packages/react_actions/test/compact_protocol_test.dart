import 'package:react_actions/react_actions.dart';
import 'package:test/test.dart';

void main() {
  group('ReactFrame', () {
    test('round-trips a CBOR payload', () {
      const frame = ReactFrame(
        kind: ReactMessageKind.invoke,
        actionId: 12,
        requestId: 34,
        flags: ReactFrameFlags.streaming,
        payload: {
          'name': 'Ada',
          'enabled': true,
          'values': [1, 2, 3],
        },
      );

      final decoded = ReactFrame.decode(frame.encode());
      expect(decoded.version, compactProtocolVersion);
      expect(decoded.kind, ReactMessageKind.invoke);
      expect(decoded.actionId, 12);
      expect(decoded.requestId, 34);
      expect(decoded.flags, ReactFrameFlags.streaming);
      expect(decoded.payload, {
        'name': 'Ada',
        'enabled': true,
        'values': [1, 2, 3],
      });
    });

    test('supports JavaScript-safe identifiers', () {
      const frame = ReactFrame(
        kind: ReactMessageKind.result,
        actionId: 0x1fffffffffffff,
        requestId: 0x1ffffffffffffe,
        payload: null,
      );
      final decoded = ReactFrame.decode(frame.encode());
      expect(decoded.actionId, 0x1fffffffffffff);
      expect(decoded.requestId, 0x1ffffffffffffe);
      expect(decoded.payload, isNull);
    });

    test('rejects invalid magic', () {
      final bytes = const ReactFrame(
        kind: ReactMessageKind.invoke,
        actionId: 1,
        requestId: 1,
        payload: null,
      ).encode();
      bytes[0] = 0;
      expect(() => ReactFrame.decode(bytes), throwsFormatException);
    });

    test('rejects unknown message kinds', () {
      final bytes = const ReactFrame(
        kind: ReactMessageKind.invoke,
        actionId: 1,
        requestId: 1,
        payload: null,
      ).encode();
      bytes[4] = 99;
      expect(() => ReactFrame.decode(bytes), throwsFormatException);
    });

    test('rejects trailing bytes', () {
      final bytes = <int>[
        ...const ReactFrame(
          kind: ReactMessageKind.invoke,
          actionId: 1,
          requestId: 1,
          payload: null,
        ).encode(),
        0,
      ];
      expect(() => ReactFrame.decode(bytes), throwsFormatException);
    });

    test('rejects malformed varints', () {
      expect(
        () => ReactFrame.decode(<int>[
          ...compactProtocolMagic,
          2,
          1,
          0,
          ...List.filled(8, 0x80),
        ]),
        throwsFormatException,
      );
    });

    test('rejects negative identifiers', () {
      const frame = ReactFrame(
        kind: ReactMessageKind.invoke,
        actionId: -1,
        requestId: 1,
        payload: null,
      );
      expect(frame.encode, throwsArgumentError);
    });
  });
}
