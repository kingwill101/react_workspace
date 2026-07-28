import 'dart:async';
import 'dart:js_interop';

import 'package:react/react.dart';
import 'callback_codecs.dart';

/// JavaScript callback trampoline entry point.
///
/// The global `__dartReactCallbacks.create` function is a single variadic
/// JS wrapper that normalizes any callback invocation into:
///
/// ```javascript
/// dispatch(reference, argsArray)
/// ```
///
/// Dart therefore exports only one fixed function signature to JS, so
/// callback arity is no longer limited by static `.toJS` wrappers.
@JS('__dartReactCallbacks.create')
external JSFunction _createCallback(
  ExternalDartReference<ReactCallback> reference,
  JSExportedDartFunction dispatcher,
);

/// Creates a JavaScript [Promise] that resolves when [future] completes.
///
/// This bridges Dart [Future] completion back into JS promise resolution
/// so async callback results can be returned through the JS interop
/// boundary.
@JS('__dartReactCallbacks.createPromise')
external JSAny _createPromise(JSFunction executor);

/// Cache of JS callback wrappers for reusable [ReactCallback] descriptors.
///
/// Caching is most effective when the same descriptor instance is reused
/// across renders. Generated per-render descriptors will not benefit
/// until hook-backed memoization preserves callback identity.
final Expando<JSFunction> _callbackCache =
    Expando<JSFunction>('ReactCallbackJSFunction');

/// Decodes JS arguments, invokes a Dart callback, and encodes the result.
///
/// This is the single statically typed dispatcher passed to the JS
/// trampoline. It uses [ReactCallback.signature] to decode arguments,
/// calls [ReactCallback.invoke], and encodes the returned value.
///
/// Throws an [ArgumentError] if fewer arguments are supplied than the
/// callback expects. Extra JS arguments are ignored so zero-argument
/// Dart callbacks can be used with browser events that supply an event
/// object.
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

  if (signature.asynchronous) {
    final encoded = encodeReactValue(signature.result, result);

    return _createPromise((JSFunction resolve, JSFunction reject) {
      if (result is Future) {
        result.then((value) {
          resolve.callAsFunction(
            null,
            encodeReactValue(signature.result, value),
          );
        }).catchError((Object error, StackTrace stackTrace) {
          reject.callAsFunction(null, error as JSAny?);
        });
      } else {
        resolve.callAsFunction(null, encoded);
      }
    }.toJS);
  }

  return encodeReactValue(signature.result, result);
}

/// The exported JS-callable dispatcher.
///
/// Its static signature is always:
///
/// ```dart
/// JSAny? Function(
///   ExternalDartReference<ReactCallback>,
///   JSArray<JSAny?>,
/// )
/// ```
final JSExportedDartFunction _dispatchReactCallbackJS =
    _dispatchReactCallback.toJS;

/// Creates a JS function that invokes [callback] through the single
/// callback trampoline.
///
/// The returned function can be passed to React props. Each invocation
/// is decoded using [callback.signature] and forwarded to
/// [ReactCallback.invoke].
///
/// If the same [callback] descriptor is passed multiple times, the
/// cached JS wrapper is returned.
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
