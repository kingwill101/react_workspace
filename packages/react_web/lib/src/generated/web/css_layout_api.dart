// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: css-layout-api
// ignore_for_file: type=lint

typedef BlockFragmentationType = String;

abstract interface class BreakTokenOptions {
  List<Object>? get childBreakTokens;
  set childBreakTokens(List<Object>? value);
  Object? get data;
  set data(Object? value);
}

final class BreakTokenOptionsValue implements BreakTokenOptions {
  @override
  List<Object>? childBreakTokens;
  @override
  Object? data;

  BreakTokenOptionsValue({this.childBreakTokens, this.data});
}

typedef BreakType = String;

typedef ChildDisplayType = String;

abstract interface class FragmentResultOptions {
  double? get inlineSize;
  set inlineSize(double? value);
  double? get blockSize;
  set blockSize(double? value);
  double? get autoBlockSize;
  set autoBlockSize(double? value);
  List<Object>? get childFragments;
  set childFragments(List<Object>? value);
  Object? get data;
  set data(Object? value);
  BreakTokenOptions? get breakToken;
  set breakToken(BreakTokenOptions? value);
}

final class FragmentResultOptionsValue implements FragmentResultOptions {
  @override
  double? inlineSize;
  @override
  double? blockSize;
  @override
  double? autoBlockSize;
  @override
  List<Object>? childFragments;
  @override
  Object? data;
  @override
  BreakTokenOptions? breakToken;

  FragmentResultOptionsValue({
    this.inlineSize,
    this.blockSize,
    this.autoBlockSize,
    this.childFragments,
    this.data,
    this.breakToken,
  });
}

abstract interface class IntrinsicSizesResultOptions {
  double? get maxContentSize;
  set maxContentSize(double? value);
  double? get minContentSize;
  set minContentSize(double? value);
}

final class IntrinsicSizesResultOptionsValue
    implements IntrinsicSizesResultOptions {
  @override
  double? maxContentSize;
  @override
  double? minContentSize;

  IntrinsicSizesResultOptionsValue({this.maxContentSize, this.minContentSize});
}

abstract interface class LayoutConstraintsOptions {
  double? get availableInlineSize;
  set availableInlineSize(double? value);
  double? get availableBlockSize;
  set availableBlockSize(double? value);
  double? get fixedInlineSize;
  set fixedInlineSize(double? value);
  double? get fixedBlockSize;
  set fixedBlockSize(double? value);
  double? get percentageInlineSize;
  set percentageInlineSize(double? value);
  double? get percentageBlockSize;
  set percentageBlockSize(double? value);
  double? get blockFragmentationOffset;
  set blockFragmentationOffset(double? value);
  BlockFragmentationType? get blockFragmentationType;
  set blockFragmentationType(BlockFragmentationType? value);
  Object? get data;
  set data(Object? value);
}

final class LayoutConstraintsOptionsValue implements LayoutConstraintsOptions {
  @override
  double? availableInlineSize;
  @override
  double? availableBlockSize;
  @override
  double? fixedInlineSize;
  @override
  double? fixedBlockSize;
  @override
  double? percentageInlineSize;
  @override
  double? percentageBlockSize;
  @override
  double? blockFragmentationOffset;
  @override
  BlockFragmentationType? blockFragmentationType;
  @override
  Object? data;

  LayoutConstraintsOptionsValue({
    this.availableInlineSize,
    this.availableBlockSize,
    this.fixedInlineSize,
    this.fixedBlockSize,
    this.percentageInlineSize,
    this.percentageBlockSize,
    this.blockFragmentationOffset,
    this.blockFragmentationType,
    this.data,
  });
}

abstract interface class LayoutOptions {
  ChildDisplayType? get childDisplay;
  set childDisplay(ChildDisplayType? value);
  LayoutSizingMode? get sizing;
  set sizing(LayoutSizingMode? value);
}

final class LayoutOptionsValue implements LayoutOptions {
  @override
  ChildDisplayType? childDisplay;
  @override
  LayoutSizingMode? sizing;

  LayoutOptionsValue({this.childDisplay, this.sizing});
}

typedef LayoutSizingMode = String;
