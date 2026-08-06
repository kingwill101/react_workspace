// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: FedCM
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

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
  String get account_id;
  set account_id(String value);
}

final class DisconnectedAccountValue implements DisconnectedAccount {
  @override
  String account_id;

  DisconnectedAccountValue({
    required this.account_id,
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
  String get accounts_endpoint;
  set accounts_endpoint(String value);
  String get client_metadata_endpoint;
  set client_metadata_endpoint(String value);
  String get id_assertion_endpoint;
  set id_assertion_endpoint(String value);
  String get login_url;
  set login_url(String value);
  String? get disconnect_endpoint;
  set disconnect_endpoint(String? value);
  IdentityProviderBranding? get branding;
  set branding(IdentityProviderBranding? value);
}

final class IdentityProviderAPIConfigValue implements IdentityProviderAPIConfig {
  @override
  String accounts_endpoint;
  @override
  String client_metadata_endpoint;
  @override
  String id_assertion_endpoint;
  @override
  String login_url;
  @override
  String? disconnect_endpoint;
  @override
  IdentityProviderBranding? branding;

  IdentityProviderAPIConfigValue({
    required this.accounts_endpoint,
    required this.client_metadata_endpoint,
    required this.id_assertion_endpoint,
    required this.login_url,
    this.disconnect_endpoint,
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
  String? get given_name;
  set given_name(String? value);
  String? get picture;
  set picture(String? value);
  List<String>? get approved_clients;
  set approved_clients(List<String>? value);
  List<String>? get login_hints;
  set login_hints(List<String>? value);
  List<String>? get domain_hints;
  set domain_hints(List<String>? value);
}

final class IdentityProviderAccountValue implements IdentityProviderAccount {
  @override
  String id;
  @override
  String name;
  @override
  String email;
  @override
  String? given_name;
  @override
  String? picture;
  @override
  List<String>? approved_clients;
  @override
  List<String>? login_hints;
  @override
  List<String>? domain_hints;

  IdentityProviderAccountValue({
    required this.id,
    required this.name,
    required this.email,
    this.given_name,
    this.picture,
    this.approved_clients,
    this.login_hints,
    this.domain_hints,
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
  String? get background_color;
  set background_color(String? value);
  String? get color;
  set color(String? value);
  List<IdentityProviderIcon>? get icons;
  set icons(List<IdentityProviderIcon>? value);
  String? get name;
  set name(String? value);
}

final class IdentityProviderBrandingValue implements IdentityProviderBranding {
  @override
  String? background_color;
  @override
  String? color;
  @override
  List<IdentityProviderIcon>? icons;
  @override
  String? name;

  IdentityProviderBrandingValue({
    this.background_color,
    this.color,
    this.icons,
    this.name,
  });
}

abstract interface class IdentityProviderClientMetadata {
  String? get privacy_policy_url;
  set privacy_policy_url(String? value);
  String? get terms_of_service_url;
  set terms_of_service_url(String? value);
}

final class IdentityProviderClientMetadataValue implements IdentityProviderClientMetadata {
  @override
  String? privacy_policy_url;
  @override
  String? terms_of_service_url;

  IdentityProviderClientMetadataValue({
    this.privacy_policy_url,
    this.terms_of_service_url,
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
  List<String> get provider_urls;
  set provider_urls(List<String> value);
}

final class IdentityProviderWellKnownValue implements IdentityProviderWellKnown {
  @override
  List<String> provider_urls;

  IdentityProviderWellKnownValue({
    required this.provider_urls,
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

