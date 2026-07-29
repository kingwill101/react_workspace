/// Neutral React event interfaces — generated from neutral_web_model.json
///
/// These abstract interfaces correspond to React synthetic events.

import 'types/html_interfaces.dart';

abstract interface class ReactSyntheticEvent<T extends WebEventTarget> {
  T get currentTarget;
  WebEventTarget get target;
  bool get bubbles;
  bool get cancelable;
  bool get defaultPrevented;
  void preventDefault();
  void stopPropagation();
}


abstract interface class ReactCompositionEvent<T extends WebEventTarget> implements ReactSyntheticEvent<T> {
}


abstract interface class ReactTouchEvent<T extends WebEventTarget> implements ReactSyntheticEvent<T> {
}


abstract interface class ReactPointerEvent<T extends WebEventTarget> implements ReactSyntheticEvent<T> {
}


abstract interface class ReactWheelEvent<T extends WebEventTarget> implements ReactSyntheticEvent<T> {
}


abstract interface class ReactDragEvent<T extends WebEventTarget> implements ReactSyntheticEvent<T> {
}


abstract interface class ReactFocusEvent<T extends WebEventTarget> implements ReactSyntheticEvent<T> {
  WebEventTarget? get relatedTarget;
}


abstract interface class ReactKeyboardEvent<T extends WebEventTarget> implements ReactSyntheticEvent<T> {
  String get key;
  int get keyCode;
  bool get altKey;
  bool get ctrlKey;
  bool get shiftKey;
}


abstract interface class ReactFormEvent<T extends WebEventTarget> implements ReactSyntheticEvent<T> {
}


abstract interface class ReactChangeEvent<T extends WebEventTarget> implements ReactSyntheticEvent<T> {
}


abstract interface class ReactInputEvent<T extends WebEventTarget> implements ReactSyntheticEvent<T> {
  String get data;
}


abstract interface class ReactMouseEvent<T extends WebEventTarget> implements ReactSyntheticEvent<T> {
  double get clientX;
  double get clientY;
  int get button;
  bool get altKey;
  bool get ctrlKey;
  bool get shiftKey;
}


