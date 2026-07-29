/// Neutral Web IDL interfaces — generated from neutral_web_model.json
///
/// These abstract interfaces correspond to Web IDL interface types.
library;

abstract interface class DOMRectList {}

abstract interface class DOMRect {}

abstract interface class TrustedHTML {}

abstract interface class ShadowRootMode {}

abstract interface class SlotAssignmentMode {}

abstract interface class EventHandler {}

abstract interface class DocumentReadyState {}

abstract interface class HTMLOrSVGScriptElement {}

abstract interface class WindowProxy {}

abstract interface class DocumentVisibilityState {}

abstract interface class NodeFilter {}

abstract interface class DOMHighResTimeStamp {}

abstract interface class FileList {}

abstract interface class WebEventTarget {}

abstract interface class EventTarget {
  void addEventListener();
  void removeEventListener();
  bool dispatchEvent();
}

abstract interface class Node implements EventTarget {
  int get nodeType;
  String get nodeName;
  String get baseURI;
  bool get isConnected;
  Document? get ownerDocument;
  Node getRootNode();
  Node? get parentNode;
  Element? get parentElement;
  bool hasChildNodes();
  NodeList get childNodes;
  Node? get firstChild;
  Node? get lastChild;
  Node? get previousSibling;
  Node? get nextSibling;
  String get nodeValue;
  set nodeValue(String value);
  String get textContent;
  set textContent(String value);
  void normalize();
  Node cloneNode();
  bool isEqualNode();
  bool isSameNode();
  int compareDocumentPosition();
  bool contains();
  String lookupPrefix();
  String lookupNamespaceURI();
  bool isDefaultNamespace();
  Node insertBefore();
  Node appendChild();
  Node replaceChild();
  Node removeChild();
}

abstract interface class NodeList {
  Node? item();
  int get length;
}

abstract interface class Element implements Node {
  String get namespaceURI;
  String get prefix;
  String get localName;
  String get tagName;
  String get id;
  set id(String value);
  String get className;
  set className(String value);
  DOMTokenList get classList;
  String get slot;
  set slot(String value);
  bool hasAttributes();
  NamedNodeMap get attributes;
  String getAttributeNames();
  String getAttribute();
  String getAttributeNS();
  void setAttribute();
  void setAttributeNS();
  void removeAttribute();
  void removeAttributeNS();
  bool toggleAttribute();
  bool hasAttribute();
  bool hasAttributeNS();
  Attr? getAttributeNode();
  Attr? getAttributeNodeNS();
  Attr? setAttributeNode();
  Attr? setAttributeNodeNS();
  Attr removeAttributeNode();
  ShadowRoot attachShadow();
  ShadowRoot? get shadowRoot;
  Element? closest();
  bool matches();
  bool webkitMatchesSelector();
  HTMLCollection getElementsByTagName();
  HTMLCollection getElementsByTagNameNS();
  HTMLCollection getElementsByClassName();
  Element? insertAdjacentElement();
  void insertAdjacentText();
  DOMRectList getClientRects();
  DOMRect getBoundingClientRect();
  bool checkVisibility();
  void scrollIntoView();
  void scroll();
  void scrollTo();
  void scrollBy();
  double get scrollTop;
  set scrollTop(double value);
  double get scrollLeft;
  set scrollLeft(double value);
  int get scrollWidth;
  int get scrollHeight;
  int get clientTop;
  int get clientLeft;
  int get clientWidth;
  int get clientHeight;
  double get currentCSSZoom;
  void setHTMLUnsafe();
  String getHTML();
  Object get innerHTML;
  set innerHTML(Object value);
  Object get outerHTML;
  set outerHTML(Object value);
  void insertAdjacentHTML();
}

abstract interface class HTMLCollection {
  int get length;
  Element? item();
  Element? namedItem();
}

abstract interface class DocumentFragment implements Node {}

abstract interface class ShadowRoot implements DocumentFragment {
  ShadowRootMode get mode;
  bool get delegatesFocus;
  SlotAssignmentMode get slotAssignment;
  bool get clonable;
  bool get serializable;
  Element get host;
  EventHandler get onslotchange;
  set onslotchange(EventHandler value);
  void setHTMLUnsafe();
  String getHTML();
  Object get innerHTML;
  set innerHTML(Object value);
}

abstract interface class Attr implements Node {
  String get namespaceURI;
  String get prefix;
  String get localName;
  String get name;
  String get value;
  set value(String value);
  Element? get ownerElement;
  bool get specified;
}

