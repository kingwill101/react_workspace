// GENERATED CODE — DO NOT EDIT

import 'dart:js_interop';

import 'package:react_js/react_js.dart';
import 'package:web/web.dart' as web;

final class BrowserHTMLCollection {
  final web.HTMLCollection _element;
  BrowserHTMLCollection(this._element);
  web.HTMLCollection get inner => _element;
}

final class BrowserHTMLAllCollection {
  final web.HTMLAllCollection _element;
  BrowserHTMLAllCollection(this._element);
  web.HTMLAllCollection get inner => _element;
}

final class BrowserHTMLHeadElement {
  final web.HTMLHeadElement _element;
  BrowserHTMLHeadElement(this._element);
  web.HTMLHeadElement get inner => _element;
}

final class BrowserHTMLFormElement {
  final web.HTMLFormElement _element;
  BrowserHTMLFormElement(this._element);
  web.HTMLFormElement get inner => _element;
}

final class BrowserHTMLFormControlsCollection {
  final web.HTMLFormControlsCollection _element;
  BrowserHTMLFormControlsCollection(this._element);
  web.HTMLFormControlsCollection get inner => _element;
}

final class BrowserHTMLImageElement {
  final web.HTMLImageElement _element;
  BrowserHTMLImageElement(this._element);
  web.HTMLImageElement get inner => _element;
}

final class BrowserHTMLAnchorElement {
  final web.HTMLAnchorElement _element;
  BrowserHTMLAnchorElement(this._element);
  web.HTMLAnchorElement get inner => _element;
}

final class BrowserHTMLOptionElement {
  final web.HTMLOptionElement _element;
  BrowserHTMLOptionElement(this._element);
  web.HTMLOptionElement get inner => _element;
}

final class BrowserHTMLSelectElement {
  final web.HTMLSelectElement _element;
  BrowserHTMLSelectElement(this._element);
  web.HTMLSelectElement get inner => _element;
}

final class BrowserHTMLOptionsCollection {
  final web.HTMLOptionsCollection _element;
  BrowserHTMLOptionsCollection(this._element);
  web.HTMLOptionsCollection get inner => _element;
}

final class BrowserHTMLTextAreaElement {
  final web.HTMLTextAreaElement _element;
  BrowserHTMLTextAreaElement(this._element);
  web.HTMLTextAreaElement get inner => _element;
}

final class BrowserHTMLLabelElement {
  final web.HTMLLabelElement _element;
  BrowserHTMLLabelElement(this._element);
  web.HTMLLabelElement get inner => _element;
}

final class BrowserHTMLInputElement {
  final web.HTMLInputElement _element;
  BrowserHTMLInputElement(this._element);
  web.HTMLInputElement get inner => _element;
}

final class BrowserHTMLDataListElement {
  final web.HTMLDataListElement _element;
  BrowserHTMLDataListElement(this._element);
  web.HTMLDataListElement get inner => _element;
}

final class BrowserHTMLButtonElement {
  final web.HTMLButtonElement _element;
  BrowserHTMLButtonElement(this._element);
  web.HTMLButtonElement get inner => _element;
}

final class BrowserHTMLSpanElement {
  final web.HTMLSpanElement _element;
  BrowserHTMLSpanElement(this._element);
  web.HTMLSpanElement get inner => _element;
}

final class BrowserHTMLDivElement {
  final web.HTMLDivElement _element;
  BrowserHTMLDivElement(this._element);
  web.HTMLDivElement get inner => _element;
}

final class BrowserReactCompositionEvent<T extends web.EventTarget> {
  final web.Event _event;
  BrowserReactCompositionEvent(this._event);
  web.Event get inner => _event;
}

final class BrowserReactSyntheticEvent<T extends web.EventTarget> {
  final web.Event _event;
  BrowserReactSyntheticEvent(this._event);
  web.Event get inner => _event;
}

final class BrowserReactTouchEvent<T extends web.EventTarget> {
  final web.Event _event;
  BrowserReactTouchEvent(this._event);
  web.Event get inner => _event;
}

final class BrowserReactPointerEvent<T extends web.EventTarget> {
  final web.Event _event;
  BrowserReactPointerEvent(this._event);
  web.Event get inner => _event;
}

final class BrowserReactWheelEvent<T extends web.EventTarget> {
  final web.Event _event;
  BrowserReactWheelEvent(this._event);
  web.Event get inner => _event;
}

final class BrowserReactDragEvent<T extends web.EventTarget> {
  final web.Event _event;
  BrowserReactDragEvent(this._event);
  web.Event get inner => _event;
}

final class BrowserReactFocusEvent<T extends web.EventTarget> {
  final web.Event _event;
  BrowserReactFocusEvent(this._event);
  web.Event get inner => _event;
}

final class BrowserReactKeyboardEvent<T extends web.EventTarget> {
  final web.Event _event;
  BrowserReactKeyboardEvent(this._event);
  web.Event get inner => _event;
}

final class BrowserReactFormEvent<T extends web.EventTarget> {
  final web.Event _event;
  BrowserReactFormEvent(this._event);
  web.Event get inner => _event;
}

final class BrowserReactChangeEvent<T extends web.EventTarget> {
  final web.Event _event;
  BrowserReactChangeEvent(this._event);
  web.Event get inner => _event;
}

