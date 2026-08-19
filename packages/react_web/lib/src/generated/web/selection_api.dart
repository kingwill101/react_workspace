// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: selection-api
// ignore_for_file: type=lint

import 'dom.dart';
import 'cssom_view.dart';

abstract interface class Selection {
  Node? get anchorNode;
  int get anchorOffset;
  Node? get focusNode;
  int get focusOffset;
  bool get isCollapsed;
  int get rangeCount;
  String get type_;
  String get direction;
  Range getRangeAt(int index);
  void addRange(Range range);
  void removeRange(Range range);
  void removeAllRanges();
  void empty();
  void collapse(Node? node, [int? offset]);
  void setPosition(Node? node, [int? offset]);
  void collapseToStart();
  void collapseToEnd();
  void extend(Node node, [int? offset]);
  void setBaseAndExtent(Node anchorNode, int anchorOffset, Node focusNode, int focusOffset);
  void selectAllChildren(Node node);
  void modify([String? alter, String? direction, String? granularity]);
  void deleteFromDocument();
  bool containsNode(Node node, [bool? allowPartialContainment]);
}

