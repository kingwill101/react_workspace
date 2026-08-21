import 'dart:collection';

/// Builds a space-separated CSS class string from strings, iterables, and
/// condition maps.
///
/// Empty strings and false map entries are omitted. Class names are de-duped
/// while preserving their first-seen order.
String classNames(
  Object? first, [
  Object? second,
  Object? third,
  Object? fourth,
  Object? fifth,
  Object? sixth,
  Object? seventh,
  Object? eighth,
]) {
  final names = <String>{};

  void append(Object? value) {
    switch (value) {
      case null || false:
        return;
      case String():
        for (final name in value.split(RegExp(r'\s+'))) {
          if (name.isNotEmpty) names.add(name);
        }
      case Iterable<Object?>():
        for (final nested in value) {
          append(nested);
        }
      case Map<Object?, Object?>():
        for (final entry in value.entries) {
          if (entry.value == true) append(entry.key);
        }
      default:
        throw ArgumentError.value(
          value,
          'className',
          'Expected a String, Iterable, condition Map, false, or null.',
        );
    }
  }

  for (final value in [
    first,
    second,
    third,
    fourth,
    fifth,
    sixth,
    seventh,
    eighth,
  ]) {
    append(value);
  }
  return names.join(' ');
}

/// A React-compatible inline style map with typed common properties and an
/// escape hatch for CSS custom properties and newly introduced properties.
final class CssStyle extends MapBase<String, Object?> {
  CssStyle({
    Object? display,
    Object? position,
    Object? top,
    Object? right,
    Object? bottom,
    Object? left,
    Object? width,
    Object? minWidth,
    Object? maxWidth,
    Object? height,
    Object? minHeight,
    Object? maxHeight,
    Object? margin,
    Object? marginTop,
    Object? marginRight,
    Object? marginBottom,
    Object? marginLeft,
    Object? padding,
    Object? paddingTop,
    Object? paddingRight,
    Object? paddingBottom,
    Object? paddingLeft,
    Object? color,
    Object? background,
    Object? backgroundColor,
    Object? fontFamily,
    Object? fontSize,
    Object? fontWeight,
    Object? lineHeight,
    Object? textAlign,
    Object? gap,
    Object? flex,
    Object? flexDirection,
    Object? alignItems,
    Object? justifyContent,
    Object? border,
    Object? borderRadius,
    Object? boxShadow,
    Object? cursor,
    Object? opacity,
    Object? overflow,
    Map<String, Object?> additionalProperties = const {},
  }) {
    _set('display', display);
    _set('position', position);
    _set('top', top);
    _set('right', right);
    _set('bottom', bottom);
    _set('left', left);
    _set('width', width);
    _set('minWidth', minWidth);
    _set('maxWidth', maxWidth);
    _set('height', height);
    _set('minHeight', minHeight);
    _set('maxHeight', maxHeight);
    _set('margin', margin);
    _set('marginTop', marginTop);
    _set('marginRight', marginRight);
    _set('marginBottom', marginBottom);
    _set('marginLeft', marginLeft);
    _set('padding', padding);
    _set('paddingTop', paddingTop);
    _set('paddingRight', paddingRight);
    _set('paddingBottom', paddingBottom);
    _set('paddingLeft', paddingLeft);
    _set('color', color);
    _set('background', background);
    _set('backgroundColor', backgroundColor);
    _set('fontFamily', fontFamily);
    _set('fontSize', fontSize);
    _set('fontWeight', fontWeight);
    _set('lineHeight', lineHeight);
    _set('textAlign', textAlign);
    _set('gap', gap);
    _set('flex', flex);
    _set('flexDirection', flexDirection);
    _set('alignItems', alignItems);
    _set('justifyContent', justifyContent);
    _set('border', border);
    _set('borderRadius', borderRadius);
    _set('boxShadow', boxShadow);
    _set('cursor', cursor);
    _set('opacity', opacity);
    _set('overflow', overflow);
    _values.addAll(additionalProperties);
  }

  final Map<String, Object?> _values = {};

  void _set(String property, Object? value) {
    if (value != null) _values[property] = value;
  }

  /// Sets a CSS property, including custom properties such as `--accent`.
  CssStyle custom(String property, Object? value) {
    if (value == null) {
      _values.remove(property);
    } else {
      _values[property] = value;
    }
    return this;
  }

