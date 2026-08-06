// GENERATED CODE — DO NOT EDIT
// ignore_for_file: type=lint
// Neutral Web surface for spec: permissions
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'html.dart';

abstract interface class PermissionDescriptor {
  String get name;
  set name(String value);
}

final class PermissionDescriptorValue implements PermissionDescriptor {
  @override
  String name;

  PermissionDescriptorValue({
    required this.name,
  });
}

abstract interface class PermissionSetParameters {
  Object get descriptor;
  set descriptor(Object value);
  PermissionState get state;
  set state(PermissionState value);
}

final class PermissionSetParametersValue implements PermissionSetParameters {
  @override
  Object descriptor;
  @override
  PermissionState state;

  PermissionSetParametersValue({
    required this.descriptor,
    required this.state,
  });
}

typedef PermissionState = String;

abstract interface class PermissionStatus {
  PermissionState get state;
  String get name;
  EventHandler get onchange;
   set onchange(EventHandler value);
}

