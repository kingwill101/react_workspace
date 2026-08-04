// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: urlpattern
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import


abstract interface class URLPattern {
  bool test([URLPatternInput? input, String? baseURL]);
  URLPatternResult? exec([URLPatternInput? input, String? baseURL]);
  String get protocol;
  String get username;
  String get password;
  String get hostname;
  String get port;
  String get pathname;
  String get search;
  String get hash;
  bool get hasRegExpGroups;
}

typedef URLPatternCompatible = Object;

abstract interface class URLPatternComponentResult {
  String get input;
  set input(String value);
  Map<String, String> get groups;
  set groups(Map<String, String> value);
}

abstract interface class URLPatternInit {
  String get protocol;
  set protocol(String value);
  String get username;
  set username(String value);
  String get password;
  set password(String value);
  String get hostname;
  set hostname(String value);
  String get port;
  set port(String value);
  String get pathname;
  set pathname(String value);
  String get search;
  set search(String value);
  String get hash;
  set hash(String value);
  String get baseURL;
  set baseURL(String value);
}

typedef URLPatternInput = Object;

abstract interface class URLPatternOptions {
  bool get ignoreCase;
  set ignoreCase(bool value);
}

abstract interface class URLPatternResult {
  List<URLPatternInput> get inputs;
  set inputs(List<URLPatternInput> value);
  URLPatternComponentResult get protocol;
  set protocol(URLPatternComponentResult value);
  URLPatternComponentResult get username;
  set username(URLPatternComponentResult value);
  URLPatternComponentResult get password;
  set password(URLPatternComponentResult value);
  URLPatternComponentResult get hostname;
  set hostname(URLPatternComponentResult value);
  URLPatternComponentResult get port;
  set port(URLPatternComponentResult value);
  URLPatternComponentResult get pathname;
  set pathname(URLPatternComponentResult value);
  URLPatternComponentResult get search;
  set search(URLPatternComponentResult value);
  URLPatternComponentResult get hash;
  set hash(URLPatternComponentResult value);
}

