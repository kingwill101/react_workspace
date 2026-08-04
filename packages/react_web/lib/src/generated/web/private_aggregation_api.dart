// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: private-aggregation-api
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'turtledove.dart';

abstract interface class PADebugModeOptions {
  Object get debugKey;
  set debugKey(Object value);
}

abstract interface class PAHistogramContribution {
  Object get bucket;
  set bucket(Object value);
  int get value;
  set value(int value);
  Object get filteringId;
  set filteringId(Object value);
}

abstract interface class PrivateAggregation {
  void contributeToHistogram(PAHistogramContribution contribution);
  void enableDebugMode([PADebugModeOptions? options]);
  void contributeToHistogramOnEvent(String event, PAExtendedHistogramContribution contribution);
}

