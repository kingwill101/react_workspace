import '../model/model.dart';

Map<String, InterfaceDecl> reactEventInterfaces() => {
  'ReactSyntheticEvent': const InterfaceDecl(
    typeId: 'react.ReactSyntheticEvent',
    name: 'ReactSyntheticEvent',
    typeParameters: [
      TypeParameterDecl(
        name: 'T',
        bound: NamedTypeRef(typeId: 'web.WebEventTarget'),
      ),
    ],
    members: [
      AttributeDecl(
        name: 'currentTarget',
        type: TypeParameterRef(name: 'T'),
      ),
      AttributeDecl(
        name: 'target',
        type: NamedTypeRef(typeId: 'web.WebEventTarget'),
      ),
      AttributeDecl(
        name: 'bubbles',
        type: NamedTypeRef(typeId: 'core.bool'),
      ),
      AttributeDecl(
        name: 'cancelable',
        type: NamedTypeRef(typeId: 'core.bool'),
      ),
      AttributeDecl(
        name: 'defaultPrevented',
        type: NamedTypeRef(typeId: 'core.bool'),
      ),
      OperationDecl(
        name: 'preventDefault',
        returnType: NamedTypeRef(typeId: 'core.void'),
      ),
      OperationDecl(
        name: 'stopPropagation',
        returnType: NamedTypeRef(typeId: 'core.void'),
      ),
    ],
  ),
  'ReactMouseEvent': const InterfaceDecl(
    typeId: 'react.ReactMouseEvent',
    name: 'ReactMouseEvent',
    typeParameters: [
      TypeParameterDecl(
        name: 'T',
        bound: NamedTypeRef(typeId: 'web.WebEventTarget'),
      ),
    ],
    extends_: [
      NamedTypeRef(
        typeId: 'react.ReactSyntheticEvent',
        arguments: [TypeParameterRef(name: 'T')],
      ),
    ],
    members: [
      AttributeDecl(
        name: 'clientX',
        type: NamedTypeRef(typeId: 'core.double'),
      ),
      AttributeDecl(
        name: 'clientY',
        type: NamedTypeRef(typeId: 'core.double'),
      ),
      AttributeDecl(
        name: 'button',
        type: NamedTypeRef(typeId: 'core.int'),
      ),
      AttributeDecl(
        name: 'altKey',
        type: NamedTypeRef(typeId: 'core.bool'),
      ),
      AttributeDecl(
        name: 'ctrlKey',
        type: NamedTypeRef(typeId: 'core.bool'),
      ),
      AttributeDecl(
        name: 'shiftKey',
        type: NamedTypeRef(typeId: 'core.bool'),
      ),
    ],
  ),
  'ReactInputEvent': const InterfaceDecl(
    typeId: 'react.ReactInputEvent',
    name: 'ReactInputEvent',
    typeParameters: [
      TypeParameterDecl(
        name: 'T',
        bound: NamedTypeRef(typeId: 'web.WebEventTarget'),
      ),
    ],
    extends_: [
      NamedTypeRef(
        typeId: 'react.ReactSyntheticEvent',
        arguments: [TypeParameterRef(name: 'T')],
      ),
    ],
    members: [
      AttributeDecl(
        name: 'data',
        type: NamedTypeRef(typeId: 'core.String'),
      ),
    ],
  ),
  'ReactChangeEvent': const InterfaceDecl(
    typeId: 'react.ReactChangeEvent',
    name: 'ReactChangeEvent',
    typeParameters: [
      TypeParameterDecl(
        name: 'T',
        bound: NamedTypeRef(typeId: 'web.WebEventTarget'),
      ),
    ],
    extends_: [
      NamedTypeRef(
        typeId: 'react.ReactSyntheticEvent',
        arguments: [TypeParameterRef(name: 'T')],
      ),
    ],
  ),
  'ReactFormEvent': const InterfaceDecl(
    typeId: 'react.ReactFormEvent',
    name: 'ReactFormEvent',
    typeParameters: [
      TypeParameterDecl(
        name: 'T',
        bound: NamedTypeRef(typeId: 'web.WebEventTarget'),
      ),
    ],
    extends_: [
      NamedTypeRef(
        typeId: 'react.ReactSyntheticEvent',
        arguments: [TypeParameterRef(name: 'T')],
      ),
    ],
  ),
  'ReactKeyboardEvent': const InterfaceDecl(
    typeId: 'react.ReactKeyboardEvent',
    name: 'ReactKeyboardEvent',
    typeParameters: [
      TypeParameterDecl(
        name: 'T',
        bound: NamedTypeRef(typeId: 'web.WebEventTarget'),
      ),
    ],
    extends_: [
      NamedTypeRef(
        typeId: 'react.ReactSyntheticEvent',
        arguments: [TypeParameterRef(name: 'T')],
      ),
    ],
    members: [
      AttributeDecl(
        name: 'key',
        type: NamedTypeRef(typeId: 'core.String'),
      ),
      AttributeDecl(
        name: 'keyCode',
        type: NamedTypeRef(typeId: 'core.int'),
      ),
      AttributeDecl(
        name: 'altKey',
        type: NamedTypeRef(typeId: 'core.bool'),
      ),
      AttributeDecl(
        name: 'ctrlKey',
        type: NamedTypeRef(typeId: 'core.bool'),
      ),
      AttributeDecl(
        name: 'shiftKey',
        type: NamedTypeRef(typeId: 'core.bool'),
      ),
    ],
  ),
  'ReactFocusEvent': const InterfaceDecl(
    typeId: 'react.ReactFocusEvent',
    name: 'ReactFocusEvent',
    typeParameters: [
      TypeParameterDecl(
        name: 'T',
        bound: NamedTypeRef(typeId: 'web.WebEventTarget'),
      ),
    ],
    extends_: [
      NamedTypeRef(
        typeId: 'react.ReactSyntheticEvent',
        arguments: [TypeParameterRef(name: 'T')],
      ),
    ],
    members: [
      AttributeDecl(
        name: 'relatedTarget',
        type: NamedTypeRef(typeId: 'web.WebEventTarget', nullable: true),
      ),
    ],
  ),
  'ReactDragEvent': const InterfaceDecl(
    typeId: 'react.ReactDragEvent',
    name: 'ReactDragEvent',
    typeParameters: [
      TypeParameterDecl(
        name: 'T',
        bound: NamedTypeRef(typeId: 'web.WebEventTarget'),
      ),
    ],
    extends_: [
      NamedTypeRef(
        typeId: 'react.ReactSyntheticEvent',
        arguments: [TypeParameterRef(name: 'T')],
      ),
    ],
  ),
  'ReactWheelEvent': const InterfaceDecl(
    typeId: 'react.ReactWheelEvent',
    name: 'ReactWheelEvent',
    typeParameters: [
      TypeParameterDecl(
        name: 'T',
        bound: NamedTypeRef(typeId: 'web.WebEventTarget'),
      ),
    ],
    extends_: [
      NamedTypeRef(
        typeId: 'react.ReactSyntheticEvent',
        arguments: [TypeParameterRef(name: 'T')],
      ),
    ],
  ),
  'ReactPointerEvent': const InterfaceDecl(
    typeId: 'react.ReactPointerEvent',
    name: 'ReactPointerEvent',
    typeParameters: [
      TypeParameterDecl(
        name: 'T',
        bound: NamedTypeRef(typeId: 'web.WebEventTarget'),
      ),
    ],
    extends_: [
      NamedTypeRef(
        typeId: 'react.ReactSyntheticEvent',
        arguments: [TypeParameterRef(name: 'T')],
      ),
    ],
  ),
  'ReactTouchEvent': const InterfaceDecl(
    typeId: 'react.ReactTouchEvent',
    name: 'ReactTouchEvent',
    typeParameters: [
      TypeParameterDecl(
        name: 'T',
        bound: NamedTypeRef(typeId: 'web.WebEventTarget'),
      ),
    ],
    extends_: [
      NamedTypeRef(
        typeId: 'react.ReactSyntheticEvent',
        arguments: [TypeParameterRef(name: 'T')],
      ),
    ],
  ),
  'ReactCompositionEvent': const InterfaceDecl(
    typeId: 'react.ReactCompositionEvent',
    name: 'ReactCompositionEvent',
    typeParameters: [
      TypeParameterDecl(
        name: 'T',
        bound: NamedTypeRef(typeId: 'web.WebEventTarget'),
      ),
    ],
    extends_: [
      NamedTypeRef(
        typeId: 'react.ReactSyntheticEvent',
        arguments: [TypeParameterRef(name: 'T')],
      ),
    ],
  ),
};