abstract interface class NamedNodeMap {
  int get length;
  Attr? item();
  Attr? getNamedItem();
  Attr? getNamedItemNS();
  Attr? setNamedItem();
  Attr? setNamedItemNS();
  Attr removeNamedItem();
  Attr removeNamedItemNS();
}

abstract interface class DOMTokenList {
  int get length;
  String item();
  bool contains();
  void add();
  void remove();
  bool toggle();
  bool replace();
  bool supports();
  String get value;
  set value(String value);
}

abstract interface class Document implements Node {
  DOMImplementation get implementation;
  String get URL;
  String get documentURI;
  String get compatMode;
  String get characterSet;
  String get charset;
  String get inputEncoding;
  String get contentType;
  DocumentType? get doctype;
  Element? get documentElement;
  HTMLCollection getElementsByTagName();
  HTMLCollection getElementsByTagNameNS();
  HTMLCollection getElementsByClassName();
  Element createElement();
  Element createElementNS();
  DocumentFragment createDocumentFragment();
  Text createTextNode();
  CDATASection createCDATASection();
  Comment createComment();
  ProcessingInstruction createProcessingInstruction();
  Node importNode();
  Node adoptNode();
  Attr createAttribute();
  Attr createAttributeNS();
  Event createEvent();
  Range createRange();
  NodeIterator createNodeIterator();
  TreeWalker createTreeWalker();
  Element? elementFromPoint();
  Element elementsFromPoint();
  CaretPosition? caretPositionFromPoint();
  Element? get scrollingElement;
  Document parseHTMLUnsafe();
  Location? get location;
  String get domain;
  set domain(String value);
  String get referrer;
  String get cookie;
  set cookie(String value);
  String get lastModified;
  DocumentReadyState get readyState;
  String get title;
  set title(String value);
  String get dir;
  set dir(String value);
  HTMLElement? get body;
  set body(HTMLElement? value);
  HTMLHeadElement? get head;
  HTMLCollection get images;
  HTMLCollection get embeds;
  HTMLCollection get plugins;
  HTMLCollection get links;
  HTMLCollection get forms;
  HTMLCollection get scripts;
  NodeList getElementsByName();
  HTMLOrSVGScriptElement? get currentScript;
  WindowProxy? open();
  void close();
  void write();
  void writeln();
  WindowProxy? get defaultView;
  bool hasFocus();
  String get designMode;
  set designMode(String value);
  bool execCommand();
  bool queryCommandEnabled();
  bool queryCommandIndeterm();
  bool queryCommandState();
  bool queryCommandSupported();
  String queryCommandValue();
  bool get hidden;
  DocumentVisibilityState get visibilityState;
  EventHandler get onreadystatechange;
  set onreadystatechange(EventHandler value);
  EventHandler get onvisibilitychange;
  set onvisibilitychange(EventHandler value);
  String get fgColor;
  set fgColor(String value);
  String get linkColor;
  set linkColor(String value);
  String get vlinkColor;
  set vlinkColor(String value);
  String get alinkColor;
  set alinkColor(String value);
  String get bgColor;
  set bgColor(String value);
  HTMLCollection get anchors;
  HTMLCollection get applets;
  void clear();
  void captureEvents();
  void releaseEvents();
  HTMLAllCollection get all;
}

abstract interface class HTMLAllCollection {
  int get length;
  Object namedItem();
  Object item();
}

abstract interface class HTMLElement implements Element {
  String get title;
  set title(String value);
  String get lang;
  set lang(String value);
  bool get translate;
  set translate(bool value);
  String get dir;
  set dir(String value);
  Object get hidden;
  set hidden(Object value);
  bool get inert;
  set inert(bool value);
  void click();
  String get accessKey;
  set accessKey(String value);
  String get accessKeyLabel;
  bool get draggable;
  set draggable(bool value);
  bool get spellcheck;
  set spellcheck(bool value);
  String get writingSuggestions;
  set writingSuggestions(String value);
  String get autocapitalize;
  set autocapitalize(String value);
  bool get autocorrect;
  set autocorrect(bool value);
  String get innerText;
  set innerText(String value);
  String get outerText;
  set outerText(String value);
  ElementInternals attachInternals();
  void showPopover();
  void hidePopover();
  bool togglePopover();
  String get popover;
  set popover(String value);
  Element? get offsetParent;
  int get offsetTop;
  int get offsetLeft;
  int get offsetWidth;
  int get offsetHeight;
}

