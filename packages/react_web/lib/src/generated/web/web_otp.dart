// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: web-otp
// ignore_for_file: type=lint


abstract interface class OTPCredentialRequestOptions {
  List<OTPCredentialTransportType>? get transport;
  set transport(List<OTPCredentialTransportType>? value);
}

final class OTPCredentialRequestOptionsValue implements OTPCredentialRequestOptions {
  @override
  List<OTPCredentialTransportType>? transport;

  OTPCredentialRequestOptionsValue({
    this.transport,
  });
}

typedef OTPCredentialTransportType = String;

