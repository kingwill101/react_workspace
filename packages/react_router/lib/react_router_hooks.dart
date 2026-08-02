// Hooks for [react-router-dom](https://reactrouter.com) v6.
//
// These bindings call into the `react_router` shim and are only available in
// JavaScript targets (browser client and Node SSR worker), matching the core
// `react_js` hook binding. The portable node API lives in
// `react_router.dart`.
//
// Hook results are decoded in the shim (see `react_router_shim.mjs`):
// dart2js cannot cast a raw `callAsFunction` return value to `JSObject` or
// `JSArray`, so the shim returns primitives or arrays of primitives.
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'react_router.dart';

/// Returns a function that navigates to a path.
///
/// See https://reactrouter.com/hooks/use-navigate.
void Function(String to, {bool replace}) useNavigate() {
  return (to, {bool replace = false}) {
    _navigate(to.toJS, {'replace': replace}.jsify());
  };
}

/// Returns the current location.
///
/// See https://reactrouter.com/hooks/use-location.
ReactRouterLocation useLocation() {
  final parts = _locationParts();
  return ReactRouterLocation(
    pathname: (parts[0] as JSString).toDart,
    search: (parts[1] as JSString).toDart,
    hash: (parts[2] as JSString).toDart,
    key: (parts[3] as JSString).toDart,
  );
}

/// Returns the current route parameters as a map.
///
/// See https://reactrouter.com/hooks/use-params.
Map<String, String> useParams() => _decodePairs(_paramPairs());

/// Returns the query parameters and a setter.
///
/// See https://reactrouter.com/hooks/use-search-params.
(Map<String, String>, void Function(Map<String, String> next)) useSearchParams() {
  final pair = _searchParamPairs();
  final entries = pair[0] as JSArray;
  final setter = pair[1] as JSFunction;
  return (
    _decodePairs(entries),
    (next) {
      final object = JSObject();
      next.forEach((key, value) {
        object.setProperty(key.toJS, value.toJS);
      });
      setter.callAsFunction(null, object);
    },
  );
}

/// Decodes `[[key, value], ...]` pairs produced by the shim.
Map<String, String> _decodePairs(JSArray pairs) {
  final result = <String, String>{};
  for (var i = 0; i < pairs.length; i++) {
    final pair = pairs[i] as JSArray;
    result[(pair[0] as JSString).toDart] = (pair[1] as JSString).toDart;
  }
  return result;
}

@JS('globalThis.__reactDartRouter.navigate')
external JSAny? _navigate(JSAny? to, JSAny? options);

@JS('globalThis.__reactDartRouter.locationParts')
external JSArray _locationParts();

@JS('globalThis.__reactDartRouter.paramPairs')
external JSArray _paramPairs();

@JS('globalThis.__reactDartRouter.searchParamPairs')
external JSArray _searchParamPairs();