abstract interface class HTMLHeadElement implements HTMLElement {}

abstract interface class ElementInternals {
  ShadowRoot? get shadowRoot;
  void setFormValue();
  HTMLFormElement? get form;
  void setValidity();
  bool get willValidate;
  ValidityState get validity;
  String get validationMessage;
  bool checkValidity();
  bool reportValidity();
  NodeList get labels;
  CustomStateSet get states;
}

abstract interface class CustomStateSet {}

abstract interface class ValidityState {
  bool get valueMissing;
  bool get typeMismatch;
  bool get patternMismatch;
  bool get tooLong;
  bool get tooShort;
  bool get rangeUnderflow;
  bool get rangeOverflow;
  bool get stepMismatch;
  bool get badInput;
  bool get customError;
  bool get valid;
}

abstract interface class HTMLFormElement implements HTMLElement {
  String get acceptCharset;
  set acceptCharset(String value);
  String get action;
  set action(String value);
  String get autocomplete;
  set autocomplete(String value);
  String get enctype;
  set enctype(String value);
  String get encoding;
  set encoding(String value);
  String get method;
  set method(String value);
  String get name;
  set name(String value);
  bool get noValidate;
  set noValidate(bool value);
  String get target;
  set target(String value);
  String get rel;
  set rel(String value);
  DOMTokenList get relList;
  HTMLFormControlsCollection get elements;
  int get length;
  void submit();
  void requestSubmit();
  void reset();
  bool checkValidity();
  bool reportValidity();
}

abstract interface class RadioNodeList implements NodeList {
  String get value;
  set value(String value);
}

abstract interface class HTMLFormControlsCollection implements HTMLCollection {}

abstract interface class Location {
  String get href;
  set href(String value);
  String get origin;
  String get protocol;
  set protocol(String value);
  String get host;
  set host(String value);
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
  void assign();
  void replace();
  void reload();
  DOMStringList get ancestorOrigins;
}

abstract interface class DOMStringList {
  int get length;
  String item();
  bool contains();
}

abstract interface class CaretPosition {
  Node get offsetNode;
  int get offset;
  DOMRect? getClientRect();
}

abstract interface class TreeWalker {
  Node get root;
  int get whatToShow;
  NodeFilter? get filter;
  Node get currentNode;
  set currentNode(Node value);
  Node? parentNode();
  Node? firstChild();
  Node? lastChild();
  Node? previousSibling();
  Node? nextSibling();
  Node? previousNode();
  Node? nextNode();
}

abstract interface class NodeIterator {
  Node get root;
  Node get referenceNode;
  bool get pointerBeforeReferenceNode;
  int get whatToShow;
  NodeFilter? get filter;
  Node? nextNode();
  Node? previousNode();
  void detach();
}

abstract interface class AbstractRange {
  Node get startContainer;
  int get startOffset;
  Node get endContainer;
  int get endOffset;
  bool get collapsed;
}

abstract interface class Range implements AbstractRange {
  Node get commonAncestorContainer;
  void setStart();
  void setEnd();
  void setStartBefore();
  void setStartAfter();
  void setEndBefore();
  void setEndAfter();
  void collapse();
  void selectNode();
  void selectNodeContents();
  int compareBoundaryPoints();
  void deleteContents();
  DocumentFragment extractContents();
  DocumentFragment cloneContents();
  void insertNode();
  void surroundContents();
  Range cloneRange();
  void detach();
  bool isPointInRange();
  int comparePoint();
  bool intersectsNode();
  DOMRectList getClientRects();
  DOMRect getBoundingClientRect();
  DocumentFragment createContextualFragment();
}

abstract interface class Event {
  String get type;
  EventTarget? get target;
  EventTarget? get srcElement;
  EventTarget? get currentTarget;
  EventTarget composedPath();
  int get eventPhase;
  void stopPropagation();
  bool get cancelBubble;
  set cancelBubble(bool value);
  void stopImmediatePropagation();
  bool get bubbles;
  bool get cancelable;
  bool get returnValue;
  set returnValue(bool value);
  void preventDefault();
  bool get defaultPrevented;
  bool get composed;
  bool get isTrusted;
  DOMHighResTimeStamp get timeStamp;
  void initEvent();
}

