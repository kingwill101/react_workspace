// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: css-layout-api
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'css_typed_om.dart';
import 'webidl.dart';

typedef BlockFragmentationType = String;

abstract interface class BreakToken {
  List<ChildBreakToken> get childBreakTokens;
  Object get data;
}

abstract interface class BreakTokenOptions {
  List<ChildBreakToken> get childBreakTokens;
  set childBreakTokens(List<ChildBreakToken> value);
  Object get data;
  set data(Object value);
}

typedef BreakType = String;

abstract interface class ChildBreakToken {
  BreakType get breakType;
  LayoutChild get child;
}

typedef ChildDisplayType = String;

abstract interface class FragmentResult {
  double get inlineSize;
  double get blockSize;
}

abstract interface class FragmentResultOptions {
  double get inlineSize;
  set inlineSize(double value);
  double get blockSize;
  set blockSize(double value);
  double get autoBlockSize;
  set autoBlockSize(double value);
  List<LayoutFragment> get childFragments;
  set childFragments(List<LayoutFragment> value);
  Object get data;
  set data(Object value);
  BreakTokenOptions get breakToken;
  set breakToken(BreakTokenOptions value);
}

abstract interface class IntrinsicSizes {
  double get minContentSize;
  double get maxContentSize;
}

abstract interface class IntrinsicSizesResultOptions {
  double get maxContentSize;
  set maxContentSize(double value);
  double get minContentSize;
  set minContentSize(double value);
}

abstract interface class LayoutChild {
  StylePropertyMapReadOnly get styleMap;
  Future<IntrinsicSizes> intrinsicSizes();
  Future<LayoutFragment> layoutNextFragment(LayoutConstraintsOptions constraints, ChildBreakToken breakToken);
}

abstract interface class LayoutConstraints {
  double get availableInlineSize;
  double get availableBlockSize;
  double? get fixedInlineSize;
  double? get fixedBlockSize;
  double get percentageInlineSize;
  double get percentageBlockSize;
  double? get blockFragmentationOffset;
  BlockFragmentationType get blockFragmentationType;
  Object get data;
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

abstract interface class LayoutEdges {
  double get inlineStart;
  double get inlineEnd;
  double get blockStart;
  double get blockEnd;
  double get inline;
  double get block;
}

abstract interface class LayoutFragment {
  double get inlineSize;
  double get blockSize;
  double get inlineOffset;
   set inlineOffset(double value);
  double get blockOffset;
   set blockOffset(double value);
  Object get data;
  ChildBreakToken? get breakToken;
}

abstract interface class LayoutOptions {
  ChildDisplayType get childDisplay;
  set childDisplay(ChildDisplayType value);
  LayoutSizingMode get sizing;
  set sizing(LayoutSizingMode value);
}

typedef LayoutSizingMode = String;

abstract interface class LayoutWorkletGlobalScope {
  void registerLayout(String name, VoidFunction layoutCtor);
}