final class BrowserReactInputEvent<T extends web.EventTarget> {
  final web.Event _event;
  BrowserReactInputEvent(this._event);
  web.Event get inner => _event;
}

final class BrowserReactMouseEvent<T extends web.EventTarget> {
  final web.Event _event;
  BrowserReactMouseEvent(this._event);
  web.Event get inner => _event;
}

void registerBrowserAdapters() {
  ReactCodecRegistry.registerHostValue(
    'web', 'web.HTMLCollection',
    decoder: (value) => BrowserHTMLCollection(value as web.HTMLCollection),
    encoder: (value) => (value as BrowserHTMLCollection)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'web.HTMLAllCollection',
    decoder: (value) => BrowserHTMLAllCollection(value as web.HTMLAllCollection),
    encoder: (value) => (value as BrowserHTMLAllCollection)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'web.HTMLHeadElement',
    decoder: (value) => BrowserHTMLHeadElement(value as web.HTMLHeadElement),
    encoder: (value) => (value as BrowserHTMLHeadElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'web.HTMLFormElement',
    decoder: (value) => BrowserHTMLFormElement(value as web.HTMLFormElement),
    encoder: (value) => (value as BrowserHTMLFormElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'web.HTMLFormControlsCollection',
    decoder: (value) => BrowserHTMLFormControlsCollection(value as web.HTMLFormControlsCollection),
    encoder: (value) => (value as BrowserHTMLFormControlsCollection)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'web.HTMLImageElement',
    decoder: (value) => BrowserHTMLImageElement(value as web.HTMLImageElement),
    encoder: (value) => (value as BrowserHTMLImageElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'web.HTMLAnchorElement',
    decoder: (value) => BrowserHTMLAnchorElement(value as web.HTMLAnchorElement),
    encoder: (value) => (value as BrowserHTMLAnchorElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'web.HTMLOptionElement',
    decoder: (value) => BrowserHTMLOptionElement(value as web.HTMLOptionElement),
    encoder: (value) => (value as BrowserHTMLOptionElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'web.HTMLSelectElement',
    decoder: (value) => BrowserHTMLSelectElement(value as web.HTMLSelectElement),
    encoder: (value) => (value as BrowserHTMLSelectElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'web.HTMLOptionsCollection',
    decoder: (value) => BrowserHTMLOptionsCollection(value as web.HTMLOptionsCollection),
    encoder: (value) => (value as BrowserHTMLOptionsCollection)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'web.HTMLTextAreaElement',
    decoder: (value) => BrowserHTMLTextAreaElement(value as web.HTMLTextAreaElement),
    encoder: (value) => (value as BrowserHTMLTextAreaElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'web.HTMLLabelElement',
    decoder: (value) => BrowserHTMLLabelElement(value as web.HTMLLabelElement),
    encoder: (value) => (value as BrowserHTMLLabelElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'web.HTMLInputElement',
    decoder: (value) => BrowserHTMLInputElement(value as web.HTMLInputElement),
    encoder: (value) => (value as BrowserHTMLInputElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'web.HTMLDataListElement',
    decoder: (value) => BrowserHTMLDataListElement(value as web.HTMLDataListElement),
    encoder: (value) => (value as BrowserHTMLDataListElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'web.HTMLButtonElement',
    decoder: (value) => BrowserHTMLButtonElement(value as web.HTMLButtonElement),
    encoder: (value) => (value as BrowserHTMLButtonElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'web.HTMLSpanElement',
    decoder: (value) => BrowserHTMLSpanElement(value as web.HTMLSpanElement),
    encoder: (value) => (value as BrowserHTMLSpanElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'web.HTMLDivElement',
    decoder: (value) => BrowserHTMLDivElement(value as web.HTMLDivElement),
    encoder: (value) => (value as BrowserHTMLDivElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'react.ReactCompositionEvent<web.EventTarget>',
    decoder: (value) => BrowserReactCompositionEvent(value as web.Event),
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'react.ReactSyntheticEvent<web.EventTarget>',
    decoder: (value) => BrowserReactSyntheticEvent(value as web.Event),
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'react.ReactTouchEvent<web.EventTarget>',
    decoder: (value) => BrowserReactTouchEvent(value as web.Event),
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'react.ReactPointerEvent<web.EventTarget>',
    decoder: (value) => BrowserReactPointerEvent(value as web.Event),
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'react.ReactWheelEvent<web.EventTarget>',
    decoder: (value) => BrowserReactWheelEvent(value as web.Event),
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'react.ReactDragEvent<web.EventTarget>',
    decoder: (value) => BrowserReactDragEvent(value as web.Event),
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'react.ReactFocusEvent<web.EventTarget>',
    decoder: (value) => BrowserReactFocusEvent(value as web.Event),
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'react.ReactKeyboardEvent<web.EventTarget>',
    decoder: (value) => BrowserReactKeyboardEvent(value as web.Event),
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'react.ReactFormEvent<web.EventTarget>',
    decoder: (value) => BrowserReactFormEvent(value as web.Event),
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'react.ReactChangeEvent<web.EventTarget>',
    decoder: (value) => BrowserReactChangeEvent(value as web.Event),
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'react.ReactInputEvent<web.EventTarget>',
    decoder: (value) => BrowserReactInputEvent(value as web.Event),
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'react.ReactMouseEvent<web.EventTarget>',
    decoder: (value) => BrowserReactMouseEvent(value as web.Event),
  );
}

