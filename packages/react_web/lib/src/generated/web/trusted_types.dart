// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: trusted-types
// ignore_for_file: type=lint

typedef CreateHTMLCallback = String? Function(String input, Object arguments);

typedef CreateScriptCallback = String? Function(String input, Object arguments);

typedef CreateScriptURLCallback =
    String? Function(String input, Object arguments);

abstract interface class TrustedHTML {
  String toJSON();
}

abstract interface class TrustedScript {
  String toJSON();
}

abstract interface class TrustedScriptURL {
  String toJSON();
}

typedef TrustedType = Object;

abstract interface class TrustedTypePolicy {
  String get name;
  TrustedHTML createHTML(String input, [List<Object>? arguments]);
  TrustedScript createScript(String input, [List<Object>? arguments]);
  TrustedScriptURL createScriptURL(String input, [List<Object>? arguments]);
}

abstract interface class TrustedTypePolicyFactory {
  TrustedTypePolicy createPolicy(
    String policyName, [
    TrustedTypePolicyOptions? policyOptions,
  ]);
  bool isHTML(Object value);
  bool isScript(Object value);
  bool isScriptURL(Object value);
  TrustedHTML get emptyHTML;
  TrustedScript get emptyScript;
  String? getAttributeType(
    String tagName,
    String attribute, [
    String? elementNs,
    String? attrNs,
  ]);
  String? getPropertyType(String tagName, String property, [String? elementNs]);
  TrustedTypePolicy? get defaultPolicy;
}

abstract interface class TrustedTypePolicyOptions {
  CreateHTMLCallback? get createHTML;
  set createHTML(CreateHTMLCallback? value);
  CreateScriptCallback? get createScript;
  set createScript(CreateScriptCallback? value);
  CreateScriptURLCallback? get createScriptURL;
  set createScriptURL(CreateScriptURLCallback? value);
}

final class TrustedTypePolicyOptionsValue implements TrustedTypePolicyOptions {
  @override
  CreateHTMLCallback? createHTML;
  @override
  CreateScriptCallback? createScript;
  @override
  CreateScriptURLCallback? createScriptURL;

  TrustedTypePolicyOptionsValue({
    this.createHTML,
    this.createScript,
    this.createScriptURL,
  });
}
