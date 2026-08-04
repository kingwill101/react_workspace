// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: css-fonts
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import


abstract interface class CSSFontFeatureValuesMap {
   Iterable<Object> get keys;
   Iterable<List<int>> get values;
   Iterable<MapEntry<Object, List<int>>> get entries;
   List<int>? operator [](Object key);
   bool has(Object key);
  void set_(Object featureValueName, Object values);
}

abstract interface class CSSFontFeatureValuesRule {
  Object get fontFamily;
   set fontFamily(Object value);
  CSSFontFeatureValuesMap get annotation;
  CSSFontFeatureValuesMap get ornaments;
  CSSFontFeatureValuesMap get stylistic;
  CSSFontFeatureValuesMap get swash;
  CSSFontFeatureValuesMap get characterVariant;
  CSSFontFeatureValuesMap get styleset;
  CSSFontFeatureValuesMap get historicalForms;
}

abstract interface class CSSFontPaletteValuesRule {
  Object get name;
  Object get fontFamily;
  Object get basePalette;
  Object get overrideColors;
}

