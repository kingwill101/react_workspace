// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: webmidi
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'html.dart';
import 'dom.dart';
import 'hr_time.dart';
import 'permissions.dart';

abstract interface class MIDIAccess {
  MIDIInputMap get inputs;
  MIDIOutputMap get outputs;
  EventHandler get onstatechange;
   set onstatechange(EventHandler value);
  bool get sysexEnabled;
}

abstract interface class MIDIConnectionEvent {
  MIDIPort? get port;
}

abstract interface class MIDIConnectionEventInit {
  MIDIPort get port;
  set port(MIDIPort value);
}

abstract interface class MIDIInput {
  EventHandler get onmidimessage;
   set onmidimessage(EventHandler value);
}

abstract interface class MIDIInputMap {
   Iterable<String> get keys;
   Iterable<MIDIInput> get values;
   Iterable<MapEntry<String, MIDIInput>> get entries;
   MIDIInput? operator [](Object key);
   bool has(Object key);
}

abstract interface class MIDIMessageEvent {
  Object get data;
}

abstract interface class MIDIMessageEventInit {
  Object get data;
  set data(Object value);
}

abstract interface class MIDIOptions {
  bool get sysex;
  set sysex(bool value);
  bool get software;
  set software(bool value);
}

abstract interface class MIDIOutput {
  void send(List<Object> data, [DOMHighResTimeStamp? timestamp]);
  void clear();
}

abstract interface class MIDIOutputMap {
   Iterable<String> get keys;
   Iterable<MIDIOutput> get values;
   Iterable<MapEntry<String, MIDIOutput>> get entries;
   MIDIOutput? operator [](Object key);
   bool has(Object key);
}

abstract interface class MIDIPort {
  String get id;
  String? get manufacturer;
  String? get name;
  MIDIPortType get type;
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
  bool get sysex;
  set sysex(bool value);
}

