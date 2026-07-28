/// Neutral React event interfaces — pure Dart, no browser dependencies.
///
/// These abstract interfaces correspond to React synthetic events with typed
/// `currentTarget` and `nativeEvent`.  The browser adapter provides concrete
/// implementations backed by `package:web`.  The SSR renderer uses these
/// interfaces for type-checking only — it never constructs or invokes events.

import 'types/html.dart';

abstract interface class ReactSyntheticEvent<T extends WebEventTarget> {
  T get currentTarget;
  WebEventTarget get target;
  bool get bubbles;
  bool get cancelable;
  bool get defaultPrevented;
  void preventDefault();
  void stopPropagation();
}

abstract interface class ReactMouseEvent<T extends WebEventTarget>
    implements ReactSyntheticEvent<T> {
  double get clientX;
  double get clientY;
  int get button;
  bool get altKey;
  bool get ctrlKey;
  bool get shiftKey;
}

abstract interface class ReactInputEvent<T extends WebEventTarget>
    implements ReactSyntheticEvent<T> {
  String get data;
}

abstract interface class ReactChangeEvent<T extends WebEventTarget>
    implements ReactSyntheticEvent<T> {}

abstract interface class ReactFormEvent<T extends WebEventTarget>
    implements ReactSyntheticEvent<T> {}

abstract interface class ReactKeyboardEvent<T extends WebEventTarget>
    implements ReactSyntheticEvent<T> {
  String get key;
  int get keyCode;
  bool get altKey;
  bool get ctrlKey;
  bool get shiftKey;
}

abstract interface class ReactFocusEvent<T extends WebEventTarget>
    implements ReactSyntheticEvent<T> {
  WebEventTarget? get relatedTarget;
}
