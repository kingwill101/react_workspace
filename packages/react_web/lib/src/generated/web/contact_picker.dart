// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: contact-picker
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'fileapi.dart';

abstract interface class ContactAddress {
  Object toJSON();
  String get city;
  String get country;
  String get dependentLocality;
  String get organization;
  String get phone;
  String get postalCode;
  String get recipient;
  String get region;
  String get sortingCode;
  List<String> get addressLine;
}

abstract interface class ContactInfo {
  List<ContactAddress> get address;
  set address(List<ContactAddress> value);
  List<String> get email;
  set email(List<String> value);
  List<Blob> get icon;
  set icon(List<Blob> value);
  List<String> get name;
  set name(List<String> value);
  List<String> get tel;
  set tel(List<String> value);
}

typedef ContactProperty = String;

abstract interface class ContactsManager {
  Future<List<ContactProperty>> getProperties();
  Future<List<ContactInfo>> select(List<ContactProperty> properties, [ContactsSelectOptions? options]);
}

abstract interface class ContactsSelectOptions {
  bool get multiple;
  set multiple(bool value);
}

