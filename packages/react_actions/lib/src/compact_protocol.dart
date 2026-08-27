import 'dart:convert';
import 'dart:typed_data';

import 'package:cbor/simple.dart' as cbor;

import 'protocol.dart';

/// Version of the compact React Dart frame protocol.
const int compactProtocolVersion = 2;

/// Content type for a compact React Dart frame.
const String compactProtocolContentType = 'application/vnd.react.dart.action';

/// Maximum CBOR payload accepted by [ReactFrame].
const int compactProtocolMaxPayloadBytes = 1024 * 1024;

/// The three-byte marker at the beginning of every compact frame.
const List<int> compactProtocolMagic = <int>[0x52, 0x44, 0x50];

/// Returns the build-independent numeric hint for a generated action ID.
///
/// The full string ID remains in the payload until generated manifests expose
/// a compact lookup table. Servers must validate the string ID and contract;
/// this value is only a fast routing hint and is not an authorization token.
int compactActionId(String id) {
  // Dart2JS cannot represent every 64-bit integer as a JS Number. Keep the
  // hash split into unsigned 32-bit halves; each intermediate multiplication
  // remains below 2^53 and is therefore exact in both Dart VM and Dart2JS.
  var upper = 0xcbf29ce4;
  var lower = 0x84222325;
  for (final byte in utf8.encode(id)) {
    lower ^= byte;
    final inputLower = lower;
    final lowProduct = inputLower * 0x1b3;
    final carry = lowProduct ~/ 0x100000000;
    lower = lowProduct % 0x100000000;
    upper = (upper * 0x1b3 + carry + inputLower * 0x100) % 0x100000000;
  }
  // Frame identifiers are constrained to the exact JS integer range. Using
  // the low 53 bits preserves more entropy than the old 32-bit projection.
  return (upper & 0x1fffff) * 0x100000000 + lower;
}

/// Message types supported by the compact protocol.
enum ReactMessageKind {
  /// Invokes a server function.
  invoke(1),

  /// Requests or carries a rendered result.
  render(2),

  /// Completes an invocation with a result.
  result(3),

  /// Completes an invocation with a structured error.
  error(4),

  /// Starts a streamed response.
  streamStart(5),

  /// Carries one streamed response chunk.
  streamChunk(6),

  /// Completes a streamed response.
  streamEnd(7);

  const ReactMessageKind(this.value);

  /// Stable numeric value written to the wire.
  final int value;

  /// Returns the message kind for a wire value.
  static ReactMessageKind fromValue(int value) {
    for (final kind in values) {
      if (kind.value == value) return kind;
    }
    throw FormatException('Unknown compact message kind: $value.');
  }
}

/// Optional flags stored in a [ReactFrame].
abstract final class ReactFrameFlags {
  /// Indicates that the message is part of a stream.
  static const int streaming = 1 << 0;
}

/// A compact, versioned binary message used by React Dart transports.
///
/// The frame contains opaque numeric action and request identifiers followed
/// by a CBOR payload. Package paths and Dart symbols are intentionally kept
/// out of the wire representation. The generated build manifest maps action
/// identifiers to server handlers.
///
/// The layout is:
///
/// ```text
/// magic(3) version(1) kind(1) flags(1)
/// action-id(varint) request-id(varint) payload-length(varint) payload(CBOR)
/// ```
///
/// This type only defines framing. HTTP headers, authentication, origin
/// checks, and action authorization remain responsibilities of the transport
/// adapter and server.
final class ReactFrame {
  /// Creates a compact protocol frame.
  const ReactFrame({
    required this.kind,
    required this.actionId,
    required this.requestId,
    required this.payload,
    this.flags = 0,
    this.version = compactProtocolVersion,
  });

  /// Message type.
  final ReactMessageKind kind;

  /// Build-scoped numeric action identifier.
  final int actionId;

  /// Request identifier used to correlate a response.
  final int requestId;

  /// Optional CBOR-compatible message payload.
  final Object? payload;

  /// Frame flags.
  final int flags;

  /// Protocol version.
  final int version;

  /// Encodes this frame into bytes.
  Uint8List encode() {
    _validateByte(version, 'version');
    _validateByte(flags, 'flags');
    _validateIdentifier(actionId, 'actionId');
    _validateIdentifier(requestId, 'requestId');

    final payloadBytes = cbor.cbor.encode(payload);
    if (payloadBytes.length > compactProtocolMaxPayloadBytes) {
      throw ArgumentError.value(
        payloadBytes.length,
        'payload',
        'exceeds $compactProtocolMaxPayloadBytes bytes',
      );
    }

    return Uint8List.fromList(<int>[
      ...compactProtocolMagic,
      version,
      kind.value,
      flags,
      ..._encodeVarint(actionId),
      ..._encodeVarint(requestId),
      ..._encodeVarint(payloadBytes.length),
      ...payloadBytes,
    ]);
  }

