// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: device-attributes
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'html.dart';

abstract interface class NavigatorManagedData {
  Future<String> getAnnotatedAssetId();
  Future<String> getAnnotatedLocation();
  Future<String> getDirectoryId();
  Future<String> getHostname();
  Future<String> getSerialNumber();
  Future<Map<String, Object>> getManagedConfiguration(List<String> keys);
  EventHandler get onmanagedconfigurationchange;
   set onmanagedconfigurationchange(EventHandler value);
}

