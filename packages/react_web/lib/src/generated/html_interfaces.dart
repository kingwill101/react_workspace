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

abstract interface class RenderingContext {}

abstract interface class OffscreenRenderingContext {}

abstract interface class Blob {}

abstract interface class FileList {}

abstract interface class TextTrackKind {}

abstract interface class TextTrackMode {}

abstract interface class MediaProvider {}

abstract interface class CanPlayTypeResult {}

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

abstract interface class HTMLMarqueeElement implements HTMLElement {
  String get behavior;
  set behavior(String value);
  String get bgColor;
  set bgColor(String value);
  String get direction;
  set direction(String value);
  String get height;
  set height(String value);
  int get hspace;
  set hspace(int value);
  int get loop;
  set loop(int value);
  int get scrollAmount;
  set scrollAmount(int value);
  int get scrollDelay;
  set scrollDelay(int value);
  bool get trueSpeed;
  set trueSpeed(bool value);
  int get vspace;
  set vspace(int value);
  String get width;
  set width(String value);
  void start();
  void stop();
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

abstract interface class NodeList {
  Node? item();
  int get length;
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

abstract interface class HTMLHeadElement implements HTMLElement {}

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

abstract interface class HTMLFontElement implements HTMLElement {
  String get color;
  set color(String value);
  String get face;
  set face(String value);
  String get size;
  set size(String value);
}

abstract interface class HTMLParamElement implements HTMLElement {
  String get name;
  set name(String value);
  String get value;
  set value(String value);
  String get type;
  set type(String value);
  String get valueType;
  set valueType(String value);
}

abstract interface class HTMLFrameSetElement implements HTMLElement {
  String get cols;
  set cols(String value);
  String get rows;
  set rows(String value);
}

abstract interface class HTMLFrameElement implements HTMLElement {
  String get name;
  set name(String value);
  String get scrolling;
  set scrolling(String value);
  String get src;
  set src(String value);
  String get frameBorder;
  set frameBorder(String value);
  String get longDesc;
  set longDesc(String value);
  bool get noResize;
  set noResize(bool value);
  Document? get contentDocument;
  WindowProxy? get contentWindow;
  String get marginHeight;
  set marginHeight(String value);
  String get marginWidth;
  set marginWidth(String value);
}

abstract interface class HTMLDirectoryElement implements HTMLElement {
  bool get compact;
  set compact(bool value);
}

abstract interface class HTMLUnknownElement implements HTMLElement {}

abstract interface class HTMLCanvasElement implements HTMLElement {
  int get width;
  set width(int value);
  int get height;
  set height(int value);
  RenderingContext? getContext();
  String toDataURL();
  void toBlob();
  OffscreenCanvas transferControlToOffscreen();
}

abstract interface class OffscreenCanvas implements EventTarget {
  int get width;
  set width(int value);
  int get height;
  set height(int value);
  OffscreenRenderingContext? getContext();
  ImageBitmap transferToImageBitmap();
  Blob convertToBlob();
  EventHandler get oncontextlost;
  set oncontextlost(EventHandler value);
  EventHandler get oncontextrestored;
  set oncontextrestored(EventHandler value);
}

abstract interface class ImageBitmap {
  int get width;
  int get height;
  void close();
}

abstract interface class HTMLSlotElement implements HTMLElement {
  String get name;
  set name(String value);
  Node assignedNodes();
  Element assignedElements();
  void assign();
}

abstract interface class HTMLTemplateElement implements HTMLElement {
  DocumentFragment get content;
  String get shadowRootMode;
  set shadowRootMode(String value);
  bool get shadowRootDelegatesFocus;
  set shadowRootDelegatesFocus(bool value);
  bool get shadowRootClonable;
  set shadowRootClonable(bool value);
  bool get shadowRootSerializable;
  set shadowRootSerializable(bool value);
}

abstract interface class HTMLScriptElement implements HTMLElement {
  String get src;
  set src(String value);
  String get type;
  set type(String value);
  bool get noModule;
  set noModule(bool value);
  bool get async_;
  set async_(bool value);
  bool get defer;
  set defer(bool value);
  String get crossOrigin;
  set crossOrigin(String value);
  String get text;
  set text(String value);
  String get integrity;
  set integrity(String value);
  String get referrerPolicy;
  set referrerPolicy(String value);
  DOMTokenList get blocking;
  String get fetchPriority;
  set fetchPriority(String value);
  bool supports();
  String get charset;
  set charset(String value);
  String get event;
  set event(String value);
  String get htmlFor;
  set htmlFor(String value);
}

abstract interface class HTMLDialogElement implements HTMLElement {
  bool get open;
  set open(bool value);
  String get returnValue;
  set returnValue(String value);
  String get closedBy;
  set closedBy(String value);
  void show();
  void showModal();
  void close();
  void requestClose();
}

abstract interface class HTMLDetailsElement implements HTMLElement {
  String get name;
  set name(String value);
  bool get open;
  set open(bool value);
}

abstract interface class HTMLLegendElement implements HTMLElement {
  HTMLFormElement? get form;
  String get align;
  set align(String value);
}

abstract interface class HTMLFieldSetElement implements HTMLElement {
  bool get disabled;
  set disabled(bool value);
  HTMLFormElement? get form;
  String get name;
  set name(String value);
  String get type;
  HTMLCollection get elements;
  bool get willValidate;
  ValidityState get validity;
  String get validationMessage;
  bool checkValidity();
  bool reportValidity();
  void setCustomValidity();
}

abstract interface class HTMLMeterElement implements HTMLElement {
  double get value;
  set value(double value);
  double get min;
  set min(double value);
  double get max;
  set max(double value);
  double get low;
  set low(double value);
  double get high;
  set high(double value);
  double get optimum;
  set optimum(double value);
  NodeList get labels;
}

abstract interface class HTMLProgressElement implements HTMLElement {
  double get value;
  set value(double value);
  double get max;
  set max(double value);
  double get position;
  NodeList get labels;
}

abstract interface class HTMLOutputElement implements HTMLElement {
  DOMTokenList get htmlFor;
  HTMLFormElement? get form;
  String get name;
  set name(String value);
  String get type;
  String get defaultValue;
  set defaultValue(String value);
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
  bool get required_;
  set required_(bool value);
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

abstract interface class HTMLOptGroupElement implements HTMLElement {
  bool get disabled;
  set disabled(bool value);
  String get label;
  set label(String value);
}

abstract interface class HTMLDataListElement implements HTMLElement {
  HTMLCollection get options;
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
  bool get required_;
  set required_(bool value);
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
  bool get required_;
  set required_(bool value);
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

abstract interface class HTMLLabelElement implements HTMLElement {
  HTMLFormElement? get form;
  String get htmlFor;
  set htmlFor(String value);
  HTMLElement? get control;
}

abstract interface class HTMLTableCellElement implements HTMLElement {
  int get colSpan;
  set colSpan(int value);
  int get rowSpan;
  set rowSpan(int value);
  String get headers;
  set headers(String value);
  int get cellIndex;
  String get scope;
  set scope(String value);
  String get abbr;
  set abbr(String value);
  String get align;
  set align(String value);
  String get axis;
  set axis(String value);
  String get height;
  set height(String value);
  String get width;
  set width(String value);
  String get ch;
  set ch(String value);
  String get chOff;
  set chOff(String value);
  bool get noWrap;
  set noWrap(bool value);
  String get vAlign;
  set vAlign(String value);
  String get bgColor;
  set bgColor(String value);
}

abstract interface class HTMLTableRowElement implements HTMLElement {
  int get rowIndex;
  int get sectionRowIndex;
  HTMLCollection get cells;
  HTMLTableCellElement insertCell();
  void deleteCell();
  String get align;
  set align(String value);
  String get ch;
  set ch(String value);
  String get chOff;
  set chOff(String value);
  String get vAlign;
  set vAlign(String value);
  String get bgColor;
  set bgColor(String value);
}

abstract interface class HTMLTableSectionElement implements HTMLElement {
  HTMLCollection get rows;
  HTMLTableRowElement insertRow();
  void deleteRow();
  String get align;
  set align(String value);
  String get ch;
  set ch(String value);
  String get chOff;
  set chOff(String value);
  String get vAlign;
  set vAlign(String value);
}

abstract interface class HTMLTableColElement implements HTMLElement {
  int get span;
  set span(int value);
  String get align;
  set align(String value);
  String get ch;
  set ch(String value);
  String get chOff;
  set chOff(String value);
  String get vAlign;
  set vAlign(String value);
  String get width;
  set width(String value);
}

abstract interface class HTMLTableCaptionElement implements HTMLElement {
  String get align;
  set align(String value);
}

abstract interface class HTMLTableElement implements HTMLElement {
  HTMLTableCaptionElement? get caption;
  set caption(HTMLTableCaptionElement? value);
  HTMLTableCaptionElement createCaption();
  void deleteCaption();
  HTMLTableSectionElement? get tHead;
  set tHead(HTMLTableSectionElement? value);
  HTMLTableSectionElement createTHead();
  void deleteTHead();
  HTMLTableSectionElement? get tFoot;
  set tFoot(HTMLTableSectionElement? value);
  HTMLTableSectionElement createTFoot();
  void deleteTFoot();
  HTMLCollection get tBodies;
  HTMLTableSectionElement createTBody();
  HTMLCollection get rows;
  HTMLTableRowElement insertRow();
  void deleteRow();
  String get align;
  set align(String value);
  String get border;
  set border(String value);
  String get frame;
  set frame(String value);
  String get rules;
  set rules(String value);
  String get summary;
  set summary(String value);
  String get width;
  set width(String value);
  String get bgColor;
  set bgColor(String value);
  String get cellPadding;
  set cellPadding(String value);
  String get cellSpacing;
  set cellSpacing(String value);
}

abstract interface class HTMLAreaElement implements HTMLElement {
  String get alt;
  set alt(String value);
  String get coords;
  set coords(String value);
  String get shape;
  set shape(String value);
  String get target;
  set target(String value);
  String get download;
  set download(String value);
  String get ping;
  set ping(String value);
  String get rel;
  set rel(String value);
  DOMTokenList get relList;
  String get referrerPolicy;
  set referrerPolicy(String value);
  bool get noHref;
  set noHref(bool value);
}

abstract interface class HTMLMapElement implements HTMLElement {
  String get name;
  set name(String value);
  HTMLCollection get areas;
}

abstract interface class HTMLTrackElement implements HTMLElement {
  String get kind;
  set kind(String value);
  String get src;
  set src(String value);
  String get srclang;
  set srclang(String value);
  String get label;
  set label(String value);
  bool get default_;
  set default_(bool value);
  int get readyState;
  TextTrack get track;
}

abstract interface class TextTrack implements EventTarget {
  TextTrackKind get kind;
  String get label;
  String get language;
  String get id;
  String get inBandMetadataTrackDispatchType;
  TextTrackMode get mode;
  set mode(TextTrackMode value);
  TextTrackCueList? get cues;
  TextTrackCueList? get activeCues;
  void addCue();
  void removeCue();
  EventHandler get oncuechange;
  set oncuechange(EventHandler value);
}

abstract interface class TextTrackCueList {
  int get length;
  TextTrackCue? getCueById();
}

abstract interface class TextTrackCue implements EventTarget {
  TextTrack? get track;
  String get id;
  set id(String value);
  double get startTime;
  set startTime(double value);
  double get endTime;
  set endTime(double value);
  bool get pauseOnExit;
  set pauseOnExit(bool value);
  EventHandler get onenter;
  set onenter(EventHandler value);
  EventHandler get onexit;
  set onexit(EventHandler value);
}

abstract interface class HTMLMediaElement implements HTMLElement {
  MediaError? get error;
  String get src;
  set src(String value);
  MediaProvider? get srcObject;
  set srcObject(MediaProvider? value);
  String get currentSrc;
  String get crossOrigin;
  set crossOrigin(String value);
  int get networkState;
  String get preload;
  set preload(String value);
  TimeRanges get buffered;
  void load();
  CanPlayTypeResult canPlayType();
  int get readyState;
  bool get seeking;
  double get currentTime;
  set currentTime(double value);
  void fastSeek();
  double get duration;
  Object getStartDate();
  bool get paused;
  double get defaultPlaybackRate;
  set defaultPlaybackRate(double value);
  double get playbackRate;
  set playbackRate(double value);
  bool get preservesPitch;
  set preservesPitch(bool value);
  TimeRanges get played;
  TimeRanges get seekable;
  bool get ended;
  bool get autoplay;
  set autoplay(bool value);
  bool get loop;
  set loop(bool value);
  void play();
  void pause();
  bool get controls;
  set controls(bool value);
  double get volume;
  set volume(double value);
  bool get muted;
  set muted(bool value);
  bool get defaultMuted;
  set defaultMuted(bool value);
  AudioTrackList get audioTracks;
  VideoTrackList get videoTracks;
  TextTrackList get textTracks;
  TextTrack addTextTrack();
}

abstract interface class HTMLAudioElement implements HTMLMediaElement {}

abstract interface class TextTrackList implements EventTarget {
  int get length;
  TextTrack? getTrackById();
  EventHandler get onchange;
  set onchange(EventHandler value);
  EventHandler get onaddtrack;
  set onaddtrack(EventHandler value);
  EventHandler get onremovetrack;
  set onremovetrack(EventHandler value);
}

abstract interface class VideoTrackList implements EventTarget {
  int get length;
  VideoTrack? getTrackById();
  int get selectedIndex;
  EventHandler get onchange;
  set onchange(EventHandler value);
  EventHandler get onaddtrack;
  set onaddtrack(EventHandler value);
  EventHandler get onremovetrack;
  set onremovetrack(EventHandler value);
}

abstract interface class VideoTrack {
  String get id;
  String get kind;
  String get label;
  String get language;
  bool get selected;
  set selected(bool value);
}

abstract interface class AudioTrackList implements EventTarget {
  int get length;
  AudioTrack? getTrackById();
  EventHandler get onchange;
  set onchange(EventHandler value);
  EventHandler get onaddtrack;
  set onaddtrack(EventHandler value);
  EventHandler get onremovetrack;
  set onremovetrack(EventHandler value);
}

abstract interface class AudioTrack {
  String get id;
  String get kind;
  String get label;
  String get language;
  bool get enabled;
  set enabled(bool value);
}

abstract interface class TimeRanges {
  int get length;
  double start();
  double end();
}

abstract interface class MediaError {
  int get code;
  String get message;
}

abstract interface class HTMLVideoElement implements HTMLMediaElement {
  int get width;
  set width(int value);
  int get height;
  set height(int value);
  int get videoWidth;
  int get videoHeight;
  String get poster;
  set poster(String value);
  bool get playsInline;
  set playsInline(bool value);
}

abstract interface class HTMLObjectElement implements HTMLElement {
  String get data;
  set data(String value);
  String get type;
  set type(String value);
  String get name;
  set name(String value);
  HTMLFormElement? get form;
  String get width;
  set width(String value);
  String get height;
  set height(String value);
  Document? get contentDocument;
  WindowProxy? get contentWindow;
  Document? getSVGDocument();
  bool get willValidate;
  ValidityState get validity;
  String get validationMessage;
  bool checkValidity();
  bool reportValidity();
  void setCustomValidity();
  String get align;
  set align(String value);
  String get archive;
  set archive(String value);
  String get code;
  set code(String value);
  bool get declare;
  set declare(bool value);
  int get hspace;
  set hspace(int value);
  String get standby;
  set standby(String value);
  int get vspace;
  set vspace(int value);
  String get codeBase;
  set codeBase(String value);
  String get codeType;
  set codeType(String value);
  String get useMap;
  set useMap(String value);
  String get border;
  set border(String value);
}

abstract interface class HTMLEmbedElement implements HTMLElement {
  String get src;
  set src(String value);
  String get type;
  set type(String value);
  String get width;
  set width(String value);
  String get height;
  set height(String value);
  Document? getSVGDocument();
  String get align;
  set align(String value);
  String get name;
  set name(String value);
}

abstract interface class HTMLIFrameElement implements HTMLElement {
  String get src;
  set src(String value);
  Object get srcdoc;
  set srcdoc(Object value);
  String get name;
  set name(String value);
  DOMTokenList get sandbox;
  String get allow;
  set allow(String value);
  bool get allowFullscreen;
  set allowFullscreen(bool value);
  String get width;
  set width(String value);
  String get height;
  set height(String value);
  String get referrerPolicy;
  set referrerPolicy(String value);
  String get loading;
  set loading(String value);
  Document? get contentDocument;
  WindowProxy? get contentWindow;
  Document? getSVGDocument();
  String get align;
  set align(String value);
  String get scrolling;
  set scrolling(String value);
  String get frameBorder;
  set frameBorder(String value);
  String get longDesc;
  set longDesc(String value);
  String get marginHeight;
  set marginHeight(String value);
  String get marginWidth;
  set marginWidth(String value);
}

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

abstract interface class HTMLSourceElement implements HTMLElement {
  String get src;
  set src(String value);
  String get type;
  set type(String value);
  String get srcset;
  set srcset(String value);
  String get sizes;
  set sizes(String value);
  String get media;
  set media(String value);
  int get width;
  set width(int value);
  int get height;
  set height(int value);
}

abstract interface class HTMLPictureElement implements HTMLElement {}

abstract interface class HTMLModElement implements HTMLElement {
  String get cite;
  set cite(String value);
  String get dateTime;
  set dateTime(String value);
}

abstract interface class HTMLBRElement implements HTMLElement {
  String get clear;
  set clear(String value);
}

abstract interface class HTMLSpanElement implements HTMLElement {}

abstract interface class HTMLTimeElement implements HTMLElement {
  String get dateTime;
  set dateTime(String value);
}

abstract interface class HTMLDataElement implements HTMLElement {
  String get value;
  set value(String value);
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

abstract interface class HTMLDivElement implements HTMLElement {
  String get align;
  set align(String value);
}

abstract interface class HTMLDListElement implements HTMLElement {
  bool get compact;
  set compact(bool value);
}

abstract interface class HTMLLIElement implements HTMLElement {
  int get value;
  set value(int value);
  String get type;
  set type(String value);
}

abstract interface class HTMLMenuElement implements HTMLElement {
  bool get compact;
  set compact(bool value);
}

abstract interface class HTMLUListElement implements HTMLElement {
  bool get compact;
  set compact(bool value);
  String get type;
  set type(String value);
}

abstract interface class HTMLOListElement implements HTMLElement {
  bool get reversed;
  set reversed(bool value);
  int get start;
  set start(int value);
  String get type;
  set type(String value);
  bool get compact;
  set compact(bool value);
}

abstract interface class HTMLQuoteElement implements HTMLElement {
  String get cite;
  set cite(String value);
}

abstract interface class HTMLPreElement implements HTMLElement {
  int get width;
  set width(int value);
}

abstract interface class HTMLHRElement implements HTMLElement {
  String get align;
  set align(String value);
  String get color;
  set color(String value);
  bool get noShade;
  set noShade(bool value);
  String get size;
  set size(String value);
  String get width;
  set width(String value);
}

abstract interface class HTMLParagraphElement implements HTMLElement {
  String get align;
  set align(String value);
}

abstract interface class HTMLHeadingElement implements HTMLElement {
  String get align;
  set align(String value);
}

abstract interface class HTMLBodyElement implements HTMLElement {
  String get text;
  set text(String value);
  String get link;
  set link(String value);
  String get vLink;
  set vLink(String value);
  String get aLink;
  set aLink(String value);
  String get bgColor;
  set bgColor(String value);
  String get background;
  set background(String value);
}

abstract interface class HTMLStyleElement implements HTMLElement {
  bool get disabled;
  set disabled(bool value);
  String get media;
  set media(String value);
  DOMTokenList get blocking;
  String get type;
  set type(String value);
}

abstract interface class HTMLMetaElement implements HTMLElement {
  String get name;
  set name(String value);
  String get httpEquiv;
  set httpEquiv(String value);
  String get content;
  set content(String value);
  String get media;
  set media(String value);
  String get scheme;
  set scheme(String value);
}

abstract interface class HTMLLinkElement implements HTMLElement {
  String get href;
  set href(String value);
  String get crossOrigin;
  set crossOrigin(String value);
  String get rel;
  set rel(String value);
  String get as_;
  set as_(String value);
  DOMTokenList get relList;
  String get media;
  set media(String value);
  String get integrity;
  set integrity(String value);
  String get hreflang;
  set hreflang(String value);
  String get type;
  set type(String value);
  DOMTokenList get sizes;
  String get imageSrcset;
  set imageSrcset(String value);
  String get imageSizes;
  set imageSizes(String value);
  String get referrerPolicy;
  set referrerPolicy(String value);
  DOMTokenList get blocking;
  bool get disabled;
  set disabled(bool value);
  String get fetchPriority;
  set fetchPriority(String value);
  String get charset;
  set charset(String value);
  String get rev;
  set rev(String value);
  String get target;
  set target(String value);
}

abstract interface class HTMLBaseElement implements HTMLElement {
  String get href;
  set href(String value);
  String get target;
  set target(String value);
}

abstract interface class HTMLTitleElement implements HTMLElement {
  String get text;
  set text(String value);
}

abstract interface class HTMLHtmlElement implements HTMLElement {
  String get version;
  set version(String value);
}