abstract interface class CharacterData implements Node {
  String get data;
  set data(String value);
  int get length;
  String substringData();
  void appendData();
  void insertData();
  void deleteData();
  void replaceData();
}

abstract interface class ProcessingInstruction implements CharacterData {
  String get target;
}

abstract interface class Comment implements CharacterData {}

abstract interface class Text implements CharacterData {
  Text splitText();
  String get wholeText;
}

abstract interface class CDATASection implements Text {}

abstract interface class DocumentType implements Node {
  String get name;
  String get publicId;
  String get systemId;
}

abstract interface class DOMImplementation {
  DocumentType createDocumentType();
  XMLDocument createDocument();
  Document createHTMLDocument();
  bool hasFeature();
}

abstract interface class XMLDocument implements Document {}

abstract interface class HTMLImageElement implements HTMLElement {
  String get alt;
  set alt(String value);
  String get src;
  set src(String value);
  String get srcset;
  set srcset(String value);
  String get sizes;
  set sizes(String value);
  String get crossOrigin;
  set crossOrigin(String value);
  String get useMap;
  set useMap(String value);
  bool get isMap;
  set isMap(bool value);
  int get width;
  set width(int value);
  int get height;
  set height(int value);
  int get naturalWidth;
  int get naturalHeight;
  bool get complete;
  String get currentSrc;
  String get referrerPolicy;
  set referrerPolicy(String value);
  String get decoding;
  set decoding(String value);
  String get loading;
  set loading(String value);
  String get fetchPriority;
  set fetchPriority(String value);
  void decode();
  int get x;
  int get y;
  String get name;
  set name(String value);
  String get lowsrc;
  set lowsrc(String value);
  String get align;
  set align(String value);
  int get hspace;
  set hspace(int value);
  int get vspace;
  set vspace(int value);
  String get longDesc;
  set longDesc(String value);
  String get border;
  set border(String value);
}

abstract interface class HTMLAnchorElement implements HTMLElement {
  String get target;
  set target(String value);
  String get download;
  set download(String value);
  String get ping;
  set ping(String value);
  String get rel;
  set rel(String value);
  DOMTokenList get relList;
  String get hreflang;
  set hreflang(String value);
  String get type;
  set type(String value);
  String get text;
  set text(String value);
  String get referrerPolicy;
  set referrerPolicy(String value);
  String get coords;
  set coords(String value);
  String get charset;
  set charset(String value);
  String get name;
  set name(String value);
  String get rev;
  set rev(String value);
  String get shape;
  set shape(String value);
}

abstract interface class HTMLOptionElement implements HTMLElement {
  bool get disabled;
  set disabled(bool value);
  HTMLFormElement? get form;
  String get label;
  set label(String value);
  bool get defaultSelected;
  set defaultSelected(bool value);
  bool get selected;
  set selected(bool value);
  String get value;
  set value(String value);
  String get text;
  set text(String value);
  int get index;
}

abstract interface class HTMLSelectElement implements HTMLElement {
  String get autocomplete;
  set autocomplete(String value);
  bool get disabled;
  set disabled(bool value);
  HTMLFormElement? get form;
  bool get multiple;
  set multiple(bool value);
  String get name;
  set name(String value);
  bool get required;
  set required(bool value);
  int get size;
  set size(int value);
  String get type;
  HTMLOptionsCollection get options;
  int get length;
  set length(int value);
  HTMLOptionElement? item();
  HTMLOptionElement? namedItem();
  void add();
  void remove();
  HTMLCollection get selectedOptions;
  int get selectedIndex;
  set selectedIndex(int value);
  String get value;
  set value(String value);
  bool get willValidate;
  ValidityState get validity;
  String get validationMessage;
  bool checkValidity();
  bool reportValidity();
  void setCustomValidity();
  void showPicker();
  NodeList get labels;
}

abstract interface class HTMLOptionsCollection implements HTMLCollection {
  void add();
  void remove();
  int get selectedIndex;
  set selectedIndex(int value);
}

