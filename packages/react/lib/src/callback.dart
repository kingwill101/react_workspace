/// Categories of values that can be passed through the React callback bridge.
enum ReactValueKind {
  /// No value.
  void_,

  /// Any JavaScript value.
  any,

  /// A JavaScript string.
  string,

  /// A JavaScript integer.
  integer,

  /// A JavaScript number.
  number,

  /// A JavaScript boolean.
  boolean,

  /// A rendered React node.
  reactNode,

  /// A synthetic browser event.
  syntheticEvent,

  /// A custom object handled by a registered [ReactCodecRegistry] codec.
  object,
}

/// Specification for a single callback argument or return value.
typedef ReactValueSpec = ({
  /// The kind of value expected or returned.
  ReactValueKind kind,

  /// Whether `null` or `undefined` is accepted.
  bool nullable,

  /// The codec ID for custom [ReactValueKind.object] values.
  String? codecId,
});

/// Complete callback signature metadata.
typedef ReactCallbackSignature = ({
  /// Ordered parameter specs.
  List<ReactValueSpec> positional,

  /// Expected return value spec.
  ReactValueSpec result,

  /// Whether the callback returns a Dart `Future`.
  bool asynchronous,
});

/// A callback that returns no value.
const reactVoid = (
  kind: ReactValueKind.void_,
  nullable: false,
  codecId: null,
);

/// Any value, including `null`.
const reactAny = (
  kind: ReactValueKind.any,
  nullable: true,
  codecId: null,
);

/// A non-null string.
const reactString = (
  kind: ReactValueKind.string,
  nullable: false,
  codecId: null,
);

/// A nullable string.
const reactNullableString = (
  kind: ReactValueKind.string,
  nullable: true,
  codecId: null,
);

/// A non-null integer.
const reactInt = (
  kind: ReactValueKind.integer,
  nullable: false,
  codecId: null,
);

/// A non-null boolean.
const reactBool = (
  kind: ReactValueKind.boolean,
  nullable: false,
  codecId: null,
);

/// A non-null synthetic event.
const reactSyntheticEvent = (
  kind: ReactValueKind.syntheticEvent,
  nullable: false,
  codecId: null,
);

/// Opaque callback descriptor that can be passed through the JS bridge.
///
/// Application code creates descriptors via generated component prop
/// adapters or typed intrinsic factories. The descriptor itself contains
/// no JS interop types; conversion to a JS function happens only in
/// `package:react_js`.
///
/// ```dart
/// final callback = ReactCallback(
///   debugName: 'button.onClick',
///   signature: const (
///     positional: [reactSyntheticEvent],
///     result: reactVoid,
///     asynchronous: false,
///   ),
///   invoke: (arguments) {
///     final event = arguments[0] as SyntheticEvent;
///     event.preventDefault();
///     return null;
///   },
/// );
/// ```
final class ReactCallback {
  /// Signature metadata for argument decoding and result encoding.
  final ReactCallbackSignature signature;

  /// Invocation adapter that receives decoded Dart arguments.
  final Object? Function(List<Object?>) invoke;

  /// Optional name used in argument-count error messages.
  final String? debugName;

  const ReactCallback({
    required this.signature,
    required this.invoke,
    this.debugName,
  });
}

/// Pure-Dart contract for a synthetic event handle.
abstract interface class SyntheticEventHandle {
  /// Prevents the browser's default action for this event.
  void preventDefault();

  /// Stops further propagation of this event.
  void stopPropagation();

  /// Whether [preventDefault] has been called.
  bool get defaultPrevented;
}

/// Pure-Dart wrapper around a synthetic event handle.
///
/// Use this type in callback signatures so application code does not
/// depend on JS interop types.
final class SyntheticEvent {
  final SyntheticEventHandle _handle;

  /// Creates a synthetic event wrapper around [_handle].
  const SyntheticEvent(this._handle);

  /// Prevents the browser's default action for this event.
  void preventDefault() => _handle.preventDefault();

  /// Stops further propagation of this event.
  void stopPropagation() => _handle.stopPropagation();

  /// Whether [preventDefault] has been called.
  bool get defaultPrevented => _handle.defaultPrevented;
}