  /// Decodes and validates one complete frame.
  factory ReactFrame.decode(List<int> bytes) {
    final reader = _FrameReader(bytes);
    if (reader.remaining < 6) {
      throw const FormatException('Compact frame is truncated.');
    }
    for (var i = 0; i < compactProtocolMagic.length; i++) {
      if (reader.readByte() != compactProtocolMagic[i]) {
        throw const FormatException('Invalid compact frame magic.');
      }
    }

    final version = reader.readByte();
    if (version != compactProtocolVersion) {
      throw FormatException('Unsupported compact protocol version: $version.');
    }
    final kind = ReactMessageKind.fromValue(reader.readByte());
    final flags = reader.readByte();
    final actionId = reader.readVarint('action ID');
    final requestId = reader.readVarint('request ID');
    final payloadLength = reader.readVarint('payload length');
    if (payloadLength > compactProtocolMaxPayloadBytes) {
      throw const FormatException('Compact frame payload is too large.');
    }
    if (reader.remaining != payloadLength) {
      throw const FormatException(
        'Compact frame has an invalid payload length.',
      );
    }

    final payload = _decodePayload(reader.readBytes(payloadLength));
    return ReactFrame(
      version: version,
      kind: kind,
      flags: flags,
      actionId: actionId,
      requestId: requestId,
      payload: payload,
    );
  }

  static Object? _decodePayload(List<int> bytes) {
    try {
      return _normalizeDecoded(cbor.cbor.decode(bytes));
    } on Object catch (error) {
      throw FormatException('Invalid CBOR payload: $error.');
    }
  }

  static Object? _normalizeDecoded(Object? value) => switch (value) {
    Map<Object?, Object?> map => <String, Object?>{
      for (final entry in map.entries)
        if (entry.key is String)
          entry.key as String: _normalizeDecoded(entry.value),
    },
    List<Object?> list => [for (final item in list) _normalizeDecoded(item)],
    _ => value,
  };
}

/// A validated server-function request carried by a compact invoke frame.
final class CompactServerFunctionRequest {
  /// Decodes a compact invoke frame and validates its envelope shape.
  factory CompactServerFunctionRequest.decode(List<int> bytes) {
    final frame = ReactFrame.decode(bytes);
    if (frame.kind != ReactMessageKind.invoke) {
      throw const FormatException('Expected a compact invoke frame.');
    }
    final payload = frame.payload;
    if (payload is! Map) {
      throw const FormatException('Compact action payload must be a map.');
    }
    final id = payload['id'];
    if (id is! String || id.isEmpty) {
      throw const FormatException('Compact action payload is missing its ID.');
    }
    // The numeric ID is a routing hint until generated manifests expose a
    // compact lookup table. The authenticated string ID remains canonical.
    if (!payload.containsKey('arguments')) {
      throw const FormatException(
        'Compact action payload is missing its arguments.',
      );
    }
    final contract = payload['contract'];
    if (contract != null && contract is! String) {
      throw const FormatException('Compact action contract must be a string.');
    }
    return CompactServerFunctionRequest._(
      frame,
      id,
      contract as String?,
      payload['arguments'],
    );
  }

  const CompactServerFunctionRequest._(
    this.frame,
    this.id,
    this.contract,
    this.arguments,
  );

  /// Original frame metadata.
  final ReactFrame frame;

  /// Generated server-function ID.
  final String id;

  /// Generated codec contract hash, when present.
  final String? contract;

  /// Encoded action arguments.
  final Object? arguments;

  /// Encodes a successful response for this request.
  ReactFrame success(Object? result) => ReactFrame(
    kind: ReactMessageKind.result,
    actionId: frame.actionId,
    requestId: frame.requestId,
    payload: {'ok': true, 'result': result},
  );

  /// Encodes a structured error response for this request.
  ReactFrame failure(ServerFunctionError error) => ReactFrame(
    kind: ReactMessageKind.error,
    actionId: frame.actionId,
    requestId: frame.requestId,
    payload: {'ok': false, 'error': error.toJson()},
  );
}

const int _maxSafeInteger = 0x1fffffffffffff;

void _validateByte(int value, String name) {
  if (value < 0 || value > 255) {
    throw ArgumentError.value(value, name, 'must fit in one byte');
  }
}

void _validateIdentifier(int value, String name) {
  if (value < 0 || value > _maxSafeInteger) {
    throw ArgumentError.value(
      value,
      name,
      'must be a non-negative JavaScript-safe integer',
    );
  }
}

List<int> _encodeVarint(int value) {
  final bytes = <int>[];
  do {
    var byte = value & 0x7f;
    value >>= 7;
    if (value != 0) byte |= 0x80;
    bytes.add(byte);
  } while (value != 0);
  return bytes;
}

final class _FrameReader {
  _FrameReader(List<int> bytes) : _bytes = bytes;

  final List<int> _bytes;
  var _offset = 0;

  int get remaining => _bytes.length - _offset;

  int readByte() {
    if (_offset >= _bytes.length) {
      throw const FormatException('Compact frame is truncated.');
    }
    return _bytes[_offset++];
  }

  int readVarint(String name) {
    var value = 0;
    var shift = 0;
    for (var i = 0; i < 8; i++) {
      final byte = readByte();
      value |= (byte & 0x7f) << shift;
      if ((byte & 0x80) == 0) {
        if (value > _maxSafeInteger) {
          throw FormatException('$name exceeds the safe integer limit.');
        }
        return value;
      }
      shift += 7;
    }
    throw FormatException('Malformed $name varint.');
  }

  List<int> readBytes(int length) {
    if (length < 0 || length > remaining) {
      throw const FormatException('Compact frame is truncated.');
    }
    final result = _bytes.sublist(_offset, _offset + length);
    _offset += length;
    return result;
  }
}
