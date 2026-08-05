import 'dart:core';

sealed class ReactTypeRef {
  const ReactTypeRef();
}

/// A host-platform type owned by a renderer adapter (e.g. `react_web`).
///
/// [hostNamespace] identifies the adapter (e.g. `'web'`).
/// [typeId] is the canonical name registered in [ReactCodecRegistry] (e.g.
/// `'ReactChangeEvent'`, `'HTMLInputElement'`).
final class HostTypeRef extends ReactTypeRef {
  final String hostNamespace;
  final String typeId;
  final bool nullable;

  const HostTypeRef({
    required this.hostNamespace,
    required this.typeId,
    this.nullable = false,
  });
}

final class NamedTypeRef extends ReactTypeRef {
  final String symbol;
  final Uri? import;
  final List<ReactTypeRef> typeArguments;
  final bool nullable;

  const NamedTypeRef({
    required this.symbol,
    this.import,
    this.typeArguments = const [],
    this.nullable = false,
  });
}

final class FunctionTypeRef extends ReactTypeRef {
  final List<FunctionParameterRef> positional;
  final List<FunctionParameterRef> named;
  final ReactTypeRef result;
  final bool nullable;
  final bool asynchronous;

  const FunctionTypeRef({
    this.positional = const [],
    this.named = const [],
    required this.result,
    this.nullable = false,
    this.asynchronous = false,
  });
}

final class RecordTypeRef extends ReactTypeRef {
  final List<RecordFieldRef> positional;
  final List<RecordFieldRef> named;
  final bool nullable;

  const RecordTypeRef({
    this.positional = const [],
    this.named = const [],
    this.nullable = false,
  });
}

final class RecordFieldRef {
  final String name;
  final ReactTypeRef type;

  const RecordFieldRef({required this.name, required this.type});
}

final class FunctionParameterRef {
  final String name;
  final ReactTypeRef type;
  final bool named;
  final bool required;

  const FunctionParameterRef({
    required this.name,
    required this.type,
    this.named = false,
    this.required = true,
  });
}

abstract final class ReactTypes {
  static const string = NamedTypeRef(symbol: 'String');
  static const integer = NamedTypeRef(symbol: 'int');
  static const number = NamedTypeRef(symbol: 'num');
  static const boolean = NamedTypeRef(symbol: 'bool');
  static const reactNode = NamedTypeRef(symbol: 'ReactNode');
  static const voidType = NamedTypeRef(symbol: 'void');
  static const dynamicType = NamedTypeRef(symbol: 'dynamic');

  /// Known `react_web` host types: element name → (hostNamespace, typeId).
  ///
  /// The type-reader uses this table to recognise `react_web` types declared
  /// in user props and emit [HostTypeRef] so the codegen generates correct
  /// `hostValue` codec calls instead of falling back to raw `.toJS`.
  static const Map<String, (String, String)> webHostTypes = {
    // Synthetic React event wrappers
    'ReactSyntheticEvent': ('web', 'ReactSyntheticEvent'),
    'ReactChangeEvent':    ('web', 'ReactChangeEvent'),
    'ReactInputEvent':     ('web', 'ReactInputEvent'),
    'ReactMouseEvent':     ('web', 'ReactMouseEvent'),
    'ReactKeyboardEvent':  ('web', 'ReactKeyboardEvent'),
    'ReactFocusEvent':     ('web', 'ReactFocusEvent'),
    'ReactFormEvent':      ('web', 'ReactFormEvent'),
    'ReactDragEvent':      ('web', 'ReactDragEvent'),
    'ReactWheelEvent':     ('web', 'ReactWheelEvent'),
    'ReactPointerEvent':   ('web', 'ReactPointerEvent'),
    'ReactTouchEvent':     ('web', 'ReactTouchEvent'),
    'ReactCompositionEvent': ('web', 'ReactCompositionEvent'),
    // HTML element types
    'HTMLElement':          ('web', 'HTMLElement'),
    'HTMLInputElement':     ('web', 'HTMLInputElement'),
    'HTMLSelectElement':    ('web', 'HTMLSelectElement'),
    'HTMLTextAreaElement':  ('web', 'HTMLTextAreaElement'),
    'HTMLButtonElement':    ('web', 'HTMLButtonElement'),
    'HTMLAnchorElement':    ('web', 'HTMLAnchorElement'),
    'HTMLFormElement':      ('web', 'HTMLFormElement'),
    'HTMLImageElement':     ('web', 'HTMLImageElement'),
    'HTMLVideoElement':     ('web', 'HTMLVideoElement'),
    'HTMLCanvasElement':    ('web', 'HTMLCanvasElement'),
    'HTMLDivElement':       ('web', 'HTMLDivElement'),
    'HTMLSpanElement':      ('web', 'HTMLSpanElement'),
    // General DOM / event
    'EventTarget':          ('web', 'EventTarget'),
    'Element':              ('web', 'Element'),
    'Event':                ('web', 'Event'),
    'Node':                 ('web', 'Node'),
  };
}
