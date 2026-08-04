// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: storage
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'fs.dart';

abstract interface class NavigatorStorage {
  StorageManager get storage;
}

abstract interface class StorageEstimate {
  int get usage;
  set usage(int value);
  int get quota;
  set quota(int value);
}

