/// Authored definitions of the React synthetic event surface.
///
/// React synthetic events are React-specific (not part of the Web IDL
/// snapshot), so they are authored once here and consumed by both the surface
/// emitter (`react_events.dart`) and the browser adapter emitter (wrappers).
/// DOM types such as `EventTarget` resolve to the complete neutral surface.
library;

final class ReactEventDef {
  final String name;
  final List<String> implements_;
  final List<ReactEventMember> members;
  final List<ReactEventMember> methods;

  const ReactEventDef({
    required this.name,
    this.implements_ = const [],
    this.members = const [],
    this.methods = const [],
  });
}

final class ReactEventMember {
  final String name;
  final String returnType;

  const ReactEventMember(this.name, this.returnType);
}

const reactEventDefs = <ReactEventDef>[
  ReactEventDef(
    name: 'ReactSyntheticEvent',
    members: [
      ReactEventMember('currentTarget', 'T'),
      ReactEventMember('target', 'EventTarget'),
      ReactEventMember('bubbles', 'bool'),
      ReactEventMember('cancelable', 'bool'),
      ReactEventMember('defaultPrevented', 'bool'),
    ],
    methods: [
      ReactEventMember('preventDefault', 'void'),
      ReactEventMember('stopPropagation', 'void'),
    ],
  ),
  ReactEventDef(
    name: 'ReactCompositionEvent',
    implements_: ['ReactSyntheticEvent<T>'],
  ),
  ReactEventDef(
    name: 'ReactTouchEvent',
    implements_: ['ReactSyntheticEvent<T>'],
  ),
  ReactEventDef(
    name: 'ReactPointerEvent',
    implements_: ['ReactSyntheticEvent<T>'],
  ),
  ReactEventDef(
    name: 'ReactWheelEvent',
    implements_: ['ReactSyntheticEvent<T>'],
  ),
  ReactEventDef(
    name: 'ReactDragEvent',
    implements_: ['ReactSyntheticEvent<T>'],
  ),
  ReactEventDef(
    name: 'ReactFocusEvent',
    implements_: ['ReactSyntheticEvent<T>'],
    members: [ReactEventMember('relatedTarget', 'EventTarget?')],
  ),
  ReactEventDef(
    name: 'ReactKeyboardEvent',
    implements_: ['ReactSyntheticEvent<T>'],
    members: [
      ReactEventMember('key', 'String'),
      ReactEventMember('keyCode', 'int'),
      ReactEventMember('altKey', 'bool'),
      ReactEventMember('ctrlKey', 'bool'),
      ReactEventMember('shiftKey', 'bool'),
    ],
  ),
  ReactEventDef(
    name: 'ReactFormEvent',
    implements_: ['ReactSyntheticEvent<T>'],
  ),
  ReactEventDef(
    name: 'ReactChangeEvent',
    implements_: ['ReactSyntheticEvent<T>'],
  ),
  ReactEventDef(
    name: 'ReactInputEvent',
    implements_: ['ReactSyntheticEvent<T>'],
    members: [ReactEventMember('data', 'String')],
  ),
  ReactEventDef(
    name: 'ReactMouseEvent',
    implements_: ['ReactSyntheticEvent<T>'],
    members: [
      ReactEventMember('clientX', 'double'),
      ReactEventMember('clientY', 'double'),
      ReactEventMember('button', 'int'),
      ReactEventMember('altKey', 'bool'),
      ReactEventMember('ctrlKey', 'bool'),
      ReactEventMember('shiftKey', 'bool'),
    ],
  ),
];
