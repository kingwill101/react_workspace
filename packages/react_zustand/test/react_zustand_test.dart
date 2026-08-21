import 'dart:io';

import 'package:test/test.dart';

/// The shim is the contract between Dart and the npm package: it must register
/// itself and expose exactly the hooks the externals in react_zustand.dart
/// reference. This test pins that contract on the native VM (no JS interop).
void main() {
  final shim = File('lib/react_zustand_shim.mjs').readAsStringSync();

  test('shim imports zustand and registers the hook bridge', () {
    expect(shim, contains("from 'zustand'"));
    expect(shim, contains('__reactDartZustand'));
    expect(shim, contains('useCount'));
    expect(shim, contains('useDoubled'));
    expect(shim, contains('inc'));
  });

  test('shim creates a store with the documented initial state', () {
    expect(shim, contains('count: 0'));
    expect(shim, contains('state.count + 1'));
  });
}