  @override
  Object? operator [](Object? key) => _values[key];

  @override
  void operator []=(String key, Object? value) => custom(key, value);

  @override
  void clear() => _values.clear();

  @override
  Iterable<String> get keys => _values.keys;

  @override
  Object? remove(Object? key) => _values.remove(key);
}

/// Creates a React-compatible inline style map.
CssStyle css({
  Object? display,
  Object? position,
  Object? top,
  Object? right,
  Object? bottom,
  Object? left,
  Object? width,
  Object? minWidth,
  Object? maxWidth,
  Object? height,
  Object? minHeight,
  Object? maxHeight,
  Object? margin,
  Object? marginTop,
  Object? marginRight,
  Object? marginBottom,
  Object? marginLeft,
  Object? padding,
  Object? paddingTop,
  Object? paddingRight,
  Object? paddingBottom,
  Object? paddingLeft,
  Object? color,
  Object? background,
  Object? backgroundColor,
  Object? fontFamily,
  Object? fontSize,
  Object? fontWeight,
  Object? lineHeight,
  Object? textAlign,
  Object? gap,
  Object? flex,
  Object? flexDirection,
  Object? alignItems,
  Object? justifyContent,
  Object? border,
  Object? borderRadius,
  Object? boxShadow,
  Object? cursor,
  Object? opacity,
  Object? overflow,
  Map<String, Object?> additionalProperties = const {},
}) => CssStyle(
  display: display,
  position: position,
  top: top,
  right: right,
  bottom: bottom,
  left: left,
  width: width,
  minWidth: minWidth,
  maxWidth: maxWidth,
  height: height,
  minHeight: minHeight,
  maxHeight: maxHeight,
  margin: margin,
  marginTop: marginTop,
  marginRight: marginRight,
  marginBottom: marginBottom,
  marginLeft: marginLeft,
  padding: padding,
  paddingTop: paddingTop,
  paddingRight: paddingRight,
  paddingBottom: paddingBottom,
  paddingLeft: paddingLeft,
  color: color,
  background: background,
  backgroundColor: backgroundColor,
  fontFamily: fontFamily,
  fontSize: fontSize,
  fontWeight: fontWeight,
  lineHeight: lineHeight,
  textAlign: textAlign,
  gap: gap,
  flex: flex,
  flexDirection: flexDirection,
  alignItems: alignItems,
  justifyContent: justifyContent,
  border: border,
  borderRadius: borderRadius,
  boxShadow: boxShadow,
  cursor: cursor,
  opacity: opacity,
  overflow: overflow,
  additionalProperties: additionalProperties,
);

/// Builds common `aria-*` properties for a host factory's
/// `additionalProps` map.
Map<String, Object?> aria({
  String? label,
  String? labelledBy,
  String? describedBy,
  String? controls,
  String? current,
  String? live,
  String? roleDescription,
  bool? atomic,
  bool? busy,
  bool? checked,
  bool? disabled,
  bool? expanded,
  bool? hidden,
  bool? modal,
  bool? pressed,
  bool? readonly,
  bool? required,
  bool? selected,
  Map<String, Object?> additionalAttributes = const {},
}) => {
  'aria-label': ?label,
  'aria-labelledby': ?labelledBy,
  'aria-describedby': ?describedBy,
  'aria-controls': ?controls,
  'aria-current': ?current,
  'aria-live': ?live,
  'aria-roledescription': ?roleDescription,
  'aria-atomic': ?atomic,
  'aria-busy': ?busy,
  'aria-checked': ?checked,
  'aria-disabled': ?disabled,
  'aria-expanded': ?expanded,
  'aria-hidden': ?hidden,
  'aria-modal': ?modal,
  'aria-pressed': ?pressed,
  'aria-readonly': ?readonly,
  'aria-required': ?required,
  'aria-selected': ?selected,
  for (final entry in additionalAttributes.entries)
    entry.key.startsWith('aria-') ? entry.key : 'aria-${entry.key}':
        entry.value,
};

/// Prefixes application values for a host factory's `additionalProps` map.
Map<String, Object?> dataAttributes(Map<String, Object?> attributes) => {
  for (final entry in attributes.entries)
    entry.key.startsWith('data-') ? entry.key : 'data-${entry.key}':
        entry.value,
};