abstract interface class HTMLTextAreaElement implements HTMLElement {
  String get autocomplete;
  set autocomplete(String value);
  int get cols;
  set cols(int value);
  String get dirName;
  set dirName(String value);
  bool get disabled;
  set disabled(bool value);
  HTMLFormElement? get form;
  int get maxLength;
  set maxLength(int value);
  int get minLength;
  set minLength(int value);
  String get name;
  set name(String value);
  String get placeholder;
  set placeholder(String value);
  bool get readOnly;
  set readOnly(bool value);
  bool get required;
  set required(bool value);
  int get rows;
  set rows(int value);
  String get wrap;
  set wrap(String value);
  String get type;
  String get defaultValue;
  set defaultValue(String value);
  String get value;
  set value(String value);
  int get textLength;
  bool get willValidate;
  ValidityState get validity;
  String get validationMessage;
  bool checkValidity();
  bool reportValidity();
  void setCustomValidity();
  NodeList get labels;
  void select();
  int get selectionStart;
  set selectionStart(int value);
  int get selectionEnd;
  set selectionEnd(int value);
  String get selectionDirection;
  set selectionDirection(String value);
  void setRangeText();
  void setSelectionRange();
}

abstract interface class HTMLLabelElement implements HTMLElement {
  HTMLFormElement? get form;
  String get htmlFor;
  set htmlFor(String value);
  HTMLElement? get control;
}

abstract interface class HTMLInputElement implements HTMLElement {
  String get accept;
  set accept(String value);
  bool get alpha;
  set alpha(bool value);
  String get alt;
  set alt(String value);
  String get autocomplete;
  set autocomplete(String value);
  bool get defaultChecked;
  set defaultChecked(bool value);
  bool get checked;
  set checked(bool value);
  String get colorSpace;
  set colorSpace(String value);
  String get dirName;
  set dirName(String value);
  bool get disabled;
  set disabled(bool value);
  HTMLFormElement? get form;
  FileList? get files;
  set files(FileList? value);
  String get formAction;
  set formAction(String value);
  String get formEnctype;
  set formEnctype(String value);
  String get formMethod;
  set formMethod(String value);
  bool get formNoValidate;
  set formNoValidate(bool value);
  String get formTarget;
  set formTarget(String value);
  int get height;
  set height(int value);
  bool get indeterminate;
  set indeterminate(bool value);
  HTMLDataListElement? get list;
  String get max;
  set max(String value);
  int get maxLength;
  set maxLength(int value);
  String get min;
  set min(String value);
  int get minLength;
  set minLength(int value);
  bool get multiple;
  set multiple(bool value);
  String get name;
  set name(String value);
  String get pattern;
  set pattern(String value);
  String get placeholder;
  set placeholder(String value);
  bool get readOnly;
  set readOnly(bool value);
  bool get required;
  set required(bool value);
  int get size;
  set size(int value);
  String get src;
  set src(String value);
  String get step;
  set step(String value);
  String get type;
  set type(String value);
  String get defaultValue;
  set defaultValue(String value);
  String get value;
  set value(String value);
  Object get valueAsDate;
  set valueAsDate(Object value);
  double get valueAsNumber;
  set valueAsNumber(double value);
  int get width;
  set width(int value);
  void stepUp();
  void stepDown();
  bool get willValidate;
  ValidityState get validity;
  String get validationMessage;
  bool checkValidity();
  bool reportValidity();
  void setCustomValidity();
  NodeList? get labels;
  void select();
  int get selectionStart;
  set selectionStart(int value);
  int get selectionEnd;
  set selectionEnd(int value);
  String get selectionDirection;
  set selectionDirection(String value);
  void setRangeText();
  void setSelectionRange();
  void showPicker();
  String get align;
  set align(String value);
  String get useMap;
  set useMap(String value);
}

abstract interface class HTMLDataListElement implements HTMLElement {
  HTMLCollection get options;
}

abstract interface class HTMLButtonElement implements HTMLElement {
  String get command;
  set command(String value);
  Element? get commandForElement;
  set commandForElement(Element? value);
  bool get disabled;
  set disabled(bool value);
  HTMLFormElement? get form;
  String get formAction;
  set formAction(String value);
  String get formEnctype;
  set formEnctype(String value);
  String get formMethod;
  set formMethod(String value);
  bool get formNoValidate;
  set formNoValidate(bool value);
  String get formTarget;
  set formTarget(String value);
  String get name;
  set name(String value);
  String get type;
  set type(String value);
  String get value;
  set value(String value);
  bool get willValidate;
  ValidityState get validity;
  String get validationMessage;
  bool checkValidity();
  bool reportValidity();
  void setCustomValidity();
  NodeList get labels;
}

abstract interface class HTMLSpanElement implements HTMLElement {}

abstract interface class HTMLDivElement implements HTMLElement {
  String get align;
  set align(String value);
}
