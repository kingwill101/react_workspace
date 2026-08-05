// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: webrtc-ice
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'webrtc.dart';
import 'html.dart';
import 'package:react_web/src/web_runtime.dart';

abstract interface class RTCIceGatherOptions {
  RTCIceTransportPolicy get gatherPolicy;
  set gatherPolicy(RTCIceTransportPolicy value);
  List<RTCIceServer> get iceServers;
  set iceServers(List<RTCIceServer> value);
}

abstract interface class RTCIceParameters {
  bool get iceLite;
  set iceLite(bool value);
  String get usernameFragment;
  set usernameFragment(String value);
  String get password;
  set password(String value);
}

abstract interface class RTCIceTransport {
  factory RTCIceTransport() =>
      WebRuntime.current.createWebObject<RTCIceTransport>(
        'RTCIceTransport',
        [],
      );
  RTCIceRole get role;
  RTCIceTransportState get state;
  RTCIceGathererState get gatheringState;
  List<RTCIceCandidate> getLocalCandidates();
  List<RTCIceCandidate> getRemoteCandidates();
  Object getSelectedCandidatePair();
  RTCIceParameters? getLocalParameters();
  RTCIceParameters? getRemoteParameters();
  EventHandler get onstatechange;
   set onstatechange(EventHandler value);
  EventHandler get ongatheringstatechange;
   set ongatheringstatechange(EventHandler value);
  EventHandler get onselectedcandidatepairchange;
   set onselectedcandidatepairchange(EventHandler value);
}

