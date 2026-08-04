// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: encrypted-media
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'dom.dart';
import 'html.dart';
import 'webidl.dart';

abstract interface class MediaEncryptedEvent {
  String get initDataType;
  Object get initData;
}

abstract interface class MediaEncryptedEventInit {
  String get initDataType;
  set initDataType(String value);
  Object get initData;
  set initData(Object value);
}

abstract interface class MediaKeyMessageEvent {
  MediaKeyMessageType get messageType;
  Object get message;
}

abstract interface class MediaKeyMessageEventInit {
  MediaKeyMessageType get messageType;
  set messageType(MediaKeyMessageType value);
  Object get message;
  set message(Object value);
}

typedef MediaKeyMessageType = String;

abstract interface class MediaKeySession {
  String get sessionId;
  double get expiration;
  Future<MediaKeySessionClosedReason> get closed;
  MediaKeyStatusMap get keyStatuses;
  EventHandler get onkeystatuseschange;
   set onkeystatuseschange(EventHandler value);
  EventHandler get onmessage;
   set onmessage(EventHandler value);
  Future<void> generateRequest(String initDataType, BufferSource initData);
  Future<bool> load(String sessionId);
  Future<void> update(BufferSource response);
  Future<void> close();
  Future<void> remove();
}

typedef MediaKeySessionClosedReason = String;

typedef MediaKeySessionType = String;

typedef MediaKeyStatus = String;

abstract interface class MediaKeyStatusMap {
   Iterable<(BufferSource, MediaKeyStatus)> get entries;
   Iterable<BufferSource> get keys;
   Iterable<MediaKeyStatus> get values;
  int get size;
  bool has(BufferSource keyId);
  MediaKeyStatus get_(BufferSource keyId);
}

abstract interface class MediaKeySystemAccess {
  String get keySystem;
  MediaKeySystemConfiguration getConfiguration();
  Future<MediaKeys> createMediaKeys();
}

abstract interface class MediaKeySystemConfiguration {
  String get label;
  set label(String value);
  List<String> get initDataTypes;
  set initDataTypes(List<String> value);
  List<MediaKeySystemMediaCapability> get audioCapabilities;
  set audioCapabilities(List<MediaKeySystemMediaCapability> value);
  List<MediaKeySystemMediaCapability> get videoCapabilities;
  set videoCapabilities(List<MediaKeySystemMediaCapability> value);
  MediaKeysRequirement get distinctiveIdentifier;
  set distinctiveIdentifier(MediaKeysRequirement value);
  MediaKeysRequirement get persistentState;
  set persistentState(MediaKeysRequirement value);
  List<String> get sessionTypes;
  set sessionTypes(List<String> value);
}

abstract interface class MediaKeySystemMediaCapability {
  String get contentType;
  set contentType(String value);
  String? get encryptionScheme;
  set encryptionScheme(String? value);
  String get robustness;
  set robustness(String value);
}

abstract interface class MediaKeys {
  MediaKeySession createSession([MediaKeySessionType? sessionType]);
  Future<MediaKeyStatus> getStatusForPolicy([MediaKeysPolicy? policy]);
  Future<bool> setServerCertificate(BufferSource serverCertificate);
}

abstract interface class MediaKeysPolicy {
  String get minHdcpVersion;
  set minHdcpVersion(String value);
}

typedef MediaKeysRequirement = String;

