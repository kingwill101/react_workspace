import 'dart:js_interop';

import 'package:react_core/react.dart';
import 'callback_codecs.dart';

@JS('__dartReactCallbacks.create')
external JSFunction _createCallback(
  ExternalDartReference<ReactCallback> reference,
  JSExportedDartFunction dispatcher,
);

@JS('__dartReactCallbacks.invoke')
external JSAny? _invokeCallback(JSFunction callback, JSArray<JSAny?> arguments);

/// Cache of JS callback wrappers for reusable [ReactCallback] descriptors.
final Expando<JSFunction> _callbackCache = Expando<JSFunction>(
  'ReactCallbackJSFunction',
);

/// Decodes JS arguments, invokes a Dart callback, and encodes the result.
JSAny? _dispatchReactCallback(
  ExternalDartReference<ReactCallback> reference,
  JSArray<JSAny?> rawArguments,
) {
  final callback = reference.toDartObject;
  final rawList = rawArguments.toDart;
  final signature = callback.signature;
  final expected = signature.positional.length;

  if (rawList.length < expected) {
    throw ArgumentError(
      '${callback.debugName ?? 'React callback'} '
      'expected $expected arguments but received '
      '${rawList.length}.',
    );
  }

  final decoded = <Object?>[];

  for (var index = 0; index < expected; index++) {
    final rawValue = index < rawList.length ? rawList[index] : null;

    decoded.add(
      decodeReactValue(
        signature.positional[index],
        rawValue,
        callback.debugName,
        index,
      ),
    );
  }

  final result = callback.invoke(decoded);

  return encodeReactValue(signature.result, result);
}

final JSExportedDartFunction _dispatchReactCallbackJS =
    _dispatchReactCallback.toJS;

/// Creates a JS function that invokes [callback] through the single
/// callback trampoline.
JSFunction callbackToJS(ReactCallback callback) {
  final cached = _callbackCache[callback];

  if (cached != null) {
    return cached;
  }

  final created = _createCallback(
    callback.toExternalReference,
    _dispatchReactCallbackJS,
  );

  _callbackCache[callback] = created;
  return created;
}

/// Invokes an existing JavaScript callback with any number of arguments.
JSAny? invokeJSCallback(JSFunction callback, List<JSAny?> arguments) {
  return _invokeCallback(callback, arguments.toJS);
}
