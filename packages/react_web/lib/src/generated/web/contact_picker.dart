// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: contact-picker
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'fileapi.dart';

abstract interface class ContactInfo {
  List<Object>? get address;
  set address(List<Object>? value);
  List<String>? get email;
  set email(List<String>? value);
  List<Blob>? get icon;
  set icon(List<Blob>? value);
  List<String>? get name;
  set name(List<String>? value);
  List<String>? get tel;
  set tel(List<String>? value);
}

final class ContactInfoValue implements ContactInfo {
  @override
  List<Object>? address;
  @override
  List<String>? email;
  @override
  List<Blob>? icon;
  @override
  List<String>? name;
  @override
  List<String>? tel;

  ContactInfoValue({
    this.address,
    this.email,
    this.icon,
    this.name,
    this.tel,
  });
}

typedef ContactProperty = String;

abstract interface class ContactsSelectOptions {
  bool? get multiple;
  set multiple(bool? value);
}

final class ContactsSelectOptionsValue implements ContactsSelectOptions {
  @override
  bool? multiple;

  ContactsSelectOptionsValue({
    this.multiple,
  });
}

