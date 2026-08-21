// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: webmidi
// ignore_for_file: type=lint

import 'hr_time.dart';
import 'html.dart';
import 'package:react_web/src/web_runtime.dart';

abstract interface class MIDIAccess {
  MIDIInputMap get inputs;
  MIDIOutputMap get outputs;
  EventHandler get onstatechange;
  set onstatechange(EventHandler value);
  bool get sysexEnabled;
}

abstract interface class MIDIConnectionEvent {
  factory MIDIConnectionEvent(
    String type_, [
    MIDIConnectionEventInit? eventInitDict,
  ]) => WebRuntime.current.createWebObject<MIDIConnectionEvent>(
    'MIDIConnectionEvent',
    [type_, eventInitDict],
  );
  MIDIPort? get port;
}

abstract interface class MIDIConnectionEventInit {
  MIDIPort? get port;
  set port(MIDIPort? value);
}

final class MIDIConnectionEventInitValue implements MIDIConnectionEventInit {
  @override
  MIDIPort? port;

  MIDIConnectionEventInitValue({this.port});
}

abstract interface class MIDIInput {
  EventHandler get onmidimessage;
  set onmidimessage(EventHandler value);
}

abstract interface class MIDIInputMap {}

abstract interface class MIDIMessageEvent {
  factory MIDIMessageEvent(
    String type_, [
    MIDIMessageEventInit? eventInitDict,
  ]) => WebRuntime.current.createWebObject<MIDIMessageEvent>(
    'MIDIMessageEvent',
    [type_, eventInitDict],
  );
  Object get data;
}

abstract interface class MIDIMessageEventInit {
  Object? get data;
  set data(Object? value);
}

final class MIDIMessageEventInitValue implements MIDIMessageEventInit {
  @override
  Object? data;

  MIDIMessageEventInitValue({this.data});
}

abstract interface class MIDIOptions {
  bool? get sysex;
  set sysex(bool? value);
  bool? get software;
  set software(bool? value);
}

final class MIDIOptionsValue implements MIDIOptions {
  @override
  bool? sysex;
  @override
  bool? software;

  MIDIOptionsValue({this.sysex, this.software});
}

abstract interface class MIDIOutput {
  void send(List<Object> data, [DOMHighResTimeStamp? timestamp]);
  void clear();
}

abstract interface class MIDIOutputMap {}

abstract interface class MIDIPort {
  String get id;
  String? get manufacturer;
  String? get name;
  MIDIPortType get type_;
  String? get version;
  MIDIPortDeviceState get state;
  MIDIPortConnectionState get connection;
  EventHandler get onstatechange;
  set onstatechange(EventHandler value);
  Future<MIDIPort> open();
  Future<MIDIPort> close();
}

typedef MIDIPortConnectionState = String;

typedef MIDIPortDeviceState = String;

typedef MIDIPortType = String;

abstract interface class MidiPermissionDescriptor {
  bool? get sysex;
  set sysex(bool? value);
}

final class MidiPermissionDescriptorValue implements MidiPermissionDescriptor {
  @override
  bool? sysex;

  MidiPermissionDescriptorValue({this.sysex});
}
