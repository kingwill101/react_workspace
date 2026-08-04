// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: CSP
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'dom.dart';

abstract interface class CSPViolationReportBody {
  String get documentURL;
  String? get referrer;
  String? get blockedURL;
  String get effectiveDirective;
  String get originalPolicy;
  String? get sourceFile;
  String? get sample;
  SecurityPolicyViolationEventDisposition get disposition;
  int get statusCode;
  int? get lineNumber;
  int? get columnNumber;
}

abstract interface class SecurityPolicyViolationEvent {
  String get documentURI;
  String get referrer;
  String get blockedURI;
  String get effectiveDirective;
  String get violatedDirective;
  String get originalPolicy;
  String get sourceFile;
  String get sample;
  SecurityPolicyViolationEventDisposition get disposition;
  int get statusCode;
  int get lineNumber;
  int get columnNumber;
}

typedef SecurityPolicyViolationEventDisposition = String;

abstract interface class SecurityPolicyViolationEventInit {
  String get documentURI;
  set documentURI(String value);
  String get referrer;
  set referrer(String value);
  String get blockedURI;
  set blockedURI(String value);
  String get violatedDirective;
  set violatedDirective(String value);
  String get effectiveDirective;
  set effectiveDirective(String value);
  String get originalPolicy;
  set originalPolicy(String value);
  String get sourceFile;
  set sourceFile(String value);
  String get sample;
  set sample(String value);
  SecurityPolicyViolationEventDisposition get disposition;
  set disposition(SecurityPolicyViolationEventDisposition value);
  int get statusCode;
  set statusCode(int value);
  int get lineNumber;
  set lineNumber(int value);
  int get columnNumber;
  set columnNumber(int value);
}

