// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: sanitizer-api
// ignore_for_file: type=lint

import 'package:react_web/src/web_runtime.dart';

abstract interface class Sanitizer {
  factory Sanitizer([SanitizerConfig? config]) =>
      WebRuntime.current.createWebObject<Sanitizer>('Sanitizer', [config]);
}

typedef SanitizerAttribute = Object;

abstract interface class SanitizerAttributeNamespace {
  String get name;
  set name(String value);
  String? get namespace;
  set namespace(String? value);
}

final class SanitizerAttributeNamespaceValue
    implements SanitizerAttributeNamespace {
  @override
  String name;
  @override
  String? namespace;

  SanitizerAttributeNamespaceValue({required this.name, this.namespace});
}

abstract interface class SanitizerConfig {
  List<SanitizerElementWithAttributes>? get elements;
  set elements(List<SanitizerElementWithAttributes>? value);
  List<SanitizerElement>? get removeElements;
  set removeElements(List<SanitizerElement>? value);
  List<SanitizerElement>? get replaceWithChildrenElements;
  set replaceWithChildrenElements(List<SanitizerElement>? value);
  List<SanitizerAttribute>? get attributes;
  set attributes(List<SanitizerAttribute>? value);
  List<SanitizerAttribute>? get removeAttributes;
  set removeAttributes(List<SanitizerAttribute>? value);
  bool? get comments;
  set comments(bool? value);
  bool? get dataAttributes;
  set dataAttributes(bool? value);
}

final class SanitizerConfigValue implements SanitizerConfig {
  @override
  List<SanitizerElementWithAttributes>? elements;
  @override
  List<SanitizerElement>? removeElements;
  @override
  List<SanitizerElement>? replaceWithChildrenElements;
  @override
  List<SanitizerAttribute>? attributes;
  @override
  List<SanitizerAttribute>? removeAttributes;
  @override
  bool? comments;
  @override
  bool? dataAttributes;

  SanitizerConfigValue({
    this.elements,
    this.removeElements,
    this.replaceWithChildrenElements,
    this.attributes,
    this.removeAttributes,
    this.comments,
    this.dataAttributes,
  });
}

typedef SanitizerElement = Object;

abstract interface class SanitizerElementNamespace {
  String get name;
  set name(String value);
  String? get namespace;
  set namespace(String? value);
}

final class SanitizerElementNamespaceValue
    implements SanitizerElementNamespace {
  @override
  String name;
  @override
  String? namespace;

  SanitizerElementNamespaceValue({required this.name, this.namespace});
}

abstract interface class SanitizerElementNamespaceWithAttributes {
  List<SanitizerAttribute>? get attributes;
  set attributes(List<SanitizerAttribute>? value);
  List<SanitizerAttribute>? get removeAttributes;
  set removeAttributes(List<SanitizerAttribute>? value);
}

final class SanitizerElementNamespaceWithAttributesValue
    implements SanitizerElementNamespaceWithAttributes {
  @override
  List<SanitizerAttribute>? attributes;
  @override
  List<SanitizerAttribute>? removeAttributes;

  SanitizerElementNamespaceWithAttributesValue({
    this.attributes,
    this.removeAttributes,
  });
}

typedef SanitizerElementWithAttributes = Object;

abstract interface class SetHTMLOptions {
  Object? get sanitizer;
  set sanitizer(Object? value);
}

final class SetHTMLOptionsValue implements SetHTMLOptions {
  @override
  Object? sanitizer;

  SetHTMLOptionsValue({this.sanitizer});
}
