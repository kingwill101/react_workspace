// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: edit-context
// ignore_for_file: type=lint

abstract interface class CharacterBoundsUpdateEventInit {
  int? get rangeStart;
  set rangeStart(int? value);
  int? get rangeEnd;
  set rangeEnd(int? value);
}

final class CharacterBoundsUpdateEventInitValue
    implements CharacterBoundsUpdateEventInit {
  @override
  int? rangeStart;
  @override
  int? rangeEnd;

  CharacterBoundsUpdateEventInitValue({this.rangeStart, this.rangeEnd});
}

abstract interface class EditContextInit {
  String? get text;
  set text(String? value);
  int? get selectionStart;
  set selectionStart(int? value);
  int? get selectionEnd;
  set selectionEnd(int? value);
}

final class EditContextInitValue implements EditContextInit {
  @override
  String? text;
  @override
  int? selectionStart;
  @override
  int? selectionEnd;

  EditContextInitValue({this.text, this.selectionStart, this.selectionEnd});
}

abstract interface class TextFormatInit {
  int? get rangeStart;
  set rangeStart(int? value);
  int? get rangeEnd;
  set rangeEnd(int? value);
  UnderlineStyle? get underlineStyle;
  set underlineStyle(UnderlineStyle? value);
  UnderlineThickness? get underlineThickness;
  set underlineThickness(UnderlineThickness? value);
}

final class TextFormatInitValue implements TextFormatInit {
  @override
  int? rangeStart;
  @override
  int? rangeEnd;
  @override
  UnderlineStyle? underlineStyle;
  @override
  UnderlineThickness? underlineThickness;

  TextFormatInitValue({
    this.rangeStart,
    this.rangeEnd,
    this.underlineStyle,
    this.underlineThickness,
  });
}

abstract interface class TextFormatUpdateEventInit {
  List<Object>? get textFormats;
  set textFormats(List<Object>? value);
}

final class TextFormatUpdateEventInitValue
    implements TextFormatUpdateEventInit {
  @override
  List<Object>? textFormats;

  TextFormatUpdateEventInitValue({this.textFormats});
}

abstract interface class TextUpdateEventInit {
  int? get updateRangeStart;
  set updateRangeStart(int? value);
  int? get updateRangeEnd;
  set updateRangeEnd(int? value);
  String? get text;
  set text(String? value);
  int? get selectionStart;
  set selectionStart(int? value);
  int? get selectionEnd;
  set selectionEnd(int? value);
  int? get compositionStart;
  set compositionStart(int? value);
  int? get compositionEnd;
  set compositionEnd(int? value);
}

final class TextUpdateEventInitValue implements TextUpdateEventInit {
  @override
  int? updateRangeStart;
  @override
  int? updateRangeEnd;
  @override
  String? text;
  @override
  int? selectionStart;
  @override
  int? selectionEnd;
  @override
  int? compositionStart;
  @override
  int? compositionEnd;

  TextUpdateEventInitValue({
    this.updateRangeStart,
    this.updateRangeEnd,
    this.text,
    this.selectionStart,
    this.selectionEnd,
    this.compositionStart,
    this.compositionEnd,
  });
}

typedef UnderlineStyle = String;

typedef UnderlineThickness = String;
