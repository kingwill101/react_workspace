// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: permissions-policy
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import


abstract interface class PermissionsPolicy {
  bool allowsFeature(String feature, [String? origin]);
  List<String> features();
  List<String> allowedFeatures();
  List<String> getAllowlistForFeature(String feature);
}

abstract interface class PermissionsPolicyViolationReportBody {
  String get featureId;
  String? get sourceFile;
  int? get lineNumber;
  int? get columnNumber;
  String get disposition;
  String? get allowAttribute;
  String? get srcAttribute;
}

