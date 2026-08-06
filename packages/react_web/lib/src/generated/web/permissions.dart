// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: permissions
// ignore_for_file: type=lint

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

