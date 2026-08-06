// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: FedCM
// ignore_for_file: type=lint

import 'credential_management.dart';
import 'dom.dart';
import 'digital_identities.dart';
import 'web_otp.dart';
import 'webauthn.dart';
import 'html.dart';
import 'netinfo.dart';
import 'fs.dart';
import 'web_locks.dart';
import 'battery_status.dart';
import 'fetch.dart';
import 'clipboard_apis.dart';
import 'encrypted_media.dart';
import 'gamepad_extensions.dart';
import 'geolocation.dart';
import 'media_capabilities.dart';
import 'audio_output.dart';
import 'mediasession.dart';
import 'permissions_request.dart';
import 'screen_wake_lock.dart';
import 'service_workers.dart';
import 'vibration.dart';
import 'web_share.dart';
import 'webmidi.dart';

abstract interface class CredentialRequestOptions {
  IdentityCredentialRequestOptions? get identity;
  set identity(IdentityCredentialRequestOptions? value);
  CredentialMediationRequirement? get mediation;
  set mediation(CredentialMediationRequirement? value);
  AbortSignal? get signal;
  set signal(AbortSignal? value);
  bool? get password;
  set password(bool? value);
  FederatedCredentialRequestOptions? get federated;
  set federated(FederatedCredentialRequestOptions? value);
  DigitalCredentialRequestOptions? get digital;
  set digital(DigitalCredentialRequestOptions? value);
  OTPCredentialRequestOptions? get otp;
  set otp(OTPCredentialRequestOptions? value);
  PublicKeyCredentialRequestOptions? get publicKey;
  set publicKey(PublicKeyCredentialRequestOptions? value);
}

final class CredentialRequestOptionsValue implements CredentialRequestOptions {
  @override
  IdentityCredentialRequestOptions? identity;
  @override
  CredentialMediationRequirement? mediation;
  @override
  AbortSignal? signal;
  @override
  bool? password;
  @override
  FederatedCredentialRequestOptions? federated;
  @override
  DigitalCredentialRequestOptions? digital;
  @override
  OTPCredentialRequestOptions? otp;
  @override
  PublicKeyCredentialRequestOptions? publicKey;

  CredentialRequestOptionsValue({
    this.identity,
    this.mediation,
    this.signal,
    this.password,
    this.federated,
    this.digital,
    this.otp,
    this.publicKey,
  });
}

abstract interface class DisconnectedAccount {
  String get accountId;
  set accountId(String value);
}

final class DisconnectedAccountValue implements DisconnectedAccount {
  @override
  String accountId;

  DisconnectedAccountValue({
    required this.accountId,
  });
}

abstract interface class IdentityCredentialDisconnectOptions {
  String get accountHint;
  set accountHint(String value);
}

final class IdentityCredentialDisconnectOptionsValue implements IdentityCredentialDisconnectOptions {
  @override
  String accountHint;

  IdentityCredentialDisconnectOptionsValue({
    required this.accountHint,
  });
}

abstract interface class IdentityCredentialRequestOptions {
  List<IdentityProviderRequestOptions> get providers;
  set providers(List<IdentityProviderRequestOptions> value);
  IdentityCredentialRequestOptionsContext? get context;
  set context(IdentityCredentialRequestOptionsContext? value);
}

final class IdentityCredentialRequestOptionsValue implements IdentityCredentialRequestOptions {
  @override
  List<IdentityProviderRequestOptions> providers;
  @override
  IdentityCredentialRequestOptionsContext? context;

  IdentityCredentialRequestOptionsValue({
    required this.providers,
    this.context,
  });
}

typedef IdentityCredentialRequestOptionsContext = String;

