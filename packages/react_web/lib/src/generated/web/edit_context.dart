// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: edit-context
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'dom.dart';

abstract interface class CharacterBoundsUpdateEventInit {
  int get rangeStart;
  set rangeStart(int value);
  int get rangeEnd;
  set rangeEnd(int value);
}

abstract interface class EditContextInit {
  String get text;
  set text(String value);
  int get selectionStart;
  set selectionStart(int value);
  int get selectionEnd;
  set selectionEnd(int value);
}

abstract interface class TextFormatInit {
  int get rangeStart;
  set rangeStart(int value);
  int get rangeEnd;
  set rangeEnd(int value);
  UnderlineStyle get underlineStyle;
  set underlineStyle(UnderlineStyle value);
  UnderlineThickness get underlineThickness;
  set underlineThickness(UnderlineThickness value);
}

abstract interface class TextFormatUpdateEventInit {
  List<Object> get textFormats;
  set textFormats(List<Object> value);
}

abstract interface class TextUpdateEventInit {
  int get updateRangeStart;
  set updateRangeStart(int value);
  int get updateRangeEnd;
  set updateRangeEnd(int value);
  String get text;
  set text(String value);
  int get selectionStart;
  set selectionStart(int value);
  int get selectionEnd;
  set selectionEnd(int value);
  int get compositionStart;
  set compositionStart(int value);
  int get compositionEnd;
  set compositionEnd(int value);
}

typedef UnderlineStyle = String;

typedef UnderlineThickness = String;

