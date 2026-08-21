// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: permissions-request
// ignore_for_file: type=lint

import 'permissions.dart';

abstract interface class Permissions {
  Future<PermissionStatus> revoke(Object permissionDesc);
  Future<PermissionStatus> query(Object permissionDesc);
}