abstract interface class IdentityProviderAPIConfig {
  String get accountsEndpoint;
  set accountsEndpoint(String value);
  String get clientMetadataEndpoint;
  set clientMetadataEndpoint(String value);
  String get idAssertionEndpoint;
  set idAssertionEndpoint(String value);
  String get loginUrl;
  set loginUrl(String value);
  String? get disconnectEndpoint;
  set disconnectEndpoint(String? value);
  IdentityProviderBranding? get branding;
  set branding(IdentityProviderBranding? value);
}

final class IdentityProviderAPIConfigValue implements IdentityProviderAPIConfig {
  @override
  String accountsEndpoint;
  @override
  String clientMetadataEndpoint;
  @override
  String idAssertionEndpoint;
  @override
  String loginUrl;
  @override
  String? disconnectEndpoint;
  @override
  IdentityProviderBranding? branding;

  IdentityProviderAPIConfigValue({
    required this.accountsEndpoint,
    required this.clientMetadataEndpoint,
    required this.idAssertionEndpoint,
    required this.loginUrl,
    this.disconnectEndpoint,
    this.branding,
  });
}

abstract interface class IdentityProviderAccount {
  String get id;
  set id(String value);
  String get name;
  set name(String value);
  String get email;
  set email(String value);
  String? get givenName;
  set givenName(String? value);
  String? get picture;
  set picture(String? value);
  List<String>? get approvedClients;
  set approvedClients(List<String>? value);
  List<String>? get loginHints;
  set loginHints(List<String>? value);
  List<String>? get domainHints;
  set domainHints(List<String>? value);
}

final class IdentityProviderAccountValue implements IdentityProviderAccount {
  @override
  String id;
  @override
  String name;
  @override
  String email;
  @override
  String? givenName;
  @override
  String? picture;
  @override
  List<String>? approvedClients;
  @override
  List<String>? loginHints;
  @override
  List<String>? domainHints;

  IdentityProviderAccountValue({
    required this.id,
    required this.name,
    required this.email,
    this.givenName,
    this.picture,
    this.approvedClients,
    this.loginHints,
    this.domainHints,
  });
}

abstract interface class IdentityProviderAccountList {
  List<IdentityProviderAccount>? get accounts;
  set accounts(List<IdentityProviderAccount>? value);
}

final class IdentityProviderAccountListValue implements IdentityProviderAccountList {
  @override
  List<IdentityProviderAccount>? accounts;

  IdentityProviderAccountListValue({
    this.accounts,
  });
}

abstract interface class IdentityProviderBranding {
  String? get backgroundColor;
  set backgroundColor(String? value);
  String? get color;
  set color(String? value);
  List<IdentityProviderIcon>? get icons;
  set icons(List<IdentityProviderIcon>? value);
  String? get name;
  set name(String? value);
}

final class IdentityProviderBrandingValue implements IdentityProviderBranding {
  @override
  String? backgroundColor;
  @override
  String? color;
  @override
  List<IdentityProviderIcon>? icons;
  @override
  String? name;

  IdentityProviderBrandingValue({
    this.backgroundColor,
    this.color,
    this.icons,
    this.name,
  });
}

abstract interface class IdentityProviderClientMetadata {
  String? get privacyPolicyUrl;
  set privacyPolicyUrl(String? value);
  String? get termsOfServiceUrl;
  set termsOfServiceUrl(String? value);
}

final class IdentityProviderClientMetadataValue implements IdentityProviderClientMetadata {
  @override
  String? privacyPolicyUrl;
  @override
  String? termsOfServiceUrl;

  IdentityProviderClientMetadataValue({
    this.privacyPolicyUrl,
    this.termsOfServiceUrl,
  });
}

abstract interface class IdentityProviderConfig {
  String get configURL;
  set configURL(String value);
  String get clientId;
  set clientId(String value);
}

final class IdentityProviderConfigValue implements IdentityProviderConfig {
  @override
  String configURL;
  @override
  String clientId;

  IdentityProviderConfigValue({
    required this.configURL,
    required this.clientId,
  });
}

abstract interface class IdentityProviderIcon {
  String get url;
  set url(String value);
  int? get size;
  set size(int? value);
}

