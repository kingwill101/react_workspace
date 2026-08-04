// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: mediaqueries-5
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'html.dart';

abstract interface class PreferenceManager {
  PreferenceObject get colorScheme;
  PreferenceObject get contrast;
  PreferenceObject get reducedMotion;
  PreferenceObject get reducedTransparency;
  PreferenceObject get reducedData;
}

abstract interface class PreferenceObject {
  String? get override_;
  String get value;
  List<String> get validValues;
  void clearOverride();
  Future<void> requestOverride(String? value);
  EventHandler get onchange;
   set onchange(EventHandler value);
}

