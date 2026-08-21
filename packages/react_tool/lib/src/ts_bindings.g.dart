// AUTO GENERATED FILE, DO NOT EDIT.
//
// Externals for the `react-ts-bindings` native library (oxc-based TypeScript
// extraction), built via native assets (`hook/build.dart`).
//
// ignore_for_file: type=lint, unused_import
import 'dart:ffi' as ffi;

@ffi.Native<
  ffi.Pointer<ffi.Char> Function(ffi.Pointer<ffi.Char>, ffi.Pointer<ffi.Char>)
>()
external ffi.Pointer<ffi.Char> tsb_extract(
  ffi.Pointer<ffi.Char> requestJson,
  ffi.Pointer<ffi.Char> npmRoot,
);

@ffi.Native<ffi.Void Function(ffi.Pointer<ffi.Char>)>()
external void tsb_free_string(ffi.Pointer<ffi.Char> ptr);