final class IdentityProviderIconValue implements IdentityProviderIcon {
  @override
  String url;
  @override
  int? size;

  IdentityProviderIconValue({
    required this.url,
    this.size,
  });
}

abstract interface class IdentityProviderRequestOptions {
  String? get nonce;
  set nonce(String? value);
  String? get loginHint;
  set loginHint(String? value);
  String? get domainHint;
  set domainHint(String? value);
}

final class IdentityProviderRequestOptionsValue implements IdentityProviderRequestOptions {
  @override
  String? nonce;
  @override
  String? loginHint;
  @override
  String? domainHint;

  IdentityProviderRequestOptionsValue({
    this.nonce,
    this.loginHint,
    this.domainHint,
  });
}

abstract interface class IdentityProviderToken {
  String get token;
  set token(String value);
}

final class IdentityProviderTokenValue implements IdentityProviderToken {
  @override
  String token;

  IdentityProviderTokenValue({
    required this.token,
  });
}

abstract interface class IdentityProviderWellKnown {
  List<String> get providerUrls;
  set providerUrls(List<String> value);
}

final class IdentityProviderWellKnownValue implements IdentityProviderWellKnown {
  @override
  List<String> providerUrls;

  IdentityProviderWellKnownValue({
    required this.providerUrls,
  });
}

abstract interface class IdentityUserInfo {
  String? get email;
  set email(String? value);
  String? get name;
  set name(String? value);
  String? get givenName;
  set givenName(String? value);
  String? get picture;
  set picture(String? value);
}

final class IdentityUserInfoValue implements IdentityUserInfo {
  @override
  String? email;
  @override
  String? name;
  @override
  String? givenName;
  @override
  String? picture;

  IdentityUserInfoValue({
    this.email,
    this.name,
    this.givenName,
    this.picture,
  });
}

typedef LoginStatus = String;

abstract interface class Navigator {
  Future<void> setAppBadge([int? contents]);
  Future<void> clearAppBadge();
  double get deviceMemory;
  String get appCodeName;
  String get appName;
  String get appVersion;
  String get platform;
  String get product;
  String get productSub;
  String get userAgent;
  String get vendor;
  String get vendorSub;
  bool taintEnabled();
  String get oscpu;
  String get language;
  List<String> get languages;
  bool get onLine;
  void registerProtocolHandler(String scheme, String url);
  void unregisterProtocolHandler(String scheme, String url);
  bool get cookieEnabled;
  PluginArray get plugins;
  MimeTypeArray get mimeTypes;
  bool javaEnabled();
  bool get pdfViewerEnabled;
  int get hardwareConcurrency;
  NetworkInformation get connection;
  Object get storageBuckets;
  StorageManager get storage;
  Object get userAgentData;
  LockManager get locks;
  bool get webdriver;
  Object get gpu;
  Object get ml;
  Future<BatteryManager> getBattery();
  bool sendBeacon(String url, [BodyInit? data]);
  Clipboard get clipboard;
  CredentialsContainer get credentials;
  Future<MediaKeySystemAccess> requestMediaKeySystemAccess(String keySystem, List<MediaKeySystemConfiguration> supportedConfigurations);
  List<Gamepad?> getGamepads();
  Geolocation get geolocation;
  UserActivation get userActivation;
  MediaCapabilities get mediaCapabilities;
  MediaDevices get mediaDevices;
  MediaSession get mediaSession;
  Permissions get permissions;
  int get maxTouchPoints;
  Object get presentation;
  WakeLock get wakeLock;
  ServiceWorkerContainer get serviceWorker;
  bool vibrate(VibratePattern pattern);
  Future<void> share([ShareData? data]);
  bool canShare([ShareData? data]);
  Future<MIDIAccess> requestMIDIAccess([MIDIOptions? options]);
  Object get usb;
  Object get windowControlsOverlay;
}

