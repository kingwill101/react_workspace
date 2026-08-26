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

  /// A value owned by a renderer.
  ///
  /// Examples:
  /// - a browser Event or Element
  /// - a React synthetic event object
  /// - a future native-renderer handle
  hostValue,

  /// Structured application data converted through a registered codec.
  encodedObject,
}

/// Specification for a single callback argument or return value.
typedef ReactValueSpec = ({
  /// The kind of value expected or returned.
  ReactValueKind kind,

  /// Whether `null` or `undefined` is accepted.
  bool nullable,

  /// Renderer that owns this value.
  ///
  /// Examples: "web", "test".
  String? hostNamespace,

  /// Stable type identifier used for diagnostics and generated adapters.
  ///
  /// Example:
  /// package:react_web/events.dart#ReactMouseEvent
  String? typeId,

  /// The codec ID for custom [ReactValueKind.encodedObject] values.
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
  hostNamespace: null,
  typeId: null,
  codecId: null,
);

/// Any value, including `null`.
const reactAny = (
  kind: ReactValueKind.any,
  nullable: true,
  hostNamespace: null,
  typeId: null,
  codecId: null,
);

/// A non-null string.
const reactString = (
  kind: ReactValueKind.string,
  nullable: false,
  hostNamespace: null,
  typeId: null,
  codecId: null,
);

/// A nullable string.
const reactNullableString = (
  kind: ReactValueKind.string,
  nullable: true,
  hostNamespace: null,
  typeId: null,
  codecId: null,
);

/// A non-null integer.
const reactInt = (
  kind: ReactValueKind.integer,
  nullable: false,
  hostNamespace: null,
  typeId: null,
  codecId: null,
);

/// A non-null boolean.
const reactBool = (
  kind: ReactValueKind.boolean,
  nullable: false,
  hostNamespace: null,
  typeId: null,
  codecId: null,
);

/// A non-null host value owned by a renderer.
const reactHostValue = (
  kind: ReactValueKind.hostValue,
  nullable: false,
  hostNamespace: null,
  typeId: null,
  codecId: null,
);

/// A generic ref callback.
typedef ReactRefCallback<T> = void Function(T? value);

/// Wrapper indicating a host prop is an event callback.
///
/// Renderers use this wrapper to distinguish event callbacks from ordinary
/// values during prop encoding.  Client encoders unwrap and convert the
/// inner [ReactCallback]; server encoders omit event props entirely.
final class ReactEventProp {
  final ReactCallback callback;
  const ReactEventProp(this.callback);
}

/// Wrapper indicating a host prop is a ref callback.
///
/// Renderers use this wrapper to distinguish ref callbacks from ordinary
/// values during prop encoding.  Client encoders unwrap and convert the
/// inner [ReactCallback]; server encoders omit ref props entirely.
final class ReactRefProp {
  final ReactCallback callback;
  const ReactRefProp(this.callback);
}

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
///     positional: [reactHostValue],
///     result: reactVoid,
///     asynchronous: false,
///   ),
///   invoke: (arguments) {
///     final rawEvent = arguments[0];
///     // cast and handle in renderer-specific code
///     return null;
///   },
/// );
/// ```
final class ReactCallback {
  /// Wraps a no-argument callback that returns no value.
  static ReactCallback zero(void Function() callback, {String? debugName}) =>
      ReactCallback(
        debugName: debugName,
        signature: const (
          positional: [],
          result: reactVoid,
          asynchronous: false,
        ),
        invoke: (_) {
          callback();
          return null;
        },
      );

  /// Wraps a one-argument callback that returns no value.
  ///
  /// [argument] tells the renderer how to decode the incoming JavaScript
  /// value before it is cast to [T]. It defaults to a nullable arbitrary
  /// value, which is suitable for exploratory foreign-component APIs.
  static ReactCallback one<T>(
    void Function(T value) callback, {
    ReactValueSpec argument = reactAny,
    String? debugName,
  }) => ReactCallback(
    debugName: debugName,
    signature: (positional: [argument], result: reactVoid, asynchronous: false),
    invoke: (arguments) {
      callback(arguments[0] as T);
      return null;
    },
  );

  /// Wraps a two-argument callback that returns no value.
  static ReactCallback two<A, B>(
    void Function(A first, B second) callback, {
    ReactValueSpec first = reactAny,
    ReactValueSpec second = reactAny,
    String? debugName,
  }) => ReactCallback(
    debugName: debugName,
    signature: (
      positional: [first, second],
      result: reactVoid,
      asynchronous: false,
    ),
    invoke: (arguments) {
      callback(arguments[0] as A, arguments[1] as B);
      return null;
    },
  );

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
