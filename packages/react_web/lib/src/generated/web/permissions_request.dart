// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: permissions-request
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'permissions.dart';

abstract interface class Permissions {
  Future<PermissionStatus> revoke(Object permissionDesc);
  Future<PermissionStatus> query(Object permissionDesc);
}

