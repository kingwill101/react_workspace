// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: CSP
// ignore_for_file: type=lint

import 'dom.dart';
import 'package:react_web/src/web_runtime.dart';

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
  factory SecurityPolicyViolationEvent(String type, [SecurityPolicyViolationEventInit? eventInitDict]) =>
      WebRuntime.current.createWebObject<SecurityPolicyViolationEvent>(
        'SecurityPolicyViolationEvent',
        [type, eventInitDict],
      );
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
  String? get documentURI;
  set documentURI(String? value);
  String? get referrer;
  set referrer(String? value);
  String? get blockedURI;
  set blockedURI(String? value);
  String? get violatedDirective;
  set violatedDirective(String? value);
  String? get effectiveDirective;
  set effectiveDirective(String? value);
  String? get originalPolicy;
  set originalPolicy(String? value);
  String? get sourceFile;
  set sourceFile(String? value);
  String? get sample;
  set sample(String? value);
  SecurityPolicyViolationEventDisposition? get disposition;
  set disposition(SecurityPolicyViolationEventDisposition? value);
  int? get statusCode;
  set statusCode(int? value);
  int? get lineNumber;
  set lineNumber(int? value);
  int? get columnNumber;
  set columnNumber(int? value);
}

final class SecurityPolicyViolationEventInitValue implements SecurityPolicyViolationEventInit {
  @override
  String? documentURI;
  @override
  String? referrer;
  @override
  String? blockedURI;
  @override
  String? violatedDirective;
  @override
  String? effectiveDirective;
  @override
  String? originalPolicy;
  @override
  String? sourceFile;
  @override
  String? sample;
  @override
  SecurityPolicyViolationEventDisposition? disposition;
  @override
  int? statusCode;
  @override
  int? lineNumber;
  @override
  int? columnNumber;

  SecurityPolicyViolationEventInitValue({
    this.documentURI,
    this.referrer,
    this.blockedURI,
    this.violatedDirective,
    this.effectiveDirective,
    this.originalPolicy,
    this.sourceFile,
    this.sample,
    this.disposition,
    this.statusCode,
    this.lineNumber,
    this.columnNumber,
  });
}

