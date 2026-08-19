// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: css-scroll-snap-2
// ignore_for_file: type=lint

import 'dom.dart';

abstract interface class SnapEventInit {
  Node? get snapTargetBlock;
  set snapTargetBlock(Node? value);
  Node? get snapTargetInline;
  set snapTargetInline(Node? value);
}

final class SnapEventInitValue implements SnapEventInit {
  @override
  Node? snapTargetBlock;
  @override
  Node? snapTargetInline;

  SnapEventInitValue({this.snapTargetBlock, this.snapTargetInline});
}
