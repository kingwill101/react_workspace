// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: encrypted-media
// ignore_for_file: type=lint

import 'html.dart';
import 'webidl.dart';
import 'package:react_web/src/web_runtime.dart';

abstract interface class MediaEncryptedEvent {
  factory MediaEncryptedEvent(
    String type_, [
    MediaEncryptedEventInit? eventInitDict,
  ]) => WebRuntime.current.createWebObject<MediaEncryptedEvent>(
    'MediaEncryptedEvent',
    [type_, eventInitDict],
  );
  String get initDataType;
  Object get initData;
}

abstract interface class MediaEncryptedEventInit {
  String? get initDataType;
  set initDataType(String? value);
  Object? get initData;
  set initData(Object? value);
}

final class MediaEncryptedEventInitValue implements MediaEncryptedEventInit {
  @override
  String? initDataType;
  @override
  Object? initData;

  MediaEncryptedEventInitValue({this.initDataType, this.initData});
}

abstract interface class MediaKeyMessageEvent {
  factory MediaKeyMessageEvent(
    String type_,
    MediaKeyMessageEventInit eventInitDict,
  ) => WebRuntime.current.createWebObject<MediaKeyMessageEvent>(
    'MediaKeyMessageEvent',
    [type_, eventInitDict],
  );
  MediaKeyMessageType get messageType;
  Object get message;
}

abstract interface class MediaKeyMessageEventInit {
  MediaKeyMessageType get messageType;
  set messageType(MediaKeyMessageType value);
  Object get message;
  set message(Object value);
}

final class MediaKeyMessageEventInitValue implements MediaKeyMessageEventInit {
  @override
  MediaKeyMessageType messageType;
  @override
  Object message;

  MediaKeyMessageEventInitValue({
    required this.messageType,
    required this.message,
  });
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
  String? get label;
  set label(String? value);
  List<String>? get initDataTypes;
  set initDataTypes(List<String>? value);
  List<MediaKeySystemMediaCapability>? get audioCapabilities;
  set audioCapabilities(List<MediaKeySystemMediaCapability>? value);
  List<MediaKeySystemMediaCapability>? get videoCapabilities;
  set videoCapabilities(List<MediaKeySystemMediaCapability>? value);
  MediaKeysRequirement? get distinctiveIdentifier;
  set distinctiveIdentifier(MediaKeysRequirement? value);
  MediaKeysRequirement? get persistentState;
  set persistentState(MediaKeysRequirement? value);
  List<String>? get sessionTypes;
  set sessionTypes(List<String>? value);
}

final class MediaKeySystemConfigurationValue
    implements MediaKeySystemConfiguration {
  @override
  String? label;
  @override
  List<String>? initDataTypes;
  @override
  List<MediaKeySystemMediaCapability>? audioCapabilities;
  @override
  List<MediaKeySystemMediaCapability>? videoCapabilities;
  @override
  MediaKeysRequirement? distinctiveIdentifier;
  @override
  MediaKeysRequirement? persistentState;
  @override
  List<String>? sessionTypes;

  MediaKeySystemConfigurationValue({
    this.label,
    this.initDataTypes,
    this.audioCapabilities,
    this.videoCapabilities,
    this.distinctiveIdentifier,
    this.persistentState,
    this.sessionTypes,
  });
}

abstract interface class MediaKeySystemMediaCapability {
  String? get contentType;
  set contentType(String? value);
  String? get encryptionScheme;
  set encryptionScheme(String? value);
  String? get robustness;
  set robustness(String? value);
}

final class MediaKeySystemMediaCapabilityValue
    implements MediaKeySystemMediaCapability {
  @override
  String? contentType;
  @override
  String? encryptionScheme;
  @override
  String? robustness;

  MediaKeySystemMediaCapabilityValue({
    this.contentType,
    this.encryptionScheme,
    this.robustness,
  });
}

abstract interface class MediaKeys {
  MediaKeySession createSession([MediaKeySessionType? sessionType]);
  Future<MediaKeyStatus> getStatusForPolicy([MediaKeysPolicy? policy]);
  Future<bool> setServerCertificate(BufferSource serverCertificate);
}

abstract interface class MediaKeysPolicy {
  String? get minHdcpVersion;
  set minHdcpVersion(String? value);
}

final class MediaKeysPolicyValue implements MediaKeysPolicy {
  @override
  String? minHdcpVersion;

  MediaKeysPolicyValue({this.minHdcpVersion});
}

typedef MediaKeysRequirement = String;
