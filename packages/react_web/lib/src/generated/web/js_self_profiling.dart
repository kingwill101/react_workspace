// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: js-self-profiling
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'hr_time.dart';

abstract interface class ProfilerFrame {
  String get name;
  set name(String value);
  int get resourceId;
  set resourceId(int value);
  int get line;
  set line(int value);
  int get column;
  set column(int value);
}

abstract interface class ProfilerInitOptions {
  DOMHighResTimeStamp get sampleInterval;
  set sampleInterval(DOMHighResTimeStamp value);
  int get maxBufferSize;
  set maxBufferSize(int value);
}

typedef ProfilerResource = String;

abstract interface class ProfilerSample {
  DOMHighResTimeStamp get timestamp;
  set timestamp(DOMHighResTimeStamp value);
  int get stackId;
  set stackId(int value);
}

abstract interface class ProfilerStack {
  int get parentId;
  set parentId(int value);
  int get frameId;
  set frameId(int value);
}

abstract interface class ProfilerTrace {
  List<ProfilerResource> get resources;
  set resources(List<ProfilerResource> value);
  List<ProfilerFrame> get frames;
  set frames(List<ProfilerFrame> value);
  List<ProfilerStack> get stacks;
  set stacks(List<ProfilerStack> value);
  List<ProfilerSample> get samples;
  set samples(List<ProfilerSample> value);
}

