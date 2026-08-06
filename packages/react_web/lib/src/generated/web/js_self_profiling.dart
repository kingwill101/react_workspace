// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: js-self-profiling
// ignore_for_file: type=lint

import 'hr_time.dart';

abstract interface class ProfilerFrame {
  String get name;
  set name(String value);
  int? get resourceId;
  set resourceId(int? value);
  int? get line;
  set line(int? value);
  int? get column;
  set column(int? value);
}

final class ProfilerFrameValue implements ProfilerFrame {
  @override
  String name;
  @override
  int? resourceId;
  @override
  int? line;
  @override
  int? column;

  ProfilerFrameValue({
    required this.name,
    this.resourceId,
    this.line,
    this.column,
  });
}

abstract interface class ProfilerInitOptions {
  DOMHighResTimeStamp get sampleInterval;
  set sampleInterval(DOMHighResTimeStamp value);
  int get maxBufferSize;
  set maxBufferSize(int value);
}

final class ProfilerInitOptionsValue implements ProfilerInitOptions {
  @override
  DOMHighResTimeStamp sampleInterval;
  @override
  int maxBufferSize;

  ProfilerInitOptionsValue({
    required this.sampleInterval,
    required this.maxBufferSize,
  });
}

typedef ProfilerResource = String;

abstract interface class ProfilerSample {
  DOMHighResTimeStamp get timestamp;
  set timestamp(DOMHighResTimeStamp value);
  int? get stackId;
  set stackId(int? value);
}

final class ProfilerSampleValue implements ProfilerSample {
  @override
  DOMHighResTimeStamp timestamp;
  @override
  int? stackId;

  ProfilerSampleValue({
    required this.timestamp,
    this.stackId,
  });
}

abstract interface class ProfilerStack {
  int? get parentId;
  set parentId(int? value);
  int get frameId;
  set frameId(int value);
}

final class ProfilerStackValue implements ProfilerStack {
  @override
  int? parentId;
  @override
  int frameId;

  ProfilerStackValue({
    this.parentId,
    required this.frameId,
  });
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

final class ProfilerTraceValue implements ProfilerTrace {
  @override
  List<ProfilerResource> resources;
  @override
  List<ProfilerFrame> frames;
  @override
  List<ProfilerStack> stacks;
  @override
  List<ProfilerSample> samples;

  ProfilerTraceValue({
    required this.resources,
    required this.frames,
    required this.stacks,
    required this.samples,
  });
}

