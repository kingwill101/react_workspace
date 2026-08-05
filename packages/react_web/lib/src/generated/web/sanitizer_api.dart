// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: sanitizer-api
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'package:react_web/src/web_runtime.dart';

abstract interface class Sanitizer {
  factory Sanitizer([SanitizerConfig? config]) =>
      WebRuntime.current.createWebObject<Sanitizer>(
        'Sanitizer',
        [config],
      );
}

typedef SanitizerAttribute = Object;

abstract interface class SanitizerAttributeNamespace {
  String get name;
  set name(String value);
  String? get namespace;
  set namespace(String? value);
}

abstract interface class SanitizerConfig {
  List<SanitizerElementWithAttributes> get elements;
  set elements(List<SanitizerElementWithAttributes> value);
  List<SanitizerElement> get removeElements;
  set removeElements(List<SanitizerElement> value);
  List<SanitizerElement> get replaceWithChildrenElements;
  set replaceWithChildrenElements(List<SanitizerElement> value);
  List<SanitizerAttribute> get attributes;
  set attributes(List<SanitizerAttribute> value);
  List<SanitizerAttribute> get removeAttributes;
  set removeAttributes(List<SanitizerAttribute> value);
  bool get comments;
  set comments(bool value);
  bool get dataAttributes;
  set dataAttributes(bool value);
}

typedef SanitizerElement = Object;

abstract interface class SanitizerElementNamespace {
  String get name;
  set name(String value);
  String? get namespace;
  set namespace(String? value);
}

abstract interface class SanitizerElementNamespaceWithAttributes {
  List<SanitizerAttribute> get attributes;
  set attributes(List<SanitizerAttribute> value);
  List<SanitizerAttribute> get removeAttributes;
  set removeAttributes(List<SanitizerAttribute> value);
}

typedef SanitizerElementWithAttributes = Object;

abstract interface class SetHTMLOptions {
  Object get sanitizer;
  set sanitizer(Object value);
}

