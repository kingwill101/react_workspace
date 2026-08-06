// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: url
// ignore_for_file: type=lint

import 'package:react_web/src/web_runtime.dart';

abstract interface class URLSearchParams {
  factory URLSearchParams([Object? init]) =>
      WebRuntime.current.createWebObject<URLSearchParams>(
        'URLSearchParams',
        [init],
      );
  int get size;
  void append(String name, String value);
  void delete(String name, [String? value]);
  String? get_(String name);
  List<String> getAll(String name);
  bool has(String name, [String? value]);
  void set_(String name, String value);
  void sort();
}

