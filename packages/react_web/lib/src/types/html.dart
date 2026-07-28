/// Neutral Web IDL interfaces — pure Dart, no browser dependencies.
///
/// These abstract interfaces correspond to Web IDL element types and are used
/// in generated factory signatures (ref callbacks, event currentTarget).  The
/// browser adapter provides concrete implementations backed by `package:web`.
/// The SSR renderer uses these interfaces for type-checking only — it never
/// constructs or inspects them.

abstract interface class WebEventTarget {}

abstract interface class WebNode implements WebEventTarget {}

abstract interface class WebElement implements WebNode {
  String? get id;
  void focus();
}

abstract interface class HTMLElement implements WebElement {
  String? get title;
  String? get lang;
  bool? get hidden;
  int? get tabIndex;
  String? get dir;
}

abstract interface class HTMLDivElement implements HTMLElement {}

abstract interface class HTMLSpanElement implements HTMLElement {}

abstract interface class HTMLButtonElement implements HTMLElement {
  bool? get disabled;
  String? get type;
}

abstract interface class HTMLInputElement implements HTMLElement {
  String? get value;
  String? get type;
  bool? get disabled;
  String? get placeholder;
}

abstract interface class HTMLFormElement implements HTMLElement {
  String? get action;
  String? get method;
}

abstract interface class HTMLLabelElement implements HTMLElement {
  String? get htmlFor;
}

abstract interface class HTMLTextAreaElement implements HTMLElement {
  String? get value;
  String? get placeholder;
  bool? get disabled;
}

abstract interface class HTMLSelectElement implements HTMLElement {
  bool? get disabled;
}

abstract interface class HTMLOptionElement implements HTMLElement {
  bool? get disabled;
  bool? get selected;
  String? get value;
}

abstract interface class HTMLAnchorElement implements HTMLElement {
  String? get href;
  String? get target;
  String? get rel;
}

abstract interface class HTMLImageElement implements HTMLElement {
  String? get src;
  String? get alt;
  int? get width;
  int? get height;
}

abstract interface class ValidityState {}
abstract interface class NodeList {}
abstract interface class DOMTokenList {}
abstract interface class HTMLCollection {}
abstract interface class HTMLFormControlsCollection implements HTMLCollection {}
abstract interface class HTMLOptionsCollection implements HTMLCollection {}

/// Marker for DOM `Element`.
abstract interface class Element implements WebElement {}

/// Marker for DOM `Node`.  
abstract interface class Node implements WebNode {}

abstract interface class NamedNodeMap {}
abstract interface class ShadowRoot {}
abstract interface class Document {}
abstract interface class FileList {}
abstract interface class HTMLDataListElement {}
