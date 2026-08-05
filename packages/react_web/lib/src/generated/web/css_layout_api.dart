// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: css-layout-api
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import


typedef BlockFragmentationType = String;

abstract interface class BreakTokenOptions {
  List<Object> get childBreakTokens;
  set childBreakTokens(List<Object> value);
  Object get data;
  set data(Object value);
}

typedef BreakType = String;

typedef ChildDisplayType = String;

abstract interface class FragmentResultOptions {
  double get inlineSize;
  set inlineSize(double value);
  double get blockSize;
  set blockSize(double value);
  double get autoBlockSize;
  set autoBlockSize(double value);
  List<Object> get childFragments;
  set childFragments(List<Object> value);
  Object get data;
  set data(Object value);
  BreakTokenOptions get breakToken;
  set breakToken(BreakTokenOptions value);
}

abstract interface class IntrinsicSizesResultOptions {
  double get maxContentSize;
  set maxContentSize(double value);
  double get minContentSize;
  set minContentSize(double value);
}

abstract interface class LayoutConstraintsOptions {
  double get availableInlineSize;
  set availableInlineSize(double value);
  double get availableBlockSize;
  set availableBlockSize(double value);
  double get fixedInlineSize;
  set fixedInlineSize(double value);
  double get fixedBlockSize;
  set fixedBlockSize(double value);
  double get percentageInlineSize;
  set percentageInlineSize(double value);
  double get percentageBlockSize;
  set percentageBlockSize(double value);
  double get blockFragmentationOffset;
  set blockFragmentationOffset(double value);
  BlockFragmentationType get blockFragmentationType;
  set blockFragmentationType(BlockFragmentationType value);
  Object get data;
  set data(Object value);
}

abstract interface class LayoutOptions {
  ChildDisplayType get childDisplay;
  set childDisplay(ChildDisplayType value);
  LayoutSizingMode get sizing;
  set sizing(LayoutSizingMode value);
}

typedef LayoutSizingMode = String;

