/// Neutral React event interfaces — generated from neutral_web_model.json
///
/// These abstract interfaces correspond to React synthetic events.
library;

import 'html_interfaces.dart';

abstract interface class ReactSyntheticEvent<T extends EventTarget> {
  T get currentTarget;
  EventTarget get target;
  bool get bubbles;
  bool get cancelable;
  bool get defaultPrevented;
  void preventDefault();
  void stopPropagation();
}

abstract interface class ReactCompositionEvent<T extends EventTarget>
    implements ReactSyntheticEvent<T> {}

abstract interface class ReactTouchEvent<T extends EventTarget>
    implements ReactSyntheticEvent<T> {}

abstract interface class ReactPointerEvent<T extends EventTarget>
    implements ReactSyntheticEvent<T> {}

abstract interface class ReactWheelEvent<T extends EventTarget>
    implements ReactSyntheticEvent<T> {}

abstract interface class ReactDragEvent<T extends EventTarget>
    implements ReactSyntheticEvent<T> {}

abstract interface class ReactFocusEvent<T extends EventTarget>
    implements ReactSyntheticEvent<T> {
  EventTarget? get relatedTarget;
}

abstract interface class ReactKeyboardEvent<T extends EventTarget>
    implements ReactSyntheticEvent<T> {
  String get key;
  int get keyCode;
  bool get altKey;
  bool get ctrlKey;
  bool get shiftKey;
}

abstract interface class ReactFormEvent<T extends EventTarget>
    implements ReactSyntheticEvent<T> {}

abstract interface class ReactChangeEvent<T extends EventTarget>
    implements ReactSyntheticEvent<T> {}

abstract interface class ReactInputEvent<T extends EventTarget>
    implements ReactSyntheticEvent<T> {
  String get data;
}

abstract interface class ReactMouseEvent<T extends EventTarget>
    implements ReactSyntheticEvent<T> {
  double get clientX;
  double get clientY;
  int get button;
  bool get altKey;
  bool get ctrlKey;
  bool get shiftKey;
}
