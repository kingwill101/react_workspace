// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: edit-context
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'dom.dart';
import 'geometry.dart';
import 'cssom_view.dart';
import 'html.dart';

abstract interface class CharacterBoundsUpdateEvent {
  int get rangeStart;
  int get rangeEnd;
}

abstract interface class CharacterBoundsUpdateEventInit {
  int get rangeStart;
  set rangeStart(int value);
  int get rangeEnd;
  set rangeEnd(int value);
}

abstract interface class EditContext {
  void updateText(int rangeStart, int rangeEnd, String text);
  void updateSelection(int start, int end);
  void updateControlBounds(DOMRect controlBounds);
  void updateSelectionBounds(DOMRect selectionBounds);
  void updateCharacterBounds(int rangeStart, List<DOMRect> characterBounds);
  List<HTMLElement> attachedElements();
  String get text;
  int get selectionStart;
  int get selectionEnd;
  int get characterBoundsRangeStart;
  List<DOMRect> characterBounds();
  EventHandler get ontextupdate;
   set ontextupdate(EventHandler value);
  EventHandler get ontextformatupdate;
   set ontextformatupdate(EventHandler value);
  EventHandler get oncharacterboundsupdate;
   set oncharacterboundsupdate(EventHandler value);
  EventHandler get oncompositionstart;
   set oncompositionstart(EventHandler value);
  EventHandler get oncompositionend;
   set oncompositionend(EventHandler value);
}

abstract interface class EditContextInit {
  String get text;
  set text(String value);
  int get selectionStart;
  set selectionStart(int value);
  int get selectionEnd;
  set selectionEnd(int value);
}

abstract interface class TextFormat {
  int get rangeStart;
  int get rangeEnd;
  UnderlineStyle get underlineStyle;
  UnderlineThickness get underlineThickness;
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

abstract interface class TextFormatUpdateEvent {
  List<TextFormat> getTextFormats();
}

abstract interface class TextFormatUpdateEventInit {
  List<TextFormat> get textFormats;
  set textFormats(List<TextFormat> value);
}

abstract interface class TextUpdateEvent {
  int get updateRangeStart;
  int get updateRangeEnd;
  String get text;
  int get selectionStart;
  int get selectionEnd;
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

