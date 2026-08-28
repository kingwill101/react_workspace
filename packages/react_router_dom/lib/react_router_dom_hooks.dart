/// Typed `use*` hooks for `react-router-dom` (navigate, location, params,
/// search params, matches, navigation, fetchers, ...).
///
/// These hooks import `dart:js_interop` and only run in JavaScript targets
/// (browser client and Node SSR worker), from inside a React render. Import
/// this library explicitly from JS-targeted Dart; do **not** import it from
/// pure Dart that must compile on the VM.
library;

export 'react_router_dom_hooks.g.dart';
